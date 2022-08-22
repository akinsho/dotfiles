local lsp = vim.lsp
local fn = vim.fn
local api = vim.api
local fmt = string.format
local diagnostic = vim.diagnostic
local L = vim.lsp.log_levels

local icons = as.style.icons.lsp
local border = as.style.current.border

if vim.env.DEVELOPING then vim.lsp.set_log_level(L.DEBUG) end

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//
--[[
Autocommands are created per buffer per feature, i.e. if buffer 8 attaches an LSP server
then an augroup with the pattern `LspCommands_8_{FEATURE}` will be created. These augroups are
localised to a buffer because the features are local to only that buffer and when we detach we need to delete
the augroups by buffer so as not to turn off the LSP for other buffers. The commands are also localised
to features because each autocommand for a feature e.g. formatting needs to be created in an idempotent
fashion because this is called n number of times for each client that attaches.

So if there are 3 clients and 1 supports formatting and another code lenses, and the last only references.
All three features should work and be setup. If only one augroup is used per buffer for all features then each time
a client detaches all lsp features will be disabled. Or the augroup will be recreated for the new client but
as a client might not support functionality that was already in place, the augroup will be deleted and recreated
without the commands for the features that that client does not support.
--]]

local FEATURES = {
  FORMATTING = 'formatting',
  CODELENS = 'codelens',
  DIAGNOSTICS = 'diagnostics',
  REFERENCES = 'references',
}

local get_augroup = function(bufnr, method)
  assert(bufnr, 'A bufnr is required to create an lsp augroup')
  return fmt('LspCommands_%d_%s', bufnr, method)
end

local function formatting_filter(client)
  local exceptions = ({
    sql = { 'sqls' },
    lua = { 'sumneko_lua' },
    proto = { 'null-ls' },
  })[vim.bo.filetype]

  if not exceptions then return true end
  return not vim.tbl_contains(exceptions, client.name)
end

---@param opts table<string, any>
local function format(opts)
  opts = opts or {}
  vim.lsp.buf.format({
    bufnr = opts.bufnr,
    async = opts.async,
    filter = formatting_filter,
  })
end

--- Check that a buffer is valid and loaded before calling a callback
--- TODO: neovim upstream should validate the buffer itself rather than
-- each user having to implement this logic
---@param callback function
---@param buf integer
local function valid_call(callback, buf)
  if not buf or not api.nvim_buf_is_loaded(buf) or not api.nvim_buf_is_valid(buf) then return end
  callback()
end

--- Add lsp autocommands
---@param client table<string, any>
---@param bufnr number
local function setup_autocommands(client, bufnr)
  if not client then
    local msg = fmt('Unable to setup LSP autocommands, client for %d is missing', bufnr)
    return vim.notify(msg, 'error', { title = 'LSP Setup' })
  end

  as.augroup(get_augroup(bufnr, FEATURES.DIAGNOSTICS), {
    {
      event = { 'CursorHold' },
      buffer = bufnr,
      desc = 'LSP: Show diagnostics',
      command = function(args) vim.diagnostic.open_float(args.buf, { scope = 'cursor', focus = false }) end,
    },
  })

  if client.server_capabilities.documentFormattingProvider then
    as.augroup(get_augroup(bufnr, FEATURES.FORMATTING), {
      {
        event = 'BufWritePre',
        buffer = bufnr,
        desc = 'LSP: Format on save',
        command = function(args)
          if not vim.g.formatting_disabled and not vim.b.formatting_disabled then
            format({ bufnr = args.buf, async = false })
          end
        end,
      },
    })
  end

  if client.server_capabilities.codeLensProvider then
    as.augroup(get_augroup(bufnr, FEATURES.CODELENS), {
      {
        event = { 'BufEnter', 'CursorHold', 'InsertLeave' },
        desc = 'LSP: Code Lens',
        buffer = bufnr,
        command = function(args) valid_call(vim.lsp.codelens.refresh, args.buf) end,
      },
    })
  end

  if client.server_capabilities.documentHighlightProvider then
    as.augroup(get_augroup(bufnr, FEATURES.REFERENCES), {
      {
        event = { 'CursorHold', 'CursorHoldI' },
        buffer = bufnr,
        desc = 'LSP: References',
        command = function(args) valid_call(vim.lsp.buf.document_highlight, args.buf) end,
      },
      {
        event = 'CursorMoved',
        desc = 'LSP: References Clear',
        buffer = bufnr,
        command = function(args) valid_call(vim.lsp.buf.clear_references, args.buf) end,
      },
    })
  end
