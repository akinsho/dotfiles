local lsp = vim.lsp
local fn = vim.fn
local api = vim.api
local fmt = string.format
local diagnostic = vim.diagnostic
local L = vim.lsp.log_levels

local icons = as.style.icons.lsp
local border = as.style.current.border
local AUGROUP = 'LspCommands'

if vim.env.DEVELOPING then
  vim.lsp.set_log_level(L.DEBUG)
end

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//

-- Show the popup diagnostics window, but only once for the current cursor location
-- by checking whether the word under the cursor has changed.
local function diagnostic_popup()
  local cword = vim.fn.expand('<cword>')
  if cword ~= vim.w.lsp_diagnostics_cword then
    vim.w.lsp_diagnostics_cword = cword
    vim.diagnostic.open_float(0, { scope = 'cursor', focus = false })
  end
end

local function formatting_filter(client)
  local exceptions = ({
    lua = { 'sumneko_lua' },
    go = { 'null-ls' },
    proto = { 'null-ls' },
  })[vim.bo.filetype]

  if not exceptions then
    return true
  end
  return not vim.tbl_contains(exceptions, client.name)
end

---@param opts table<string, any>
local format = function(opts)
  opts = opts or {}
  vim.lsp.buf.format({
    bufnr = opts.bufnr,
    async = opts.async,
    filter = formatting_filter,
  })
end

--- Add lsp autocommands
---@param client table<string, any>
---@param bufnr number
local function setup_autocommands(client, bufnr)
  local cmds = {}
  if not client then
    local msg = fmt('Unable to setup LSP autocommands, client for %d is missing', bufnr)
    return vim.notify(msg, 'error', { title = 'LSP Setup' })
  end
  if client.server_capabilities.documentFormattingProvider then
    table.insert(cmds, {
      event = 'BufWritePre',
      buffer = bufnr,
      desc = 'Format the current buffer on save',
      command = function(args)
        format({ bufnr = args.buf, async = true })
      end,
    })
  end
  if client.server_capabilities.codeLensProvider then
    table.insert(cmds, {
      event = { 'BufEnter', 'CursorHold', 'InsertLeave' },
      buffer = bufnr,
      command = function()
        vim.lsp.codelens.refresh()
      end,
    })
  end
  if client.server_capabilities.documentHighlightProvider then
    table.insert(cmds, {
      event = { 'CursorHold' },
      buffer = bufnr,
      desc = 'Show diagnostics',
      command = function()
        diagnostic_popup()
      end,
    })
    table.insert(cmds, {
      event = { 'CursorHold', 'CursorHoldI' },
      buffer = bufnr,
      desc = 'LSP: Document Highlight',
      command = function()
        vim.lsp.buf.document_highlight()
      end,
    })
    table.insert(cmds, {
      event = 'CursorMoved',
      desc = 'LSP: Document Highlight (Clear)',
      buffer = bufnr,
      command = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end
  as.augroup(AUGROUP, cmds)
end

-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//

---Setup mapping when an lsp attaches to a buffer
---@param _ table lsp client
local function setup_mappings(_)
  local function with_desc(desc)
    return { buffer = 0, desc = desc }
  end

  as.nnoremap(']c', vim.diagnostic.goto_prev, with_desc('lsp: go to prev diagnostic'))
  as.nnoremap('[c', vim.diagnostic.goto_next, with_desc('lsp: go to next diagnostic'))

  as.nnoremap('<leader>rf', format, with_desc('lsp: format buffer'))
  as.nnoremap('<leader>ca', vim.lsp.buf.code_action, with_desc('lsp: code action'))
  as.xnoremap('<leader>ca', vim.lsp.buf.range_code_action, with_desc('lsp: code action'))
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

local function setup_plugins(client, bufnr)
  local ok, navic = pcall(require, 'nvim-navic')
  if ok and client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

---Add buffer local mappings, autocommands, tagfunc etc for attaching servers
---@param client table lsp client
---@param bufnr number
local function on_attach(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client)
  setup_plugins(client, bufnr)
  if client.server_capabilities.definitionProvider then
    vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
  end
end

--- A set of custom overrides for specific lsp clients
--- This is a way of adding functionality for specific lsps
--- without putting all this logic in the general on_attach function
local client_overrides = {
  sqls = function(client, bufnr)
    require('sqls').on_attach(client, bufnr)
  end,
}

as.augroup('LspSetupCommands', {
  {
    event = 'LspAttach',
    desc = 'setup the language server autocommands',
    command = function(args)
      local bufnr = args.buf
      -- if the buffer is invalid we should not try and attach to it
      if not api.nvim_buf_is_valid(args.buf) or not args.data then
        return
      end
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
      if client_overrides[client.name] then
        client_overrides[client.name](client, bufnr)
      end
    end,
  },
  {
    event = 'LspDetach',
    desc = 'Clean up after detached LSP',
    command = function(args)
      api.nvim_clear_autocmds({ group = AUGROUP, buffer = args.buf })
    end,
  },
})
-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
local command = as.command

command('LspFormat', function()
  format({ bufnr = 0, async = false })
end)

-- A helper function to auto-update the quickfix list when new diagnostics come
-- in and close it once everything is resolved. This functionality only runs whilst
-- the list is open.
-- similar functionality is provided by: https://github.com/onsails/diaglist.nvim
local function make_diagnostic_qf_updater()
  local cmd_id = nil
  return function()
    if not api.nvim_buf_is_valid(0) then
      return
    end
    vim.diagnostic.setqflist({ open = false })
    as.toggle_list('quickfix')
    if not as.is_vim_list_open() and cmd_id then
      api.nvim_del_autocmd(cmd_id)
      cmd_id = nil
    end
    if cmd_id then
      return
    end
    cmd_id = api.nvim_create_autocmd('DiagnosticChanged', {
      callback = function()
        if as.is_vim_list_open() then
          vim.diagnostic.setqflist({ open = false })
          if #vim.fn.getqflist() == 0 then
            as.toggle_list('quickfix')
          end
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
      if not m or d.severity < m.severity then
        max_severity_per_line[d.lnum] = d
      end
    end
    -- Pass the filtered diagnostics (with our custom namespace) to
    -- the original handler
    callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
  end
end

local signs_handler = diagnostic.handlers.signs
diagnostic.handlers.signs = {
  show = max_diagnostic(signs_handler.show),
  hide = function(_, bufnr)
    signs_handler.hide(ns, bufnr)
  end,
}

local virt_text_handler = diagnostic.handlers.virtual_text
diagnostic.handlers.virtual_text = {
  show = max_diagnostic(virt_text_handler.show),
  hide = function(_, bufnr)
    virt_text_handler.hide(ns, bufnr)
  end,
}

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
lsp.handlers['textDocument/hover'] = lsp.with(
  lsp.handlers.hover,
  { border = border, max_width = max_width, max_height = max_height }
)

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
    keep = function()
      return lvl == 'ERROR' or lvl == 'WARN'
    end,
  })
end
