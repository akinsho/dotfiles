""---------------------------------------------------------------------------//
" Deoplete Options
""---------------------------------------------------------------------------//
if exists('g:gui_oni')
  finish
endif
let g:deoplete#enable_at_startup       = 1
if !has('nvim')
  call deoplete#custom#option('yarp', v:true)
endif

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

call deoplete#custom#source('tag', 'rank', 9999)
" lambda - λ
" call deoplete#custom#option('ignore_sources', {'_': ['buffer']})
call deoplete#custom#source('ultisnips',    'rank', 150)
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
