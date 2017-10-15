""---------------------------------------------------------------------------//
" Highlights {{{
""---------------------------------------------------------------------------//
" Highlight cursor column onwards - kind of cool
""---------------------------------------------------------------------------//
" let &colorcolumn=join(range(81,999),",")
" highlight ColorColumn guibg=#2c3a41
" set colorcolumn=80
""---------------------------------------------------------------------------//
syntax clear SpellBad
syntax clear SpellCap
syntax clear SpellLocal
syntax clear SpellRare
syntax clear Search

highlight SpellBad  term=underline cterm=italic ctermfg=Red
highlight SpellCap  term=underline cterm=italic ctermfg=Blue
highlight! link SpellLocal SpellCap
highlight! link SpellRare SpellCap
" Clearing conceal messes up indent guide lines
" highlight clear Conceal "Sets no highlighting for conceal
highlight Conceal gui=bold
""---------------------------------------------------------------------------//
"few nicer JS colours
""---------------------------------------------------------------------------//
" highlight jsFuncCall gui=italic ctermfg=cyan
" highlight cssBraces guifg=cyan
highlight xmlAttrib gui=italic,bold cterm=italic,bold ctermfg=121
highlight jsxAttrib cterm=italic,bold ctermfg=121
highlight jsThis ctermfg=224
highlight jsSuper ctermfg=13
highlight Include gui=italic cterm=italic
highlight jsFuncArgs gui=italic cterm=italic ctermfg=217
highlight jsClassProperty ctermfg=14 cterm=bold,italic term=bold,italic
highlight jsExportDefault gui=italic,bold cterm=italic ctermfg=179
highlight Type gui=italic,bold cterm=italic
highlight htmlArg gui=italic,bold cterm=italic,bold ctermfg=yellow
highlight Comment gui=italic cterm=italic
highlight Type    gui=italic,bold cterm=italic,bold
" highlight Identifier gui=italic,bold
highlight CursorLine term=none cterm=none
highlight Folded  gui=bold guifg=#A2E8F6
highlight WildMenu guibg=#004D40 guifg=white ctermfg=none ctermbg=none
highlight MatchParen cterm=bold ctermbg=none guifg=#29EF58 guibg=NONE
"Color the tildes at the end of the buffer
" hi link EndOfBuffer VimFgBgAttrib
"#282C34
if has('gui_running')
  hi VertSplit guibg=bg guifg=bg
endif
""---------------------------------------------------------------------------//
" Startify Highlighting
""---------------------------------------------------------------------------//
hi StartifyBracket  guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifyFile     guifg=#eeeeee ctermfg=255 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifyFooter   guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifyHeader   guifg=#E7B563 ctermfg=114 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifyNumber   guifg=#f8f8f2 ctermfg=215 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifyPath     guifg=#8a8a8a ctermfg=245 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifySection  guifg=#E7B563 ctermfg=114 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifySelect   guifg=#5fdfff ctermfg=81 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifySlash    guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifySpecial  guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
if has('nvim')
  highlight TermCursor ctermfg=green guifg=green
endif
""---------------------------------------------------------------------------//
"Autocomplete menu highlighting
""---------------------------------------------------------------------------//
"make the completion menu a bit more readable
highlight PmenuSel guibg=#004D40 guifg=white gui=bold
highlight PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
highlight PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE
highlight BufTabLineCurrent gui=bold guibg=#E7B563 guifg=black
"}}}
""---------------------------------------------------------------------------//
""---------------------------------------------------------------------------//
" NETRW
""---------------------------------------------------------------------------//
let g:netrw_liststyle    = 3
let g:netrw_banner       = 0
let g:netrw_browse_split = 4
let g:netrw_winsize      = 25
let g:netrw_altv         = 1
augroup netrw
  autocmd!
  autocmd FileType netrw map <buffer> q :q<CR>
  autocmd FileType netrw map <buffer> l <CR>
  autocmd FileType netrw map <buffer> h <CR>
augroup END
" NERDTrees highlighting {{{
""---------------------------------------------------------------------------//
function! NERDTreeHighlightFile(extension, fg, bg, guifg)
  exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guifg='. a:guifg
  exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('html', 202, 'none', '#FC4709')
