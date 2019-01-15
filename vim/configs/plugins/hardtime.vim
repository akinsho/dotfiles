""---------------------------------------------------------------------------//
" HardTime
""---------------------------------------------------------------------------//"
let g:hardtime_allow_different_key    = 1
let g:hardtime_maxcount               = 2
let g:hardtime_default_on             = 1
let g:hardtime_ignore_buffer_patterns = [ "NERD.*" ]
let g:hardtime_ignore_quickfix = 1
let g:hardtime_timeout                = 1500

" if strftime("%H") > 18 "Turn on Hard Time out of working hours
"   let g:hardtime_default_on             = 1
"   exe 'HardTimeOn'
" else
"   let g:hardtime_default_on             = 0
" endif
