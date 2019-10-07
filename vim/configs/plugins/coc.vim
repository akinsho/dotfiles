if !has_key(g:plugs, 'coc.nvim') || exists('g:gui_oni')
  finish
endif

call coc#add_extension(
      \ 'coc-tag',
      \ 'coc-json',
      \ 'coc-go',
      \ 'coc-tsserver',
      \ 'coc-rls',
      \ 'coc-snippets',
      \ 'coc-highlight',
      \ 'coc-css',
      \ 'coc-prettier',
      \ 'coc-jest',
      \ 'coc-emoji',
      \ 'coc-eslint',
      \ 'coc-yank',
      \ 'coc-flow',
      \ 'coc-vimlsp',
      \ 'coc-git',
      \ 'coc-tabnine',
      \)

" TODO Coc pairs is takes half a second to expand
" \ 'coc-pairs',

function! s:coc_init() abort
  let s:languageservers = {}

  if executable('lua-lsp')
    let s:languageservers['lua'] = {
          \ 'command': 'lua-lsp',
          \ 'filetypes': ['lua']
          \}
  endif


  if executable('ccls')
    let s:languageservers['ccls'] = {
          \ "command": "ccls",
          \ "filetypes": ["c", "cpp", "objc", "objcpp"],
          \ "rootPatterns": [".ccls", "compile_commands.json", ".vim/", ".git/", ".hg/"],
          \ "initializationOptions": {
          \ "cacheDirectory": "/tmp/ccls"
          \}
          \}
  endif

  if executable('ocaml-language-server')
    let s:languageservers['ocaml'] = {
          \ 'command': 'ocaml-language-server',
          \ 'args': ['--stdio'],
          \ 'trace.server': 'verbose',
          \ 'filetypes': ['ocaml'],
          \}
  endif

  if executable("elm-language-server")
    let s:languageservers["elmLS"]   = {
          \ "command": "elm-language-server",
          \ "filetypes": ["elm"],
          \ "rootPatterns": ["elm.json"],
          \}
  endif

  let s:reason_language_server = $HOME.'/rls-linux/reason-language-server'
  if filereadable(s:reason_language_server)
    let s:languageservers['reason'] = {
          \ 'command': s:reason_language_server,
          \ 'trace.server': 'verbose',
          \ 'filetypes': ['reason'],
          \ 'settings': {
          \  'reason_language_server': {
          \    'per_value_codelens': v:true,
          \    'useOldDuneProcess': v:true,
          \   }
          \ }
          \}
  endif

  if !empty(s:languageservers)
    call coc#config('languageserver', s:languageservers)
  endif
endfunction
""---------------------------------------------------------------------------//
" Coc Autocommands
""---------------------------------------------------------------------------//

augroup coc_commands
  autocmd!
  autocmd VimEnter * call s:coc_init()

  autocmd CursorHold * silent call CocActionAsync('highlight')
  " autocmd CursorHoldI * call CocActionAsync('showSignatureHelp')
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json,javascript,javascript.jsx setlocal formatexpr=CocActionAsync('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup End

""---------------------------------------------------------------------------//
" CoC Mappings
""---------------------------------------------------------------------------//
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
iunmap <TAB>
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
if has("nvim")
  " Or use `complete_info` if your vim support it, like:
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
        \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
" Use `[c` and `]c` for navigate diagnostics
nmap <silent> ]c <Plug>(coc-diagnostic-prev)
nmap <silent> [c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> <localleader>gr <Plug>(coc-references)
" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <silent><leader>a  <Plug>(coc-codeaction-selected)
" Remap for do codeAction of current line
nmap <silent><leader>a  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <silent><leader>ff  <Plug>(coc-fix-current)
nmap <silent><leader>rf  <Plug>(coc-refactor)
" Remap for rename current word
nmap <silent><leader>rn <Plug>(coc-rename)

""---------------------------------------------------------------------------//
" Using CocList
""---------------------------------------------------------------------------//
" nnoremap <silent> <localleader>y  :<C-u>CocList -A --normal yank<cr>
" Show all diagnostics
nnoremap <silent> <leader>d :<C-u>CocList diagnostics<cr>
" Show commands
nnoremap <silent> <leader>c  :<C-u>CocList commands<cr>
" Manage extensions
nnoremap <silent> <leader>e  :<C-u>CocList extensions<cr>
" " Find symbol of current document
nnoremap <silent> <leader>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <leader>s  :<C-u>CocList -I symbols<cr>
" Resume latest coc list
nnoremap <silent> <localleader>p  :<C-u>CocListResume<CR>

nmap <expr> <silent> <C-e> <SID>select_current_word()
function! s:select_current_word()
  if !get(g:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc
""---------------------------------------------------------------------------//
" Coc Git
""---------------------------------------------------------------------------//
" navigate chunks of current buffer
nmap <silent> ]h <Plug>(coc-git-prevchunk)
nmap <silent> [h <Plug>(coc-git-nextchunk)
" show chunk diff at current position
nmap <silent> gi <Plug>(coc-git-chunkinfo)
" create text object for git chunks
omap ih <Plug>(coc-text-object-inner)
xmap ih <Plug>(coc-text-object-inner)
omap ah <Plug>(coc-text-object-outer)
xmap ah <Plug>(coc-text-object-outer)
nnoremap <silent><leader>hs :<C-u>CocCommand git.chunkStage<CR>
nnoremap <silent><leader>hu :<C-u>CocCommand git.chunkUndo<CR>
nnoremap <silent><leader>gl :<C-u>CocCommand git.copyUrl<CR>
""---------------------------------------------------------------------------//
" Coc Highlights
""---------------------------------------------------------------------------//
augroup Coc_highlights
  autocmd!
  autocmd Colorscheme * highlight CocErrorSign  ctermfg=Red guifg=#ff0000
  autocmd Colorscheme * highlight CocWarningSign  ctermfg=Brown guifg=#ff922b
  autocmd ColorScheme * highlight CocInfoSign  ctermfg=Yellow guifg=#fab005
  autocmd Colorscheme * highlight CocErrorHighlight guifg=#E06C75 gui=underline
  autocmd Colorscheme * highlight CocCodeLens ctermfg=Gray guifg=#999999
  autocmd ColorScheme * highlight CocHighlightText gui=underline,bold
augroup END
" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocActionAsync('format')
" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call CocActionAsync('fold', <f-args>)