call NERDTreeHighlightFile('hbs', 202, 'none', '#FC4709')
call NERDTreeHighlightFile('jade', 149, 'none', '#A0D24D')
call NERDTreeHighlightFile('json', 223, 'none', '#FECEA0')
call NERDTreeHighlightFile('scss', 44, 'none', '#db7093')
call NERDTreeHighlightFile('css', 44, 'none', '#db7093')
call NERDTreeHighlightFile('js', 226, 'none', '#FFD700')
call NERDTreeHighlightFile('ts', 226, 'none', '#2EB4FF')
call NERDTreeHighlightFile('tsx', 226, 'none', '#2EB4FF')
call NERDTreeHighlightFile('go', 039, 'none', '#5BD9FF')
call NERDTreeHighlightFile('rb', 197, 'none', '#E53378')
call NERDTreeHighlightFile('md', 208, 'none', '#FD720A')
call NERDTreeHighlightFile('jsx', 140, 'none', '#9E6FCD')
call NERDTreeHighlightFile('svg', 178, 'none', '#CDA109')
call NERDTreeHighlightFile('gif', 36, 'none', '#15A274')
call NERDTreeHighlightFile('jpg', 36, 'none', '#15A274')
call NERDTreeHighlightFile('png', 36, 'none', '#15A274')
call NERDTreeHighlightFile('vim', 36, 'none', '#87bb7c')
call NERDTreeHighlightFile('DS_Store', 'Gray', 'none', '#686868')
call NERDTreeHighlightFile('gitconfig', 'Gray', 'none', '#686868')
call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#686868')
call NERDTreeHighlightFile('bashrc', 'Gray', 'none', '#686868')
call NERDTreeHighlightFile('zshrc', 'Gray', 'none', '#686868')
call NERDTreeHighlightFile('bashprofile', 'Gray', 'none', '#151515')
" NERDTree: Set colors
hi! NERDTreeGitStatusModified ctermfg=1 guifg=#D370A3
hi! NERDTreeGitStatusStaged ctermfg=10 guifg=#A3D572
hi! NERDTreeGitStatusUntracked ctermfg=12 guifg=#98CBFE
hi! def link NERDTreeGitStatusDirDirty Constant
hi! def link NERDTreeGitStatusDirClean DiffAdd
hi! def link NERDTreeGitStatusUnmerged Label
hi! def link NERDTreeGitStatusUnknown Comment
hi! NERDTreeDir          guifg=#F9F9F8
hi! NERDTreeOpenable     guifg=#E7B563
hi! NERDTreeClosable     guifg=#E7B563
hi! NERDTreeDirSlash     guifg=#7E8E91
hi! NERDTreeCWD          guifg=#7E8E91

" For viewing patches
highlight diffRemoved gui=bold
highlight diffAdded gui=bold
"}}}
""---------------------------------------------------------------------------//
" HardTime {{{
""---------------------------------------------------------------------------//"
nnoremap <leader>ht :HardTimeToggle<CR>
if strftime("%H") > 18 "Turn on Hard Time out of working hours
  let g:hardtime_default_on             = 1
  exe 'HardTimeOn'
else
  let g:hardtime_default_on             = 0
endif
let g:hardtime_timeout                = 500
let g:hardtime_ignore_buffer_patterns = [ "NERD.*" ]
"}}}
""---------------------------------------------------------------------------//
"NERDTree {{{
""---------------------------------------------------------------------------//
" Ctrl+N to toggle Nerd Tree
function! NERDTreeToggleAndFind()
  if (exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1)
    execute 'NERDTreeClose'
  else
    execute 'NERDTreeFind'
  endif
endfunction
nnoremap <silent> <c-n> :NERDTreeToggle<cr>
nnoremap <c-n>f :call NERDTreeToggleAndFind()<CR>

let g:NERDTreeMapOpenSplit              = 's'
let g:NERDTreeMapOpenVSplit             = 'v'
let g:NERDTreeBookmarksFile             = $DOTFILES.'/vim/.NERDTreeBookmarks'
let NERDTreeIgnore = ['\.js.map$', '\.DS_Store$']
let g:NERDTreeAutoDeleteBuffer          = 1
let g:NERDTreeWinSize                   = 30
let g:NERDTreeQuitOnOpen                = 1
let g:NERDTreeMinimalUI                 = 1
let g:NERDTreeCascadeOpenSingleChildDir = 1
let g:NERDTreeShowBookmarks             = 1
let g:NERDTreeAutoDeleteBuffer          = 1
let g:NERDTreeShowHidden                = 1 "Show hidden files by default
" NerdTree Arrow Options = ["├","└"]

let g:webdevicons_enable_nerdtree           = 1
" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:NERDTree')
  if exists('g:loaded_webdevicons')
    call webdevicons#hardRefresh()
  endif
endif
" let g:WebDevIconsUnicodeDecorateFolderNodes                      = 1
" let g:DevIconsEnableFoldersOpenClose                             = 1
" let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol         = ''
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols        = {}
let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol           = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['md']  = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['css'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['js']  = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vim'] = ''
"}}}
""---------------------------------------------------------------------------//
" MAGIT {{{
""---------------------------------------------------------------------------//
nnoremap mgo :MagitOnly<CR>
"}}}
""---------------------------------------------------------------------------//"
" LIGHTLINE {{{
""---------------------------------------------------------------------------//
source $DOTFILES/vim/configs/lightline.vim
"}}}
""---------------------------------------------------------------------------//
" NERDTree Git {{{
""---------------------------------------------------------------------------//
" NERDTree: Git Plugin
let g:NERDTreeIndicatorMapCustom = {
      \ "Modified"  : "",
      \ "Staged"    : "",
      \ "Untracked" : "",
      \ "Renamed"   : "",
      \ "Unmerged"  : "",
      \ "Deleted"   : "",
      \ "Dirty"     : "",
      \ "Clean"     : "",
      \ "Unknown"   : ""
      \ }
"}}}
""---------------------------------------------------------------------------//
" VCoolor {{{
""---------------------------------------------------------------------------//
nnoremap <leader>vc :VCoolor<CR>
inoremap ç <c-o>:VCoolor<CR>
" }}}
"--------------------------------------------
" CTRLSF - CTRL-SHIFT-F {{{
"--------------------------------------------
let g:ctrlsf_default_root = 'project+fw' "Search at the project root i.e git or hg folder
let g:ctrlsf_winsize      = "30%"
let g:ctrlsf_ignore_dir   = ['bower_components', 'node_modules']
let g:ctrlsf_confirm_save = 0
nmap     <C-F>w <Plug>CtrlSFCwordExec
nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>F <Plug>CtrlSFVwordPath
vmap     <C-F>f <Plug>CtrlSFVwordExec
nmap     <C-F>n <Plug>CtrlSFCwordPath
nmap     <C-F>p <Plug>CtrlSFPwordPath
nnoremap <C-F>o :CtrlSFOpen<CR>
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>

function! g:CtrlSFAfterMainWindowInit()
  setl wrap nonumber norelativenumber
endfunction
"}}}
""---------------------------------------------------------------------------//
" COMFORTABLE MOTION {{{
""---------------------------------------------------------------------------//
" Scroll proportional to window height
let g:comfortable_motion_no_default_key_mappings = 1
let g:comfortable_motion_impulse_multiplier = 1.5  " Feel free to increase/decrease this value.
nnoremap <silent> <C-d> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2)<CR>
nnoremap <silent> <C-f> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 4)<CR>
nnoremap <silent> <C-b> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>
noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>
"}}}
""---------------------------------------------------------------------------//
" TEXTOBJECT - COMMENT {{{
""---------------------------------------------------------------------------//
let g:textobj_comment_no_default_key_mappings = 1
xmap ac <Plug>(textobj-comment-a)
omap ac <Plug>(textobj-comment-a)
xmap ic <Plug>(textobj-comment-i)
omap ic <Plug>(textobj-comment-i)
"}}}
""---------------------------------------------------------------------------//
"     ALE {{{
""---------------------------------------------------------------------------//
" Disable linting for all minified JS files.
if has('gui_running')
  let g:ale_set_balloons                 = 1
