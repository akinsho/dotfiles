-- Inspiration
-- 1. vim-relativity
-- 2. numbers.vim - https://github.com/myusuf3/numbers.vim/blob/master/plugin/numbers.vim
--
-- NOTE: it's important that we use BufReadPost as otherwise the buftype and filetype
-- variables might not be set correctly

local autocommands = require("as.autocommands")
local fn = vim.fn
local M = {}

-- block list certain plugins and buffer types
local function is_blocked()
  if fn.buflisted(fn.bufnr("")) == 0 then
    return true
  end

  if vim.wo.diff then
    return true
  end

  if fn.exists("#goyo") > 0 then
    return true
  end

  if vim.wo.previewwindow then
    return true
  end

  for _, ft in ipairs(vim.g.number_filetype_exclusions) do
    if vim.bo.ft == ft then
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
  "todoist"
}

vim.g.number_buftype_exclusions = {
  "terminal",
  "quickfix",
  "help"
}

autocommands.create(
  {
    ToggleRelativeLineNumbers = {
      {"BufEnter", "*", [[lua require("as.numbers").enable_relative_number()]]},
      {"BufLeave", "*", [[lua require("as.numbers").disable_relative_number()]]},
      {"FileType", "*", [[lua require("as.numbers").enable_relative_number()]]},
      {"FocusGained", "*", [[lua require("as.numbers").enable_relative_number()]]},
      {"FocusLost", "*", [[lua require("as.numbers").disable_relative_number()]]},
      {"InsertEnter", "*", [[lua require("as.numbers").disable_relative_number()]]},
      {"InsertLeave", "*", [[lua require("as.numbers").enable_relative_number()]]}
    }
  }
)

return M
