" Vim syntax file
" Add checkboxes to *.md files
" source: https://gist.github.com/huytd/668fc018b019fbc49fa1c09101363397
" based on: https://www.reddit.com/r/vim/comments/h8pgor/til_conceal_in_vim/

" Custom conceal (does not work with existing syntax highlight plugin)
syntax match todoCheckbox "- \[\ \]" conceal cchar=
syntax match todoCheckbox "- \[x\]" conceal cchar=

highlight def link todoCheckbox Todo

highlight Conceal ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE

" Avoid highlighting any of the following as misspelled words:
"
" * URIs (i.e., words prefixed by one or more alphanumeric characters followed
"   by a "://" delimiter), strongly inspired by this blog post:
"     http://www.panozzaj.com/blog/2016/03/21/ignore-urls-and-acroynms-while-spell-checking-vim/
" * Acronyms (i.e., words comprised of only three or more uppercase
"   alphanumeric characters optionally followed by an "s"), strongly inspired
"   by the same blog post.
"
" Note that these highlight groups only apply to a subset of filetypes. For
" more complex filetypes (e.g., Python), a "containedin=" clause explicitly
" referencing the type of parent highlight group containing these child
" highlight groups is required. To prevent filetype plugins from ignoring these
" highlight groups, these groups *MUST* be added to a custom
" "~/.vim/after/syntax/{filetype.vim}" filetype plugin rather than listed here.
" See also this explanatory StackOverflow answer:
"     https://vi.stackexchange.com/a/4003/16249
syntax match NoSpellUri '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell
syntax match NoSpellAcronym '\<\(\u\|\d\)\{3,}s\?\>' contains=@NoSpell
