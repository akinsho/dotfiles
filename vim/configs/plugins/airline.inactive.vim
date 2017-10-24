""---------------------------------------------------------------------------//
"               Airline 
""---------------------------------------------------------------------------//
augroup AirLineRefresh
  autocmd BufDelete * call airline#extensions#tabline#buflist#invalidate()
augroup END
let g:airline_highlighting_cache                          = 1
let g:airline#extensions#branch#empty_message             = "No Git 😅"
let g:airline_skip_empty_sections                         = 1
let g:airline#parts#ffenc#skip_expected_string            = 'utf-8[unix]'
let g:airline_powerline_fonts                             = 1
let g:airline#extensions#tabline#enabled                  = 1
let g:airline#extensions#tabline#switch_buffers_and_tabs  = 1
let g:airline#extensions#tabline#show_tabs                = 1
let g:airline#extensions#tabline#tab_nr_type              = 2 " Show # of splits and tab #
let g:airline#extensions#tabline#fnamemod                 = ':t'
let g:airline#extensions#tabline#show_tab_type            = 1
let g:airline#extensions#tabline#fnamecollapse            = 1
let g:airline#extensions#tabline#keymap_ignored_filetypes = ['vimfiler', 'nerdtree']
let g:airline#extensions#tabline#formatter                = 'unique_tail_improved'
let g:airline#extensions#tabline#tab_min_count            = 1
" let g:airline#extensions#tabline#left_sep                 = ''
" let g:airline#extensions#tabline#left_alt_sep             = ''
" let g:airline#extensions#tabline#right_sep                = ''
" let g:airline#extensions#tabline#right_alt_sep            = ''
" let g:airline_left_alt_sep                                = ''
" let g:airline_right_alt_sep                               = ''
" let g:airline_right_sep                                   = ''
" let g:airline_left_sep                                    = ''
let g:ff_map = { "unix": "␊", "mac": "␍", "dos": "␍␊" }
let g:airline_section_c = airline#section#create(["%{getcwd()}", g:airline_symbols.space, '%t %{GetFileSize()}'])
"Get method finds the fileformat array and returns the matching key the &ff or ? expand tab shows whether i'm using spaces or tabs
let g:airline_section_y ="%{get(g:ff_map,&ff,'?').(&expandtab?'\ ˽\ ':'\ ⇥\ ').&tabstop}"
let g:airline#extensions#tabline#show_close_button = 1
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:airline_inactive_collapse                    = 1
" * configure pattern to be ignored on BufAdd autocommand >
" fixes unnecessary redraw, when e.g. opening Gundo window
let airline#extensions#tabline#ignore_bufadd_pat   =
      \ '\c\vgundo|undotree|vimfiler|tagbar|nerd_tree'

let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <localleader>1 <Plug>AirlineSelectTab1
nmap <localleader>2 <Plug>AirlineSelectTab2
nmap <localleader>3 <Plug>AirlineSelectTab3
nmap <localleader>4 <Plug>AirlineSelectTab4
nmap <localleader>5 <Plug>AirlineSelectTab5
nmap <localleader>6 <Plug>AirlineSelectTab6
nmap <localleader>7 <Plug>AirlineSelectTab7
nmap <localleader>8 <Plug>AirlineSelectTab8
nmap <localleader>9 <Plug>AirlineSelectTab9
nmap <localleader>- <Plug>AirlineSelectPrevTab
nmap <localleader>+ <Plug>AirlineSelectNextTab
"}}}
""---------------------------------------------------------------------------//
