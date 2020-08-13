setlocal foldmethod=manual " Leave folding to Coc

" Open flutter only commands in dart files
nnoremap <silent><leader>cc :CocList --input=flutter commands<CR>
nnoremap <silent><leader>co :CocCommand flutter.toggleOutline<CR>
