"--------------------------------------------------------------------------------
"  Whitespace highlighting
"--------------------------------------------------------------------------------
" source: https://vim.fandom.com/wiki/Highlight_unwanted_spaces (comment at the bottom)
" implementation: https://github.com/inkarkat/vim-ShowTrailingWhitespace

function s:is_applicable_buf() abort
  return strlen(&buftype) == 0
endfunction

function whitespace#setup() abort
  highlight ExtraWhitespace ctermfg=red guifg=red
endfunction

function! whitespace#toggle_trailing(mode)
  if !s:is_applicable_buf()
    return
  endif
  let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
  if exists('w:whitespace_match_number')
    call matchdelete(w:whitespace_match_number)
    call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
  else
    let w:whitespace_match_number =  matchadd('ExtraWhitespace', pattern)
  endif
endfunction