endif
" Enable completion where available.
" let g:ale_javascript_prettier_options = '--config ~/.prettierrc'
let g:ale_lint_on_insert_leave = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5' "Order of arguments matters here!!
let g:ale_pattern_options = {'\.min.js$': {'ale_enabled': 0}}
let g:ale_fixers = {
      \'typescript':['prettier'],
      \'javascript':['prettier', 'eslint'],
      \'json':'prettier',
      \'css':'stylelint'
      \}
" Allow local in Shell Check
let g:ale_sh_shellcheck_options = '-e SC2039'
let g:ale_echo_msg_format             = '%linter%: %s [%severity%]'
let g:ale_sign_column_always          = 1
let g:ale_sign_error                  = '✘'
let g:ale_sign_warning                = '⚠️'
"TODO: integrate stylelint
let g:ale_linters                     = {
      \'python': ['flake8'],
      \'css': ['stylelint'],
      \'jsx': ['eslint'],
      \'sql': ['sqlint'],
      \'typescript':['tsserver', 'tslint'],
      \'go': ['gofmt -e', 'go vet', 'golint', 'go build', 'gosimple', 'staticcheck'],
      \'html':[]
      \}
let g:ale_set_highlights    = 0
let g:ale_linter_aliases    = {'jsx': 'css', 'typescript.jsx': 'css'}
nmap ]a <Plug>(ale_next_wrap)
nmap [a <Plug>(ale_previous_wrap)
"}}}
""---------------------------------------------------------------------------//
" Gutentags {{{
""---------------------------------------------------------------------------//
let g:gutentags_ctags_exclude = ['*node_modules*', '*bower_components*', 'tmp*', 'temp*', 'package*json',
      \ '*.min.js',
      \ '*html*',
      \ 'jquery*.js',
      \ '*/vendor/*',
      \ '*/python2.7/*',
      \ '*/migrate/*.rb'
      \]
" }}}
""---------------------------------------------------------------------------//
"TAGBAR{{{
""---------------------------------------------------------------------------//
nnoremap <leader>. :TagbarToggle<CR>
let g:tagbar_autoshowtag                = 1
let g:tagbar_autoclose                  = 1
let g:tagbar_show_visibility            = 0
let g:tagbar_autofocus                  = 1
let g:airline#extensions#tagbar#enabled = 0
let g:tagbar_type_typescript = {
      \ 'ctagstype': 'typescript',
      \ 'kinds': [
      \ 'c:classes',
      \ 'n:modules',
      \ 'f:functions',
      \ 'v:variables',
      \ 'v:varlambdas',
      \ 'm:members',
      \ 'i:interfaces',
      \ 'e:enums',
      \ ]
      \ }
"}}}
""---------------------------------------------------------------------------//
" NEOTERM {{{
""---------------------------------------------------------------------------//
let g:neoterm_size         = '20'
let g:neoterm_position     = 'horizontal'
let g:neoterm_automap_keys = ',tt'
let g:neoterm_autoscroll   = 1
let g:neoterm_fixedsize    = 1
" Git commands
command! -nargs=+ Tg :T git <args>
" Useful maps
" hide/close terminal
nnoremap <silent> <leader><CR> :Ttoggle<CR>
nnoremap <silent> <leader>ta :TtoggleAll<CR>
nnoremap <silent> <leader>tn :Tnew<CR>
nnoremap <silent> <leader>tc :Tclose!<CR>
nnoremap <silent> <leader>tx :TcloseAll!<CR>
nnoremap <silent> <leader>ts :TREPLSendFile<cr>
nnoremap <silent> <leader>tl :TREPLSendLine<cr>
vnoremap <silent> <leader>tl :TREPLSendSelection<cr>
nnoremap <silent> <leader>th :call neoterm#close()<cr>
" clear terminal
nnoremap <silent> <leader>tl :call neoterm#clear()<cr>
nnoremap <silent> <leader>tk :call neoterm#kill()<cr>
"}}}
""---------------------------------------------------------------------------//
" FUGITIVE {{{
""---------------------------------------------------------------------------//
" For fugitive.git, dp means :diffput. Define dg to mean :diffget
nnoremap <silent> <leader>dg :diffget<CR>
nnoremap <silent> <leader>dp :diffput<CR>
"Fugitive bindings
nnoremap <leader>gs :Gstatus<CR>
"Stages the current file
nnoremap <leader>gw :Gwrite<CR>
"Rename the current file and the corresponding buffer
nnoremap <leader>gm :Gmove<Space>
"Revert current file to last checked in version
nnoremap <leader>gre :Gread<CR>
"Remove the current file and the corresponding buffer
nnoremap <leader>grm :Gremove<CR>
"See in a side window who is responsible for lines of code
nnoremap <leader>gbl :Gblame<CR>
"Opens the index - i.e. git saved version of a file
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gt :Gcommit -v -q %:p<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>ggp :Ggrep<Space>
nnoremap <leader>gbr :Git branch<Space>
nnoremap <leader>go :Git checkout<Space>
nnoremap <leader>gL :Glog<BAR>:bot copen<CR>
"Open current file on github.com
nnoremap <leader>gb :Gbrowse<CR>
"Make it work in Visual mode to open with highlighted linenumbers
vnoremap <leader>gb :Gbrowse<CR>
"}}}
""---------------------------------------------------------------------------//
""---------------------------------------------------------------------------//
" VIM WIKI {{{
""---------------------------------------------------------------------------//
let g:work_wiki = {}
let g:work_wiki.path = $DOTFILES.'/vim/wiki/work/todo.wiki'
let g:work_wiki.path_html = $DOTFILES.'/vim/wiki/work/todo.html'
let g:play_wiki = {}
let g:play_wiki.path = $DOTFILES.'/vim/wiki/play/todo.wiki'
let g:play_wiki.path_html = $DOTFILES.'vim/wiki/play/todo.html'
let g:vimwiki_listsyms = '✗○◐●✓'
let g:vimwiki_list = [g:play_wiki, g:work_wiki]
"}}}
""---------------------------------------------------------------------------//
" JSX{{{
""---------------------------------------------------------------------------//
let g:jsx_ext_required          = 0 "Allow jsx in .js files REQUIRED
"}}}
""---------------------------------------------------------------------------//
" VIM CSV{{{
""---------------------------------------------------------------------------//
let g:csv_autocmd_arrange      = 1
let g:csv_autocmd_arrange_size = 1024*1024
let g:csv_strict_columns       = 1
let g:csv_highlight_column     = 'y'
"}}}
""---------------------------------------------------------------------------//
"Indent Guide {{{
""---------------------------------------------------------------------------//
let g:indentLine_fileType       = [
      \ 'c',
      \ 'cpp',
      \ 'typescript',
      \ 'javascript',
      \ 'javascript.jsx',
      \ 'typescript.tsx'
      \ ]
let g:indentLine_bufNameExclude = [
      \ 'NERD_tree.*',
      \ 'Startify',
      \ 'terminal',
      \ 'help',
      \ 'magit',
      \ 'peekabo' ]
let g:indentLine_faster         = 1
let g:indentLine_setConceal     = 0
let g:indentLine_concealcursor  = ''
let g:indentLine_char           = '┊'
let g:indentLine_color_term     = 228
" let g:indentLine_char = " ︙"
nnoremap <leader>il :IndentLinesToggle<CR>
"}}}
""---------------------------------------------------------------------------//
"VIM-GO{{{
""---------------------------------------------------------------------------//
let g:go_term_height                    = 30
let g:go_term_width                     = 30
let g:go_term_mode                      = "split"
let g:go_list_type                      = "quickfix"
let g:go_fmt_command                    = "goimports"
let g:go_auto_type_info                 = 0
let g:go_auto_sameids                   = 0
let g:go_fmt_autosave                   = 1
let g:go_doc_keywordprg_enabled         = 0 "Stops auto binding K
let g:go_highlight_variable_assignments = 1
let g:go_def_reuse_buffer               = 1
let g:go_highlight_functions            = 1
let g:go_highlight_methods              = 1
let g:go_highlight_extra_types          = 1
let g:go_highlight_structs              = 1
let g:go_highlight_operators            = 1
let g:go_highlight_build_constraints    = 1
let g:go_metalinter_autosave = 1
let g:go_metalinter_autosave_enabled = ['vet', 'golint', 'vetshadow', 'goconst','ineffassign']
"}}}
""---------------------------------------------------------------------------//
" Git Gutter {{{
""---------------------------------------------------------------------------//
nnoremap <leader>gg :GitGutterToggle<CR>
let g:gitgutter_map_keys              = 0
let g:gitgutter_enabled               = 1
let g:gitgutter_grep_command          = 'ag --nocolor'
let g:gitgutter_sign_modified         = '•'
let g:gitgutter_sign_modified_removed = '±'
let g:gitgutter_sign_added            = '❖'
let g:gitgutter_sign_removed          = '-'
let g:gitgutter_max_signs             = 200
nnoremap <silent> ]c :GitGutterNextHunk<CR>
nnoremap <silent> [c :GitGutterPrevHunk<CR>
nnoremap <silent> <Leader>hr :GitGutterRevertHunk<CR>
nnoremap <silent> <Leader>hp :GitGutterPreviewHunk<CR><c-w>j
nnoremap <silent> <Leader>hs :GitGutterStageHunk<CR>
""---------------------------------------------------------------------------//
" Vim-Expand-Region {{{
""---------------------------------------------------------------------------//
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
"}}}
""---------------------------------------------------------------------------//
" VIM-EASY-ALIGN {{{
""---------------------------------------------------------------------------//
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vnoremap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
"}}}
""---------------------------------------------------------------------------//
" VIM-JAVASCRIPT {{{
""---------------------------------------------------------------------------//
" let g:javascript_conceal_arrow_function = "⇒"
" let g:javascript_conceal_undefined      = "¿"
" let g:javascript_conceal_super          = "Ω"
" let g:javascript_conceal_null           = "ø"
let g:javascript_plugin_flow            = 1
let g:javascript_plugin_jsdoc           = 1
"}}}
""---------------------------------------------------------------------------//
"EasyMotion mappings {{{
""---------------------------------------------------------------------------//
let g:EasyMotion_prompt = 'Jump to → '
let g:EasyMotion_do_mapping       = 0
let g:EasyMotion_startofline      = 0
let g:EasyMotion_smartcase        = 1
let g:EasyMotion_use_smartsign_us = 1
omap t <Plug>(easymotion-bd-tl)
" nmap s <Plug>(easymotion-s)
" Jump to anwhere with only `s{char}{target}`
" `s<CR>` repeat last find motion.
map s <Plug>(easymotion-f)
nmap s <Plug>(easymotion-overwin-f)
" easymotion with hjkl keys
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
"}}}
""---------------------------------------------------------------------------//
"                    EMMET for Vim {{{
""---------------------------------------------------------------------------//
let g:user_emmet_mode         = 'a'
let g:user_emmet_complete_tag = 1
let g:user_emmet_settings     = {
      \ 'html': { 'empty_element_suffix': ' />'  },
      \'javascript': {'extends': 'jsx', 'empty_element_suffix': ' />',
      \},
      \'typescript':{'extends': 'tsx', 'empty_element_suffix': ' />'}
      \}
let g:user_emmet_leader_key     = "<C-Y>"
let g:user_emmet_expandabbr_key =  "<C-Y>"
let g:user_emmet_install_global = 0
"}}}
""---------------------------------------------------------------------------//
" UNDOTREE {{{
""---------------------------------------------------------------------------//
let g:undotree_TreeNodeShape      = '◦' " Alternative: '◉'
let g:undotree_SplitWidth         = 35
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<CR>
"}}}
""---------------------------------------------------------------------------//
" Javascript libraries Syntax {{{
""---------------------------------------------------------------------------//
"Set up libraries to highlight with library syntax highlighter
let g:used_javascript_libs = 'underscore,flux,angularjs,jquery,rambda,react,jasmine,chai,handlebars,requirejs'
"}}}
""---------------------------------------------------------------------------//
" EDITOR CONFIG {{{
""---------------------------------------------------------------------------//
let g:EditorConfig_core_mode = 'external_command' " Speed up editorconfig plugin
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
"}}}
""---------------------------------------------------------------------------//
" NERDComment {{{
""---------------------------------------------------------------------------//
" Commenting
let g:NERDSpaceDelims       = 1
let g:NERDCompactSexyComs   = 1
let g:NERDDefaultAlign      = 'left'
let g:NERDCustomDelimiters  = {
      \ 'jsx': { 'leftAlt': '{/*','rightAlt': '*/}'},
      \ 'javascript.jsx': { 'leftAlt': '{/*','rightAlt': '*/}',
      \ 'left': '//', 'right': ''
      \ },
      \ 'typescript.tsx': { 'leftAlt': '{/*','rightAlt': '*/}',
      \ 'left': '//', 'right': ''
      \ }
      \  }
let g:NERDCommentEmptyLines = 1
"}}}
""---------------------------------------------------------------------------//
" VIM-TEST {{{
""---------------------------------------------------------------------------//
" this can be in the project-local .vimrc
function! TypeScriptTransform(cmd) abort
  return substitute(a:cmd, 'src/\vtest/(\S+)\.ts', 'build/test/\1.js','g')
endfunction

let g:test#custom_transformations = {"typescript": function("TypeScriptTransform")}
let g:test#transformation = "typescript"

nnoremap <silent> <localleader>tn :TestNearest<CR>
nnoremap <silent> <localleader>tf :TestFile<CR>
nnoremap <silent> <localleader>ts :TestSuite<CR>
nnoremap <silent> <localleader>tl :TestLast<CR>
nnoremap <silent> <localleader>tv :TestVisit<CR>
"}}}
""---------------------------------------------------------------------------//
" Polyglot {{{
""---------------------------------------------------------------------------//
let g:polyglot_disabled = ['clojure', 'go']
let g:vue_disable_pre_processors=1
"}}}
""---------------------------------------------------------------------------//
" ELM {{{
""---------------------------------------------------------------------------//
let g:elm_format_autosave   = 1
let g:elm_jump_to_error     = 1
let g:elm_detailed_complete = 1
let g:elm_setup_keybindings = 1
let g:elm_make_output_file  = "index.html"

"}}}
""---------------------------------------------------------------------------//
" ECHODOC {{{
""---------------------------------------------------------------------------//
let g:echodoc#enable_at_startup = 1
let g:echodoc#type              = "signature"
"}}}
"---------------------------------------------------------------------------//
" BUFTABLINE {{{
""---------------------------------------------------------------------------//  "
hi TabLineSel guibg=white guifg=black
let g:buftabline_separators = 0
let g:buftabline_indicators = 1
let g:buftabline_numbers = 2
nmap <localleader>1 <Plug>BufTabLine.Go(1)
nmap <localleader>2 <Plug>BufTabLine.Go(2)
nmap <localleader>3 <Plug>BufTabLine.Go(3)
nmap <localleader>4 <Plug>BufTabLine.Go(4)
nmap <localleader>5 <Plug>BufTabLine.Go(5)
nmap <localleader>6 <Plug>BufTabLine.Go(6)
nmap <localleader>7 <Plug>BufTabLine.Go(7)
nmap <localleader>8 <Plug>BufTabLine.Go(8)
nmap <localleader>9 <Plug>BufTabLine.Go(9)
nmap <localleader>0 <Plug>BufTabLine.Go(10)
if has('gui_running')
  nmap <D-1> <Plug>BufTabLine.Go(1)
  nmap <D-2> <Plug>BufTabLine.Go(2)
  nmap <D-3> <Plug>BufTabLine.Go(3)
  nmap <D-4> <Plug>BufTabLine.Go(4)
  nmap <D-5> <Plug>BufTabLine.Go(5)
  nmap <D-6> <Plug>BufTabLine.Go(6)
  nmap <D-7> <Plug>BufTabLine.Go(7)
  nmap <D-8> <Plug>BufTabLine.Go(8)
  nmap <D-9> <Plug>BufTabLine.Go(9)
  nmap <D-0> <Plug>BufTabLine.Go(10)
endif
"}}}
""---------------------------------------------------------------------------//
" INVESTIGATE {{{
""---------------------------------------------------------------------------//
let g:investigate_syntax_for_typescript = "javascript"
let g:investigate_syntax_for_typescripttsx = "javascript"
let g:investigate_syntax_for_javascriptjsx = "javascript"
let g:investigate_use_dash                 = 1
"}}}
""---------------------------------------------------------------------------//
" Deoplete Options {{{
""---------------------------------------------------------------------------//
if has("nvim")
  let g:deoplete#auto_complete_delay          = 0
  let g:deoplete#enable_at_startup            = 1
  let g:deoplete#auto_completion_start_length = 1
  let g:deoplete#enable_smart_case            = 1
  let g:deoplete#max_menu_width               = 80
  let g:deoplete#max_menu_height              = 40
  let g:deoplete#file#enable_buffer_path      = 1
  let g:deoplete#ignore_sources = {}
  let g:deoplete#ignore_sources._ = ['around']
  call deoplete#custom#source('ultisnips', 'rank', 290)
  call deoplete#custom#source('ternjs', 'rank', 300)
  call deoplete#custom#set('buffer', 'mark', '')
  call deoplete#custom#set('ternjs', 'mark', '')
  call deoplete#custom#set('tern', 'mark', '')
  call deoplete#custom#set('omni', 'mark', '⌾')
  call deoplete#custom#set('file', 'mark', '')
  call deoplete#custom#set('jedi', 'mark', '')
  call deoplete#custom#set('typescript', 'mark', '')
  call deoplete#custom#set('ultisnips', 'mark', '')
  "}}}
  ""---------------------------------------------------------------------------//
  " Deoplete Go {{{
  ""---------------------------------------------------------------------------//
  let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
  let g:deoplete#sources#go#use_cache     = 1
  let g:deoplete#sources#go#pointer       = 1
  let g:deoplete#sources#go#sort_class = [
        \ 'package',
        \ 'func',
        \ 'type',
        \ 'var',
        \ 'const',
        \ 'ultisnips'
        \ ]
  "}}}
  ""---------------------------------------------------------------------------//
  " NVIM TYPESCRIPT {{{
  ""---------------------------------------------------------------------------//
  let g:nvim_typescript#kind_symbols = {
        \ 'keyword': 'keyword',
        \ 'class': '',
        \ 'interface': 'interface',
        \ 'script': 'script',
        \ 'module': '',
        \ 'local class': 'local class',
        \ 'type': 'type',
        \ 'enum': '',
        \ 'enum member': '',
        \ 'alias': '',
        \ 'type parameter': 'type param',
        \ 'primitive type': 'primitive type',
        \ 'var': '',
        \ 'local var': '',
        \ 'property': '',
        \ 'let': '',
        \ 'const': '',
        \ 'label': 'label',
        \ 'parameter': 'param',
        \ 'index': 'index',
        \ 'function': '',
        \ 'local function': 'local function',
        \ 'method': '',
        \ 'getter': '',
        \ 'setter': '',
        \ 'call': 'call',
        \ 'constructor': '',
        \}
  let g:nvim_typescript#javascript_support       = 0
  let g:nvim_typescript#vue_support              = 1
  let g:deoplete#sources#ternjs#types            = 1
  let g:deoplete#sources#ternjs#docs             = 1
  let g:deoplete#sources#ternjs#case_insensitive = 1
  let g:tmuxcomplete#trigger                     = ''

  let g:tern_request_timeout = 1
  "Add extra filetypes
  let g:tern#filetypes = [
        \ 'tsx',
        \ 'typescript.tsx',
        \ 'typescript.jsx',
        \ 'typescript',
        \ 'javascript',
        \ 'jsx',
        \ 'javascript.jsx',
        \ ]
  "Add extra filetypes
  let g:deoplete#sources#ternjs#filetypes = [
        \ 'tsx',
        \ 'typescript.tsx',
        \ 'typescript.jsx',
        \ 'typescript',
        \ 'javascript',
        \ 'jsx',
        \ 'javascript.jsx',
        \ ]
  let g:deoplete#sources#ternjs#omit_object_prototype = 0
  let g:deoplete#sources#ternjs#guess                 = 1
  let g:tern_map_keys                                 = 0
  let g:tern_show_argument_hints                      = 'on_hold'
  let g:tern_show_signature_in_pum                    = 1
  let g:tern#command                                  = ["tern"]
  let g:tern#arguments                                = ["--persistent"]
