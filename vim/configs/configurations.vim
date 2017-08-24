""---------------------------------------------------------------------------//
" Highlights
""---------------------------------------------------------------------------//
" Highlight cursor column onwards - kind of cool
""---------------------------------------------------------------------------//
" let &colorcolumn=join(range(81,999),",")
highlight ColorColumn guibg=#2c3a41
""---------------------------------------------------------------------------//
highlight clear SpellBad
highlight SpellBad  term=underline cterm=italic ctermfg=Red
highlight clear SpellCap
highlight SpellCap  term=underline cterm=italic ctermfg=Blue
highlight clear SpellLocal
highlight SpellLocal  term=underline cterm=italic ctermfg=Blue
highlight clear SpellRare
highlight SpellRare  term=underline cterm=italic ctermfg=Blue
highlight clear Conceal "Sets no highlighting for conceal
""---------------------------------------------------------------------------//
"few nicer JS colours
""---------------------------------------------------------------------------//
highlight xmlAttrib gui=italic,bold cterm=italic,bold ctermfg=121
highlight jsxAttrib cterm=italic,bold ctermfg=121
highlight jsThis ctermfg=224
highlight jsSuper ctermfg=13
highlight jsFuncCall ctermfg=cyan
highlight jsClassProperty ctermfg=14 cterm=bold,italic term=bold,italic
highlight cssBraces ctermfg=cyan
"highlight jsComment ctermfg=245 ctermbg=none
highlight htmlArg gui=italic,bold cterm=italic,bold ctermfg=yellow
highlight Comment gui=italic cterm=italic
highlight Type    gui=italic cterm=italic
highlight Folded guifg=#FFC66D guibg=NONE
highlight CursorLine term=none cterm=none
highlight link StartifySlash Directory
"make the completion menu a bit more readable
highlight PmenuSel guibg=#004D40 guifg=white
highlight Pmenu guibg=#00897b guifg=white
" highlight WildMenu ctermbg=253 ctermfg=0
"so it's clear which paren I'm on and which is matched
highlight MatchParen cterm=bold ctermbg=none guifg=green guibg=NONE
highlight Search ctermbg=NONE guifg=NONE guibg=NONE
" highlight VertSplit guifg=black ctermfg=black
if has('gui_running')
  hi VertSplit guibg=bg guifg=bg
endif
" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" Highlight term cursor differently
if has('nvim')
  highlight TermCursor ctermfg=green guifg=green
endif
""---------------------------------------------------------------------------//
"VIM ROOTER
""---------------------------------------------------------------------------//
let g:rooter_change_directory_for_non_project_files = 'current'
let g:rooter_resolve_links = 1
let g:rooter_silent_chdir = 1
""---------------------------------------------------------------------------//
"NERDTree
""---------------------------------------------------------------------------//
" Ctrl+N to toggle Nerd Tree
 function! NERDTreeToggleAndFind()
    if (exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1)
      execute ':NERDTreeClose'
    else
      execute ':NERDTreeFind'
    endif
  endfunction
" nnoremap <C-N> :NERDTreeToggle<CR>
nnoremap <silent> <c-n> :call ToggleNERDTreeWithRefresh()<cr>
nnoremap <localleader>n :call NERDTreeToggleAndFind()<CR>

fun! ToggleNERDTreeWithRefresh()
    :NERDTreeToggle
    if(exists("b:NERDTreeType") == 1)
        call feedkeys("R")
    endif
endf

let g:NERDTreeHijackNetrw               = 0 "Off as it messes with startify's autoload session
let g:NERDTreeAutoDeleteBuffer          = 1
let g:NERDTreeWinSize                   = 30
let NERDTreeDirArrowExpandable          = "├"
let NERDTreeDirArrowCollapsible         = "└"
let g:NERDTreeQuitOnOpen                = 1
let g:NERDTreeMinimalUI                 = 1
let g:NERDTreeCascadeOpenSingleChildDir = 1
let g:NERDTreeShowBookmarks             = 1
let g:NERDTreeAutoDeleteBuffer          = 1
let g:NERDTreeShowHidden                = 1 "Show hidden files by default
" Expandable ideas = [' ', ' ', ','','├','└']

