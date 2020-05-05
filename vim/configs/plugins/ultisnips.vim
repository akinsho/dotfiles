if !has_key(plugs, 'ultisnips')
  finish
endif
""---------------------------------------------------------------------------//
" ULTISNIPS {{{
""---------------------------------------------------------------------------//
" Snippet settings:
let g:snips_author = 'Akin Sowemimo'
let g:UltiSnipsSnippetsDir          = $DOTFILES."/vim/snippets" "Both of these settings are necessary
let g:UltiSnipsSnippetDirectories   = ["UltiSnips", $DOTFILES."/vim/snippets"]
let g:UltiSnipsExpandTrigger        = "<C-J>"
let g:UltiSnipsJumpForwardTrigger   = "<C-J>"
let g:UltiSnipsJumpBackwardTrigger  = "<C-K>"
let g:UltiSnipsEditSplit            = "vertical" "If you want :UltiSnipsEdit to split your window.
nnoremap <localleader>u :UltiSnipsEdit<CR>
"}}}