endif
"}}}
""---------------------------------------------------------------------------//
" vim-exchange {{{
""---------------------------------------------------------------------------//
let g:exchange_no_mappings = 1
nmap X <Plug>(Exchange)
xmap X <Plug>(Exchange)
"}}}
""---------------------------------------------------------------------------//
" Goyo {{{
""---------------------------------------------------------------------------//
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <F3> :Goyo<CR>
function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set nonumber norelativenumber
  set statusline=
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  set number relativenumber
  redraw!
  " Quit Vim if this is the only remaining buffer
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction

autocmd! User GoyoLeave nested call <SID>goyo_leave()
autocmd! User GoyoEnter nested call <SID>goyo_enter()

" Goyo
function! s:auto_goyo()
  if &ft == 'markdown' && winnr('$') == 1
    Goyo
  elseif exists('#goyo')
    Goyo!
  endif
endfunction

augroup goyo_markdown
  autocmd!
  autocmd BufNewFile,BufRead * call s:auto_goyo()
  autocmd User GoyoLeave nested call s:goyo_leave()
augroup END
"}}}
""---------------------------------------------------------------------------//
" VIM MARKDOWN {{{
""---------------------------------------------------------------------------//
let g:markdown_composer_syntax_theme='hybrid'
let g:vim_markdown_fenced_languages = [
      \'css',
      \'javascript',
      \'js=javascript',
      \'json=json',
      \'ruby',
      \'xml',
      \'html',
      \'python',
      \'sql'
      \]
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_folding_disabled = 1 " Stop folding markdown please
"}}}
""---------------------------------------------------------------------------//
" ULTISNIPS {{{
""---------------------------------------------------------------------------//
" Snippet settings:
let g:snips_author = 'Akin Sowemimo'
let g:UltiSnipsSnippetsDir          = $DOTFILES."/vim/mySnippets" "Both of these settings are necessary
let g:UltiSnipsSnippetDirectories   = ["UltiSnips", $HOME."/Dotfiles/vim/mySnippets"]
let g:UltiSnipsExpandTrigger        = "<C-J>"
let g:UltiSnipsJumpForwardTrigger   = "<C-J>"
let g:UltiSnipsJumpBackwardTrigger  = "<C-K>"
let g:UltiSnipsEditSplit            = "vertical" "If you want :UltiSnipsEdit to split your window.
nnoremap <localleader>u :UltiSnipsEdit<CR>
"}}}
""---------------------------------------------------------------------------//
" FZF {{{
""---------------------------------------------------------------------------//
"--------------------------------------------
" FZF bindings
"--------------------------------------------
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options

  let branch_files_options = { 'source': '( git status --porcelain | awk ''{print $2}''; git diff --name-only HEAD $(git merge-base HEAD master) ) | sort | uniq'}
  let uncommited_files_options = { 'source': '( git status --porcelain | awk ''{print $2}'' ) | sort | uniq'}

  let s:diff_options =
        \ '--reverse ' .
        \ '--preview "(git diff --color=always master -- {} | tail -n +5 || cat {}) 2> /dev/null | head -'.&lines.'"'

  command! BranchFiles call fzf#run(fzf#wrap('BranchFiles',
        \ extend(branch_files_options, { 'options': s:diff_options }), 0))

  function! Fzf_checkout_branch(b)
    "First element is the command e.g ctrl-x, second element is the selected branch
    let l:str = split(a:b[1], '* ')
    let l:branch = get(l:str, 1, '')
    if exists('g:loaded_fugitive')
      let cmd = get({ 'ctrl-x': 'Git branch -d '}, a:b[0], 'Git checkout ')
      try
        execute cmd . a:b[1]
      catch
        echohl WarningMsg
        echom v:exception
        echohl None
      endtry
    endif
  endfunction

  let branch_options = { 'source': '( git branch -a )', 'sink*': function('Fzf_checkout_branch') }
  let s:branch_log =
        \'--reverse --expect=ctrl-x '.
        \'--preview "(git log --color=always --graph --abbrev-commit --decorate  --first-parent -- {})"'

