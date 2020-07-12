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
      \ 'bg+':     ['bg', 'Visual', 'PmenuSel', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment']
      \}

" Always enable preview window on the right with 60% width
let g:fzf_preview_window = 'right:50%'

" Make fzf floating window quasi transparent in Neovim
if exists('&winblend')
  augroup FZF_Settings
    au!
    autocmd Filetype fzf setlocal winblend=7
  augroup end
endif

" Border style (rounded / sharp / horizontal)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'border': 'rounded' } }

command! -bang -nargs=* Find call fzf#vim#grep(
      \ 'rg --column --line-number --no-heading'.
      \ ' --fixed-strings --ignore-case --no-ignore --hidden'.
      \ ' --follow  --color "always" '.shellescape(<q-args>), 1, <bang>0
      \ )

" FIXME: this includes git excluded files
command! -bang Dots
      \ call fzf#vim#files(g:dotfiles, fzf#vim#with_preview(), <bang>0)

nnoremap <silent><localleader>gs :GFiles?<cr>
nnoremap <silent><localleader>f :Files<cr>
nnoremap <silent><localleader>d :Dots<CR>
nnoremap <silent><localleader>b :BTags<CR>
nnoremap <silent><localleader>o :Buffers<CR>
nnoremap <silent><localleader>m :History<CR>
nnoremap <silent><localleader>c :Commits<CR>
nnoremap <silent><localleader>li :Lines<CR>
nnoremap <silent><localleader>h :Helptags<CR>

" Launch file search using FZF
if isdirectory(".git")
  " if in a git project, use :GFiles
  nnoremap <silent><C-P> :GFiles --cached --others --exclude-standard<CR>
else
  " otherwise, use :FZF
  nnoremap <silent><C-P> :Files<CR>
endif
" Find Word under cursor
nnoremap <silent><leader>f :Rg<CR>
nnoremap <silent><leader>F :Find <C-R><C-W><CR>

nnoremap <localleader>ma  :Marks<CR>
nnoremap <localleader>mm :Maps<CR>
"}}}
