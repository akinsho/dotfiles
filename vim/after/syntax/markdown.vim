" Vim syntax file
" Add checkboxes to *.md files
" source: https://gist.github.com/huytd/668fc018b019fbc49fa1c09101363397
" based on: https://www.reddit.com/r/vim/comments/h8pgor/til_conceal_in_vim/

" Custom conceal (does not work with existing syntax highlight plugin)
" syntax match todoCheckbox "\[\ \]" conceal cchar=
" syntax match todoCheckbox "\[x\]" conceal cchar=

call matchadd('Conceal', '\[\ \]', 0, -1, {'conceal': ''})
call matchadd('Conceal', '\[x\]', 0, -1, {'conceal': ''})

highlight def link todoCheckbox Todo

highlight Conceal ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