" Home made git branch functionality
  command! Branches call fzf#run(fzf#wrap('Branches',
        \ extend(branch_options, { 'options': s:branch_log  })))

  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow  --color "always" '.shellescape(<q-args>), 1, <bang>0)

  command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

  command! -bang -nargs=? -complete=dir GFiles
        \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

  command! -bang Dots
        \ call fzf#run(fzf#wrap('dotfiles', {'dir': $DOTFILES}, <bang>0))

  command! Modified call fzf#run(fzf#wrap(
        \ {'source': 'git ls-files --exclude-standard --others --modified'}))

  noremap <localLeader>mo :Modified<cr>
  " Use ripgrep instead of ag:
  command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
        \   <bang>0 ? fzf#vim#with_preview('right:50%:hidden', '?')
        \           : fzf#vim#with_preview('right:60%'),
        \   <bang>0)

  imap <c-x>l <plug>(fzf-complete-line)
  imap <c-x>p <plug>(fzf-complete-path)
  inoremap <expr> <c-x>w fzf#vim#complete#word({'left': '15%'})
  nnoremap <silent> <localleader>bf :BranchFiles<cr>
  nnoremap <silent> <localleader>br :Branches<cr>
  nnoremap <silent> <localleader>d :Dots<CR>
  nnoremap <silent> <localleader>t :BTags<CR>
  nnoremap <silent> <localleader>o :Buffers<CR>
  nnoremap <silent> <localleader>a :Windows<CR>
  nnoremap <silent> <localleader>m :History<CR>
  nnoremap <silent> <localleader>c :Commits<CR>
  nnoremap <silent> <localleader>l :Lines<CR>
  nnoremap <silent> <localleader>H :Helptags<CR>

  " Launch file search using FZF
  if isdirectory(".git")
    " if in a git project, use :GFiles
    nnoremap <silent><C-P> :GFiles --cached --others --exclude-standard<CR>
  else
    " otherwise, use :FZF
    nnoremap <silent><C-P> :Files<CR>
  endif
  nnoremap \ :Rg<CR>
  "Find Word under cursor
  nnoremap <leader>f :Find <C-R><C-W><CR>
  nnoremap <leader>F :Find 

  let g:fzf_action = {
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'split',
        \ 'ctrl-v': 'vsplit'
        \ }

  nnoremap <localleader>ma  :Marks<CR>
  nnoremap <localleader>mm :Maps<CR>

  let g:fzf_nvim_statusline = 1
  "Customize fzf colors to match your color scheme
  let g:fzf_colors =
        \ { 'fg':    ['fg', 'Normal'],
        \ 'bg':      ['bg', 'Normal'],
        \ 'border':  ['fg', 'Ignore'],
        \ 'hl':      ['fg', 'Comment'],
        \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
        \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
        \ 'hl+':     ['fg', 'Statement'],
        \ 'info':    ['fg', 'PreProc'],
        \ 'prompt':  ['fg', 'Conditional'],
        \ 'pointer': ['fg', 'Exception'],
        \ 'marker':  ['fg', 'Keyword'],
        \ 'spinner': ['fg', 'Label'],
        \ 'header':  ['fg', 'Comment']
        \}

  " Files + devicons
  function! Fzf_dev()
    function! s:files()
      let files = split(system($FZF_DEFAULT_COMMAND), '\n')
      return s:prepend_icon(files)
    endfunction

    function! s:prepend_icon(candidates)
      let result = []
      for candidate in a:candidates
        let filename = fnamemodify(candidate, ':p:t')
        let icon = WebDevIconsGetFileTypeSymbol(filename, isdirectory(filename))
        call add(result, printf("%s %s", icon, candidate))
      endfor

      return result
    endfunction

    function! s:edit_file(item)
      let parts = split(a:item, ' ')
      let file_path = get(parts, 1, '')
      execute 'silent e' file_path
    endfunction

    call fzf#run({
          \ 'source': <sid>files(),
          \ 'sink':   function('s:edit_file'),
          \ 'options': '-m -x +s',
          \ 'down':    '40%' })
  endfunction
