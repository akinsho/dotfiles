local lsp = vim.lsp
local fn = vim.fn
local api = vim.api
local fmt = string.format
local diagnostic = vim.diagnostic
local L = vim.lsp.log_levels

local icons = as.style.icons

if vim.env.DEVELOPING then
  vim.lsp.set_log_level(L.DEBUG)
end

-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
local command = as.command

command {
  'LspLog',
  function()
    vim.cmd('edit ' .. vim.lsp.get_log_path())
  end,
}

command {
  'LspFormat',
  function()
    vim.lsp.buf.formatting_sync(nil, 1000)
  end,
}

command {
  'LspDiagnostics',
  function()
    vim.diagnostic.setqflist { open = false }
    as.toggle_list 'quickfix'
    if as.is_vim_list_open() then
      as.augroup('LspDiagnosticUpdate', {
        {
          event = { 'DiagnosticChanged' },
          pattern = { '*' },
          command = function()
            if as.is_vim_list_open() then
              as.toggle_list 'quickfix'
            end
          end,
        },
      })
    elseif fn.exists '#LspDiagnosticUpdate' > 0 then
      vim.cmd 'autocmd! LspDiagnosticUpdate'
    end
  end,
}
as.nnoremap('<leader>ll', '<Cmd>LspDiagnostics<CR>', 'toggle quickfix diagnostics')

-----------------------------------------------------------------------------//
-- Signs
-----------------------------------------------------------------------------//
local diagnostic_types = {
  { 'Error', icon = icons.error },
  { 'Warn', icon = icons.warn },
  { 'Hint', icon = icons.hint },
  { 'Info', icon = icons.info },
}

fn.sign_define(vim.tbl_map(function(t)
  local hl = 'DiagnosticSign' .. t[1]
  return {
    name = hl,
    text = t.icon,
    texthl = hl,
    linehl = fmt('%sLine', hl),
  }
end, diagnostic_types))

--- Restricts nvim's diagnostic signs to only the single most severe one per line
--- @see `:help vim.diagnostic`

local ns = api.nvim_create_namespace 'severe-diagnostics'
--- Get a reference to the original signs handler
local signs_handler = vim.diagnostic.handlers.signs
--- Override the built-in signs handler
vim.diagnostic.handlers.signs = {
  show = function(_, bufnr, _, opts)
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
    signs_handler.show(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
  end,
  hide = function(_, bufnr)
    signs_handler.hide(ns, bufnr)
  end,
}

-----------------------------------------------------------------------------//
-- LSP Progress notification
-----------------------------------------------------------------------------//
local client_notifs = {}

local spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

local function update_spinner(client_id, token)
  local notif_data = client_notifs[client_id][token]
  if notif_data and notif_data.spinner then
    local new_spinner = (notif_data.spinner + 1) % #spinner_frames
    local new_notif = vim.notify(nil, nil, {
      hide_from_history = true,
      icon = spinner_frames[new_spinner],
      replace = notif_data.notification,
    })
    client_notifs[client_id][token] = {
      notification = new_notif,
      spinner = new_spinner,
    }
    vim.defer_fn(function()
      update_spinner(client_id, token)
    end, 100)
  end
end

local function format_title(title, client)
  return (client and client.name or '') .. (#title > 0 and ': ' .. title or '')
end

local function format_message(message, percentage)
  return (percentage and percentage .. '%\t' or '') .. (message or '')
end

local function lsp_progress_notification(_, result, ctx)
  local client_id = ctx.client_id
  local val = result.value
  if val.kind then
    if not client_notifs[client_id] then
      client_notifs[client_id] = {}
    end
    local notif_data = client_notifs[client_id][result.token]
    if val.kind == 'begin' then
      local message = format_message(val.message or 'Loading...', val.percentage)
      local notification = vim.notify(message, 'info', {
        title = format_title(val.title, vim.lsp.get_client_by_id(client_id)),
        icon = spinner_frames[1],
        timeout = false,
        hide_from_history = true,
      })
      client_notifs[client_id][result.token] = {
        notification = notification,
        spinner = 1,
      }
      update_spinner(client_id, result.token)
    elseif val.kind == 'report' and notif_data then
      local new_notif = vim.notify(
        format_message(val.message, val.percentage),
        'info',
        { replace = notif_data.notification, hide_from_history = false }
      )
      client_notifs[client_id][result.token] = {
        notification = new_notif,
        spinner = notif_data.spinner,
      }
    elseif val.kind == 'end' and notif_data then
      local new_notif = vim.notify(
        val.message and format_message(val.message) or 'Complete',
        'info',
        { icon = '', replace = notif_data.notification, timeout = 500 }
      )
      client_notifs[client_id][result.token] = {
        notification = new_notif,
      }
    end
  end
end

-----------------------------------------------------------------------------//
-- Handler overrides
-----------------------------------------------------------------------------//
diagnostic.config {
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  virtual_text = false,
}

local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

-- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
lsp.handlers['textDocument/hover'] = lsp.with(
  lsp.handlers.hover,
  { border = 'rounded', max_width = max_width, max_height = max_height }
)

lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, {
  border = 'rounded',
  max_width = max_width,
  max_height = max_height,
})

lsp.handlers['window/showMessage'] = function(_, result, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
  vim.notify(result.message, lvl, {
    title = 'LSP | ' .. client.name,
    timeout = 10000,
    keep = function()
      return lvl == 'ERROR' or lvl == 'WARN'
    end,
  })
end

lsp.handlers['$/progress'] = lsp_progress_notification
