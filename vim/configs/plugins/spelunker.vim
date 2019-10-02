if !has_key(g:plugs,"spelunker")
  finish
endif

set nospell
" Enable spelunker.vim. (default: 1)
" 1: enable
" 0: disable
let g:enable_spelunker_vim = 1
" Max amount of word suggestions. (default: 15)
let g:spelunker_max_suggest_words = 10
" Max amount of highlighted words in buffer. (default: 100)
let g:spelunker_max_hi_words_each_buf = 100
" Spellcheck type: (default: 1)
" 1: File is checked for spelling mistakes when opening and saving. This
" may take a bit of time on large files.
" 2: Spellcheck displayed words in buffer. Fast and dynamic. The waiting time
" depends on the setting of CursorHold `set updatetime=1000`.
let g:spelunker_check_type = 2
" Highlight type: (default: 1)
" 1: Highlight all types (SpellBad, SpellCap, SpellRare, SpellLocal).
" 2: Highlight only SpellBad.
" FYI: https://vim-jp.org/vimdoc-en/spell.html#spell-quickstart
let g:spelunker_highlight_type = 1
