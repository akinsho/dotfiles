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

" since this mutates an environment variable we check that it has already
" been appended before attempting to append it again
let opts = ' --bind=ctrl-a:select-all --layout=reverse'
if stridx(expand('$FZF_DEFAULT_OPTS'), opts) == -1
  let $FZF_DEFAULT_OPTS .= opts
endif

let branch_files_options = {
      \ 'source': '( git status --porcelain | awk ''{print $2}''; git diff --name-only HEAD $(git merge-base HEAD master) ) | sort | uniq'
      \ }

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
endfunction

let g:fzf_action = {
      \ 'ctrl-l': function('s:build_quickfix_list'),
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
      \ 'border':  ['fg', 'Comment'],
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
let g:fzf_preview_window = 'right:55%'

" Make fzf floating window quasi transparent in Neovim
if exists('&winblend')
  augroup FZF_Settings
    au!
    autocmd Filetype fzf setlocal winblend=7
  augroup end
endif

" Border style (rounded / sharp / horizontal)
let g:fzf_layout = {
      \ 'window': {
      \   'width': 0.8,
      \   'height': 0.7,
      \   'border': 'rounded'
      \   }
      \ }

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --column --line-number --no-heading  --glob "!.git"'.
  \   ' --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Find call fzf#vim#grep(
      \ 'rg --column --line-number --no-heading'.
      \ ' --fixed-strings --ignore-case --no-ignore --hidden'.
      \ ' --glob "!.git"'.
      \ ' --follow  --color "always" '.shellescape(<q-args>), 1, <bang>0
      \ )

" FIXME: this includes git excluded files
command! -bang Dots
      \ call fzf#vim#files(g:dotfiles, fzf#vim#with_preview(), <bang>0)

command! -bang WikiSearch
      \ call fzf#vim#files(g:wiki_path, fzf#vim#with_preview(), <bang>0)


function s:fzf_files() abort
  " Launch file search using FZF
  if isdirectory(".git")
    " if in a git project, use :GFiles
    GFiles --cached --others --exclude-standard --full-name
  else
    " otherwise, use :FZF
    Files
  endif
endfunction

nnoremap <silent><C-P> :call <SID>fzf_files()<CR>

nnoremap <silent><leader>gS :GFiles?<cr>
nnoremap <silent><leader>ff :Files<cr>
nnoremap <silent><leader>fd :Dots<CR>
nnoremap <silent><leader>fo :Buffers<CR>
nnoremap <silent><leader>fh :History<CR>
nnoremap <silent><leader>fc :Commits<CR>
nnoremap <silent><leader>f? :Helptags<CR>
" Find Word under cursor
nnoremap <silent><leader>fs :Rg<CR>
nnoremap <silent><leader>fw :Find <C-R><C-W><CR>
"}}}
