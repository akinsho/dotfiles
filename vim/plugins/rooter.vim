"follow symlinked file
function! FollowSymlink()
  let current_file = expand('%p')
  " check if file type is a symlink
  if getftype(current_file) == 'link'
    "If it is a symlink resolve to the actual filepath
    " and open the actual file
    let actual_file = resolve(current_file)
    silent! exec 'file ' . actual_file
  endif
endfunction

"Set working directory to git project root
" or directory of current file if not a git project
function! SetProjectRoot()
  " default to the current file's directory
  lcd %:p:h
  let git_dir = system("git rev-parse --show-toplevel")
  " See if the command output starts with 'fatal' (if it does
  " then not in a git repo)
  let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
  " if git project change local directory to git project root
  if empty(is_not_git_dir)
    exec 'lcd ' . git_dir
  endif
endfunction

"Follow symlink and set working directory
autocmd BufRead *
      \ call FollowSymlink() |
      \ call SetProjectRoot()

" netrw: follow symlink and set working directory
autocmd CursorMoved silent *
  " short circuit for non-netrw files
  \ if &filetype == 'netrw' |
  \   call FollowSymlink() |
  \   call SetProjectRoot() |
  \ endif
