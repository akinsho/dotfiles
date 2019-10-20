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
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }

let g:fzf_nvim_statusline = 1
let g:fzf_buffers_jump    = 1
"Customize fzf colors to match your color scheme
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'NormalFloat'],
      \ 'border':  ['fg', 'VertSplit'],
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

if has('nvim')
  let g:fzf_layout = { 'window': 'call FloatingFZF()' }

  " Make fzf floating window quasi transparent in Neovim
  if exists('&winblend')
    augroup FZF_Settings
      au!
      autocmd Filetype fzf setlocal winblend=7
    augroup end
  endif

  function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')

    let width = float2nr(&columns * 0.8)
    let height = float2nr(&lines * 0.6)
    let opts = {
          \ 'relative': 'editor',
          \ 'row': (&lines - height) / 2,
          \ 'col': (&columns - width) / 2,
          \ 'width': width,
          \ 'height': height
          \}

    let win = nvim_open_win(buf, v:true, opts)
    call setwinvar(win, '&winhighlight', 'NormalFloat:Pmenu')
  endfunction
else
  " If not neovim the we are using terminal fzf so we should
  " clear the window highlights
  augroup FZF_Vim_Highlight
    au!
    autocmd FileType fzf setlocal winhighlight=
  augroup END
endif

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
nnoremap \ :Rg<CR>
"Find Word under cursor
nnoremap <leader>f :Find <C-R><C-W><CR>
nnoremap <leader>F :Find<space>

nnoremap <localleader>ma  :Marks<CR>
nnoremap <localleader>mm :Maps<CR>
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
