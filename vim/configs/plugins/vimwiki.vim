""---------------------------------------------------------------------------//
" VIM WIKI
""---------------------------------------------------------------------------//
let g:wiki_path = isdirectory($HOME.'/Dropbox') ? $HOME.'/Dropbox/wiki' : $HOME . '/wiki'
let g:wiki = {
      \'path': g:wiki_path,
      \'path_html': g:wiki_path,
      \}
let g:vimwiki_listsyms = '✗○◐●✓'
let g:vimwiki_list = [g:wiki]

function! s:close_wikis() abort
  for i in range(1, bufnr('$'))
    if bufexists(i) && getbufvar(i, '&filetype') == 'vimwiki' && winbufnr(i) == -1
      execute i 'bdelete'
    endif
  endfor
endfunction

augroup Wikis
  au!
  autocmd TabLeave * call s:close_wikis()
augroup END