" NERDTrees File highlighting
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
" call NERDTreeHighlightFile('ts', 226, 'none', '#2E7AB1')
" call NERDTreeHighlightFile('tsx', 226, 'none', '#2E7AB1')
call NERDTreeHighlightFile('rb', 197, 'none', '#E53378')
call NERDTreeHighlightFile('md', 208, 'none', '#FD720A')
call NERDTreeHighlightFile('jsx', 140, 'none', '#9E6FCD')
call NERDTreeHighlightFile('svg', 178, 'none', '#CDA109')
call NERDTreeHighlightFile('gif', 36, 'none', '#15A274')
call NERDTreeHighlightFile('jpg', 36, 'none', '#15A274')
call NERDTreeHighlightFile('png', 36, 'none', '#15A274')
call NERDTreeHighlightFile('DS_Store', 'Gray', 'none', '#686868')
call NERDTreeHighlightFile('gitconfig', 'Gray', 'none', '#686868')
call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#686868')
call NERDTreeHighlightFile('bashrc', 'Gray', 'none', '#686868')
call NERDTreeHighlightFile('zshrc', 'Gray', 'none', '#686868')
call NERDTreeHighlightFile('bashprofile', 'Gray', 'none', '#151515')

if executable('rg')
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
elseif executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

if exists('NERDTree') " after a re-source, fix syntax matching issues (concealing brackets):
  if exists('g:loaded_webdevicons')
    call webdevicons#hardRefresh()
  endif
endif
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols        = {} " needed
let g:WebDevIconsUnicodeDecorateFolderNodes                      = 1
let g:DevIconsEnableFoldersOpenClose                             = 1
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol         = ''
let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol           = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['tsx'] = '' " Set tsx extension icon to same as ts
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['js']  = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vim'] = ''

""---------------------------------------------------------------------------//
"               Airline
""---------------------------------------------------------------------------//
let g:webdevicons_enable_airline_tabline                 = 1
let g:airline#parts#ffenc#skip_expected_string           = 'utf-8[unix]'
let g:airline_powerline_fonts                            = 1
let g:airline#extensions#tabline#enabled                 = 1
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
let g:airline#extensions#tabline#show_tabs               = 1
let g:airline#extensions#tabline#tab_nr_type             = 2 " Show # of splits and tab #
let g:airline#extensions#tabline#fnamemod                = ':t'
let g:airline#extensions#tabline#show_tab_type           = 1
let g:airline_section_c = '%t %{GetFileSize()}'

"  let g:airline#extensions#default#layout = [
"       \ [ 'a', 'b', 'y' ],
"       \ [ 'x', 'c', 'z', 'error', 'warning' ]
"       \ ]
let g:airline#extensions#tabline#show_close_button = 1
let g:airline#extensions#ale#error_symbol = '✖:'
let g:airline#extensions#ale#warning_symbol = '⚠:'
let g:airline_inactive_collapse                    = 1
let g:airline#extensions#tabline#close_symbol     = 'x' " * configure symbol used to represent close button >
" * configure pattern to be ignored on BufAdd autocommand >
" fixes unnecessary redraw, when e.g. opening Gundo window
let airline#extensions#tabline#ignore_bufadd_pat   =
      \ '\c\vgundo|undotree|vimfiler|tagbar|nerd_tree'

let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <localleader>1 <Plug>AirlineSelectTab1
nmap <localleader>2 <Plug>AirlineSelectTab2
nmap <localleader>3 <Plug>AirlineSelectTab3
nmap <localleader>4 <Plug>AirlineSelectTab4
nmap <localleader>5 <Plug>AirlineSelectTab5
nmap <localleader>6 <Plug>AirlineSelectTab6
nmap <localleader>7 <Plug>AirlineSelectTab7
nmap <localleader>8 <Plug>AirlineSelectTab8
nmap <localleader>9 <Plug>AirlineSelectTab9
nmap <localleader>- <Plug>AirlineSelectPrevTab
nmap <localleader>+ <Plug>AirlineSelectNextTab

"--------------------------------------------
" CTRLSF - CTRL-SHIFT-F
"--------------------------------------------
let g:ctrlsf_default_root = 'project+fw' "Search at the project root i.e git or hg folder
let g:ctrlsf_winsize      = "30%"
let g:ctrlsf_ignore_dir   = ['bower_components', 'node_modules']
nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>f <Plug>CtrlSFVwordPath
vmap     <C-F>F <Plug>CtrlSFVwordExec
nmap     <C-F>n <Plug>CtrlSFCwordPath
nmap     <C-F>p <Plug>CtrlSFPwordPath
nnoremap <C-F>o :CtrlSFOpen<CR>
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>

