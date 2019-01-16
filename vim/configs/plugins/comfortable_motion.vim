""---------------------------------------------------------------------------//
" COMFORTABLE MOTION 
""---------------------------------------------------------------------------//
" Scroll proportional to window height
let g:comfortable_motion_no_default_key_mappings = 0
noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>
"}}}
