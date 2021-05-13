-- Inspiration
-- 1. vim-relativity
-- 2. numbers.vim - https://github.com/myusuf3/numbers.vim/blob/master/plugin/numbers.vim

local api = vim.api
local M = {}

local function is_floating_win()
  return vim.fn.win_gettype() == "popup"
end

-- block list certain plugins and buffer types
local function is_blocked()
  local win_type = vim.fn.win_gettype()

  if not api.nvim_buf_is_valid(0) and not api.nvim_buf_is_loaded(0) then
    return true
  end

  if vim.wo.diff then
    return true
  end

  if win_type == "command" then
    return true
  end

  if vim.wo.previewwindow then
    return true
  end

  for _, ft in ipairs(vim.g.number_filetype_exclusions) do
    if vim.bo.ft == ft or string.match(vim.bo.ft, ft) then
      return true
    end
  end

  for _, buftype in ipairs(vim.g.number_buftype_exclusions) do
    if vim.bo.buftype == buftype then
      return true
    end
  end
  return false
end

function M.enable_relative_number()
  if is_floating_win() then
    return
  end
  if is_blocked() then
    -- setlocal nonumber norelativenumber
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    -- setlocal number relativenumber
    vim.wo.number = true
    vim.wo.relativenumber = true
  end
end

function M.disable_relative_number()
  if is_floating_win() then
    return
  end
  if is_blocked() then
    -- setlocal nonumber norelativenumber
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    -- setlocal number norelativenumber
    vim.wo.number = true
    vim.wo.relativenumber = false
  end
end

vim.g.number_filetype_exclusions = {
  "undotree",
  "log",
  "man",
  "dap-repl",
  "markdown",
  "vimwiki",
  "vim-plug",
  "gitcommit",
  "toggleterm",
  "fugitive",
  "coc-explorer",
  "coc-list",
  "list",
  "NvimTree",
  "startify",
  "help",
  "todoist",
  "lsputil_locations_list",
  "lsputil_symbols_list",
  "himalaya",
  "Trouble"
}

vim.g.number_buftype_exclusions = {
  "terminal",
  "quickfix",
  "help",
  "nofile",
  "acwrite"
}

as.augroup(
  "ToggleRelativeLineNumbers",
  {
    {
      events = {"BufEnter"},
      targets = {"*"},
      command = [[lua require("as.numbers").enable_relative_number()]]
    },
    {
      events = {"BufLeave"},
      targets = {"*"},
      command = [[lua require("as.numbers").disable_relative_number()]]
    },
    {
      events = {"FileType"},
      targets = {"*"},
      command = [[lua require("as.numbers").enable_relative_number()]]
    },
    {
      events = {"FocusGained"},
      targets = {"*"},
      command = [[lua require("as.numbers").enable_relative_number()]]
    },
    {
      events = {"FocusLost"},
      targets = {"*"},
      command = [[lua require("as.numbers").disable_relative_number()]]
    },
    {
      events = {"InsertEnter"},
      targets = {"*"},
      command = [[lua require("as.numbers").disable_relative_number()]]
    },
    {
      events = {"InsertLeave"},
      targets = {"*"},
      command = [[lua require("as.numbers").enable_relative_number()]]
    }
  }
)

return M