end

-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//

---Setup mapping when an lsp attaches to a buffer
---@param _ table lsp client
---@param bufnr number
local function setup_mappings(_, bufnr)
  local function with_desc(desc) return { buffer = bufnr, desc = desc } end

  as.nnoremap(
    ']c',
    function() vim.diagnostic.goto_prev({ float = false }) end,
    with_desc('lsp: go to prev diagnostic')
  )
  as.nnoremap(
    '[c',
    function() vim.diagnostic.goto_next({ float = false }) end,
    with_desc('lsp: go to next diagnostic')
  )

  vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, with_desc('lsp: code action'))
  as.nnoremap('<leader>rf', format, with_desc('lsp: format buffer'))
  as.nnoremap('gd', vim.lsp.buf.definition, with_desc('lsp: definition'))
  as.nnoremap('gr', vim.lsp.buf.references, with_desc('lsp: references'))
  as.nnoremap('K', vim.lsp.buf.hover, with_desc('lsp: hover'))
  as.nnoremap('gI', vim.lsp.buf.incoming_calls, with_desc('lsp: incoming calls'))
  as.nnoremap('gi', vim.lsp.buf.implementation, with_desc('lsp: implementation'))
  as.nnoremap('<leader>gd', vim.lsp.buf.type_definition, with_desc('lsp: go to type definition'))
  as.nnoremap('<leader>cl', vim.lsp.codelens.run, with_desc('lsp: run code lens'))
  as.nnoremap('<leader>rn', vim.lsp.buf.rename, with_desc('lsp: rename'))
end

-----------------------------------------------------------------------------//
-- LSP SETUP/TEARDOWN
-----------------------------------------------------------------------------//

---@param client table
---@param bufnr number
local function setup_plugins(client, bufnr)
  local navic_ok, navic = pcall(require, 'nvim-navic')
  if navic_ok and client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
  local hints_ok, hints = pcall(require, 'lsp-inlayhints')
  if hints_ok then hints.on_attach(bufnr, client) end
end

-- Add buffer local mappings, autocommands etc for attaching servers
-- this runs for each client because they have different capabilities so each time one
-- attaches it might enable autocommands or mappings that the previous client did not support
---@param client table the lsp client
---@param bufnr number
local function on_attach(client, bufnr)
  setup_plugins(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client, bufnr)
end

--- A set of custom overrides for specific lsp clients
--- This is a way of adding functionality for specific lsps
--- without putting all this logic in the general on_attach function
local client_overrides = {
  sqls = function(client, bufnr) require('sqls').on_attach(client, bufnr) end,
}

as.augroup('LspSetupCommands', {
  {
    event = 'LspAttach',
    desc = 'setup the language server autocommands',
    command = function(args)
      local bufnr = args.buf
      -- if the buffer is invalid we should not try and attach to it
      if not api.nvim_buf_is_valid(args.buf) or not args.data then return end
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
      if client_overrides[client.name] then client_overrides[client.name](client, bufnr) end
    end,
  },
  {
    event = 'LspDetach',
    desc = 'Clean up after detached LSP',
    command = function(args)
      -- Only clear autocommands if there are no other clients attached to the buffer
      if next(vim.lsp.get_active_clients({ bufnr = args.buf })) then return end
      as.foreach(
        function(feature)
          pcall(api.nvim_clear_autocmds, {
            group = get_augroup(args.buf, feature),
            buffer = args.buf,
          })
        end,
        FEATURES
      )
    end,
  },
})
-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
local command = as.command

command('LspFormat', function() format({ bufnr = 0, async = false }) end)

