"-----------------------------------------------------------------------------------
"MAPPINGS {{{
"-----------------------------------------------------------------------------------
" Close all the buffers
nnoremap <leader>ba :1,1000 bd!<cr>
" Quickly edit your macros
" Usage <leader>m or "q<leader>m
nnoremap <leader>m  :<c-u><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

"""""""""""""""""""""""""""""""""""""""""""""""""""
" => VISUAL MODE RELATED
""""""""""""""""""""""""""""""""""""""""""""""""""
" ; and , search
" forward/backward regardless of the direction of the previous
" character search: 
nnoremap <expr> : getcharsearch().forward ? ';' : ','
nnoremap <expr> , getcharsearch().forward ? ',' : ';'
" Treat long lines as break lines (useful when moving around in them).
" Store relative line number jumps in the jumplist.
noremap <expr> j v:count > 1 ? 'm`' . v:count . 'j' : 'gj'
noremap <expr> k v:count > 1 ? 'm`' . v:count . 'k' : 'gk'

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

nnoremap <Leader>s :update<CR>
" Tab and Shift + Tab Circular buffer navigation
nnoremap <tab>   :bnext<CR>
nnoremap <S-tab> :bprevious<CR>
"20 enter to go to line 20
nnoremap <CR> G
nnoremap <BS> gg
"Change operator arguments to a character representing the desired motion
nnoremap ; :
nnoremap : ;

nnoremap [Alt]   <Nop>
xnoremap [Alt]   <Nop>
" nmap    e  [Alt]
" xmap    e  [Alt]
" Like gv, but select the last changed text.
nnoremap gi  `[v`]
" Specify the last changed text as {motion}.
onoremap <silent> gi  :<C-u>normal gc<CR>"`
vnoremap <silent> gi  :<C-u>normal gc<CR>
" Capitalize.
nnoremap gu <ESC>gUiw`]
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
" Select rectangle.
xnoremap r <C-v>
" 'quote'
" onoremap aq  a'
" xnoremap aq  a'
" onoremap iq  i'
" xnoremap iq  i'

" \"double quote"
" onoremap ad  a"
" xnoremap ad  a"
" onoremap id  i"
" xnoremap id  i"

" <angle>
" onoremap aa  a>
" xnoremap aa  a>
" onoremap ia  i>
" xnoremap ia  i>
"Change two horizontally split windows to vertical splits
nnoremap <LocalLeader>h <C-W>t <C-W>K
"Change two vertically split windows to horizontal splits
nnoremap <LocalLeader>v <C-W>t <C-W>H
"Select txt that has just been read or pasted in
nnoremap gV `[V`]

"Bubbling text a la vimcasts - http://vimcasts.org/episodes/bubbling-text/
" Better bubbling a la Tpope's unimpaired vim
nmap ë [e
nmap ê ]e
vmap ë [egv
vmap ê ]egv

"Line completion - native vim
inoremap ç <C-X><C-L>
"Replace current word with last deleted word
nnoremap S diw"0P
" make . work with visually selected lines
vnoremap . :norm.<CR>
" nnoremap ó :update<CR>
inoremap ó <C-O>:update<CR>
"This mapping allows yanking all of a line without taking the new line
"character as well can be with our without spaces
vnoremap <silent> al :<c-u>norm!0v$h<cr>
vnoremap <silent> il :<c-u>norm!^vg_<cr>
onoremap <silent> al :norm val<cr>
onoremap <silent> il :norm vil<cr>
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
set pastetoggle=<F2>
set timeout timeoutlen=500 ttimeoutlen=100 "time out on mapping after half a second, time out on key codes after a tenth of a second automatically at present
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
"Help Command - vertical split
command! -complete=help -nargs=1 H call VerticalHelp(<f-args>)
function! VerticalHelp(topic)
  execute "vertical botright help " . a:topic
  execute "vertical resize 78"
endfunction
"Remap back tick for jumping to marks more quickly
nnoremap ' `
nnoremap ` '

nnoremap rs ^d0
"Save all files
nnoremap qa :wqa<CR>
" clean up any trailing whitespace - neoformat does this
" nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<cr>
"open a new file in the same directory
nnoremap <Leader>nf :e <C-R>=expand("%:p:h") . "/" <CR>

nnoremap <localleader>c :<c-f>
"Open command line window
nnoremap <localleader>l :redraw!<cr>
"--------------------------------------------
" Window resizing bindings
"--------------------------------------------
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
" Max out the height of the current split
nnoremap <localleader>f <C-W>_
" Max out the width of the current split
nnoremap <localleader>e <C-W>|

"Normalize all split sizes, which is very handy when resizing terminal
nnoremap <leader>= <C-W>=
"Break out current window into new tabview
nnoremap <leader>t <C-W>T
"Close every window in the current tabview but the current one
nnoremap <localleader>q <C-W>o
"Swap top/bottom or left/right split
nnoremap <leader>r <C-W>R
"--------------------------------------------
"Open Common files
nnoremap <leader>ez :e ~/.zshrc<cr>
nnoremap <leader>et :e ~/.tmux.conf<cr>

nnoremap <leader>x :lclose<CR>
"Indent a page 
nnoremap <C-G>f gg=G<CR>
" duplicate line and comment (requires vim-commentary)
nmap <leader>cc yygccp
xmap <leader>cc m'ygvgc''jp
"map window keys to leader - Interfere with tmux navigator
" noremap <C-h> <c-w>h
" noremap <C-j> <c-w>j
" noremap <C-k> <c-w>k
" noremap <C-l> <c-w>l
"Remap arrow keys to do nothing
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

"Moves cursor back to the start of a line
inoremap <C-B> <C-O>I
" Make Ctrl-e jump to the end of the current line in the insert mode. This is
" handy when you are in the middle of a line and would like to go to its end
" without switching to the normal mode.
" source : https://blog.petrzemek.net/2016/04/06/things-about-vim-i-wish-i-knew-earlier/
inoremap <C-e> <C-o>$
"Move to beginning of a line in insert mode
inoremap <c-a> <c-o>0
inoremap <c-e> <c-o>$
"Remaps native ctrl k - deleting to the end of a line to control e
" inoremap <C-Q> <C-K>
" Map jk to esc key - using jk prevents jump that using ii causes
" inoremap jk <ESC>:w<CR>
inoremap jk <ESC>
inoremap ;; <End>;<Esc>:w<CR>

" Yank text to the OS X clipboard
noremap <localleader>y "*y
noremap <localleader>yy "*Y
"Maps K and J to a 10 k and j but @= makes the motions multipliable - not
"a word I know
noremap K  @='10k'<CR>
noremap J  @='10j'<CR>

"This line opens the vimrc in a vertical split
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <localleader>ev :tabnew $MYVIMRC<cr>

"This line allows the current file to source the vimrc allowing me use bindings as they're added
nnoremap <leader>sv :source $MYVIMRC<cr>
"This maps leader quote (single or double to wrap the word in quotes)
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel
nnoremap <leader>< viw<esc>a ><esc>bi<<esc>lel
" Remap going to beginning and end of lines
" move to beginning/end of line
nnoremap H ^
nnoremap L $

"Map Q to remove a CR
nnoremap Q J

"Add neovim terminal escape with ESC mapping
if has("nvim")
  tnoremap <ESC> <C-\><C-n>
endif
"}}}
