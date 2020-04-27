" Programatically derive colors for lightline mods
function! tabline#get_theme_background(highlight) abort
  let l:gui_bgcolor = synIDattr(hlID(a:highlight), 'bg#')
  if !strlen(l:gui_bgcolor)
    let l:gui_bgcolor = synIDattr(hlID(a:highlight), 'fg#')
  endif
  return l:gui_bgcolor
endfunction

let s:theme_opts = {
      \ 'one': { 'name': 'one', 'color': '#1b1e24' },
      \ 'onedark': { 'name': 'onedark', 'color': '#1b1e24' },
      \ 'palenight': { 'name': 'palenight', 'color': '' },
      \ 'tender': { 'name': 'tender', 'color': '#1d1d1d' },
      \ 'nightowl': { 'name': 'nightowl', 'color': '#060F1F' },
      \ 'vim-monokai-tasty': { 'name': 'monokai_tasty', 'color': '#1d1d1d' }
      \ }

let s:colors = {
      \ 'gold'         : '#F5F478',
      \ 'bright_blue'  : '#A2E8F6',
      \ 'dark_blue'    : '#4e88ff',
      \ 'dark_yellow'  : '#d19a66',
      \ 'green'        : '#98c379'
      \}

let theme_colors = get(s:theme_opts, g:colors_name, { 'color': '#1b1e24' })
let s:tabline_background = theme_colors['color']
let s:tabline_foreground = tabline#get_theme_background('Comment')
let s:selected_background = tabline#get_theme_background('Normal')

function! tabline#get_colors() abort
  return extend({
        \ 'tabline_foreground': s:tabline_foreground,
        \ 'tabline_background': s:tabline_background,
        \ 'tabline_selected_background': s:selected_background
        \ }, s:colors)
endfunction
