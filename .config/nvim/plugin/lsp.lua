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

local list_type = as.nightly and 'quickfix' or 'location'
local function set_diagnostics()
  if as.nightly then
    return vim.diagnostic.setqflist { open = false }
  end
  ---@diagnostic disable-next-line: deprecated
  vim.lsp.diagnostic.set_loclist { open_loclist = false, workspace = true }
end

command {
  'LspDiagnostics',
  function()
    set_diagnostics()
    as.toggle_list(list_type)
    if as.is_vim_list_open() then
      local event = as.nightly and 'DiagnosticsChanged' or 'LspDiagnosticsChanged'
      as.augroup('LspDiagnosticUpdate', {
        {
          events = { fmt('User %s', event) },
          command = function()
            set_diagnostics()
            if as.is_vim_list_open() then
              as.toggle_list(list_type)
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

local prefix = as.nightly and 'DiagnosticSign' or 'LspDiagnosticsSign'

local diagnostic_types = {
  { 'Hint', icon = as.style.icons.hint },
  { 'Error', icon = as.style.icons.error },
  { as.nightly and 'Warn' or 'Warning', icon = as.style.icons.warn },
  { as.nightly and 'Info' or 'Information', icon = as.style.icons.info },
}

fn.sign_define(vim.tbl_map(function(t)
  local hl = prefix .. t[1]
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
    local lnum = as.nightly and d.lnum or d.range.start.line
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
if not as.nightly then
  -- Capture real implementation of function that sets signs
  local set_signs = vim.lsp.diagnostic.set_signs
  ---@param diagnostics table
  ---@param bufnr number
  ---@param client_id number
  ---@param sign_ns number
  ---@param opts table
  vim.lsp.diagnostic.set_signs = function(diagnostics, bufnr, client_id, sign_ns, opts)
    local filtered = filter_diagnostics(diagnostics, bufnr)
    -- call original function
    set_signs(filtered, bufnr, client_id, sign_ns, opts)
  end
else
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
end

-----------------------------------------------------------------------------//
-- Handler overrides
-----------------------------------------------------------------------------//
vim.lsp.handlers['textDocument/rename'] = function(err, result)
  if err then
    vim.notify(("Error running lsp query 'rename': " .. err), vim.log.levels.ERROR)
  end
  if result and result.changes then
    local msg = ''
    for f, c in pairs(result.changes) do
      local new = c[1].newText
      msg = msg .. fmt('%d changes -> %s', #c, f:gsub('file://', ''):gsub(fn.getcwd(), '.')) .. '\n'
      msg = msg:sub(1, #msg - 1)
      vim.notify(
        msg,
        vim.log.levels.INFO,
        { title = fmt('Rename: %s -> %s', fn.expand '<cword>', new) }
      )
    end
  end
  vim.lsp.util.apply_workspace_edit(result)
end

local function rename(curr, win)
  local name = vim.trim(fn.getline '.')
  api.nvim_win_close(win, true)
  if #name > 0 and name ~= curr then
    local params = vim.lsp.util.make_position_params()
    params.newName = name
    vim.lsp.buf_request(0, 'textDocument/rename', params)
  end
end

-- DIY Rename function inspired by a reddit post, which uses a floating window
-- https://www.reddit.com/r/neovim/comments/ql4iuj/rename_hover_including_window_title_and/
-- TODO: replace this with https://github.com/filipdutescu/renamer.nvim/
-- once it's stable
function as.lsp.rename()
  local name = fn.expand '<cword>'
  local ok, ts = pcall(require, 'nvim-treesitter-playground.hl-info')
  local tshl = ''
  if ok and ts then
    if #ts <= 0 then
      return
    end
    tshl = ts.get_treesitter_hl()
    local ind = tshl[#tshl]:match '^.*()%*%*.*%*%*'
    tshl = tshl[#tshl]:sub(ind + 2, -3)
  end

  local win = require('plenary.popup').create(name, {
    title = 'New Name',
    style = 'minimal',
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    relative = 'cursor',
    borderhighlight = 'FloatBorder',
    titlehighlight = 'Title',
    highlight = tshl,
    focusable = true,
    width = 25,
    height = 1,
    line = 'cursor+2',
    col = 'cursor-1',
  })
  -- Move cursor to the end of the prefix
  vim.cmd 'stopinsert'
  vim.cmd 'startinsert!'

  local opts = { buffer = 0 }
  as.inoremap('<Esc>', '<cmd>stopinsert | q!<CR>', opts)
  as.nnoremap('<Esc>', '<cmd>stopinsert | q!<CR>', opts)
  as.inoremap('<CR>', function()
    vim.cmd 'stopinsert'
    rename(name, win)
  end, opts)
  as.nnoremap('<CR>', function()
    vim.cmd 'stopinsert'
    rename(name, win)
  end, opts)
end

if as.nightly then
  vim.diagnostic.config {
    underline = true,
    virtual_text = false,
    signs = false,
    update_in_insert = false,
    severity_sort = true,
  }
else
  lsp.handlers['textDocument/publishDiagnostics'] =
    lsp.with(lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = false,
      signs = true,
      update_in_insert = false,
      severity_sort = true,
    })
end

local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

-- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
lsp.handlers['textDocument/hover'] = lsp.with(
  lsp.handlers.hover,
  { border = 'rounded', max_width = max_width, max_height = max_height }
)
