setlocal spell spelllang=en_gb
setlocal expandtab
setlocal shiftwidth=2
setlocal nowrap
setlocal softtabstop=2
setlocal colorcolumn=
setlocal concealcursor=
setlocal nonumber norelativenumber

highlight VimwikiDelText gui=strikethrough guifg=#5c6370 guibg=background
highlight VimwikiLink gui=underline guifg=#61AFEF
highlight link VimwikiCheckBoxDone VimwikiDelText

if v:lua.as.plugin_loaded('which-key.nvim')
lua << EOF
  local ok, wk = pcall(require, "which-key")
  if ok then
    wk.register({
      w = {
        name = "+wiki",
        d  = 'delete current wiki file',
        h  = 'convert wiki to html',
        hh = 'convert wiki to html & open browser',
        r  = 'rename wiki file',
        n  = 'go to vim wiki page specified',
        s = 'select wiki',
        i = 'go to diary index',
        w = 'go to wiki index',
        t = 'go to wiki index in a tab',
      }
    }, {prefix = "<leader>"})
  end
EOF
endif
