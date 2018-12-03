""---------------------------------------------------------------------------//
" Deoplete Options
""---------------------------------------------------------------------------//
if exists('g:gui_oni')
  finish
endif
let g:deoplete#enable_at_startup       = 1
if !has('nvim')
  let g:deoplete#enable_yarp             = 1
endif
let g:deoplete#enable_smart_case       = 1
let g:deoplete#enable_ignore_case      = 1
let g:deoplete#enable_camel_case       = 1
let g:deoplete#max_menu_width          = 80
let g:deoplete#max_menu_height         = 50
let g:deoplete#file#enable_buffer_path = 1
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns   = {}
endif
" lambda - λ
call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
call deoplete#custom#source('ultisnips', 'rank', 630)
call deoplete#custom#source('buffer',       'mark', '')
call deoplete#custom#source('ternjs',       'mark', '')
call deoplete#custom#source('vim',          'mark', '')
call deoplete#custom#source('tern',         'mark', '')
call deoplete#custom#source('omni',         'mark', '⌾')
call deoplete#custom#source('file',         'mark', '')
call deoplete#custom#source('jedi',         'mark', '')
call deoplete#custom#source('typescript',   'mark', '')
call deoplete#custom#source('ultisnips',    'mark', '')
call deoplete#custom#source('around',       'mark', '⚡')
call deoplete#custom#source('flow',         'mark', '')
