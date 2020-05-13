""---------------------------------------------------------------------------//
" STARTIFY
""---------------------------------------------------------------------------//
let g:startify_lists = [
    \ { 'type': 'sessions',  'header': ['  😸 Sessions']       },
    \ { 'type': 'files',     'header': ['   MRU']            },
    \ { 'type': 'dir',       'header': ['   Recently opened in '. getcwd()] },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \ ]

let  g:startify_bookmarks    =  [
      \ {'v': '~/.vimrc'},
      \ {'z': '~/.zshrc'},
      \ {'t': '~/.tmux.conf'}
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
