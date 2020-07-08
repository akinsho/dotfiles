""---------------------------------------------------------------------------//
" STARTIFY
""---------------------------------------------------------------------------//
let g:startify_lists = [
    \ { 'type': 'sessions',  'header': ['  😸 Sessions']       },
    \ { 'type': 'files',     'header': ['   Recent']            },
    \ { 'type': 'dir',       'header': ['   Recently opened in '. fnamemodify(getcwd(), ':t')] },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \ ]

let  g:startify_bookmarks    =  [
    \ {'z': '~/.zshrc'},
    \ {'v': '~/.config/nvim/init.vim'},
    \ {'t': '~/.config/tmux/.tmux.conf'},
    \ {'d': $DOTFILES }
    \ ]


let g:startify_commands = [
    \ {'pu': ['Update plugins',':PlugUpdate | PlugUpgrade']},
    \ {'ps': ['Plugins status', ':PlugStatus']},
    \ {'h':  ['Help', ':help']}
    \ ]

let g:startify_fortune_use_unicode    = 1
let g:startify_session_autoload       = 1
let g:startify_session_delete_buffers = 1
let g:startify_session_persistence    = 1
let g:startify_update_oldfiles        = 1
let g:startify_session_sort           = 1
let g:startify_change_to_vcs_root     = 0
nnoremap <localleader>ss :SSave!<CR>
"}}}
