setlocal iskeyword+=:,#
setlocal foldmethod=marker
nnoremap <silent><buffer><leader>so :source % <bar> :call utils#message('Sourced ' . expand('%'), 'Title')<CR>

" add custom vim-surround mappings for vim
" https://github.com/AndrewRadev/Vimfiles/blob/eada7a20dc705729f963348357d7754124d0b183/ftplugin/vim.vim#L3
let b:surround_{char2nr('i')} = "if \1if: \1 \r endif"
let b:surround_{char2nr('w')} = "while \1while: \1 \r endwhile"
let b:surround_{char2nr('f')} = "for \1for: \1 {\r endfor"
let b:surround_{char2nr('e')} = "foreach \1foreach: \1 \r enforeach"
let b:surround_{char2nr('F')} = "function! \1function: \1() \r endfunction"
let b:surround_{char2nr('T')} = "try \r endtry"
