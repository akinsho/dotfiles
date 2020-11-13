" If fugitive is the last window then close it and go to the previous one
if winnr('$') == 1
  execute 'bd | b#'
endif

resize 14
setlocal nonumber norelativenumber
setlocal winfixheight
