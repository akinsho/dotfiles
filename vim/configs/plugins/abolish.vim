""---------------------------------------------------------------------------//
" Abolish
""---------------------------------------------------------------------------//
" Find and Replace Using Abolish Plugin %S - Subvert
""---------------------------------------------------------------------------//
nnoremap <localleader>[ :S/<C-R><C-W>//<LEFT>
nnoremap <localleader>] :%S/<C-r><C-w>//c<left><left>
vnoremap <localleader>[ "zy:%S/<C-r><C-o>"//c<left><left>
