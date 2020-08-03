if !PluginLoaded("vim-which-key")
  finish
endif
" Define prefix dictionary
let g:which_leader_key_map =  {
      \ '1' : 'which_key_ignore',
      \ '2' : 'which_key_ignore',
      \ '3' : 'which_key_ignore',
      \ '4' : 'which_key_ignore',
      \ '5' : 'which_key_ignore',
      \ '6' : 'which_key_ignore',
      \ '7' : 'which_key_ignore',
      \ '8' : 'which_key_ignore',
      \ '9' : 'which_key_ignore',
      \ '10' : 'which_key_ignore',
      \ 'A': 'Projectionist: edit alternate',
      \ 'av': 'Projectionst: vsplit alternate',
      \ 'a' : 'Coc codeaction (for text object)',
      \ 'c' : {
      \   'name': '+Coc command',
      \   'f': 'search: cursor word',
      \   'y': 'list: yank',
      \   'b': 'list: branches',
      \   'd': 'list: diagnostic',
      \   'c': 'list: command',
      \   'e': 'list: extension',
      \   'o': 'list: outline',
      \   's': 'list: symbol',
      \   'm': 'list: marketplace',
      \   'r': 'list: resume',
      \   'a': 'codelens: action'
      \},
      \ 'h': {
      \   'name': '+Git hunk',
      \   's': 'stage',
      \   'u': 'undo',
      \},
      \ 'r': {
      \ 'name': '+Coc edit',
      \   'a': 'codeaction: entire file',
      \   'r': 'refactor',
      \   'f': 'fix current line',
      \   'n': 'rename cursor word'
      \ },
      \ 'n' : {
      \  'name': '+New',
      \  'f' :'Create a new file',
      \  's' : 'Create new file in a split',
      \ },
      \ 'f' : 'Find cursor word (fzf)',
      \ 'F' : 'Find word (prompt)',
      \ 'E' : 'Show token under the cursor',
      \ 'p' : {
      \   'name': '+Vim plug',
      \   'u': 'Update',
      \   'c': 'Clean',
      \   's': 'Status',
      \   'i': 'Install'
      \ },
      \ 'q': 'Sayonara: close buffer (keep window)',
      \ 'g' : 'Grep word under the cursor',
      \ 'l' : {
      \   'name': '+List',
      \   'i' : 'Toggle location list',
      \   's': 'Toggle quickfix'
      \ },
      \ 'e' : {
      \   'name': '+Edit',
      \   'v' : 'Open vimrc in a new buffer',
      \   'z' : 'Open zshrc in a new buffer',
      \   't' : 'Open tmux config in a new buffer',
      \},
      \ 'o' : {
      \   'name': '+Only',
      \   'n': 'Close all other buffers',
      \ },
      \ 'u': 'Toggle undo tree',
      \ ',s': 'Subversive: range',
      \ 's': 'Subversive: current word',
      \ 'ss': 'Subversive: entire line',
      \ 'S': 'Subversive: till end of line',
      \ 'w' : 'Save',
      \ 'wt': 'Open vimwiki index',
      \ 'z' : 'Zoom in current buffer',
      \ 'Z' : 'Zoom in with tab',
      \ 'sw' : 'Swap buffers horizontally',
      \ 'so' : 'Source current buffer',
      \ 'sv' : 'Source init.vim',
      \ 'U' : 'Uppercase all word',
      \ "," : 'Go to previous buffer',
      \ "=" : 'Make windows equal size',
      \ ")" : 'Wrap with parens',
      \ "}" : 'Wrap with braces',
      \ "\"" : 'Wrap with double quotes',
      \ "'" : 'Wrap with single quotes',
      \ "`" : 'Wrap with back ticks',
      \ "[" : 'Subsitute cursor word in file',
      \ "]" : 'Substitute cursor word on line',
      \ "<s-tab>" : 'Go to previous buffer',
      \ "<tab>" : 'Go to next buffer',
      \}

let g:which_localleader_key_map =  {
      \ '0' : 'which_key_ignore',
      \ '1' : 'which_key_ignore',
      \ '2' : 'which_key_ignore',
      \ '3' : 'which_key_ignore',
      \ '4' : 'which_key_ignore',
      \ '5' : 'which_key_ignore',
      \ '6' : 'which_key_ignore',
      \ '7' : 'which_key_ignore',
      \ '8' : 'which_key_ignore',
      \ '9' : 'which_key_ignore',
      \ 'g' : {
      \   'name': '+Git commands',
      \   'c': 'Git commit',
      \   's': 'FZF: git status',
      \   'b': 'Coc: Git browse',
      \   'u': 'Coc: Copy git URL',
      \   'p': 'Git push (terminal)',
      \   'pf': 'Git push --force (terminal)',
      \},
      \ 'h' : 'Change two horizontally split windows to vertical splits',
      \ 'v' : 'Change two vertically split windows to horizontal splits',
      \ 'l' : 'Redraw window',
      \ 'q' : 'Close buffer (kill window)',
      \ 'z' : 'Center view port',
      \ 't' : {
      \   'name': '+Vim Test',
      \   'n' : 'Test nearest',
      \   'f' : 'Test file',
      \   's' : 'Test suite',
      \},
      \ 's': {
      \  'name': '+Session',
      \  's': 'Save'
      \} ,
      \ ',' : 'Add comma to end of line',
      \ ';' : 'Add semicolon to end of line',
      \ '?' : 'Search for word under cursor in google',
      \ '!' : 'Search for word under cursor in google',
      \ '<tab>' : 'Open vim bufferlist',
      \ "[" : 'Open space above',
      \ "]" : 'Insert space below',
      \}

let g:which_key_use_floating_win       = 0
let g:which_key_disable_default_offset = 1

if !g:which_key_use_floating_win
  autocmd! FileType which_key
  autocmd  FileType which_key set laststatus=0
        \| autocmd BufLeave <buffer> set laststatus=2
endif

call which_key#register(',', 'g:which_leader_key_map')
call which_key#register('<Space>', 'g:which_localleader_key_map')
nnoremap <silent> <localleader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <leader>           :<c-u>WhichKey  ','<CR>
