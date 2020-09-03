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
lua << EOF
  local jobs = require"async_job"
  local msg = 'Auto commit'
  local path = vim.g.learnings_wiki_path
  local add_job = jobs.exec('git -C '..path..' add .')
  local result = vim.fn.jobwait({add_job})
  if result and result[1] > 0 then
    local err_cmd = string.format(
      'echoerr "Failed to commit %s"', vim.g.learnings_wiki_path
    )
    vim.cmd(err_cmd)
  end
  jobs.exec('git -C '..path..' commit -m "'..msg..'" .')
EOF
  catch /.*/
    echoerr v:exception
    echo 'occurred at: '.v:throwpoint
    echoerr 'failed to commit '.g:learnings_wiki_path
  endtry
endfunction


if has('nvim') " autocommit is a lua based function
  augroup AutoCommitLearningsWiki
    autocmd!
    execute 'autocmd BufWritePost '. g:learnings_wiki_path . '/*.wiki call <SID>autocommit()'
  augroup END
endif

command! CloseVimWikis call s:close_wikis()
nnoremap <silent> <leader>wq :CloseVimWikis<CR>
