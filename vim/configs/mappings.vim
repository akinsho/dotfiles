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
  "Add neovim terminal escape with ESC mapping
  tmap <ESC> <C-\><C-n>
  tmap <Leader>e <C-\><C-n>
  tmap <C-h> <C-\><C-n><C-h>
  tmap <C-j> <C-\><C-n><C-j>
  tmap <C-k> <C-\><C-n><C-k>
  tmap <C-l> <C-\><C-n><C-l>
  tmap <leader>x <c-\><c-n>:bp! <BAR> bd! #<CR>
  tmap <leader><tab> <C-\><C-n>:bnext<CR>
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

nnoremap <leader><leader> viwxi()<Esc>P
vnoremap <leader><leader> xi()<Esc>P

" Open new tab more easily:
nnoremap ,t :tabnew<cr>
nnoremap ,T :tabedit %<cr>gT:quit<cr>
""---------------------------------------------------------------------------//
" MACROS
""---------------------------------------------------------------------------//
" Quickly make a macro and use it with "."
let s:simple_macro_active = 0
nnoremap M :call <SID>SimpleMacro()<cr>
function! s:SimpleMacro()
  if s:simple_macro_active == 0

    call feedkeys('qm', 'n')
    let s:simple_macro_active = 1

  elseif s:simple_macro_active == 1

    normal! q
    " remove trailing M
    let @m = @m[0:-2]
    call repeat#set(":\<c-u>call repeat#wrap('@m', 1)\<cr>", 1)
    let s:simple_macro_active = 0

  endif
endfunction

" Quickly edit your macros
" Usage <leader>m or "q<leader>m
nnoremap <leader>m  :<c-u><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>
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
" Focus marked text by highlighting everything else as a comment
xnoremap <silent> <cr> :<c-u>call <SID>Focus()<cr>
nnoremap <silent> <cr> :call <SID>Unfocus()<cr>

function! s:Focus()
  let start = line("'<")
  let end   = line("'>")

  call matchadd('Comment', '.*\%<'.start.'l')
  call matchadd('Comment', '.*\%>'.end.'l')
  syntax sync fromstart
  redraw
endfunction

function! s:Unfocus()
  call clearmatches()
endfunction

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

" Toggle background with <leader>bg
nnoremap <leader>bg :let &background = (&background == "dark" ? "light" : "dark")<cr>

" These mappings will make it so that going to the next one in a search will
" center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

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
""---------------------------------------------------------------------------//
" => Command mode related
""---------------------------------------------------------------------------//
" Smart mappings on the command line
cno $d e ~/Desktop/

" $q is super useful when browsing on the command line
" it deletes everything until the last slash
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
" Scroll command history
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
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
"Save
nnoremap <leader>s :update<cr>
inoremap <C-s> <C-O>:update<cr>
"Save all files
nnoremap qa :wqa<CR>
vnoremap <C-Q>     <esc>
" ----------------------------------------------------------------------------
" Quickfix
" ----------------------------------------------------------------------------
nnoremap ]q :cnext<CR>zz
nnoremap [q :cprev<CR>zz
nnoremap ]l :lnext<cr>zz
nnoremap [l :lprev<cr>zz
" ----------------------------------------------------------------------------
" Tabs
" ----------------------------------------------------------------------------
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

"File completion made a little less painful
inoremap <c-f> <c-x><c-f>
" ----------------------------------------------------------------------------
" Buffers
" ----------------------------------------------------------------------------
" Tab and Shift + Tab Circular buffer navigation
nnoremap <tab>  :bnext<CR>
nnoremap <S-tab> :bprevious<CR>
"Switch to previous
nnoremap <leader>sw :b#<CR>
""---------------------------------------------------------------------------//
nnoremap <BS> gg
"Change operator arguments to a character representing the desired motion
nnoremap ; :
nnoremap : ;
"nnoremap [Alt]   <Nop>
"xnoremap [Alt]   <Nop>
" nmap    e  [Alt]
" xmap    e  [Alt]
""---------------------------------------------------------------------------//
" Last Insterted or Changed object
""---------------------------------------------------------------------------//
" Like gv, but select the last changed text.
nnoremap gi  `[v`]
" select last paste in visual mode
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'
""---------------------------------------------------------------------------//
" Capitalize
""---------------------------------------------------------------------------//
" Capitalize.
nnoremap ,U <ESC>gUiw`]
inoremap <C-u> <ESC>gUiw`]a
" ----------------------------------------------------------------------------
" Moving lines
" ----------------------------------------------------------------------------
" nnoremap <silent> <C-]> :move+<cr>
" nnoremap <silent> <C-[> :move-2<cr>
" xnoremap <silent> <C-k> :move-2<cr>gv
" xnoremap <silent> <C-j> :move'>+<cr>gv

