if !PluginLoaded('vimwiki')
  finish
endif
""---------------------------------------------------------------------------//
" VIM WIKI
""---------------------------------------------------------------------------//
let g:wiki_path = isdirectory(expand('$HOME/Dropbox')) ?
      \ $HOME.'/Dropbox/wiki' : $HOME . '/wiki'
let g:wiki = {
      \'name': 'knowledge base',
      \'path': g:wiki_path,
      \'path_html': g:wiki_path.'/public/',
      \'auto_toc': 1,
      \'auto_diary_index': 1,
      \'auto_generate_links': 1,
      \'auto_tags': 1,
      \}

let g:learnings_wiki_path = $HOME.'/wiki'
let g:learnings_wiki = {
      \'name': 'Learnings',
      \'path': g:learnings_wiki_path,
      \'path_html': g:learnings_wiki_path . '/public',
      \'auto_tags': 1,
      \'auto_export': 1,
      \}

let g:dotfiles_wiki_path = $DOTFILES.'/wiki'
let g:dotfiles_wiki = {
      \'name': 'Dotfiles Wiki',
      \'path': g:dotfiles_wiki_path,
      \'path_html': g:dotfiles_wiki_path . '/public',
      \'auto_toc': 1,
      \'auto_tags': 1,
      \}

let g:vimwiki_auto_chdir    = 1
let g:vimwiki_tags_header   = 'Wiki tags'
let g:vimwiki_auto_header   = 1
let g:vimwiki_hl_headers    = 1 " too colourful
let g:vimwiki_conceal_pre   = 1
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_listsyms = '✗○◐●✓'
let g:vimwiki_list = [g:wiki, g:learnings_wiki, g:dotfiles_wiki]

let g:vimwiki_global_ext = 0
let g:vimwiki_folding = 'expr'

function! s:close_wikis() abort
  let bufs = range(1, bufnr('$'))
  for buf in bufs
    if bufexists(buf) && getbufvar(buf, '&filetype') == 'vimwiki' && winbufnr(buf) == -1
      silent! execute buf 'bdelete'
    endif
  endfor
endfunction

function! s:autocommit() abort
  try
    let msg = 'Auto commit'
    let add = 'git -C '.g:learnings_wiki_path.' add .'
    let commit = 'git -C '.g:learnings_wiki_path.' commit -m "'.msg.'" .'
    call luaeval('require("akinsho.async_job").execSync(_A)', [add, commit])
  catch /.*/
    echoerr v:exception
    echo 'occurred at: '.v:throwpoint
    echoerr 'failed to commit '.g:learnings_wiki_path
  endtry
endfunction

function! s:auto_push(...) abort
  try
    call utils#message('pushing '.g:learnings_wiki_path.'...', 'Title')
    let cmd = 'git -C '. g:learnings_wiki_path. ' push -q origin master'
    call luaeval('require("akinsho.async_job").exec(_A, 0)', cmd)
  catch /.*/
    echoerr v:exception
  endtry
endfunction

let s:timer = -1

function! s:auto_save_start() abort
  if s:timer < 0
    call utils#message('Starting learning wiki auto save', 'Title')
    let s:timer = timer_start(1000 * 60 * 5, function('s:auto_push'), { 'repeat': -1 })
  endif
endfunction

function! s:auto_save_stop() abort
  call utils#message('Stopping learning wiki auto save', 'Title')
  call timer_stop(s:timer)
  let s:timer = -1
endfunction


if has('nvim') " autocommit is a lua based function
  let s:target_wiki = g:learnings_wiki_path . '/*.wiki'
  if isdirectory(g:learnings_wiki_path . '/.git')
    augroup AutoCommitLearningsWiki
      autocmd!
      execute 'autocmd BufWritePost '. s:target_wiki .' call <SID>autocommit()'
      execute 'autocmd BufEnter,FocusGained '. s:target_wiki .' call <SID>auto_save_start()'
      execute 'autocmd BufLeave,FocusLost '. s:target_wiki .' call <SID>auto_save_stop()'
    augroup END
  endif
endif

command! CloseVimWikis call s:close_wikis()
nnoremap <silent> <leader>wq :CloseVimWikis<CR>
