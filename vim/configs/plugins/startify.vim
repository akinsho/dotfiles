""---------------------------------------------------------------------------//
" STARTIFY
""---------------------------------------------------------------------------//
let g:startify_list_order = [
      \ ['   😸 My Sessions:'],
      \ 'sessions',
      \ [' → Recent'],
      \ 'files',
      \ [' → My Bookmarks:'],
      \ 'bookmarks',
      \ [' → Recent files in current directory:'],
      \ 'dir',
      \ ['  → Commands:'],
      \ 'commands',
      \ ]

let g:startify_session_before_save = [
      \ 'echo "Cleaning up before saving.."',
      \ 'silent! NERDTreeClose',
      \ ]
let g:startify_session_dir         = '~/.vim/session'
let g:startify_bookmarks           = [
      \ {'v': '~/.vimrc'},
      \ {'z': '~/.zshrc'},
      \ {'t': '~/.tmux.conf'}
      \ ]

let g:startify_skiplist = [
      \ 'COMMIT_EDITMSG',
      \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc',
      \ 'bundle/.*/doc',
      \ '/data/repo/neovim/runtime/doc',
      \ ]
let g:startify_fortune_use_unicode    = 1
let g:startify_session_autoload       = 1
let g:startify_session_delete_buffers = 1
let g:startify_session_persistence    = 1
let g:startify_update_oldfiles        = 1
let g:startify_session_sort           = 1
let g:startify_change_to_vcs_root     = 1
nnoremap <localleader>ss :SSave!<CR>
"}}}