-- A helper function to auto-update the quickfix list when new diagnostics come
-- in and close it once everything is resolved. This functionality only runs whilst
-- the list is open.
-- similar functionality is provided by: https://github.com/onsails/diaglist.nvim
local function make_diagnostic_qf_updater()
  local cmd_id = nil
  return function()
    local buf = api.nvim_get_current_buf()
    if not api.nvim_buf_is_valid(buf) and api.nvim_buf_is_loaded(buf) then return end
    pcall(vim.diagnostic.setqflist, { open = false })
    as.toggle_list('quickfix')
    if not as.is_vim_list_open() and cmd_id then
      api.nvim_del_autocmd(cmd_id)
      cmd_id = nil
    end
    if cmd_id then return end
    cmd_id = api.nvim_create_autocmd('DiagnosticChanged', {
      callback = function()
        if as.is_vim_list_open() then
          pcall(vim.diagnostic.setqflist, { open = false })
          if #fn.getqflist() == 0 then as.toggle_list('quickfix') end
        end
      end,
    })
  end
end

command('LspDiagnostics', make_diagnostic_qf_updater())
as.nnoremap('<leader>ll', '<Cmd>LspDiagnostics<CR>', 'toggle quickfix diagnostics')

-----------------------------------------------------------------------------//
-- Signs
-----------------------------------------------------------------------------//
local function sign(opts)
  fn.sign_define(opts.highlight, {
    text = opts.icon,
    texthl = opts.highlight,
    culhl = opts.highlight .. 'Line',
  })
end

sign({ highlight = 'DiagnosticSignError', icon = icons.error })
sign({ highlight = 'DiagnosticSignWarn', icon = icons.warn })
sign({ highlight = 'DiagnosticSignInfo', icon = icons.info })
sign({ highlight = 'DiagnosticSignHint', icon = icons.hint })
-----------------------------------------------------------------------------//
-- Handler Overrides
-----------------------------------------------------------------------------//
--[[
This section overrides the default diagnostic handlers for signs and virtual text so that only
the most severe diagnostic is shown per line
--]]

local ns = api.nvim_create_namespace('severe-diagnostics')

--- Restricts nvim's diagnostic signs to only the single most severe one per line
--- @see `:help vim.diagnostic`
local function max_diagnostic(callback)
  return function(_, bufnr, _, opts)
    -- Get all diagnostics from the whole buffer rather than just the
    -- diagnostics passed to the handler
    local diagnostics = vim.diagnostic.get(bufnr)
    -- Find the "worst" diagnostic per line
    local max_severity_per_line = {}
    for _, d in pairs(diagnostics) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then max_severity_per_line[d.lnum] = d end
    end
    -- Pass the filtered diagnostics (with our custom namespace) to
    -- the original handler
    callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
  end
end

local signs_handler = diagnostic.handlers.signs
diagnostic.handlers.signs = vim.tbl_extend('force', signs_handler, {
  show = max_diagnostic(signs_handler.show),
  hide = function(_, bufnr) signs_handler.hide(ns, bufnr) end,
})

local virt_text_handler = diagnostic.handlers.virtual_text
diagnostic.handlers.virtual_text = vim.tbl_extend('force', virt_text_handler, {
  show = max_diagnostic(virt_text_handler.show),
  hide = function(_, bufnr) virt_text_handler.hide(ns, bufnr) end,
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
  severity_sort = true,
  virtual_text = {
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
    focusable = false,
    source = 'always',
    prefix = function(diag, i, _)
      local level = diagnostic.severity[diag.severity]
      local prefix = fmt('%d. %s ', i, icons[level:lower()])
      return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
    end,
  },
})

-- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
lsp.handlers['textDocument/hover'] =
  lsp.with(lsp.handlers.hover, { border = border, max_width = max_width, max_height = max_height })

lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, {
  border = border,
  max_width = max_width,
  max_height = max_height,
})

lsp.handlers['window/showMessage'] = function(_, result, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
  vim.notify(result.message, lvl, {
    title = 'LSP | ' .. client.name,
    timeout = 8000,
    keep = function() return lvl == 'ERROR' or lvl == 'WARN' end,
  })
end