"}}}
""---------------------------------------------------------------------------//
" STARTIFY {{{
""---------------------------------------------------------------------------//
let g:startify_list_order = [
      \ ['   😸 My Sessions:'],
      \ 'sessions',
      \ [' → Recent'],
      \ 'files',
      \ [' → My Bookmarks:'],
      \ 'bookmarks',
      \ [' → Recent files in current directory:'],
      \ 'dir',
      \ ['  → Commands:'],
      \ 'commands',
      \ ]

let g:startify_session_before_save = [
      \ 'echo "Cleaning up before saving.."',
      \ 'silent! NERDTreeClose',
      \ ]
let g:startify_session_dir         = '~/.vim/session'
let g:startify_bookmarks           = [
      \ {'v': '~/.vimrc'},
      \ {'z': '~/.zshrc'},
      \ {'t': '~/.tmux.conf'}
      \ ]

let g:startify_skiplist = [
      \ 'COMMIT_EDITMSG',
      \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc',
      \ 'bundle/.*/doc',
      \ '/data/repo/neovim/runtime/doc',
      \ ]
let g:startify_fortune_use_unicode    = 1
let g:startify_session_autoload       = 1
let g:startify_session_delete_buffers = 1
let g:startify_session_persistence    = 1
let g:startify_update_oldfiles        = 1
let g:startify_session_sort           = 1
let g:startify_change_to_vcs_root     = 1
"}}}
""---------------------------------------------------------------------------//
" Abolish {{{
""---------------------------------------------------------------------------//
nnoremap <leader>S :S/<C-R><C-W>//<LEFT>
nnoremap <leader>s :%S/<C-R><C-W>//<LEFT>
" }}}

""---------------------------------------------------------------------------//
"Surround {{{
""---------------------------------------------------------------------------//
vmap s <Plug>VSurround
vmap s <Plug>VSurround
" }}}
""---------------------------------------------------------------------------//
" CAMELCASEMOTION {{{
""---------------------------------------------------------------------------//
" This sets default mapping for camel case text object
call camelcasemotion#CreateMotionMappings('<leader>')
"}}}
""---------------------------------------------------------------------------//
" TMUX NAVIGATOR {{{
""---------------------------------------------------------------------------//
if exists('$TMUX')
  " Disable tmux navigator when zooming the Vim pane
  let g:tmux_navigator_disable_when_zoomed = 1
  let g:tmux_navigator_save_on_switch = 2
endif
"}}}
""---------------------------------------------------------------------------//
""---------------------------------------------------------------------------//
" VIM-CALENDAR {{{
""---------------------------------------------------------------------------//
let g:calendar_google_calendar = 1
let g:calendar_google_task     = 1
let g:calendar_frame = 'unicode'
"}}}
