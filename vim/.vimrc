"--------------------------------------------------------------------------------
" Plug Setup {{{1
"--------------------------------------------------------------------------------
"--------------------------------------------------------------------------------
" CORE {{{1
"--------------------------------------------------------------------------------
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', #{dir: '~/.fzf', do: './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
if exists('$TMUX')
  Plug 'christoomey/vim-tmux-navigator'
endif
Plug 'neoclide/coc.nvim'
Plug 'honza/vim-snippets'
Plug 'mbbill/undotree', {'on:' ['UndotreeToggle']}
Plug 'mhinz/vim-sayonara', {'on:''Sayonara' }
Plug 'itchyny/vim-highlighturl'
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-apathy'
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'chaoren/vim-wordmotion'
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
Plug 'kana/vim-textobj-user'
      \ | Plug 'kana/vim-operator-user'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/goyo.vim', #{for: ['vimwiki','markdown']}
Plug 'ryanoasis/vim-devicons'
Plug 'bagrat/vim-buffet'
Plug 'rakr/vim-one'

call plug#end()

" cfilter plugin allows filter down an existing quickfix list
packadd! cfilter
packadd! matchit

nnoremap <silent><leader>pi :PlugInstall<CR>
nnoremap <silent><leader>ps :PlugStatus<CR>
nnoremap <silent><leader>pc :PlugClean<CR>
nnoremap <silent><leader>pu :PlugUpdate<CR>
tnoremap <C-h> <C-W>h
tnoremap <C-j> <C-W>j
tnoremap <C-k> <C-W>k
tnoremap <C-l> <C-W>l
tnoremap <C-x> <C-W><silent>q!<CR>
" vim:foldmethod=marker