""---------------------------------------------------------------------------//
" Paragrapgh Wise navigation
""---------------------------------------------------------------------------//
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
""---------------------------------------------------------------------------//
" Credit: Tpope
" text-object: line - Elegant text-object pattern hacked out of jdaddy.vim.
""---------------------------------------------------------------------------//
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

nnoremap <F6> :! open %<CR>
" Remap jumping to the last spot you were editing previously to bk as this is easier form me to remember
nnoremap bk `.
" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$
""---------------------------------------------------------------------------//
" Quick find/replace
""---------------------------------------------------------------------------//
nnoremap <Leader>[ :%s/<C-r><C-w>/
nnoremap <localleader>[ :s/<C-r><C-w>/
vnoremap <Leader>[ "zy:%s/<C-r><C-o>"/
""---------------------------------------------------------------------------//
" Find and Replace Using Abolish Plugin %S - Subvert
""---------------------------------------------------------------------------//
nnoremap <leader>{ :%S/<C-r><C-w>/
vnoremap <Leader>{ "zy:%S/<C-r><C-o>"/
" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
"Remap back tick for jumping to marks more quickly back
nnoremap ' `
nnoremap ` '
""---------------------------------------------------------------------------//
" press enter for newline without insert
" nnoremap <localleader><cr> o<esc>
"******************************************************
""---------------------------------------------------------------------------//
"Sort a visual selection
vnoremap <leader>s :sort<CR>
"open a new file in the same directory
nnoremap <Leader>nf :e <C-R>=expand("%:p:h") . "/" <CR>

nnoremap <localleader>c :<c-f>
"Open command line window
nnoremap <leader>hl :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>
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
""---------------------------------------------------------------------------//
" Insert & Commandline mode Paste
""---------------------------------------------------------------------------//
inoremap <C-p> <Esc>pa
cnoremap <C-p> <C-r>"

" Delete left-hand side of assignment
nnoremap d= df=x
" ----------------------------------------------------------------------------
"Credit: JGunn :Count
" ----------------------------------------------------------------------------
command! -nargs=1 Count execute printf('%%s/%s//gn', escape(<q-args>, '/')) | normal! ``
" ----------------------------------------------------------------------------
" Todo - Check the repo for Todos and add to the qf list
" ----------------------------------------------------------------------------
function! s:todo() abort
  let entries = []
  for cmd in ['git grep -niI -e TODO -e FIXME -e XXX 2> /dev/null',
            \ 'grep -rniI -e TODO -e FIXME -e XXX * 2> /dev/null']
    let lines = split(system(cmd), '\n')
    if v:shell_error != 0 | continue | endif
    for line in lines
      let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
      call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
    endfor
    break
  endfor

  if !empty(entries)
    call setqflist(entries)
    copen
  endif
endfunction
command! Todo call s:todo()
" ----------------------------------------------------------------------------
" Open FILENAME:LINE:COL
" ----------------------------------------------------------------------------
function! s:goto_line()
  let tokens = split(expand('%'), ':')
  if len(tokens) <= 1 || !filereadable(tokens[0])
    return
  endif

  let file = tokens[0]
  let rest = map(tokens[1:], 'str2nr(v:val)')
  let line = get(rest, 0, 1)
  let col  = get(rest, 1, 1)
  bd!
  silent execute 'e' file
  execute printf('normal! %dG%d|', line, col)
endfunction

autocmd! BufNewFile * nested call s:goto_line()
" ----------------------------------------------------------------------------
" <Leader>?/! | Google it / Feeling lucky
" ----------------------------------------------------------------------------
function! s:goog(pat, lucky)
  let q = '"'.substitute(a:pat, '["\n]', ' ', 'g').'"'
  let q = substitute(q, '[[:punct:] ]',
       \ '\=printf("%%%02X", char2nr(submatch(0)))', 'g')
  call system(printf('open "https://www.google.com/search?%sq=%s"',
                   \ a:lucky ? 'btnI&' : '', q))
endfunction

nnoremap <leader>? :call <SID>goog(expand("<cWORD>"), 0)<cr>
nnoremap <leader>! :call <SID>goog(expand("<cWORD>"), 1)<cr>
xnoremap <leader>? "gy:call <SID>goog(@g, 0)<cr>gv
xnoremap <leader>! "gy:call <SID>goog(@g, 1)<cr>gv

" ----------------------------------------------------------------------------
" ConnectChrome
" ----------------------------------------------------------------------------
if has('mac')
  function! s:connect_chrome(bang)
    augroup connect-chrome
      autocmd!
      if !a:bang
        autocmd BufWritePost <buffer> call system(join([
        \ "osascript -e 'tell application \"Google Chrome\"".
        \               "to tell the active tab of its first window\n",
        \ "  reload",
        \ "end tell'"], "\n"))
      endif
    augroup END
  endfunction
  command! -bang ConnectChrome call s:connect_chrome(<bang>0)
endif

" ----------------------------------------------------------------------------
" ?ie | entire object
" ----------------------------------------------------------------------------
xnoremap <silent> ie gg0oG$
onoremap <silent> ie :<C-U>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>

""---------------------------------------------------------------------------//
" Navigation (CORE)
""---------------------------------------------------------------------------//
"Remaps native ctrl k - deleting to the end of a line to control e
" Map jk to esc key
inoremap jk <ESC>
xnoremap jk <ESC>
cnoremap jk <C-C>
"Maps K and J to a 10 k and j but @= makes the motions multipliable - not
"a word I know
" ********* BIG CHANGE ***********************
" noremap K  @='10gk'<CR>
" noremap J  @='10gj'<CR>
" scroll the viewport faster
nnoremap J 4<C-e>
nnoremap K 4<C-y>

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

" Make Ctrl-e jump to the end of the current line in the insert mode. This is
" handy when you are in the middle of a line and would like to go to its end
" without switching to the normal mode.
" source : https://blog.petrzemek.net/2016/04/06/things-about-vim-i-wish-i-knew-earlier/
"Move to beginning of a line in insert mode
inoremap <c-a> <c-o>0
inoremap <c-e> <c-o>$

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
""---------------------------------------------------------------------------//
" Map key to toggle opt
""---------------------------------------------------------------------------//
function! MapToggle(key, opt)
  let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
  exec 'nnoremap '.a:key.' '.cmd
  exec 'inoremap '.a:key." \<C-O>".cmd
endfunction
command! -nargs=+ MapToggle call MapToggle(<f-args>)
""---------------------------------------------------------------------------//
" Display-altering option toggles
""---------------------------------------------------------------------------//
MapToggle <F1> wrap
MapToggle <F2> list
""---------------------------------------------------------------------------//
" Behavior-altering option toggles
""---------------------------------------------------------------------------//
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
nnoremap <silent> g* :silent! :grep! -w <C-R><C-W><CR>
nnoremap <silent> ga :silent! :grepadd!<space>
" Show last search in quickfix (http://travisjeffery.com/b/2011/10/m-x-occur-for-vim/)
nnoremap g/ :vimgrep /<C-R>//j %<CR>\|:cw<CR>
" nnoremap <silent> g/ :silent! :grep!<space>
