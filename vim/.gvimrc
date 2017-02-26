
"Add lightline a more light weight airline alternative
Plugin 'itchyny/lightline.vim'

  let g:lightline = {
    \ 'colorscheme': 'sialoquent',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component': {
    \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
    \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
    \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
    \ },
    \ 'component_visible_condition': {
    \   'readonly': '(&filetype!="help"&& &readonly)',
    \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
    \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '∿', 'right': '❂' }
    \ }
endif

"Theme for MacVim=============================================
let g:webdevicons_enable = 0

  colorscheme sialoquent

  " set transparency=4
  set guifont=Roboto\ Mono\ Light\ for\ Powerline:h14

  let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
  highlight GitGutterAdd guifg = '#A3E28B'
  let g:gitgutter_sign_modified = '•'
  let g:gitgutter_sign_added = '❖'
