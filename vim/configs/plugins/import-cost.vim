if !has_key(g:plugs, "vim-import-cost") 
  finish
endif

augroup import_cost_auto_run
  autocmd!
  autocmd InsertLeave *.js,*.jsx,*.ts,*.tsx silent! ImportCost
  autocmd BufEnter *.js,*.jsx,*.ts,*.tsx  silent! ImportCost
  autocmd BufLeave *.js,*.jsx,*.ts,*.tsx ImportCostClear
augroup END
