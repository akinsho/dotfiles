-- TODO: Convert to use vim.diagnostic when 0.6 is stable
-- [ ] use DiagnosticSign* and remove LspDiagnosticSign*
-- [ ] use vim.diagnostic.config not handler overwrite

local lsp = vim.lsp
local fn = vim.fn
local api = vim.api
local fmt = string.format
local L = vim.lsp.log_levels

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

local function set_diagnostics()
  return vim.diagnostic.setqflist { open = false }
end

command {
  'LspDiagnostics',
  function()
    set_diagnostics()
    as.toggle_list 'quickfix'
    if as.is_vim_list_open() then
      as.augroup('LspDiagnosticUpdate', {
        {
          events = { 'DiagnosticChanged' },
          targets = { '*' },
          command = function()
            set_diagnostics()
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
  { 'Hint', icon = as.style.icons.hint },
  { 'Error', icon = as.style.icons.error },
  { 'Warn', icon = as.style.icons.warn },
  { 'Info', icon = as.style.icons.info },
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

---Override diagnostics signs helper to only show the single most relevant sign
---@see: http://reddit.com/r/neovim/comments/mvhfw7/can_built_in_lsp_diagnostics_be_limited_to_show_a
---@param diagnostics table[]
---@param bufnr number
---@return table[]
local function filter_diagnostics(diagnostics, bufnr)
  if not diagnostics then
    return {}
  end
  -- Work out max severity diagnostic per line
  local max_severity_per_line = {}
  for _, d in pairs(diagnostics) do
    local lnum = d.lnum
    if max_severity_per_line[lnum] then
      local current_d = max_severity_per_line[lnum]
      if d.severity < current_d.severity then
        max_severity_per_line[lnum] = d
      end
    else
      max_severity_per_line[lnum] = d
    end
  end

  -- map to list
  local filtered_diagnostics = {}
  for _, v in pairs(max_severity_per_line) do
    table.insert(filtered_diagnostics, v)
  end
  return filtered_diagnostics
end

--- This overwrites the diagnostic show/set_signs function to replace it with a custom function
--- that restricts nvim's diagnostic signs to only the single most severe one per line
local ns = api.nvim_create_namespace 'severe-diagnostics'
local show = vim.diagnostic.show
local function display_signs(bufnr)
  -- Get all diagnostics from the current buffer
  local diagnostics = vim.diagnostic.get(bufnr)
  local filtered = filter_diagnostics(diagnostics, bufnr)
  show(ns, bufnr, filtered, {
    virtual_text = false,
    underline = false,
    signs = true,
  })
end

function vim.diagnostic.show(namespace, bufnr, ...)
  show(namespace, bufnr, ...)
  display_signs(bufnr)
end

-----------------------------------------------------------------------------//
-- Handler overrides
-----------------------------------------------------------------------------//
vim.diagnostic.config {
  underline = true,
  virtual_text = false,
  signs = false,
  update_in_insert = false,
  severity_sort = true,
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
