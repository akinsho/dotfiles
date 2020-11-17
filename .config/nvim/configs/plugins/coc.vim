if !PluginLoaded('coc.nvim')
  finish
endif
""---------------------------------------------------------------------------//
" Extensions
""---------------------------------------------------------------------------//
let g:coc_global_extensions = [
      \ 'coc-java',
      \ 'coc-marketplace',
      \ 'coc-json',
      \ 'coc-vimlsp',
      \ 'coc-rls',
      \ 'coc-python',
      \ 'coc-html',
      \ 'coc-snippets',
      \ 'coc-highlight',
      \ 'coc-css',
      \ 'coc-prettier',
      \ 'coc-emoji',
      \ 'coc-yank',
      \ 'coc-git',
      \ 'coc-eslint',
      \ 'coc-go',
      \ 'coc-word',
      \ 'coc-tabnine',
      \ 'coc-flutter-tools',
      \ 'coc-xml',
      \ 'coc-tsserver',
      \ 'coc-graphql',
      \ 'coc-spell-checker'
      \]

function! s:coc_init() abort
  let s:languageservers = {}

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

  " manually compiled and installed
  " using https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
  " https://github.com/sumneko/lua-language-server/wiki/Setting-without-VSCode
  let s:lua_path = expand('$HOME/lua-language-server')
  if executable(s:lua_path.'/bin/Linux/lua-language-server') && has('nvim')
    let s:languageservers['lua'] = {
          \ 'command': s:lua_path.'/bin/Linux/lua-language-server',
          \ 'args': ["-E", "-e", "LANG=en", s:lua_path."/main.lua"],
          \ 'filetypes': ['lua'],
          \ 'rootPatterns': ['.git/'],
          \ 'settings': {
          \  'Lua': {
          \   'workspace': {
          \     'library': {
          \       expand("$VIMRUNTIME/lua"): v:true
          \     },
          \   },
          \   'runtime': {'version': "LuaJIT"},
          \   'diagnostics': {
          \      'globals': ['vim'],
          \    },
          \   'completion': {
          \     'keywordSnippet': 'Both'
          \   }
          \  }
          \ },
          \}
  endif

  if executable("elm-language-server")
    let s:languageservers["elmLS"]   = {
          \ "command": "elm-language-server",
          \ "filetypes": ["elm"],
          \ "rootPatterns": ["elm.json"],
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
	" Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Setup formatexpr specified filetype(s).
  autocmd FileType go,dart,vim,javascript,typescript setlocal formatexpr=CocActionAsync('formatSelected')
  autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
  " Suggestions don't work and are not needed in the command line window
  autocmd CmdwinEnter * let b:coc_suggest_disable = 1
augroup End

""---------------------------------------------------------------------------//
" CoC Mappings
""---------------------------------------------------------------------------//
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
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

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Use `[c` and `]c` for navigate diagnostics
nmap <expr><silent> ]c &diff ? ']c' : "\<Plug>(coc-diagnostic-prev)"
nmap <expr><silent> [c &diff ? '[c' : "\<Plug>(coc-diagnostic-next)"

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

function! s:setup_command_abbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

" Use C to open coc config
call s:setup_command_abbrs('C', 'CocConfig')

xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
xmap im <Plug>(coc-classobj-i)
omap im <Plug>(coc-classobj-i)
xmap am <Plug>(coc-classobj-a)
omap am <Plug>(coc-classobj-a)
""---------------------------------------------------------------------------//
" Code Actions
""---------------------------------------------------------------------------//
nmap <silent><leader>ca <Plug>(coc-codelens-action)
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <silent><leader>a  <Plug>(coc-codeaction-selected)
nmap <silent><leader>a  <Plug>(coc-codeaction-selected)

" Fix autofix problem of current line
nmap <silent><leader>rf  <Plug>(coc-fix-current)
nmap <silent><leader>rr  <Plug>(coc-refactor)
" Remap for rename current word
nmap <silent><leader>rn <Plug>(coc-rename)

" source: https://www.youtube.com/watch?v=q7gr6s8skt0
" add --hidden flag so dotfiles are always searched
nnoremap <leader>cf :CocSearch --hidden <C-R>=expand("<cword>")<CR><CR>

" Scroll the floating window if open
" FIXME this breaks smooth scrolling
" Remap <C-f> and <C-b> for scroll float windows/popups.
" Note coc#float#scroll works on neovim >= 0.4.3 or vim >= 8.2.0750
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" NeoVim-only mapping for visual mode scroll
" Useful on signatureHelp after jump placeholder of snippet expansion
if has('nvim')
  vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<C-f>"
  vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<C-b>"
endif
"---------------------------------------------------------------------------//
" Coc Statusline
""---------------------------------------------------------------------------//
let g:coc_status_error_sign = "✗ "
let g:coc_status_warning_sign = " "
""---------------------------------------------------------------------------//
" Using CocList
""---------------------------------------------------------------------------//
nnoremap <silent> <leader>cy  :<C-u>CocList -A --normal yank<cr>
" Show all diagnostics
nnoremap <silent><nowait> <leader>cd  :<C-u>CocList diagnostics<cr>
" Show commands
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
" Manage extensions
nnoremap <silent> <leader>ce  :<C-u>CocList extensions<cr>
" " Find symbol of current document
nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <leader>cs  :<C-u>CocList symbols<cr>
" Search marketplace for coc symbols
nnoremap <silent> <leader>cm  :<C-u>CocList marketplace<cr>
" Search snippets
nnoremap <silent> <leader>cn  :<C-u>CocList snippets <CR>
" Resume latest coc list
nnoremap <silent> <leader>cr  :<C-u>CocListResume<CR>
""---------------------------------------------------------------------------//
" Coc Git
""---------------------------------------------------------------------------//
" navigate chunks of current buffer
nmap <silent> ]h <Plug>(coc-git-prevchunk)
nmap <silent> [h <Plug>(coc-git-nextchunk)
" show chunk diff at current position
nmap <silent> gi <Plug>(coc-git-chunkinfo)
" show commit contains current position
nmap <localleader>gv <Plug>(coc-git-commit)
" create text object for git chunks
omap ih <Plug>(coc-git-chunk-inner)
xmap ih <Plug>(coc-git-chunk-inner)
omap ah <Plug>(coc-git-chunk-outer)
xmap ah <Plug>(coc-git-chunk-outer)
nnoremap <silent><leader>cb :CocList branches<CR>
nnoremap <silent><leader>hs :<C-u>CocCommand git.chunkStage<CR>
nnoremap <silent><leader>hu :<C-u>CocCommand git.chunkUndo<CR>
nnoremap <silent><localleader>gbo :CocCommand git.browserOpen<CR>
nnoremap <silent><localleader>gu :<C-u>CocCommand git.copyUrl<CR>
""---------------------------------------------------------------------------//
" Coc Highlights
""---------------------------------------------------------------------------//
function s:apply_coc_highlights()
  highlight CocErrorHighlight guisp=#E06C75 gui=undercurl
  highlight CocWarningHighlight guisp=orange gui=undercurl
  highlight CocInfoHighlight guisp=orange gui=undercurl
  highlight CocHighlightText gui=underline
  highlight CocHintHighlight guisp=#15aabf gui=undercurl
  highlight link CocOutlineIndentLine LineNr
  " By default this links to CocHintSign but that keeps getting cleared mysteriously
  highlight CocRustChainingHint  ctermfg=Blue guifg=#15aabf
endfunction

augroup Coc_highlights
  autocmd!
  autocmd VimEnter * call <SID>apply_coc_highlights()
  autocmd Colorscheme * call <SID>apply_coc_highlights()
augroup END

""---------------------------------------------------------------------------//
" Formatting
""---------------------------------------------------------------------------//
" Use `:Format` for format current buffer
command! -nargs=0 CocFormat :call CocActionAsync('format')
""---------------------------------------------------------------------------//
" Folds {{{1
""---------------------------------------------------------------------------//
" Coc folds are inconsistent and don't integrate with vim bindings and behaviour
" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call CocActionAsync('fold', <f-args>)
nnoremap <silent> <localleader>fa :Fold<CR>
nnoremap <silent> <localleader>fr :Fold region<CR>
nnoremap <silent> <localleader>fi :Fold imports<CR>
nnoremap <silent> <localleader>fc :Fold comments<CR>
"}}}

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
""---------------------------------------------------------------------------//
" Tags
""---------------------------------------------------------------------------//
set tagfunc=CocTagFunc
