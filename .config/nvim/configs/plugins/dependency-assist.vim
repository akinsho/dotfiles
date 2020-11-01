if !PluginLoaded('dependency-assist.nvim')
  finish
endif

lua << EOF
  require'dependency_assist'.setup{
    key = '<C-P>'
  }
EOF
