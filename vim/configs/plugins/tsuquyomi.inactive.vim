let g:tsuquyomi_auto_open              = 1
let g:tsuquyomi_disable_quickfix       = 1
if has('gui_running') && has('ballooneval')
  set ballooneval
  augroup TsuBal
    autocmd BufNewFile,BufRead *.ts
          \ setlocal ballonexpr=tsuquyomi#balloonexpr()
  augroup END
endif
