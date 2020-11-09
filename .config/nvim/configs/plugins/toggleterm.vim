"--------------------------------------------------------------------------------
" Mappings
"--------------------------------------------------------------------------------
command! ResetToggleTerm :ResetLuaPlugin '^nvim%-toggleterm%.lua'<CR>
command! -count=1 TermGitPush lua require'toggleterm'.exec("git push", <count>, 12)
command! -count=1 TermGitPushF lua require'toggleterm'.exec("git push -f", <count>, 12)

lua << EOF
require"toggleterm".setup{
  size = 15,
  open_mapping = [[<c-\>]],
  shade_filetypes = {},
}
EOF
