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

let $FZF_DEFAULT_OPTS .= ' --bind=ctrl-a:select-all --layout=reverse --margin=5%,5%'

let branch_files_options = {
      \ 'source': '( git status --porcelain | awk ''{print $2}''; git diff --name-only HEAD $(git merge-base HEAD master) ) | sort | uniq'
      \ }
let uncommited_files_options = {
      \ 'source': '( git status --porcelain | awk ''{print $2}'' ) | sort | uniq'
      \ }

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-e' : 'tab edit',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }

let g:fzf_nvim_statusline = 1
let g:fzf_buffers_jump    = 0

" Customize fzf colors to match your color scheme
" bg+ controls the highlight of the selected item
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'border':  ['fg', 'VertSplit'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'PmenuSel', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment']
      \}

" Make fzf floating window quasi transparent in Neovim
if exists('&winblend')
  augroup FZF_Settings
    au!
    autocmd Filetype fzf setlocal winblend=7
  augroup end
endif

" Border style (rounded / sharp / horizontal)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'border': 'rounded' } }

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

command! -bang -nargs=* Find call fzf#vim#grep(
      \ 'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow  --color "always" '.shellescape(<q-args>), 1, <bang>0
      \ )

command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir GFiles
      \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

"To use ripgrep instead of ag:
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%'),
      \   <bang>0)

command! -bang Dots
      \ call fzf#vim#files(g:dotfiles, fzf#vim#with_preview(), <bang>0)

command! Modified call fzf#run(fzf#wrap(
      \ {'source': 'git ls-files --exclude-standard --others --modified'}))

nnoremap <localleader>mo :Modified<cr>
nnoremap <localleader>bw :Wipeout<cr>
nnoremap <silent> <localleader>bf :BranchFiles<cr>
nnoremap <silent> <localleader>f :Files<cr>
nnoremap <silent> <localleader>d :Dots<CR>
nnoremap <silent> <localleader>b :BTags<CR>
nnoremap <silent> <localleader>o :Buffers<CR>
nnoremap <silent> <localleader>m :History<CR>
nnoremap <silent> <localleader>c :Commits<CR>
nnoremap <silent> <localleader>li :Lines<CR>
nnoremap <silent> <localleader>h :Helptags<CR>

" Launch file search using FZF
if isdirectory(".git")
  " if in a git project, use :GFiles
  nnoremap <silent><C-P> :GFiles --cached --others --exclude-standard<CR>
else
  " otherwise, use :FZF
  nnoremap <silent><C-P> :Files<CR>
endif
nnoremap <silent> \ :Rg<CR>
"Find Word under cursor
nnoremap <leader>f :Find <C-R><C-W><CR>
nnoremap <leader>F :Find<space>

nnoremap <localleader>ma  :Marks<CR>
nnoremap <localleader>mm :Maps<CR>
"}}}