""---------------------------------------------------------------------------//
" TEXTOBJECT - COMMENT
""---------------------------------------------------------------------------//
let g:textobj_comment_no_default_key_mappings = 1
xmap ac <Plug>(textobj-comment-a)
omap ac <Plug>(textobj-comment-a)
xmap ic <Plug>(textobj-comment-i)
omap ic <Plug>(textobj-comment-i)

""---------------------------------------------------------------------------//
" Sayonara
""---------------------------------------------------------------------------//
nnoremap <leader>q :Sayonara!<CR>
nnoremap <C-Q> :Sayonara<CR>
""---------------------------------------------------------------------------//
"     ALE
""---------------------------------------------------------------------------//
" Disable linting for all minified JS files.
if has('gui_running')
  let g:ale_set_balloons                 = 1
endif
if has('vim')
  " Enable completion where available.
  let g:ale_completion_enabled           = 1
endif
let g:ale_pattern_options                = {'\.min.js$': {'ale_enabled': 0}}
let g:ale_fixers                         = {}
let g:ale_fixers.javascript              = ['prettier', 'eslint']
let g:ale_fixers.typescript              = ['prettier']
let g:ale_fixers.css                     = ['stylelint']
let g:ale_javascript_prettier_options    = '--single-quote --trailing-comma es5' "Order of arguments matters here!!
let g:ale_typescript_tsserver_use_global = 1
let g:ale_echo_msg_format                = '%linter%: %s [%severity%]'
let g:ale_sign_column_always             = 1
let g:ale_sign_error                     = '✘'
let g:ale_sign_warning                   = '⚠️'
let g:ale_linters                        = {
      \'python': ['flake8'],
      \'css': ['stylelint'],
      \'jsx': ['stylelint', 'eslint'],
      \'sql': ['sqlint'],
      \'typescript':['tsserver', 'tslint', 'stylelint'],
      \'html':[]
      \}
let g:ale_linter_aliases    = {'jsx': 'css', 'typescript.jsx': 'css'}
let g:ale_set_highlights    = 0
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ OK']
nmap <silent> <C-/> <Plug>(ale_previous_wrap)
nmap <silent> <C-\> <Plug>(ale_next_wrap)

""---------------------------------------------------------------------------//
" CAPSLOCK
""---------------------------------------------------------------------------//
imap <C-L> <C-O><Plug>CapsLockToggle
""---------------------------------------------------------------------------//
" FUGITIVE
""---------------------------------------------------------------------------//
"Fugitive bindings
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
"Open current file on github.com
nnoremap <leader>gb :Gbrowse<CR>
"Make it work in Visual mode to open with highlighted linenumbers
vnoremap <leader>gb :Gbrowse<CR>
""---------------------------------------------------------------------------//
" JSX & POLYGLOT
""---------------------------------------------------------------------------//
let g:jsx_ext_required          = 1
""---------------------------------------------------------------------------//
"VIM-GO
""---------------------------------------------------------------------------//
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"
let g:go_doc_keywordprg_enabled = 0
let g:go_highlight_functions    = 1
let g:go_highlight_methods      = 1
""---------------------------------------------------------------------------//
" Git Gutter
""---------------------------------------------------------------------------//
nnoremap <leader>gg :GitGutterToggle<CR>
let g:gitgutter_enabled       = 0
let g:gitgutter_sign_modified = '•'
let g:gitgutter_sign_modified_removed='±'
let g:gitgutter_eager         = 1
let g:gitgutter_sign_added    = '❖'
let g:gitgutter_grep_command  = 'ag --nocolor'
""---------------------------------------------------------------------------//
" EXPAND REGION VIM
""---------------------------------------------------------------------------//
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
""---------------------------------------------------------------------------//
" SIDEWAYS
""---------------------------------------------------------------------------//
nnoremap <C-F> :SidewaysLeft<cr>
nnoremap <C-F>r :SidewaysRight<cr>
""---------------------------------------------------------------------------//
" VIM-EASY-ALIGN
""---------------------------------------------------------------------------//
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vnoremap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
""---------------------------------------------------------------------------//
" VIM-JAVASCRIPT
""---------------------------------------------------------------------------//
let g:javascript_plugin_flow       = 1
let g:javascript_conceal_undefined = "¿"
let g:javascript_conceal_super     = "Ω"
let g:javascript_conceal_null      = "ø"
let g:javascript_plugin_jsdoc      = 1

