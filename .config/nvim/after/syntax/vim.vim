" Avoid highlighting any of the following as misspelled words:
"
" * URIs (i.e., words prefixed by one or more alphanumeric characters followed
"   by a "://" delimiter), strongly inspired by this blog post:
"   http://www.panozzaj.com/blog/2016/03/21/ignore-urls-and-acroynms-while-spell-checking-vim/
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
"
" See also this explanatory StackOverflow answer:
" https://vi.stackexchange.com/a/4003/16249
if hlexists('vimLineComment')
  syntax match NoSpellAcronym '\<\(\u\|\d\)\{3,}s\?\>' transparent contains=@NoSpell containedin=vim.*Comment,vim.*String
endif
