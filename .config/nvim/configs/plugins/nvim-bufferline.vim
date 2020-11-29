if !PluginLoaded('nvim-bufferline.lua')
  finish
endif


lua << EOF
require'bufferline'.setup {
  options = {
    mappings = true,
    sort_by = "directory",
    separator_style = "slant"
  };
}
EOF

nnoremap <silent> gb :BufferLinePick<CR>
nnoremap <silent><leader><tab>  :BufferLineCycleNext<CR>
nnoremap <silent><S-tab> :BufferLineCyclePrev<CR>
nnoremap <silent>[b  :BufferLineMoveNext<CR>
nnoremap <silent>]b :BufferLineMovePrev<CR>
