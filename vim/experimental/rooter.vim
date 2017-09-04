"follow symlinked file
function! FollowSymlink()
  let l:current_file = expand('%p')
  " check if file type is a symlink
  if getftype(l:current_file) ==# 'link'
    "If it is a symlink resolve to the actual filepath
    " and open the actual file
    let l:actual_file = resolve(l:current_file)
    silent! exec 'file ' . l:actual_file
  endif
endfunction

"Set working directory to git project root
" or directory of current file if not a git project
function! SetProjectRoot()
  " default to the current file's directory
  lcd %:p:h
  let l:git_dir = system('git rev-parse --show-toplevel')
  " See if the command output starts with 'fatal' (if it does
  " then not in a git repo)
  let l:is_not_git_dir = matchstr(l:git_dir, '^fatal:.*')
  " if git project change local directory to git project root
  if empty(l:is_not_git_dir)
    exec 'lcd ' . l:git_dir
  endif
endfunction

augroup RooterVim
  au!
"Follow symlink and set working directory
autocmd BufRead *
      \if &filetype !=# 'gitcommit'
      \ call FollowSymlink() |
      \ call SetProjectRoot()
      \endif

" netrw: follow symlink and set working directory
autocmd CursorMoved silent *
  " short circuit for non-netrw files
  \ if &filetype == 'netrw' |
  \   call FollowSymlink() |
  \   call SetProjectRoot() |
  \ endif
augroup END
