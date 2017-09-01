""---------------------------------------------------------------------------//
"MAPPINGS {{{
""---------------------------------------------------------------------------//
""---------------------------------------------------------------------------//
"Terminal {{{
""---------------------------------------------------------------------------//
" Terminal settings
if has('nvim')
  set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
  " set guicursor=n-v-c-i-ci-ve:block
  " nnoremap <silent> <leader><Enter> :tabnew<CR>:terminal<CR>

  "Add neovim terminal escape with ESC mapping
  tmap <ESC> <C-\><C-n>
  tmap <Leader>e <C-\><C-n>
  tmap <C-h> <C-\><C-n><C-h>
  tmap <C-j> <C-\><C-n><C-j>
  tmap <C-k> <C-\><C-n><C-k>
  tmap <C-l> <C-\><C-n><C-l>
  tmap <leader>x <c-\><c-n>:bp! <BAR> bd! #<CR>
  tmap <tab> <C-\><C-n>:bnext<CR>
  tmap <localleader><S-tab> <C-\><C-n>:bprev<CR>
  tmap <leader>1  <C-\><C-n><Plug>AirlineSelectTab1
  tmap <leader>2  <C-\><C-n><Plug>AirlineSelectTab2
  tmap <leader>3  <C-\><C-n><Plug>AirlineSelectTab3
  tmap <leader>4  <C-\><C-n><Plug>AirlineSelectTab4
  tmap <leader>5  <C-\><C-n><Plug>AirlineSelectTab5
  tmap <leader>6  <C-\><C-n><Plug>AirlineSelectTab6
  tmap <leader>7  <C-\><C-n><Plug>AirlineSelectTab7
  tmap <leader>8  <C-\><C-n><Plug>AirlineSelectTab8
  tmap <leader>9  <C-\><C-n><Plug>AirlineSelectTab9
  nmap <leader>t :term<cr>
  tmap <leader>, <C-\><C-n>:bnext<cr>
"Opening splits with terminal in all directions
nnoremap <leader>h<CR> :leftabove 30vnew<CR>:terminal<CR>
nnoremap <leader>l<CR> :rightbelow 30vnew<CR>:terminal<CR>
nnoremap <leader>k<CR> :leftabove 10new<CR>:terminal<CR>
nnoremap <leader>j<CR> :rightbelow 10new<CR>:terminal<CR>
endif
"}}}
""---------------------------------------------------------------------------//"
"Select Entire
""---------------------------------------------------------------------------//
nnoremap <leader>va ggVGo
xnoremap <Leader>v <C-C>ggVG

