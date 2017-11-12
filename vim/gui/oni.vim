set noruler
set laststatus=0

augroup TS
  au!
  autocmd FileType *.ts,*.tsx let g:ale_set_signs = 0
augroup END