""---------------------------------------------------------------------------//
"EasyMotion mappings
""---------------------------------------------------------------------------//
let g:EasyMotion_do_mapping       = 0
let g:EasyMotion_smartcase        = 1
let g:EasyMotion_use_smartsign_us = 1
let g:EasyMotion_startofline      = 0
omap t <Plug>(easymotion-bd-tl)
" nmap s <Plug>(easymotion-s)
" Jump to anwhere with only `s{char}{target}`
" `s<CR>` repeat last find motion.
map s <Plug>(easymotion-f)
nmap s <Plug>(easymotion-overwin-f)
" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

""---------------------------------------------------------------------------//
"                    EMMET for Vim
""---------------------------------------------------------------------------//
let g:user_emmet_mode         = 'a'
let g:user_emmet_complete_tag = 1
let g:user_emmet_settings     = {
          \'javascript': {'extends': 'jsx'},
          \'typescript':{'extends': 'tsx'}
          \}
let g:user_emmet_leader_key     = "<C-Y>"
let g:user_emmet_expandabbr_key =  "<C-Y>"
let g:user_emmet_install_global = 0
""---------------------------------------------------------------------------//
nnoremap <leader>u :UndotreeToggle<CR>
""---------------------------------------------------------------------------//
"Set up libraries to highlight with library syntax highlighter
let g:used_javascript_libs = 'underscore,flux,angularjs,jquery,rambda,react,jasmine,chai,handlebars,requirejs'
" let g:html_indent_tags = 'li\|p' " Treat <li> and <p> tags like the block tags they are
""---------------------------------------------------------------------------//
" EDITOR CONFIG
""---------------------------------------------------------------------------//
let g:EditorConfig_core_mode = 'external_command' " Speed up editorconfig plugin
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

""---------------------------------------------------------------------------//
"Plugin configurations "{{{
""---------------------------------------------------------------------------//

let test#runners = {'Typescript': ['Mocha', 'Jest']}
let test#runners = {'Typescript': ['Mocha']}
" Commenting
let g:NERDSpaceDelims       = 1
let g:NERDCompactSexyComs   = 1
let g:NERDDefaultAlign      = 'left'
let g:NERDCustomDelimiters  = {
  \    'jsx': { 'left': '{/*','right': '*/}' },
  \    'typescript.jsx': { 'left': '{/*','right': '*/}' },
  \    'typescript.tsx': { 'left': '{/*','right': '*/}' }
  \  }
let g:NERDCommentEmptyLines = 1

nmap <silent> <leader>vt :TestNearest<CR>
nmap <silent> <leader>vT :TestFile<CR>
nmap <silent> <leader>va :TestSuite<CR>
nmap <silent> <leader>vl :TestLast<CR>
nmap <silent> <leader>vg :TestVisit<CR>

""---------------------------------------------------------------------------//
" Polyglot
""---------------------------------------------------------------------------//
let g:polyglot_disabled = ['elm','clojure']
let g:vue_disable_pre_processors=1
""---------------------------------------------------------------------------//
" ELM
""---------------------------------------------------------------------------//
let g:elm_format_autosave   = 1
let g:elm_jump_to_error     = 1
let g:elm_detailed_complete = 1
let g:elm_setup_keybindings = 1
let g:elm_make_output_file  = "index.html"
""---------------------------------------------------------------------------//
let g:echodoc#enable_at_startup= 1

""---------------------------------------------------------------------------//
" Deoplete Options
""---------------------------------------------------------------------------//
if has("nvim")
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
  let g:deoplete#enable_at_startup       = 1
  let g:deoplete#sources#go#gocode_binary= $GOPATH.'/bin/gocode'
  let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const', 'ultisnips']
  let g:deoplete#sources#go#package_dot  = 1
  let g:deoplete#sources#go#use_cache    = 1
  let g:deoplete#sources#go#pointer      = 1
  let g:deoplete#enable_smart_case       = 1
  let g:deoplete#auto_complete_delay     = 0
  let g:deoplete#enable_refresh_always   = 0
  let g:deoplete#max_abbr_width          = 0
  let g:deoplete#max_menu_width          = 0
  let g:deoplete#file#enable_buffer_path = 1
  let g:deoplete#omni#functions          = {}
  let g:deoplete#omni#functions.javascript = [
        \ 'tern#Complete',
        \ 'jspc#omni'
        \]
  let g:deoplete#omni#functions.typescript = [
      \ 'tern#Complete',
      \ 'jspc#omni'
      \]
  let g:deoplete#omni#functions["typescript.tsx"] = [
      \ 'tern#Complete',
      \ 'jspc#omni'
      \]
  call deoplete#custom#source('ultisnips', 'rank', 6000)
  let g:nvim_typescript#javascript_support       = 1
  let g:nvim_typescript#vue_support              = 1
  let g:deoplete#sources#ternjs#types            = 1
  let g:deoplete#sources#ternjs#docs             = 1
  let g:deoplete#sources#ternjs#case_insensitive = 1
  let g:tmuxcomplete#trigger                     = ''
  let g:nvim_typescript#type_info_on_hold        = 1
  call deoplete#custom#set('buffer', 'mark', '')
  call deoplete#custom#set('ternjs', 'mark', '')
  call deoplete#custom#set('omni', 'mark', '⌾')
  call deoplete#custom#set('file', 'mark', '')
  call deoplete#custom#set('jedi', 'mark', '')
  call deoplete#custom#set('typescript', 'mark', '')
  call deoplete#custom#set('ultisnips', 'mark', '')
  augroup Typescript_helpers
    au!
    autocmd FileType typescript nnoremap <localleader>p :TSDefPreview<CR>
    autocmd FileType typescript nnoremap <localleader>d :TSDef<CR>
    autocmd FileType typescript nnoremap <localleader>r :TSRefs<CR>
    autocmd FileType typescript nnoremap <localleader>t :TSType<CR>
    autocmd FileType typescript nnoremap <localleader>c :TSEditConfig<CR>
    autocmd FileType typescript nnoremap <localleader>i :TSImport<CR>
  augroup END
