" Define prefix dictionary
let g:which_leader_key_map =  {}
let g:which_localleader_key_map =  {}

let g:which_localleader_key_map.0 = 'which_key_ignore'
let g:which_localleader_key_map.1 = 'which_key_ignore'
let g:which_localleader_key_map.2 = 'which_key_ignore'
let g:which_localleader_key_map.3 = 'which_key_ignore'
let g:which_localleader_key_map.4 = 'which_key_ignore'
let g:which_localleader_key_map.5 = 'which_key_ignore'
let g:which_localleader_key_map.6 = 'which_key_ignore'
let g:which_localleader_key_map.7 = 'which_key_ignore'
let g:which_localleader_key_map.8 = 'which_key_ignore'
let g:which_localleader_key_map.9 = 'which_key_ignore'

let g:which_localleader_key_map.h = 'Change two horizontally split windows to vertical splits'
let g:which_localleader_key_map.v = 'Change two vertically split windows to horizontal splits'
let g:which_localleader_key_map.l = 'Redraw window'
let g:which_localleader_key_map.q = 'Close quickfix/location list'
let g:which_localleader_key_map.z = 'Center view port'
let g:which_localleader_key_map.e = { 'name': '+edit-tab' }
let g:which_localleader_key_map.e.v = 'Open vimrc in a new tab'
let g:which_localleader_key_map.n = 'New file'
let g:which_localleader_key_map[','] = 'Add comma to end of line'
let g:which_localleader_key_map[';'] = 'Add semicolon to end of line'
let g:which_localleader_key_map['?'] = 'Search for word under cursor in google'
let g:which_localleader_key_map['!'] = 'Search for word under cursor in google'
let g:which_localleader_key_map['<tab>'] = 'Open vim bufferlist'
let g:which_localleader_key_map["["] = 'Open space above'
let g:which_localleader_key_map["]"] = 'Insert space below'

let g:which_leader_key_map.n = { 'name': '+new' }
let g:which_leader_key_map.e = { 'name': '+edit-buffer' }
let g:which_leader_key_map.ar = 'Toggle auto resize'
let g:which_leader_key_map.f = 'Find cursor word (fzf)'
let g:which_leader_key_map.F = 'Find word (prompt)'
let g:which_leader_key_map.E = 'Show token under the cursor'
let g:which_leader_key_map.g = 'Grep word under the cursor'
let g:which_leader_key_map.gl = 'Copy git url for current line'
let g:which_leader_key_map.l = { 'name': 'left' }
let g:which_leader_key_map.l.i = 'Toggle quickfix/location list'
let g:which_leader_key_map.l['<CR>'] = 'open terminal right'
let g:which_leader_key_map.z = 'Zoom in current buffer'
let g:which_leader_key_map.Z = 'Zoom in with tab'
let g:which_leader_key_map.ev = 'Open vimrc in a new buffer'
let g:which_leader_key_map.ez = 'Open zshrc in a new buffer'
let g:which_leader_key_map.et = 'Open tmux config in a new buffer'
let g:which_leader_key_map.s = 'Sort a visual selection'
let g:which_leader_key_map.so = 'Source current buffer'
let g:which_leader_key_map.sv = 'Source init.vim'
let g:which_leader_key_map.U = 'Uppercase all word'
let g:which_leader_key_map.n.f ='Create a new file'
let g:which_leader_key_map[","] = 'Go to previous buffer'
let g:which_leader_key_map["="] = 'Make windows equal size'
let g:which_leader_key_map[")"] = 'Wrap with parens'
let g:which_leader_key_map["}"] = 'Wrap with braces'
let g:which_leader_key_map["\""] = 'Wrap with double quotes'
let g:which_leader_key_map["\'"] = 'Wrap with single quotes'
let g:which_leader_key_map['on'] = 'Close all other buffers'
let g:which_leader_key_map["["] = 'Subsitute cursor word in file'
let g:which_leader_key_map["]"] = 'Substitue cursor word on line'
let g:which_leader_key_map["<s-tab>"] = 'Go to previous buffer'
let g:which_leader_key_map["<tab>"] = 'Go to next buffer'

" The map must be registered before the mappings below
call which_key#register('<space>', "g:which_localleader_key_map")
call which_key#register(',', "g:which_leader_key_map")

nnoremap <silent> <localleader>      :<c-u>WhichKey '<space>'<CR>
nnoremap <silent> <leader>           :<c-u>WhichKey  ','<CR>
