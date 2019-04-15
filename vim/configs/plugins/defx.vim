if !has_key(g:plugs, 'defx.nvim')
  finish
endif

function! DefxRoot(path) abort
  return fnamemodify(a:path, ':t')
endfunction

call defx#custom#source('file', {
      \ 'root': 'DefxRoot',
      \})

call defx#custom#column('filename', {
      \ 'directory_icon': '',
      \ 'opened_icon': '',
      \ })

call defx#custom#column('mark', {
      \ 'readonly_icon': '✗',
      \ 'selected_icon': '✓',
      \ })

call defx#custom#option('_', {
      \ 'columns': 'indent:git:icons:filename:type',
      \ 'buffer_name':'',
      \ 'root_marker':'Current: ',
      \ 'show_ignored_files': 1,
      \ 'split' : 'vertical',
      \ 'direction': 'topleft',
      \ 'toggle': 1,
      \ 'sort': 'Time',
      \})

" Git
if has_key(g:plugs, 'defx-git')
  let g:defx_git#indicators = {
        \ 'Modified'  : '✹',
        \ 'Staged'    : '✚',
        \ 'Untracked' : '✭',
        \ 'Renamed'   : '➜',
        \ 'Unmerged'  : '═',
        \ 'Ignored'   : '☒',
        \ 'Deleted'   : '✖',
        \ 'Unknown'   : '?'
        \ }
endif

if has_key(g:plugs, 'defx-icons')
  " Icons
  let g:defx_icons_column_length = 2
  let g:defx_icons_mark_icon = '*'
  let g:defx_icons_default_icon = ''
  let g:defx_icons_directory_symlink_icon = ''

  " Speeds up defx massively
  let g:defx_icons_enable_syntax_highlight = 1
endif

nnoremap <silent><C-N> :call OpenDefx()<CR>
function! OpenDefx() abort
  let g:defx_open_path = getcwd()
  execute('Defx
        \ -winwidth=`&columns / 5`
        \ -search=`expand("%:p")`
        \ `g:defx_open_path`')
endfunction

function! s:defx_context_menu() abort
  let l:actions = ['new_multiple_files', 'rename', 'copy', 'move', 'paste', 'remove']
  let l:selection = confirm('Action?', "&New file/directory\n&Rename\n&Copy\n&Move\n&Paste\n&Delete")
  silent exe 'redraw'

  return feedkeys(defx#do_action(l:actions[l:selection - 1]))
endfunction

augroup DefxCommands
  au!
  autocmd! FileType defx call s:defx_mappings()
augroup END

function! s:defx_mappings() abort
  nnoremap <silent><buffer>M :call <sid>defx_context_menu()<CR>
  nnoremap <silent><buffer><expr> c defx#do_action('copy')
  nnoremap <silent><buffer><expr> m defx#do_action('move')
  nnoremap <silent><buffer><expr> p defx#do_action('paste')
  nnoremap <silent><buffer><expr> r defx#do_action('rename')
  nnoremap <silent><buffer><expr> o
        \ defx#is_directory() ?
        \ defx#do_action('open_or_close_tree') :
        \ defx#do_action('multi', ['drop', 'quit'])
  nnoremap <silent><buffer><expr> O defx#do_action('open_tree_recursive')
  nnoremap <silent><buffer><expr> d defx#do_action('remove_trash')
  nnoremap <silent><buffer><expr> l defx#do_action('open_directory')
  nnoremap <silent><buffer><expr> v defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> D defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N defx#do_action('new_file')
  nnoremap <silent><buffer><expr> x defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> h defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q defx#do_action('quit')
  nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> * defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> cd defx#do_action('change_vim_cwd')
  nnoremap <silent><buffer><expr> <CR>
        \ defx#is_directory() ?
        \ defx#do_action('open') :
        \ defx#do_action('multi', ['drop', 'quit'])
  nnoremap <silent><buffer><expr> C
        \ defx#do_action('toggle_columns',
        \                'mark:filename:type:size:time')
  nnoremap <silent><buffer><expr> ;
        \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> <c-p> defx#do_action('print')
  nnoremap <silent><buffer><expr> <c-r> defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <space> defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> <RightMouse> defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> <2-LeftMouse> defx#do_action('drop')
endfunction
