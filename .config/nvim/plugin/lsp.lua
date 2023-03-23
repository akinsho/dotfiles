if not as then return end

local lsp, fs, fn, api, fmt = vim.lsp, vim.fs, vim.fn, vim.api, string.format
local diagnostic = vim.diagnostic
local L, S = vim.lsp.log_levels, vim.diagnostic.severity

local icons = as.ui.icons.lsp
local border = as.ui.current.border

if vim.env.DEVELOPING then vim.lsp.set_log_level(L.DEBUG) end

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//

local FEATURES = {
  DIAGNOSTICS = { name = 'diagnostics' },
  CODELENS = { name = 'codelens', provider = 'codeLensProvider' },
  FORMATTING = { name = 'formatting', provider = 'documentFormattingProvider' },
  REFERENCES = { name = 'references', provider = 'documentHighlightProvider' },
}

---@param bufnr integer
---@param capability string
---@return table[]
local function clients_by_capability(bufnr, capability)
  return vim.tbl_filter(
    function(c) return c.server_capabilities[capability] end,
    lsp.get_active_clients({ buffer = bufnr })
  )
end

--- Create augroups for each LSP feature and track which capabilities each client
--- registers in a buffer local table
---@param bufnr integer
---@param client lsp.Client
---@param events { [string]: { clients: number[], group_id: number? } }
---@return fun(feature: {provider: string, name: string}, commands: fun(string): ...)
local function augroup_factory(bufnr, client, events)
  return function(feature, commands)
    local provider, name = feature.provider, feature.name
    if not provider or client.server_capabilities[provider] then
      events[name].group_id = as.augroup(fmt('LspCommands_%d_%s', bufnr, name), commands(provider))
      table.insert(events[name].clients, client.id)
    end
  end
end

local function formatting_filter(client)
  local exceptions = ({
    sql = { 'sqls' },
    proto = { 'null-ls' },
  })[vim.bo.filetype]

  if not exceptions then return true end
  return not vim.tbl_contains(exceptions, client.name)
end

---@param opts {bufnr: integer, async: boolean, filter: fun(lsp.Client): boolean}
local function format(opts)
  opts = opts or {}
  lsp.buf.format({ bufnr = opts.bufnr, async = opts.async, filter = formatting_filter })
end

--- Autocommands are created per buffer per feature, i.e. if buffer 8 attaches an LSP server
--- then an augroup with the pattern `LspCommands_8_{FEATURE}` will be created. These augroups are
--- localised to a buffer because the features are local to only that buffer and when we detach we need to delete
--- the augroups by buffer so as not to turn off the LSP for other buffers. The commands are also localised
--- to features because each autocommand for a feature e.g. formatting needs to be created in an idempotent
--- fashion because this is called n number of times for each client that attaches.
---
--- So if there are 3 clients and 1 supports formatting and another code lenses, and the last only references.
--- All three features should work and be setup. If only one augroup is used per buffer for all features then each time
--- a client detaches all lsp features will be disabled. Or the augroup will be recreated for the new client but
--- as a client might not support functionality that was already in place, the augroup will be deleted and recreated
--- without the commands for the features that that client does not support.
--- TODO: find a way to make this less complex...
---@param client lsp.Client
---@param bufnr number
local function setup_autocommands(client, bufnr)
  if not client then
    local msg = fmt('Unable to setup LSP autocommands, client for %d is missing', bufnr)
    return vim.notify(msg, 'error', { title = 'LSP Setup' })
  end

  local b = vim.b[bufnr]
  local events = b.lsp_events
    or {
      [FEATURES.CODELENS.name] = { clients = {}, group_id = nil },
      [FEATURES.FORMATTING.name] = { clients = {}, group_id = nil },
      [FEATURES.DIAGNOSTICS.name] = { clients = {}, group_id = nil },
      [FEATURES.REFERENCES.name] = { clients = {}, group_id = nil },
    }

  local augroup = augroup_factory(bufnr, client, events)
  augroup(FEATURES.FORMATTING, function(provider)
    return {
      event = 'BufWritePre',
      buffer = bufnr,
      desc = 'LSP: Format on save',
      command = function(args)
        if not vim.g.formatting_disabled and not b.formatting_disabled then
          local clients = clients_by_capability(args.buf, provider)
          if #clients >= 1 then format({ bufnr = args.buf, async = #clients == 1 }) end
        end
      end,
    }
  end)

  augroup(FEATURES.CODELENS, function()
    return {
      event = { 'BufEnter', 'CursorHold', 'InsertLeave' },
      desc = 'LSP: Code Lens',
      buffer = bufnr,
      command = function() pcall(lsp.codelens.refresh) end,
    }
  end)

  augroup(FEATURES.REFERENCES, function()
    return {
      event = { 'CursorHold', 'CursorHoldI' },
      buffer = bufnr,
      desc = 'LSP: References',
      command = function() lsp.buf.document_highlight() end,
    }, {
      event = 'CursorMoved',
      desc = 'LSP: References Clear',
      buffer = bufnr,
      command = function() lsp.buf.clear_references() end,
    }
  end)
  b.lsp_events = events
