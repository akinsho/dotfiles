return function()
  vim.g.indentLine_fileTypeExclude = {
    "packer",
    "vimwiki",
    "markdown",
    "json",
    "txt",
    "vista",
    "help",
    "todoist"
  }
  vim.g.indentLine_bufNameExclude = {"Startify", "terminal", "peekabo"}
  vim.g.indentLine_bufTypeExclude = {"terminal", "nofile"}
  vim.g.indentLine_faster = 1
  vim.g.indentLine_setConceal = 1
  vim.g.indentLine_setColors = 1
  vim.g.indentLine_char = "│"
  vim.g.indentLine_defaultGroup = "Comment"
end
