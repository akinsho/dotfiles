"---------------------------------------------------------------------------//
" BUFTABLINE
""---------------------------------------------------------------------------//
highlight BufTabLineHidden guibg=#22252B guifg=#5A5E68
highlight BufTabLineCurrent guifg=#A2E8F6 gui=bold
highlight BufTabLineActive guifg=white
highlight BufTablineFill guibg=#22252B
highlight TabLineSel guifg=#A2E8F6 guifg=#5A5E68 gui=bold
let g:buftabline_indicators = 1
let g:buftabline_numbers = 2
nmap <localleader>1 <Plug>BufTabLine.Go(1)
nmap <localleader>2 <Plug>BufTabLine.Go(2)
nmap <localleader>3 <Plug>BufTabLine.Go(3)
nmap <localleader>4 <Plug>BufTabLine.Go(4)
nmap <localleader>5 <Plug>BufTabLine.Go(5)
nmap <localleader>6 <Plug>BufTabLine.Go(6)
nmap <localleader>7 <Plug>BufTabLine.Go(7)
nmap <localleader>8 <Plug>BufTabLine.Go(8)
nmap <localleader>9 <Plug>BufTabLine.Go(9)
nmap <localleader>0 <Plug>BufTabLine.Go(10)
if has('gui_running') || has('gui_vimr')
  if has('nvim')
    tmap <D-0> <C-\><C-n><Plug>BufTabLine.Go(1)
    tmap <D-2> <C-\><C-n><Plug>BufTabLine.Go(2)
    tmap <D-3> <C-\><C-n><Plug>BufTabLine.Go(3)
    tmap <D-4> <C-\><C-n><Plug>BufTabLine.Go(4)
    tmap <D-5> <C-\><C-n><Plug>BufTabLine.Go(5)
    tmap <D-6> <C-\><C-n><Plug>BufTabLine.Go(6)
    tmap <D-7> <C-\><C-n><Plug>BufTabLine.Go(7)
    tmap <D-8> <C-\><C-n><Plug>BufTabLine.Go(8)
  endif
  nmap <D-0> <Plug>BufTabLine.Go(1)
  nmap <D-2> <Plug>BufTabLine.Go(2)
  nmap <D-3> <Plug>BufTabLine.Go(3)
  nmap <D-4> <Plug>BufTabLine.Go(4)
  nmap <D-5> <Plug>BufTabLine.Go(5)
  nmap <D-6> <Plug>BufTabLine.Go(6)
  nmap <D-7> <Plug>BufTabLine.Go(7)
  nmap <D-8> <Plug>BufTabLine.Go(8)
  nmap <D-9> <Plug>BufTabLine.Go(9)
endif
"}}}