end

----------------------------------------------------------------------------------------------------
--  LSP file Rename
----------------------------------------------------------------------------------------------------

---@param data { old_name: string, new_name: string }
local function prepare_rename(data)
  local bufnr = fn.bufnr(data.old_name)
  for _, client in pairs(lsp.get_active_clients({ bufnr = bufnr })) do
    local rename_path = { 'server_capabilities', 'workspace', 'fileOperations', 'willRename' }
    if not vim.tbl_get(client, rename_path) then
      vim.notify(fmt('%s does not support rename files'), 'error', { title = 'LSP' })
    end
    local params = {
      files = { { newUri = 'file://' .. data.new_name, oldUri = 'file://' .. data.old_name } },
    }
    local resp = client.request_sync('workspace/willRenameFiles', params, 1000)
    vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
  end
end

local function rename_file()
  local old_name = api.nvim_buf_get_name(0)
  local new_name = fmt('%s/%s', fs.dirname(old_name), fn.input('New name: '))
  prepare_rename({ old_name = old_name, new_name })
  lsp.util.rename(old_name, new_name)
end

----------------------------------------------------------------------------------------------------
--  Related Locations
----------------------------------------------------------------------------------------------------
-- This relates to:
-- 1. https://github.com/neovim/neovim/issues/19649#issuecomment-1327287313
-- 2. https://github.com/neovim/neovim/issues/22744#issuecomment-1479366923
-- neovim does not currently correctly report the related locations for diagnostics.
-- TODO: once a PR for this is merged delete this workaround

local function show_related_locations(diag)
  local related_info = diag.relatedInformation
  if not related_info or #related_info == 0 then return diag end
  for _, info in ipairs(related_info) do
    diag.message = ('%s\n%s(%d:%d)%s'):format(
      diag.message,
      fn.fnamemodify(vim.uri_to_fname(info.location.uri), ':p:.'),
      info.location.range.start.line + 1,
      info.location.range.start.character + 1,
      not as.falsy(info.message) and (': %s'):format(info.message) or ''
    )
  end
  return diag
end

local handler = lsp.handlers['textDocument/publishDiagnostics']
---@diagnostic disable-next-line: duplicate-set-field
lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
  result.diagnostics = vim.tbl_map(show_related_locations, result.diagnostics)
  handler(err, result, ctx, config)
end

-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//

---Setup mapping when an lsp attaches to a buffer
---@param _ table lsp client
---@param bufnr number
local function setup_mappings(_, bufnr)
  local function with_desc(desc) return { buffer = bufnr, desc = fmt('lsp: %s', desc) } end

  map(
    'n',
    ']c',
    function() vim.diagnostic.goto_prev({ float = true }) end,
    with_desc('go to prev diagnostic')
  )
  map(
    'n',
    '[c',
    function() vim.diagnostic.goto_next({ float = true }) end,
    with_desc('go to next diagnostic')
  )

  map({ 'n', 'x' }, '<leader>ca', lsp.buf.code_action, with_desc('code action'))
  map('n', '<leader>rf', format, with_desc('format buffer'))
  map('n', 'gd', lsp.buf.definition, with_desc('definition'))
  map('n', 'gr', lsp.buf.references, with_desc('references'))
  map('n', 'K', lsp.buf.hover, with_desc('hover'))
  map('n', 'gI', lsp.buf.incoming_calls, with_desc('incoming calls'))
  map('n', 'gi', lsp.buf.implementation, with_desc('implementation'))
  map('n', '<leader>gd', lsp.buf.type_definition, with_desc('go to type definition'))
  map('n', '<leader>cl', lsp.codelens.run, with_desc('run code lens'))
  map('n', '<leader>ri', lsp.buf.rename, with_desc('rename'))
  map('n', '<leader>rN', rename_file, with_desc('rename with input'))
end

-----------------------------------------------------------------------------//
-- LSP SETUP/TEARDOWN
-----------------------------------------------------------------------------//

---@alias ClientOverrides {on_attach: fun(client: lsp.Client, bufnr: number), semantic_tokens: fun(bufnr: number, client: lsp.Client, token: table)}

--- A set of custom overrides for specific lsp clients
--- This is a way of adding functionality for specific lsps
--- without putting all this logic in the general on_attach function
---@type {[string]: ClientOverrides}
local client_overrides = {
  sqls = {
    on_attach = function(client, bufnr) require('sqls').on_attach(client, bufnr) end,
  },
  tsserver = {
    semantic_tokens = function(bufnr, client, token)
      if token.type == 'variable' and token.modifiers['local'] and not token.modifiers.readonly then
        lsp.semantic_tokens.highlight_token(token, bufnr, client.id, '@danger')
      end
    end,
  },
}

---@param client lsp.Client
---@param bufnr number
local function setup_plugins(client, bufnr)
  local navic_ok, navic = pcall(require, 'nvim-navic')
  if navic_ok and client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
  local hints_ok, hints = pcall(require, 'lsp-inlayhints')
  if hints_ok then hints.on_attach(client, bufnr) end
end

