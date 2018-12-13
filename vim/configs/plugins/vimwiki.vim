""---------------------------------------------------------------------------//
" VIM WIKI
""---------------------------------------------------------------------------//
let g:work_wiki = {}
let g:work_wiki.path = $DOTFILES.'/vim/wiki/work/todo.wiki'
let g:work_wiki.path_html = $DOTFILES.'/vim/wiki/work/todo.html'
let g:home_wiki = {}
let g:home_wiki.path = $DOTFILES.'/vim/wiki/home/todo.wiki'
let g:home_wiki.path_html = $DOTFILES.'vim/wiki/home/todo.html'
let g:vimwiki_listsyms = '✗○◐●✓'
let g:vimwiki_list = [g:home_wiki, g:work_wiki]

function! s:close_wikis() abort
  for i in range(1, bufnr('$'))
    if bufexists(i) && getbufvar(i, '&filetype') == 'vimwiki' && winbufnr(i) == -1
      execute i 'bdelete'
    endif
  endfor
endfunction

autocmd TabLeave * call s:close_wikis()