endif

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
let g:tern_show_argument_hints      = '0'
let g:tern_map_keys                 = 1
let g:tern_show_signature_in_pum    = 1

let g:tern#command                  = ["tern"]
let g:tern#arguments                = ["--persistent"]

""---------------------------------------------------------------------------//
" SUPERTAB
""---------------------------------------------------------------------------//
" let g:SuperTabDefaultCompletionType = "<c-n>"
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabLongestHighlight      = 1

""---------------------------------------------------------------------------//
" Goyo
""---------------------------------------------------------------------------//
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <F3> :Goyo<CR>
function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowmode
  set noshowcmd
  set nonumber
  set scrolloff=999
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  set showmode
  set showcmd
  set number relativenumber
  set scrolloff=5
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Goyo
function! s:auto_goyo()
  if &ft == 'markdown' && winnr('$') == 1
    Goyo
  elseif exists('#goyo')
    Goyo!
  endif
endfunction

function! s:goyo_leave()
  if winnr('$') < 2
    silent! :q
  endif
endfunction

augroup goyo_markdown
  autocmd!
  autocmd BufNewFile,BufRead * call s:auto_goyo()
  autocmd! User GoyoLeave nested call s:goyo_leave()
augroup END
""---------------------------------------------------------------------------//
" VIM MARKDOWN
""---------------------------------------------------------------------------//
let g:vim_markdown_fenced_languages =[
  \'css',
  \'erb=eruby',
  \'javascript',
  \'js=javascript',
  \'json=json',
  \'ruby',
  \'sass',
  \'scss=sass',
  \'xml',
  \'html',
  \'python',
  \'stylus=css',
  \'less=css',
  \'sql'
  \]
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_folding_disabled = 1 " Stop folding markdown please
""---------------------------------------------------------------------------//
" ULTISNIPS
""---------------------------------------------------------------------------//
let g:UltiSnipsSnippetsDir          = "~/Dotfiles/vim/mySnippets" "Both of these settings are necessary
let g:UltiSnipsSnippetDirectories   = ["UltiSnips", $HOME."/Dotfiles/vim/mySnippets"]
let g:UltiSnipsExpandTrigger        = "<C-J>"
let g:UltiSnipsJumpForwardTrigger   = "<C-J>"
let g:UltiSnipsListSnippets         = "<space>ls"
let g:UltiSnipsJumpBackwardTrigger  = "<C-K>"
let g:UltiSnipsEditSplit            = "vertical" "If you want :UltiSnipsEdit to split your window.

