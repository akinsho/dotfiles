""---------------------------------------------------------------------------//
" VIM WIKI
""---------------------------------------------------------------------------//
let g:wiki_path = isdirectory($HOME.'/Dropbox') ? $HOME.'/Dropbox/wiki' : $HOME . '/wiki'
let g:common_wiki_path = $DOTFILES.'vim/wiki'
let g:common_wiki = {
      \'path': g:common_wiki_path,
      \'path_html': g:common_wiki_path,
      \}
let g:wiki = {
      \'path': g:wiki_path,
      \'path_html': g:wiki_path,
      \}
let g:vimwiki_listsyms = '✗○◐●✓'
let g:vimwiki_list = [g:wiki, g:common_wiki]

function! s:close_wikis() abort
  let l:bufs = range(1, bufnr('$'))
  for buf in l:bufs
    if bufexists(buf) && getbufvar(buf, '&filetype') == 'vimwiki' && winbufnr(buf) == -1
      execute buf 'bdelete'
    endif
  endfor
endfunction

command! CloseVimWikis call s:close_wikis()

augroup Wikis
  au!
  autocmd TabLeave * call s:close_wikis()
augroup END
