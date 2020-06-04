""---------------------------------------------------------------------------//
" Fold Text
""---------------------------------------------------------------------------//
" Current profile:
" using profile func utils#fold_text
" 0.022417s i.e. 22ms
" keep in mind this is called a lot but this is largely fine but
" slow in more general terms due to poor viml performance
" ---------------------------------------------------------------------------//
function s:replace_tabs(value) abort
  return substitute(a:value, '\t', repeat(' ', &tabstop), 'g')
endfunction

" CREDIT:
" getline returns the line leading whitespace so we remove it
" https://stackoverflow.com/questions/5992336/indenting-fold-text
function s:strip_whitespace(value) abort
  return substitute(a:value, '^\s*', '', 'g')
endfunction

function s:prepare_fold_section(value) abort
  return s:strip_whitespace(s:replace_tabs(a:value))
endfunction

" List of filetypes to use default fold text for
let s:fold_exclusions = ['vim']

function s:is_ignored() abort
  return index(s:fold_exclusions, &filetype) >= 0 || &diff
endfunction

function s:is_import(item) abort
  return strlen(matchstr(a:item, "^import")) > 0
endfunction

function s:transform_import(item, foldsymbol) abort
  " this regex matches anything after an import followed by a space
  " this might not hold true for all languages but think it does
  " for all the ones I use
  return substitute(a:item, '^import .\+', 'import '.a:foldsymbol, '')
endfunction

" Naive regex to match closing delimiters (undoubtedly there are edge cases)
" if the fold text doesn't include delimiter characters just append an
" empty string. This avoids folds that look like func…end or
" import 'pkg'…import 'second-pkg'
" this fold text should handle cases like
"
" value.Struct{
"    Field : String
" }.Method()
" turns into
"
" value.Struct{…}.Method()
"
function s:contains_delimiter(value) abort
  return strlen(matchstr(a:value, '}\|)\|]\|`\|>', 'g'))
endfunction

" We initially check if the fold start text is an import by looking for the
" 'import' keyword at the Start of a line. If it is we replace the line with
" import … although if the fold end text contains a delimiter
" e.g.
" import {
"   thing1
" } from 'apple'
" '}' being a delimiter we instead allow normal folding to happen
" ie.
" import {…} from 'apple'
function s:handle_fold_start(start_text, end_text, foldsymbol) abort
  if s:is_import(a:start_text) && !s:contains_delimiter(a:end_text)
    return s:transform_import(a:start_text, a:foldsymbol)
  endif
  return s:prepare_fold_section(a:start_text) . a:foldsymbol
endfunction

function s:handle_fold_end(item) abort
  if !s:contains_delimiter(a:item) || s:is_import(a:item)
    return ''
  endif
  return  s:prepare_fold_section(a:item)
endfunction

" CREDIT:
" 1. https://coderwall.com/p/usd_cw/a-pretty-vim-foldtext-function
function! folds#render(...)
  if s:is_ignored()
    return foldtext()
  endif
  let end_text = getline(v:foldend)
  let start_text = getline(v:foldstart)
  let end = s:handle_fold_end(end_text)
  let start = s:handle_fold_start(start_text, end_text, '…')
  let line = start . end
  let lines_count = v:foldend - v:foldstart + 1
  let count_text = '('.lines_count .' lines)'
  let fold_char = matchstr(&fillchars, 'fold:\')
  let indentation = indent(v:foldstart)
  let fold_start = repeat(' ', indentation) . line
  let fold_end = count_text . repeat(' ', 2)
  " NOTE: foldcolumn can now be set to a value of auto:Count e.g auto:5
  " so we split off the auto portion so we can still get the line count
  let column_size = split(&foldcolumn, ":")[-1]
  let text_length = strlen(substitute(fold_start . fold_end, '.', 'x', 'g')) + column_size
  return fold_start . repeat(' ', winwidth(0) - text_length - 7) . fold_end
endfunction

