return function()
  vim.cmd [[command! -count=1 TermGitPush lua require'toggleterm'.exec("git push", <count>, 12)]]
  vim.cmd [[command! -count=1 TermGitPushF lua require'toggleterm'.exec("git push -f", <count>, 12)]]

  require "toggleterm".setup {
    size = 15,
    open_mapping = [[<c-\>]],
    shade_filetypes = {"none"}
  }
end
