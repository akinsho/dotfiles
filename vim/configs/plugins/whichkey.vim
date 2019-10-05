" Define prefix dictionary
let g:which_leader_key_map =  {}
let g:which_localleader_key_map =  {}

let g:which_localleader_key_map.h = 'Change two horizontally split windows to vertical splits'
let g:which_localleader_key_map.v = 'Change two vertically split windows to horizontal splits'
let g:which_localleader_key_map.l = 'Redraw window'
let g:which_localleader_key_map.q = 'close quickfix/location list'
let g:which_localleader_key_map.z = 'center view port'
let g:which_localleader_key_map.e = { 'name': '+edit-tab' }
let g:which_localleader_key_map.e.v = 'open vimrc in a new tab'
let g:which_localleader_key_map.n = 'new-file'
let g:which_localleader_key_map[','] = 'add comma to end of line'
let g:which_localleader_key_map[';'] = 'add semicolon to end of line'
let g:which_localleader_key_map['?'] = 'Search for word under cursor in google'
let g:which_localleader_key_map['!'] = 'Search for word under cursor in google'
let g:which_localleader_key_map.TAB = 'open vim bufferlist'
let g:which_localleader_key_map.0 = 'open buffer 0'
let g:which_localleader_key_map.1 = 'open buffer 1'
let g:which_localleader_key_map.2 = 'open buffer 2'
let g:which_localleader_key_map.3 = 'open buffer 3'
let g:which_localleader_key_map.4 = 'open buffer 4'
let g:which_localleader_key_map.5 = 'open buffer 5'
let g:which_localleader_key_map.6 = 'open buffer 6'
let g:which_localleader_key_map.7 = 'open buffer 7'
let g:which_localleader_key_map.8 = 'open buffer 8'
let g:which_localleader_key_map.9 = 'open buffer 9'
let g:which_localleader_key_map["["] = 'open space above'
let g:which_localleader_key_map["]"] = 'insert space below'

let g:which_leader_key_map.e = { 'name': '+edit-buffer' }
let g:which_leader_key_map.z = 'Zoom in current buffer'
let g:which_leader_key_map.Z = 'Zoom in with tab'
let g:which_leader_key_map.ev = 'open vimrc in a new buffer'
let g:which_leader_key_map.ez = 'open zshrc in a new buffer'
let g:which_leader_key_map.et = 'open tmux config in a new buffer'
let g:which_leader_key_map.s = 'sort a visual selection'
let g:which_leader_key_map.n = { 'name': '+new' }
let g:which_leader_key_map.n.f ='create a new file'
let g:which_leader_key_map[")"] = 'wrap with parens'
let g:which_leader_key_map["}"] = 'wrap with braces'
let g:which_leader_key_map["\""] = 'wrap with double quotes'
let g:which_leader_key_map["\'"] = 'wrap with single quotes'
let g:which_leader_key_map['on'] = 'close all other buffers'
let g:which_leader_key_map.TAB = 'Go to next buffer'
let g:which_leader_key_map["s-tab"] = 'Go to next buffer'

" The map must be registered before the mappings below
call which_key#register('<space>', "g:which_localleader_key_map")
call which_key#register(',', "g:which_leader_key_map")

nnoremap <silent> <localleader>      :<c-u>WhichKey '<space>'<CR>
nnoremap <silent> <leader>           :<c-u>WhichKey  ','<CR>
