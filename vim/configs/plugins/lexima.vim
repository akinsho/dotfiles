" call lexima#add_rule({'char': '|', 'input_after': '|', 'filetype': 'reason', 'syntax': 'rustFoldBraces'})
" FIXME: Raise an issue on the styled-components repo
augroup js_styled_bug
  au!
  au Filetype javascript,javascript.jsx let b:lexima_enable_newline_rules = 0
augroup END
