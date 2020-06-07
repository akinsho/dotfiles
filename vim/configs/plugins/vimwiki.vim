if !has_key(g:plugs, 'vimwiki')
  finish
endif
""---------------------------------------------------------------------------//
" VIM WIKI
""---------------------------------------------------------------------------//
" Mac == Work (Don't/Can't sync work wiki files)
let g:wiki_path = isdirectory($HOME.'/Dropbox') && !has('mac') ?
      \ $HOME.'/Dropbox/wiki' : $HOME . '/wiki'
let g:common_wiki_path = $DOTFILES.'/wiki'
let g:common_wiki = {
      \'path': g:common_wiki_path,
      \'path_html': g:common_wiki_path . '/html',
      \}
let g:wiki = {
      \'path': g:wiki_path,
      \'path_html': g:wiki_path,
      \'auto_export': 1,
      \'auto_toc': 1,
      \}

let g:vimwiki_auto_header   = 1
let g:vimwiki_hl_headers    = 0 " too colourful
let g:vimwiki_conceal_pre   = 1
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_listsyms = '✗○◐●✓'
let g:vimwiki_list = [g:wiki, g:common_wiki]

let g:vimwiki_global_ext = 0

let g:vimwiki_folding = 'expr'

function! s:close_wikis() abort
  let l:bufs = range(1, bufnr('$'))
  for buf in l:bufs
    if bufexists(buf) && getbufvar(buf, '&filetype') == 'vimwiki' && winbufnr(buf) == -1
      silent! execute buf 'bdelete'
    endif
  endfor
endfunction

command! CloseVimWikis call s:close_wikis()
