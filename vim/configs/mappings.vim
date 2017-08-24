""---------------------------------------------------------------------------//
"MAPPINGS {{{
""---------------------------------------------------------------------------//
""---------------------------------------------------------------------------//
" NEOVIM
""---------------------------------------------------------------------------//
" Terminal settings
if has('nvim')
  set guicursor=n-v-c-i-ci-ve:block
  " \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  " set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  "       \,sm:block-blinkwait175-blinkoff150-blinkon175
  tnoremap <Leader>e <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-h>
  tnoremap <C-j> <C-\><C-n><C-j>
  tnoremap <C-k> <C-\><C-n><C-k>
  tnoremap <C-l> <C-\><C-n><C-l>
  tmap <leader>. <C-\><C-n>:bprevious<CR>
  tmap <leader>1  <C-\><C-n><Plug>AirlineSelectTab1
  tmap <leader>2  <C-\><C-n><Plug>AirlineSelectTab2
  tmap <leader>3  <C-\><C-n><Plug>AirlineSelectTab3
  tmap <leader>4  <C-\><C-n><Plug>AirlineSelectTab4
  tmap <leader>5  <C-\><C-n><Plug>AirlineSelectTab5
  tmap <leader>6  <C-\><C-n><Plug>AirlineSelectTab6
  tmap <leader>7  <C-\><C-n><Plug>AirlineSelectTab7
  tmap <leader>8  <C-\><C-n><Plug>AirlineSelectTab8
  tmap <leader>9  <C-\><C-n><Plug>AirlineSelectTab9
  tmap <leader>x <c-\><c-n>:bp! <BAR> bd! #<CR>
  nmap <leader>t :term<cr>
  tmap <leader>, <C-\><C-n>:bnext<cr>
endif
""---------------------------------------------------------------------------//
"Terminal {{{
""---------------------------------------------------------------------------//
nnoremap <silent> <leader><Enter> :tabnew<CR>:terminal<CR>

