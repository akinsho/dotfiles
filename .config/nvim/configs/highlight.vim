""---------------------------------------------------------------------------//
" Color Scheme {{{1
""---------------------------------------------------------------------------//
set background=dark
if PluginLoaded('onedark.vim')
  " ========================
  " OneDark
  " ========================
  func s:one_dark_overrides() abort
    " These overrides should be called before the plugin loads
    " Bold (+/- italicised) types
    call onedark#extend_highlight('Title', { 'gui': 'bold' })
    call onedark#extend_highlight('Type', { 'gui': 'italic,bold' })
    call onedark#extend_highlight('htmlArg', { 'gui': 'italic,bold' })
    " Italicised imports
    call onedark#extend_highlight('Include', { 'gui': 'italic' })
    call onedark#extend_highlight('jsImport', { 'gui': 'italic' })
    call onedark#extend_highlight('jsExport', { 'gui': 'italic' })
    call onedark#extend_highlight('jsExportDefault', { 'gui': 'italic,bold' })
    " Italicises function calls
    call onedark#extend_highlight('jsFuncCall', { 'gui': 'italic' })
    call onedark#extend_highlight('TabLineSel', { 'bg': { 'gui': '#61AFEF', 'cterm': 8} })
    call onedark#set_highlight('SpellRare', {
          \ 'gui': 'undercurl',
          \ 'bg': { 'gui': 'transparent', 'cterm': 'NONE', 'cterm16': 'NONE'   },
          \ 'fg': { 'gui': 'transparent', 'cterm': 'NONE', 'cterm16': 'NONE'  },
          \ })
  endfunc
  augroup OneDarkOverrides
    autocmd!
    autocmd ColorScheme * call s:one_dark_overrides()
  augroup END

  let g:onedark_terminal_italics = 1
  colorscheme onedark
elseif PluginLoaded('vim-one')
  " ========================
  " ONE
  " ========================
  " See highlight.vim for colorscheme overrides
  let g:one_allow_italics = 1
  colorscheme one
elseif PluginLoaded('material.vim')
  " ========================
  " Material
  " ========================
  " let g:material_theme_style = 'default' | 'palenight' | 'ocean' | 'lighter' | 'darker'
  colorscheme material
elseif PluginLoaded('candid.vim')
  " ========================
  " Candid
  " ========================
  colorscheme candid
elseif PluginLoaded('night-owl.vim')
  " ========================
  " Night Owl
  " ========================
  colorscheme night-owl
elseif PluginLoaded('vim-monokai-tasty')
  " ========================
  " Monokai Tasty
  " ========================
  let g:vim_monokai_tasty_italic = 1
  colorscheme vim-monokai-tasty
endif

"--------------------------------------------------------------------------------
" Plugin highlights
"--------------------------------------------------------------------------------
function! s:plugin_highlights() abort
  if PluginLoaded('vim-sneak')
    " Highlighting sneak and it's label is a little complicated
    " The plugin creates a colorscheme autocommand that
    " checks for the existence of these highlight groups
    " it is best to leave this as is as they are picked up on colorscheme loading
    " N.B: we explicitly set the background even though it overrides the colorscheme
    " because without it the plugin bizarrely resets the background
    highlight Sneak guifg=red guibg=background
    highlight SneakLabel gui=italic,bold,underline guifg=red guibg=background
    highlight SneakLabelMask guifg=red guibg=background
  endif

  if PluginLoaded('vim-which-key')
    highlight WhichKeySeperator guifg=LightGreen guibg=background
  endif

  if !PluginLoaded('conflict-marker.vim')
    " Highlight VCS conflict markers
    match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
  endif
endfunction

function! s:general_overrides() abort
  highlight Todo gui=bold
  highlight Credit gui=bold
  highlight CursorLineNr guifg=yellow gui=bold
  highlight FoldColumn guibg=background
  highlight! link Folded Comment
  highlight MatchParen gui=bold guifg=lightGreen guibg=NONE
  highlight IncSearch guibg=NONE guifg=LightGreen gui=italic,bold,underline
  highlight clear mkdLineBreak
  " Add undercurl to existing spellbad highlight
  highlight SpellBad gui=undercurl guibg=transparent guifg=transparent guisp=green

  highlight! link dartStorageClass Statement

  " Customize Diff highlighting
  highlight DiffAdd guibg=green guifg=NONE
  highlight DiffDelete guibg=red guifg=#5c6370 gui=NONE

  " NOTE: these highlights are used by fugitive's Git buffer
  " highlight! link DiffAdded DiffAdd
  " highlight! link DiffRemoved DiffDelete
  highlight DiffChange guibg=#344f69 guifg=NONE
  highlight DiffText guibg=#2f628e guifg=NONE
endfunction

""---------------------------------------------------------------------------//
" Colorscheme highlights
""---------------------------------------------------------------------------//
function! s:colorscheme_overrides() abort
  if g:colors_name ==? 'one'
    call one#highlight('Type', 'e5c07b', '', 'italic,bold')
    " Italicise imports
    call one#highlight('jsxComponentName', '61afef', '', 'bold,italic')
    call one#highlight('Include', '61afef', '', 'italic')
    call one#highlight('jsImport', '61afef', '', 'italic')
    call one#highlight('jsExport', '61afef', '', 'italic')
    call one#highlight('typescriptImport', 'c678dd', '', 'italic')
    call one#highlight('typescriptExport', '61afef', '', 'italic')
    call one#highlight('vimCommentTitle', 'c678dd', '', 'bold,italic')
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
endfunction

function! s:apply_user_highlights() abort
  if has('nvim')
    highlight TermCursor ctermfg=green guifg=green
    highlight link MsgSeparator Comment
  endif
  call s:plugin_highlights()
  call s:general_overrides()
  call s:colorscheme_overrides()
endfunction


augroup InitHighlights
  au!
  autocmd VimEnter * call s:apply_user_highlights()
  autocmd ColorScheme * call s:apply_user_highlights()
augroup END
