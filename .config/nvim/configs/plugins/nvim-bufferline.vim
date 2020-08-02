if !PluginLoaded('nvim-bufferline.lua')
  finish
endif


lua << EOF
require'bufferline'.setup {
  options = {
    view = "multiwindow",
    mappings = true,
  };
}
EOF