---@param client lsp.Client
---@param bufnr number
local function setup_semantic_tokens(client, bufnr)
  local overrides = client_overrides[client.name]
  if not overrides or not overrides.semantic_tokens then return end
  as.augroup(fmt('LspSemanticTokens%s', client.name), {
    event = 'LspTokenUpdate',
    buffer = bufnr,
    desc = fmt('Configure the semantic tokens for the %s', client.name),
    command = function(args) overrides.semantic_tokens(args.buf, client, args.data.token) end,
  })
end

-- Add buffer local mappings, autocommands etc for attaching servers
-- this runs for each client because they have different capabilities so each time one
-- attaches it might enable autocommands or mappings that the previous client did not support
---@param client lsp.Client the lsp client
---@param bufnr number
local function on_attach(client, bufnr)
  setup_plugins(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client, bufnr)
  setup_semantic_tokens(client, bufnr)
end

as.augroup('LspSetupCommands', {
  event = 'LspAttach',
  desc = 'setup the language server autocommands',
  command = function(args)
    local client = lsp.get_client_by_id(args.data.client_id)
    on_attach(client, args.buf)
    local overrides = client_overrides[client.name]
    if not overrides or not overrides.on_attach then return end
    overrides.on_attach(client, args.buf)
  end,
}, {
  event = 'LspDetach',
  desc = 'Clean up after detached LSP',
  command = function(args)
    local client_id, b = args.data.client_id, vim.b[args.buf]
    if not b.lsp_events or not client_id then return end
    for _, state in pairs(b.lsp_events) do
      if #state.clients == 1 and state.clients[1] == client_id then
        api.nvim_clear_autocmds({ group = state.group_id, buffer = args.buf })
      end
      state.clients = vim.tbl_filter(function(id) return id ~= client_id end, state.clients)
    end
  end,
}, {
  event = 'DiagnosticChanged',
  desc = 'Update the diagnostic locations',
  command = function(args)
    diagnostic.setloclist({ open = false })
    if #args.data.diagnostics == 0 then vim.cmd('silent! lclose') end
  end,
})
-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
local command = as.command

command('LspFormat', function() format({ bufnr = 0, async = false }) end)

-----------------------------------------------------------------------------//
-- Signs
-----------------------------------------------------------------------------//
---@param opts {highlight: string, icon: string, linehl?: boolean}
local function sign(opts)
  fn.sign_define(opts.highlight, {
    text = opts.icon,
    texthl = opts.highlight,
    numhl = opts.linehl ~= false and opts.highlight .. 'Nr' or nil,
    culhl = opts.linehl ~= false and opts.highlight .. 'CursorNr' or nil,
    linehl = opts.linehl ~= false and opts.highlight .. 'Line' or nil,
  })
end

sign({ highlight = 'DiagnosticSignError', icon = icons.error })
sign({ highlight = 'DiagnosticSignWarn', icon = icons.warn })
sign({ highlight = 'DiagnosticSignInfo', linehl = false, icon = icons.info })
sign({ highlight = 'DiagnosticSignHint', linehl = false, icon = icons.hint })
-----------------------------------------------------------------------------//
-- Handler Overrides
-----------------------------------------------------------------------------//
-- This section overrides the default diagnostic handlers for signs and virtual text so that only
-- the most severe diagnostic is shown per line

--- The custom namespace is so that ALL diagnostics across all namespaces can be aggregated
--- including diagnostics from plugins
local ns = api.nvim_create_namespace('severe-diagnostics')

--- Restricts nvim's diagnostic signs to only the single most severe one per line
--- see `:help vim.diagnostic`
---@param callback fun(namespace: integer, bufnr: integer, diagnostics: table, opts: table)
---@return fun(namespace: integer, bufnr: integer, diagnostics: table, opts: table)
local function max_diagnostic(callback)
  return function(_, bufnr, diagnostics, opts)
    local max_severity_per_line = as.fold(function(diag_map, d)
      local m = diag_map[d.lnum]
      if not m or d.severity < m.severity then diag_map[d.lnum] = d end
      return diag_map
    end, diagnostics, {})
    callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
  end
end

local signs_handler = diagnostic.handlers.signs
diagnostic.handlers.signs = vim.tbl_extend('force', signs_handler, {
  show = max_diagnostic(signs_handler.show),
  hide = function(_, bufnr) signs_handler.hide(ns, bufnr) end,
})
-----------------------------------------------------------------------------//
-- Diagnostic Configuration
-----------------------------------------------------------------------------//
local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

diagnostic.config({
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
  virtual_text = false and {
    severity = S.ERROR,
    spacing = 1,
    prefix = '',
    format = function(d)
      local level = diagnostic.severity[d.severity]
      return fmt('%s %s', icons[level:lower()], d.message)
    end,
  },
  float = {
    max_width = max_width,
    max_height = max_height,
    border = border,
    header = { ' Problems', 'UnderlinedTitle' },
    focusable = true,
    source = 'if_many',
    prefix = function(diag)
      local level = diagnostic.severity[diag.severity]
      local prefix = fmt('%s ', icons[level:lower()])
      return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
    end,
  },
})
