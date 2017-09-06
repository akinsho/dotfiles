" NERDTrees File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg)
  exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guifg='. a:guifg
  exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction
augroup NERDTreeHighlighing
"Clear AUTOCOMMAND Always FFS
  au!
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
  "TODO - Figure if and how to use these highlight groups
  highlight! NERDTreeGitStatusModified ctermfg=1 guifg=#D370A3
  highlight! NERDTreeGitStatusStaged ctermfg=10 guifg=#A3D572
  highlight! NERDTreeGitStatusUntracked ctermfg=12 guifg=#98CBFE
  highlight! def link NERDTreeOpenable Function
  highlight! def link NERDTreeClosable NERDTreeOpenable
  highlight! def link NERDTreeGitStatusDirDirty Constant
  highlight! def link NERDTreeGitStatusDirClean DiffAdd
  highlight! def link NERDTreeGitStatusUnmerged Label
  highlight! def link NERDTreeGitStatusUnknown Comment
augroup END
