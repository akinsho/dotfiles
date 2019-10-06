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
let g:which_localleader_key_map.q = 'close quickfix/location list'
let g:which_localleader_key_map.z = 'center view port'
let g:which_localleader_key_map.e = { 'name': '+edit-tab' }
let g:which_localleader_key_map.e.v = 'open vimrc in a new tab'
let g:which_localleader_key_map.n = 'new file'
let g:which_localleader_key_map[','] = 'add comma to end of line'
let g:which_localleader_key_map[';'] = 'add semicolon to end of line'
let g:which_localleader_key_map['?'] = 'Search for word under cursor in google'
let g:which_localleader_key_map['!'] = 'Search for word under cursor in google'
let g:which_localleader_key_map['<TAB>'] = 'open vim bufferlist'
let g:which_localleader_key_map["["] = 'open space above'
let g:which_localleader_key_map["]"] = 'insert space below'

let g:which_leader_key_map.ar = 'toggle auto resize'
let g:which_leader_key_map.e = { 'name': '+edit-buffer' }
let g:which_leader_key_map.f = 'find cursor word (fzf)'
let g:which_leader_key_map.F = 'find word (prompt)'
let g:which_leader_key_map.E = 'Show token under the cursor'
let g:which_leader_key_map.g = 'grep word under the cursor'
let g:which_leader_key_map.l = { 'name': 'left' }
let g:which_leader_key_map.l.i = 'Toggle quickfix/location list'
let g:which_leader_key_map.l['<CR>'] = 'open terminal right'
let g:which_leader_key_map.z = 'Zoom in current buffer'
let g:which_leader_key_map.Z = 'Zoom in with tab'
let g:which_leader_key_map.ev = 'open vimrc in a new buffer'
let g:which_leader_key_map.ez = 'open zshrc in a new buffer'
let g:which_leader_key_map.et = 'open tmux config in a new buffer'
let g:which_leader_key_map.s = 'sort a visual selection'
let g:which_leader_key_map.so = 'source current buffer'
let g:which_leader_key_map.sv = 'source init.vim'
let g:which_leader_key_map.U = 'Uppercase all word'
let g:which_leader_key_map.n = { 'name': '+new' }
let g:which_leader_key_map.n.f ='create a new file'
let g:which_leader_key_map[","] = 'go to previous buffer'
let g:which_leader_key_map["="] = 'make windows equal size'
let g:which_leader_key_map[")"] = 'wrap with parens'
let g:which_leader_key_map["}"] = 'wrap with braces'
let g:which_leader_key_map["\""] = 'wrap with double quotes'
let g:which_leader_key_map["\'"] = 'wrap with single quotes'
let g:which_leader_key_map['on'] = 'close all other buffers'
let g:which_leader_key_map["["] = 'subsitute cursor word in file'
let g:which_leader_key_map["]"] = 'substitue cursor word on line'
let g:which_leader_key_map["<s-tab>"] = 'Go to previous buffer'
let g:which_leader_key_map["<tab>"] = 'Go to next buffer'

" The map must be registered before the mappings below
call which_key#register('<space>', "g:which_localleader_key_map")
call which_key#register(',', "g:which_leader_key_map")

nnoremap <silent> <localleader>      :<c-u>WhichKey '<space>'<CR>
nnoremap <silent> <leader>           :<c-u>WhichKey  ','<CR>
