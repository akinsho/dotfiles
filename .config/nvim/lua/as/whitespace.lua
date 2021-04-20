----------------------------------------------------------------------------------
--  Whitespace highlighting
----------------------------------------------------------------------------------
-- source: https://vim.fandom.com/wiki/Highlight_unwanted_spaces (comment at the bottom)
-- implementation: https://github.com/inkarkat/vim-ShowTrailingWhitespace

local M = {}
local fn = vim.fn

local function is_invalid_buf()
  return vim.bo.filetype == "" or vim.bo.buftype ~= "" or not vim.bo.modifiable
end

function M.setup()
  require("as.highlights").highlight("ExtraWhitespace", {guifg = "red"})
  as.augroup(
    "WhitespaceMatch",
    {
      {
        events = {"ColorScheme"},
        targets = {"*"},
        command = [[lua require("as.highlights").highlight("ExtraWhitespace", {guifg = "red"})]]
      },
      {
        events = {"BufEnter", "FileType", "InsertLeave"},
        targets = {"*"},
        command = [[lua require('as.whitespace').toggle_trailing('n')]]
      },
      {
        events = {"InsertEnter"},
        targets = {"*"},
        command = [[lua require('as.whitespace').toggle_trailing('i')]]
      }
    }
  )
end

function M.toggle_trailing(mode)
  if is_invalid_buf() then
    vim.wo.list = false
    return
  end
  if not vim.wo.list then
    vim.wo.list = true
  end
  local pattern = mode == "i" and [[\s\+\%#\@<!$]] or [[\s\+$]]
  if vim.w.whitespace_match_number then
    fn.matchdelete(vim.w.whitespace_match_number)
    fn.matchadd("ExtraWhitespace", pattern, 10, vim.w.whitespace_match_number)
  else
    vim.w.whitespace_match_number = fn.matchadd("ExtraWhitespace", pattern)
  end
end

return M