"Opening splits with terminal in all directions
nnoremap <leader>h<CR> :leftabove vnew<CR>:terminal<CR>
nnoremap <leader>l<CR> :rightbelow vnew<CR>:terminal<CR>
nnoremap <leader>k<CR> :leftabove new<CR>:terminal<CR>
nnoremap <leader>j<CR> :rightbelow new<CR>:terminal<CR>
"}}}
"Bubbling text a la vimcasts - http://vimcasts.org/episodes/bubbling-text/
nnoremap ]e ddkP
nnoremap [e ddp
" Move visual block
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv

inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nnoremap <leader>n :enew<cr>
" Close a tab
nnoremap <leader>tc :tabclose<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nnoremap ,q :bp <BAR> bd #<CR>
" " Show all open buffers and their status
nnoremap <leader>bl :ls<CR>
"Displays the name of the highlight group of the selected word
nnoremap <leader>E :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<cr>
"nnoremap <silent><expr> <CR> empty(&buftype) ? '@@' : '<CR>'
"Evaluates whether there is a fold on the current line if so unfold it else return a normal space
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
" Close all the buffers
nnoremap <leader>ba :1,1000 bd!<cr>
" Quickly edit your macros
" Usage <leader>m or "q<leader>m
nnoremap <leader>m  :<c-u><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>
" Shortcuts
" Change Working Directory to that of the current file
""---------------------------------------------------------------------------//
" => Command mode related
""---------------------------------------------------------------------------//
" Smart mappings on the command line
cno $h e ~/
cno $d e ~/Desktop/
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line
" it deletes everything until the last slash 
cno $q <C-\>eDeleteTillSlash()<cr>
" insert path of current file into a command
cmap <c-f> <c-r>=expand("%:p:h") . "/" <cr>
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h
cmap w!! w !sudo tee % >/dev/null

""---------------------------------------------------------------------------//
" => VISUAL MODE RELATED
""---------------------------------------------------------------------------//
" Store relative line number jumps in the jumplist.
noremap <expr> j v:count > 1 ? 'm`' . v:count . 'j' : 'gj'
noremap <expr> k v:count > 1 ? 'm`' . v:count . 'k' : 'gk'
" vim-vertical-move replacement
" credit: cherryberryterry: https://www.reddit.com/r/vim/comments/4j4duz/a/d33s213
function! s:vjump(dir) abort
  let c = '%'.virtcol('.').'v'
  let flags = a:dir ? 'bnW' : 'nW'
  let bot = search('\v'.c.'.*\n^(.*'.c.'.)@!.*$', flags)
  let top = search('\v^(.*'.c.'.)@!.*$\n.*\zs'.c, flags)

  " norm! m`
  return a:dir ? (line('.') - (bot > top ? bot : top)).'k'
    \        : ((bot < top ? bot : top) - line('.')).'j'
endfunction
vnoremap <expr> <c-j> <SID>vjump(0)
vnoremap <expr> <c-k> <SID>vjump(1)
xnoremap <expr> <C-j> <SID>vjump(0)
xnoremap <expr> <C-k> <SID>vjump(1)
onoremap <expr> <C-j> <SID>vjump(0)
onoremap <expr> <C-k> <SID>vjump(1)

" Emacs like keybindings for the command line (:) are better
" and you cannot use Vi style-binding here anyway, because ESC
" just closes the command line and using Home and End..
" remap arrow keys
" c-a / c-e everywhere
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
"Save
nnoremap <C-S> :update<CR>
nnoremap <leader>s :update<cr>
inoremap <C-s> <C-O>:update<cr>
"Quit
vnoremap <C-Q>     <esc>
" Tab and Shift + Tab Circular buffer navigation
nnoremap <tab>   :bnext<CR>
nnoremap <S-tab> :bprevious<CR>
" nnoremap <CR> G "20 enter to go to line 20
nnoremap <BS> gg
"Change operator arguments to a character representing the desired motion
nnoremap ; :
nnoremap : ;
"nnoremap [Alt]   <Nop>
"xnoremap [Alt]   <Nop>
" nmap    e  [Alt]
" xmap    e  [Alt]
" Like gv, but select the last changed text.
nnoremap gi  `[v`]
" Specify the last changed text as {motion}.
onoremap <silent> gi  :<C-u>normal gc<CR>"`
vnoremap <silent> gi  :<C-u>normal gc<CR>
" Capitalize.
nnoremap õ <ESC>gUiw`]
inoremap <C-u> <ESC>gUiw`]a
" Smart }."
nnoremap <silent> } :<C-u>call ForwardParagraph()<CR>
onoremap <silent> } :<C-u>call ForwardParagraph()<CR>
xnoremap <silent> } <Esc>:<C-u>call ForwardParagraph()<CR>mzgv`z
function! ForwardParagraph()
  let cnt = v:count ? v:count : 1
  let i = 0
  while i < cnt
    if !search('^\s*\n.*\S','W')
      normal! G$
      return
    endif
    let i = i + 1
  endwhile
endfunction
" Select block.
xnoremap r <C-v>
" Made mappings recursize to work with targets plugin
" 'quote'
omap aq  a'
xmap aq  a'
omap iq  i'
xmap iq  i'

" \"double quote"
omap ad  a"
xmap ad  a"
omap id  i"
xmap id  i"

" <angle>
" omap aa  a>
" xmap aa  a>
" omap ia  i>
" xmap ia  i>
"Change two horizontally split windows to vertical splits
nnoremap <LocalLeader>h <C-W>t <C-W>K
"Change two vertically split windows to horizontal splits
nnoremap <LocalLeader>v <C-W>t <C-W>H
"Select txt that has just been read or pasted in
nnoremap gV `[V`]

" make last typed word uppercase
inoremap :u <esc>viwUea
" find visually selected text
vnoremap * y/<C-R>"<CR>
" replace word under cursor
nnoremap S :%s/\<<C-R><C-W>\>//gc<Left><Left><Left>
" make . work with visually selected lines
vnoremap . :norm.<CR>
inoremap ó <C-O>:update<CR>
" text-object: line
" Elegant text-object pattern hacked out of jdaddy.vim.
function! s:line_inner_movement(count) abort
  "TODO: handle count
  if empty(getline('.'))
    return "\<Esc>"
  endif
  let [lopen, copen, lclose, cclose] = [line('.'), 1, line('.'), col('$')-1]
  call setpos("'[", [0, lopen, copen, 0])
  call setpos("']", [0, lclose, cclose, 0])
  return "`[o`]"
endfunction
xnoremap <expr>   il <SID>line_inner_movement(v:count1)
onoremap <silent> il :normal vil<CR>

"ctrl-o in insert mode allows you to perform one normal mode command then
"returns to insert mode
" inoremap <C-j> <Down>
inoremap ê <Down>
inoremap è <left>
inoremap ë <up>
inoremap ì <right>
" select last paste in visual mode
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <F6> :! open %<CR>
" Remap jumping to the last spot you were editing previously to bk as this is easier form me to remember
nnoremap bk `.
" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$
nnoremap <leader>sw :b#<CR>
" Quick find/replace
nnoremap <Leader>[ :%s/<C-r><C-w>/
vnoremap <Leader>[ "zy:%s/<C-r><C-o>"/
"--------------------------------------------
"Absolutely fantastic function from stoeffel/.dotfiles which allows you to
"repeat macros across a visual range
"--------------------------------------------
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
"--------------------------------------------

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
"Remap back tick for jumping to marks more quickly
nnoremap ' `
nnoremap ` '

"Save all files
nnoremap qa :wqa<CR>
" press enter for newline without insert
nnoremap <cr> o<esc>
"Sort a visual selection
vnoremap <leader>s :sort<CR>
"open a new file in the same directory
nnoremap <Leader>nf :e <C-R>=expand("%:p:h") . "/" <CR>

nnoremap <localleader>c :<c-f>
"Open command line window
nnoremap <localleader>L :redraw!<cr>
""---------------------------------------------------------------------------//
" Window resizing bindings
""---------------------------------------------------------------------------//
"Create a horizontal split
nnoremap _ :sp<CR>
"Create a vertical split
nnoremap \| :vsp<CR>
" Resize window vertically  - shrink
nnoremap <down> 15<c-w>-
" Resize window vertically - grow
nnoremap <up> 15<c-w>+
" Increase window size horizontally
nnoremap <left> 15<c-w>>
" Decrease window size horizontally
nnoremap <right> 15<c-w><

"Normalize all split sizes, which is very handy when resizing terminal
nnoremap <leader>= <C-W>=
"Break out current window into new tabview
nnoremap <leader>nt <C-W>T
"Close every window in the current tabview but the current one
nnoremap <localleader>q <C-W>o
"Swap top/bottom or left/right split
nnoremap <leader>r <C-W>R
""---------------------------------------------------------------------------//
"Open Common files
nnoremap <leader>ez :e ~/.zshrc<cr>
nnoremap <leader>et :e ~/.tmux.conf<cr>
nnoremap <leader>x :lclose<CR>
"Indent a page
nnoremap <C-G>f gg=G<CR>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Make Ctrl-e jump to the end of the current line in the insert mode. This is
" handy when you are in the middle of a line and would like to go to its end
" without switching to the normal mode.
" source : https://blog.petrzemek.net/2016/04/06/things-about-vim-i-wish-i-knew-earlier/
"Move to beginning of a line in insert mode
inoremap <c-a> <c-o>0
inoremap <c-e> <c-o>$
"Remaps native ctrl k - deleting to the end of a line to control e
" inoremap <C-Q> <C-K>
" Map jk to esc key
inoremap jk <ESC>
xnoremap jk <ESC>
cnoremap jk <C-C>

" Yank text to the OS X clipboard
noremap <localleader>y "*y
noremap <localleader>yy "*Y
"Maps K and J to a 10 k and j but @= makes the motions multipliable - not
"a word I know
nnoremap K  @='10k'<CR>
nnoremap J  @='10j'<CR>

"This line opens the vimrc in a vertical split
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <localleader>ev :tabnew $MYVIMRC<cr>

"This line allows the current file to source the vimrc allowing me use bindings as they're added
nnoremap <leader>sv :source $MYVIMRC<cr>
"This maps leader quote (single or double to wrap the word in quotes)
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel
" Remap going to beginning and end of lines
" move to beginning/end of line
nnoremap H ^
nnoremap L $
nnoremap <leader>ll :vertical resize +10<cr>
nnoremap <leader>hh :vertical resize -10<cr>
nnoremap <leader>jj :res +10<cr>
nnoremap <leader>kk :res -10<cr>
"Map Q to remove a CR
nnoremap Q J
nnoremap <leader>co :botright cope<cr>
"Add neovim terminal escape with ESC mapping
if has("nvim")
  tnoremap <ESC> <C-\><C-n>
endif
"}}}

" Shortcut to jump to next conflict marker"
nnoremap <silent> <localleader>co /^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>

" Zoom / Restore window.
function! s:ZoomToggle() abort
  if exists('t:zoomed') && t:zoomed
    exec t:zoom_winrestcmd
    let t:zoomed = 0
  else
    let t:zoom_winrestcmd = winrestcmd()
    resize
    vertical resize
    let t:zoomed = 1
  endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <leader>z :ZoomToggle<CR>

command! PU PlugUpdate | PlugUpgrade

" Map key to toggle opt
function! MapToggle(key, opt)
  let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
  exec 'nnoremap '.a:key.' '.cmd
  exec 'inoremap '.a:key." \<C-O>".cmd
endfunction
command! -nargs=+ MapToggle call MapToggle(<f-args>)

" Display-altering option toggles
MapToggle <F1> wrap
MapToggle <F3> list

" Behavior-altering option toggles
MapToggle <F10> scrollbind
MapToggle <F11> ignorecase
set pastetoggle=<F2>

fu! ToggleColorColumn()
  if &colorcolumn
    set colorcolumn=""
  else
    set colorcolumn=80
  endif
endfunction
nnoremap <F4> :call ToggleColorColumn()<CR>


""---------------------------------------------------------------------------//
" GREPPING
""---------------------------------------------------------------------------//
nnoremap <silent> g/ :silent! :grep!<space>
nnoremap <silent> g* :silent! :grep! -w <C-R><C-W><CR>
nnoremap <silent> ga :silent! :grepadd!<space>
