""---------------------------------------------------------------------------//
" NERDTrees highlighting
""---------------------------------------------------------------------------//
function! NERDTreeHighlightFile(extension, fg, bg, guifg)
  exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guifg='. a:guifg
  exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('html',        202, 'none', '#FC4709')
call NERDTreeHighlightFile('hbs',         202, 'none', '#FC4709')
call NERDTreeHighlightFile('jade',        149, 'none', '#A0D24D')
call NERDTreeHighlightFile('json',        223, 'none', '#FECEA0')
call NERDTreeHighlightFile('scss',        44, 'none', '#db7093')
call NERDTreeHighlightFile('css',         44, 'none', '#db7093')
call NERDTreeHighlightFile('js',          226, 'none', '#FFD700')
call NERDTreeHighlightFile('ts',          226, 'none', '#2EB4FF')
call NERDTreeHighlightFile('tsx',         226, 'none', '#2EB4FF')
call NERDTreeHighlightFile('go',          039, 'none', '#5BD9FF')
call NERDTreeHighlightFile('rb',          197, 'none', '#E53378')
call NERDTreeHighlightFile('md',          208, 'none', '#FD720A')
call NERDTreeHighlightFile('jsx',         140, 'none', '#9E6FCD')
call NERDTreeHighlightFile('svg',         178, 'none', '#CDA109')
call NERDTreeHighlightFile('gif',         36, 'none', '#15A274')
call NERDTreeHighlightFile('jpg',         36, 'none', '#15A274')
call NERDTreeHighlightFile('png',         36, 'none', '#15A274')
call NERDTreeHighlightFile('vim',         36, 'none', '#87bb7c')
call NERDTreeHighlightFile('DS_Store',    'Gray', 'none', '#686868')
call NERDTreeHighlightFile('gitconfig',   'Gray', 'none', '#686868')
call NERDTreeHighlightFile('gitignore',   'Gray', 'none', '#686868')
call NERDTreeHighlightFile('bashrc',      'Gray', 'none', '#686868')
call NERDTreeHighlightFile('zshrc',       'Gray', 'none', '#686868')
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
"NERDTree
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
let g:NERDTreeBookmarksFile             = g:dotfiles . '/vim/.NERDTreeBookmarks'
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
if !g:gui_neovim_running
  let g:NERDTreeDirArrowExpandable = ''
  let g:NERDTreeDirArrowCollapsible = ''
else
  let g:WebDevIconsUnicodeDecorateFolderNodes                      = 1
  let g:DevIconsEnableFoldersOpenClose                             = 1
  let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol         = ''
endif
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols        = {}
let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol           = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['md']  = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['css'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['js']  = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vim'] = ''
"}}}