""---------------------------------------------------------------------------//
" FZF
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
if !has('gui_running')
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow  --color "always" '.shellescape(<q-args>), 1, <bang>0)
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
" Use ripgrep instead of ag:
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)
" Advanced customization using autoload functions
" Replace the default dictionary completion with fzf-based fuzzy completion

" This command now supports CTRL-T, CTRL-V, and CTRL-X key bindings
" and opens fzf according to g:fzf_layout setting.
command! Buffers call fzf#run(fzf#wrap(
    \ {'source': map(range(1, bufnr('$')), 'bufname(v:val)')}))

" This extends the above example to open fzf in fullscreen
" when the command is run with ! suffix (Buffers!)
command! -bang Buffers call fzf#run(fzf#wrap(
    \ {'source': map(range(1, bufnr('$')), 'bufname(v:val)')}, <bang>0))

command! FZFMru call fzf#run({
\ 'source':  reverse(s:all_files()),
\ 'sink':    'edit',
\ 'options': '-m -x +s',
\ 'down':    '40%' })

function! s:all_files()
  return extend(
  \ filter(copy(v:oldfiles),
  \        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

imap <c-x>l <plug>(fzf-complete-line)
imap <c-x>p <plug>(fzf-complete-path)
inoremap <expr> <c-x>w fzf#vim#complete#word({'left': '15%'})
nnoremap <silent> <localleader>m :FZFMru<CR>
nnoremap <silent> <localleader>o :Buffers<CR>
nnoremap <silent> <localleader>a :Windows<CR>
nnoremap <silent> <localleader>H :History<CR>
nnoremap <silent> <localleader>C :Commits<CR>
nnoremap <silent> <localleader>l :Lines<CR>

function! SearchWordWithRg()
  execute 'Rg' expand('<cword>')
endfunction

" Launch file search using FZF
nnoremap <localleader>p :GitFiles <CR>
nnoremap <C-P> :call Fzf_dev()<CR>
nnoremap \ :Rg!<CR>
nnoremap <space>\ :call SearchWordWithRg()<CR>
endif

if !has('gui_running')
  nnoremap <localleader>ma  :Marks<CR>
  nnoremap <localleader>mm :Maps<CR>
  let g:fzf_action = {
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-s': 'split',
        \ 'ctrl-v': 'vsplit'
        \}
let g:fzf_nvim_statusline = 1
"Customize fzf colors to match your color scheme
  let g:fzf_colors =
        \ { 'fg':    ['fg', 'Normal'],
        \ 'bg':      ['bg', 'Normal'],
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

endif
""---------------------------------------------------------------------------//
" STARTIFY
""---------------------------------------------------------------------------//
let g:startify_list_order = [
      \ ['   😇 My Sessions:'],
      \ 'sessions',
      \ ['   MRU Files:'],
      \ 'files',
      \ ['   My Bookmarks:'],
      \ 'bookmarks',
      \ ['   MRU files in current directory:'],
      \ 'dir',
      \ ['   Commands:'],
      \ 'commands',
      \ ]

let g:startify_session_dir         = '~/.vim/session'
let g:startify_bookmarks           = [
      \ {'vimrc: ': '~/.vimrc'},
      \ {'zshrc: ':'~/.zshrc'},
      \ {'tmux: ':'~/.tmux.conf'}
      \ ]
let g:startify_session_autoload    = 1
let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root  = 1
let g:startify_session_sort        = 1
""---------------------------------------------------------------------------//
" This sets default mapping for camel case text object
call camelcasemotion#CreateMotionMappings('<leader>')
""---------------------------------------------------------------------------//
" TMUX NAVIGATOR
""---------------------------------------------------------------------------//
if exists('$TMUX')
  " Disable tmux navigator when zooming the Vim pane
  let g:tmux_navigator_disable_when_zoomed = 1
  " saves on moving pane but only the currently opened buffer if changed
  let g:tmux_navigator_save_on_switch = 2
endif
"}}}
"

function! GetFileSize() "{{{
  let bytes = getfsize(expand("%:p"))
  if bytes <= 0
    return ""
  endif
  if bytes < 1024
    return "[" . bytes . " b]"
  else
    return "[" . (bytes / 1024) . " kb]"
  endif
endfunction "}}}
"---------------------------------------------------------------------