""---------------------------------------------------------------------------//
" BUBBLING - Hacked out of Unimpaired.vim
""---------------------------------------------------------------------------//
"Bubbling text a la vimcasts & tpope -
"https://github.com/tpope/vim-unimpaired/blob/3a7759075cca5b0dc29ce81f2747489b6c8e36a7/plugin/unimpaired.vim#L206 
"http://vimcasts.org/episodes/bubbling-text/
" Move visual block
function! s:ExecMove(cmd) abort
  let old_fdm = &foldmethod
  if old_fdm != 'manual'
    let &foldmethod = 'manual'
  endif
  normal! m`
  silent! exe a:cmd
  norm! ``
  if old_fdm != 'manual'
    let &foldmethod = old_fdm
  endif
endfunction

function! s:Move(cmd, count, map) abort
  call s:ExecMove('move'.a:cmd.a:count)
  silent! call repeat#set("\<Plug>Move".a:map, a:count)
endfunction

function! s:MoveSelectionDown(count) abort
  call s:ExecMove("'<,'>move'>+".a:count)
  silent! call repeat#set("\<Plug>MoveSelectionDown", a:count)
endfunction

function! s:MoveSelectionUp(count) abort
  call s:ExecMove("'<,'>move'<--".a:count)
  silent! call repeat#set("\<Plug>MoveSelectionUp", a:count)
endfunction

nnoremap <silent> <Plug>MoveUp            :<C-U>call <SID>Move('--',v:count1,'Up')<CR>
noremap  <silent> <Plug>MoveSelectionDown :<C-U>call <SID>MoveSelectionDown(v:count1)<CR>
nnoremap <silent> <Plug>MoveDown          :<C-U>call <SID>Move('+',v:count1,'Down')<CR>
noremap  <silent> <Plug>MoveSelectionUp   :<C-U>call <SID>MoveSelectionUp(v:count1)<CR>

nnoremap <leader><leader> viwxi()<Esc>P
vnoremap <leader><leader> xi()<Esc>P

""---------------------------------------------------------------------------//
" Add Empty space above and below
""---------------------------------------------------------------------------//
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>
""---------------------------------------------------------------------------//
"Tab completion
""---------------------------------------------------------------------------//
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nnoremap <leader>n :enew<cr>
" Close a tab
nnoremap <leader>tc :tabclose<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
" nnoremap <leader>q :bp <BAR> bd #<CR>
" nnoremap <leader>q :on<CR>
" Better redo
nnoremap U <C-R>
" Paste in visual mode multiple times
xnoremap p pgvy
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
" nnoremap <silent><expr> <CR> empty(&buftype) ? '@@' : '<CR>'
"Evaluates whether there is a fold on the current line if so unfold it else return a normal space
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
" Close all the buffers
" nnoremap <leader>ba :bufdo bd!<cr>
" Quickly edit your macros
" Usage <leader>m or "q<leader>m
nnoremap <leader>m  :<c-u><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>
""---------------------------------------------------------------------------//
" => Command mode related
""---------------------------------------------------------------------------//
" Smart mappings on the command line
cno $h e ~/
cno $d e ~/Desktop/
cno $j e ./

" $q is super useful when browsing on the command line
" it deletes everything until the last slash 
cno $q <C-\>eDeleteTillSlash()<cr>
" insert path of current file into a command
cmap <c-f> <c-r>=expand("%:p:h") . "/" <cr>
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h
cmap w!! w !sudo tee % >/dev/null
" Commands {{{
" Loop cnext / cprev / lnext / lprev {{{
command! Cnext try | cnext | catch | cfirst | catch | endtry
command! Cprev try | cprev | catch | clast | catch | endtry
command! Lnext try | lnext | catch | lfirst | catch | endtry
command! Lprev try | lprev | catch | llast | catch | endtry
cabbrev cnext Cnext
cabbrev cprev CPrev
cabbrev lnext Lnext
cabbrev lprev Lprev
" }}}

""---------------------------------------------------------------------------//
" => VISUAL MODE RELATED
""---------------------------------------------------------------------------//
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
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
" Scroll command history
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
"Save
nnoremap <C-S> :update<CR>
nnoremap <leader>s :update<cr>
inoremap <C-s> <C-O>:update<cr>
"Quit
vnoremap <C-Q>     <esc>
nnoremap <leader>ln :cnext<CR>
nnoremap <leader>lp :cprev<CR>
"File completion made a little less painful
inoremap <c-f> <c-x><c-f>
" Tab and Shift + Tab Circular buffer navigation
nnoremap <tab>  :bnext<CR>
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
" Capitalize.
nnoremap ,U <ESC>gUiw`]
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

"Change two horizontally split windows to vertical splits
nnoremap <LocalLeader>h <C-W>t <C-W>K
"Change two vertically split windows to horizontal splits
nnoremap <LocalLeader>v <C-W>t <C-W>H
"Select txt that has just been read or pasted in
nnoremap gV `[V`]
" find visually selected text
vnoremap * y/<C-R>"<CR>
" make . work with visually selected lines
vnoremap . :norm.<CR>
" text-object: line
" Elegant text-object pattern hacked out of jdaddy.vim.
function! s:line_inner_movement(count) abort
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
nnoremap <localleader>[ :s/<C-r><C-w>/
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
"Remap back tick for jumping to marks more quickly back
nnoremap ' `
nnoremap ` '

"Save all files
nnoremap qa :wqa<CR>
" press enter for newline without insert
"******************************************************
" nnoremap <localleader><cr> o<esc>
noremap <tab><CR> o<Esc>
"Sort a visual selection
vnoremap <leader>s :sort<CR>
"open a new file in the same directory
nnoremap <Leader>nf :e <C-R>=expand("%:p:h") . "/" <CR>

nnoremap <localleader>c :<c-f>
"Open command line window
nnoremap <leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>
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
"close loclist or qflist
nnoremap <leader>x :cclose <bar> lclose<CR>
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
"Maps K and J to a 10 k and j but @= makes the motions multipliable - not
"a word I know
noremap K  @='10gk'<CR>
noremap J  @='10gj'<CR>

"This line opens the vimrc in a vertical split
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <localleader>ev :tabnew $MYVIMRC<cr>
command! Vimrc :e $MYVIMRC
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
MapToggle <F2> list
" Behavior-altering option toggles
MapToggle <F5> scrollbind

set pastetoggle=<F3>

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
