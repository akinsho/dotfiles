if !has_key(g:plugs, 'nvim-bufferline.lua')
  finish
endif


lua << EOF
require'bufferline'.setup {
  options = {
    view = "multiwindow",
    numbers = "ordinal",
    number_style = "superscript",
  };
  bufferline_tab_selected = {
    guifg = "#E5C07B",
    guibg = "#3E4452"
  };
}
EOF
