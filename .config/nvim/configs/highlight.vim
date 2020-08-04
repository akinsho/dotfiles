""---------------------------------------------------------------------------//
" Highlights
""---------------------------------------------------------------------------//
function! ApplyUserHighlights() abort
  "---------------------------------------------------------------------------//
  " Set the colour column to highlight one column after the 'textwidth'
  set colorcolumn=+1

  if !PluginLoaded('conflict-marker.vim')
    " Highlight VCS conflict markers
    match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
  endif

  if has('nvim')
    highlight TermCursor ctermfg=green guifg=green
    highlight link MsgSeparator Comment
  endif

  " Add undercurl to existing spellbad highlight
  let s:error_fg = synIDattr(hlID('Error'), 'fg')
  let s:rare_fg = synIDattr(hlID('SpellRare'), 'fg')
  execute 'highlight SpellBad gui=undercurl guibg=transparent guifg=transparent guisp='.s:error_fg

  " Define highlight for URIs e.g. http://stackoverflow.com
  " this is used in the syntax after files for highlighting URIs in comments
  let s:comment_fg = synIDattr(hlID('Comment'), 'fg')
  execute 'highlight URIHighlight guisp='.s:comment_fg.' gui=underline,italic guifg='.s:comment_fg

  highlight Todo gui=bold
  highlight Credit gui=bold
  highlight CursorLineNr guifg=yellow gui=bold
  highlight FoldColumn guibg=background
  highlight! link dartStorageClass Statement

  " Customize Diff highlighting
  highlight DiffAdded guibg=NONE
  highlight DiffAdd guibg=green guifg=NONE
  highlight DiffDelete guibg=red guifg=NONE
  highlight! link DiffChange IncSearch
  highlight! link DiffText Search
  ""---------------------------------------------------------------------------//
  " Custom highlights
  ""---------------------------------------------------------------------------//
  if g:colors_name ==? 'one'
    call one#highlight('Folded', '5c6370', 'none', 'italic,bold')
    call one#highlight('Type', 'e5c07b', 'none', 'italic,bold')
    " Italicise imports
    call one#highlight('Include', '61afef', 'none', 'italic')
    call one#highlight('jsImport', '61afef', 'none', 'italic')
    call one#highlight('jsExport', '61afef', 'none', 'italic')
    call one#highlight('typescriptImport', 'c678dd', 'none', 'italic')
    call one#highlight('typescriptExport', '61afef', 'none', 'italic')
    call one#highlight('vimCommentTitle', 'c678dd', 'none', 'bold,italic')
  elseif g:colors_name ==? 'onedark'
    " Do nothing overrides have been done elsewhere
  elseif g:colors_name ==? 'vim-monokai-tasty'
    highlight clear SignColumn
    highlight GitGutterAdd guifg=green
    highlight GitGutterChange guifg=yellow
    highlight GitGutterDelete guifg=red
    " Italicise imports and exports without breaking their base highlights
    call utils#extend_highlight('Special', 'SpecialItalic', 'gui=italic')
    highlight link typescriptImport SpecialItalic
    highlight link typescriptExport SpecialItalic
    highlight link jsxAttrib SpecialItalic
    highlight tsxAttrib gui=italic,bold
  else " No specific colour scheme with overrides then do it manually
    highlight jsFuncCall gui=italic
    highlight Comment gui=italic cterm=italic
    highlight xmlAttrib gui=italic,bold cterm=italic,bold ctermfg=121
    highlight jsxAttrib cterm=italic,bold ctermfg=121
    highlight Type    gui=italic,bold cterm=italic,bold
    highlight jsThis ctermfg=224,gui=italic
    highlight Include gui=italic cterm=italic
    highlight jsFuncArgs gui=italic cterm=italic ctermfg=217
    highlight jsClassProperty ctermfg=14 cterm=bold,italic term=bold,italic
    highlight jsExportDefault gui=italic,bold cterm=italic ctermfg=179
    highlight htmlArg gui=italic,bold cterm=italic,bold ctermfg=yellow
    highlight Folded  gui=bold,italic cterm=bold
    highlight link typescriptExport jsImport
    highlight link typescriptImport jsImport
  endif
  "---------------------------------------------------------------------------//
endfunction


augroup InitHighlights
  au!
  autocmd VimEnter * call ApplyUserHighlights()
  autocmd ColorScheme * call ApplyUserHighlights()
augroup END
