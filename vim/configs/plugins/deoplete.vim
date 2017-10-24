""---------------------------------------------------------------------------//
" Deoplete Options
""---------------------------------------------------------------------------//
  let g:deoplete#enable_at_startup       = 1
  let g:deoplete#enable_smart_case       = 1
  let g:deoplete#enable_ignore_case      = 1
  let g:deoplete#enable_camel_case       = 1
  let g:deoplete#max_menu_width          = 80
  let g:deoplete#max_menu_height         = 50
  let g:deoplete#file#enable_buffer_path = 1
  let g:tmuxcomplete#trigger                     = ''
  let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
  call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])
  call deoplete#custom#source('ultisnips', 'rank', 630)
  call deoplete#custom#set('typescript',   'rank', 600)
  call deoplete#custom#set('buffer',       'mark', '')
  call deoplete#custom#set('ternjs',       'mark', '')
  call deoplete#custom#set('vim',          'mark', '')
  call deoplete#custom#set('tern',         'mark', '')
  call deoplete#custom#set('omni',         'mark', '⌾')
  call deoplete#custom#set('file',         'mark', '')
  call deoplete#custom#set('jedi',         'mark', '')
  call deoplete#custom#set('typescript',   'mark', '')
  call deoplete#custom#set('ultisnips',    'mark', '')
  "}}}
