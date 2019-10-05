""---------------------------------------------------------------------------//
"MAPPINGS
""---------------------------------------------------------------------------//
""---------------------------------------------------------------------------//
"Terminal {{{
""---------------------------------------------------------------------------//
" Terminal settings
if has('nvim')
  "Add neovim terminal escape with ESC mapping
  tnoremap <ESC> <C-\><C-n>
  tnoremap jk <C-\><C-n>
  " Recursive mappings so that the rebound <C-direction> mappings are triggerd
  tmap <C-h> <C-\><C-n><C-h>
  tmap <C-j> <C-\><C-n><C-j>
  tmap <C-k> <C-\><C-n><C-k>
  tmap <C-l> <C-\><C-n><C-l>
  " TODO: this mapping should delete the buffer and close the window
  tnoremap <silent><leader>x <c-\><c-n><Cmd>bp! <BAR> bd! #<CR>
  tnoremap <silent><leader><S-Tab> <C-\><C-n><Cmd>bprev<CR>
  tnoremap <silent><leader><Tab> <C-\><C-n><Cmd>bnext<cr>
  nnoremap <leader>h<CR> <Cmd>leftabove 60vnew<CR><Cmd>terminal<CR>
  nnoremap <leader>l<CR> <Cmd>rightbelow 60vnew<CR><Cmd>terminal<CR>
  nnoremap <leader>k<CR> <Cmd>leftabove 10new<CR><Cmd>terminal<CR>
  nnoremap <leader>j<CR> <Cmd>rightbelow 10new<CR><Cmd>terminal<CR>
  nnoremap <Leader>te <Cmd>tabnew<CR><Cmd>te<CR>
else
  tmap <C-h> <C-W>h
  tmap <C-j> <C-W>j
  tmap <C-k> <C-W>k
  tmap <C-l> <C-W>l
  tmap <C-x> <C-W><silent>q!<CR>
endif
"Opening splits with terminal in all directions
"}}}

""---------------------------------------------------------------------------//
" MACROS {{{
""---------------------------------------------------------------------------//
"--------------------------------------------
"Absolutely fantastic function from stoeffel/.dotfiles which allows you to
"repeat macros across a visual range
"--------------------------------------------
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
xnoremap @ <Cmd><C-u>call ExecuteMacroOverVisualRange()<CR>
"}}}
" ----------------------------------------------------------------------------
" Credit: JGunn Choi ?il | inner line
" ----------------------------------------------------------------------------
" includes newline
xnoremap al $o0
onoremap al :<C-u>normal val<CR>
" No Spaces or CR
xnoremap <silent> il <Esc>^vg_
onoremap <silent> il :<C-U>normal! ^vg_<CR>
""---------------------------------------------------------------------------//
" Word transposition. Lifted from:
" http://superuser.com/questions/290360/how-to-switch-words-in-an-easy-manner-in-vim/290449#290449
""---------------------------------------------------------------------------//
" exchange word under cursor with the next word without moving the cursor
nnoremap gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o><C-l>

" move the current word to the right and keep the cursor on it
nnoremap [w "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o>/\w\+\_W\+<CR><C-l>

" move the current word to the left and keep the cursor on it
nnoremap ]w "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o><C-l>
""---------------------------------------------------------------------------//
" Add Empty space above and below
""---------------------------------------------------------------------------//
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>
""---------------------------------------------------------------------------//
" Make the given command repeatable using repeat.vim
command! -nargs=* Repeatable call s:Repeatable(<q-args>)
function! s:Repeatable(command)
  exe a:command
  call repeat#set(':Repeatable '.a:command."\<cr>")
endfunction
"---------------------------------------------------------------------------//
"Tab completion
"---------------------------------------------------------------------------//
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible()?"\<C-p>":"\<TAB>"
"---------------------------------------------------------------------------//
" To open a new empty buffer
nnoremap <localleader>n :enew<cr>
" Paste in visual mode multiple times
xnoremap p pgvy
" search visual selection
vnoremap // y/<C-R>"<CR>

" nnoremap <silent> <c-m>k :<C-u>call utils#move_line_up()<CR>
" nnoremap <silent> <c-m>j :<C-u>call utils#move_line_down()<CR>
" inoremap <silent> <C-m>k <C-o>:call utils#move_line_up()<CR>
" inoremap <silent> <C-m>j <C-o>:call utils#move_line_down()<CR>
" vnoremap <silent> <C-Up> :<C-u>call utils#move_visual_up()<CR>
" vnoremap <silent> <C-Down> :<C-u>call utils#move_visual_down()<CR>
" xnoremap <silent> <C-Up> :<C-u>call utils#move_visual_up()<CR>
" xnoremap <silent> <C-Down> :<C-u>call utils#move_visual_down()<CR>

" Credit: JustinMK
nnoremap g> :set nomore<bar>40messages<bar>set more<CR>

" Enter key should repeat the last macro recorded or just act as enter
" nnoremap <silent><expr> <CR> empty(&buftype) ? '@@' : '<CR>'
"Evaluates whether there is a fold on the current line if so unfold it else return a normal space
nnoremap <silent> <space> @=(foldlevel('.')?'za':"\<Space>")<CR>
" "Refocus" folds
nnoremap <localleader>z zMzvzz
" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO
""---------------------------------------------------------------------------//
" => Command mode related
""---------------------------------------------------------------------------//
" Commands {{{1
command! -bang -range -nargs=1 -complete=file MoveWrite  <line1>,<line2>write<bang> <args> | <line1>,<line2>delete _
command! -bang -range -nargs=1 -complete=file MoveAppend <line1>,<line2>write<bang> >> <args> | <line1>,<line2>delete _
" smooth searching
cnoremap <expr> <Tab>   getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>/<C-r>/" : "<C-z>"
cnoremap <expr> <S-Tab> getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>?<C-r>/" : "<S-Tab>"
" Smart mappings on the command line
cmap cwd lcd %:p:h<tab>
cmap w!! w !sudo tee % >/dev/null
" insert path of current file into a command
cnoremap %% <C-r>=fnameescape(expand('%'))<cr>
cnoremap :: <C-r>=fnameescape(expand('%:p:h'))<cr>/

command! -nargs=1 AutoResize call utils#auto_resize(<args>)
nnoremap <leader>ar :AutoResize 70<CR>

" Asterix sets the current word as target for N and n jumps but does not trigger a jump itself
nnoremap * m`:keepjumps normal! *``<cr>

"---------------------------------------------------------------------------//
" Auto Closing Pairs
"---------------------------------------------------------------------------//
" If im not using a plugin then use homegrown mappings
if !has_key(g:plugs, 'lexima.vim')
  inoremap ( ()<left>
  inoremap { {}<left>
  inoremap ` ``<left>
  inoremap ```<CR> ```<CR>```<Esc>O<Tab>
  inoremap (<CR> (<CR>)<Esc>O<Tab>
  inoremap {<CR> {<CR>}<Esc>O<Tab>
  inoremap {; {<CR>};<Esc>O<Tab>
  inoremap {, {<CR>},<Esc>O<Tab>
  inoremap [<CR> [<CR>]<Esc>O<Tab>
  inoremap ([ ([<CR>])<Esc>O<Tab>
  inoremap [; [<CR>];<Esc>O<Tab>
  inoremap [, [<CR>],<Esc>O<Tab>
endif
""---------------------------------------------------------------------------//
" => VISUAL MODE RELATED
""---------------------------------------------------------------------------//
" Store relative line number jumps in the jumplist.
nnoremap <expr><silent> j (v:count > 1 ? 'm`' . v:count : '') . 'gj'
nnoremap <expr><silent> k (v:count > 1 ? 'm`' . v:count : '') . 'gk'
" c-a / c-e everywhere - RSI.vim provides these
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos() - 2]<CR>
" Scroll command history
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
" Insert escaped '/' while inputting a search pattern
cnoremap <expr> / getcmdtype() == "/" ? "\/" : "/"
"Save
nnoremap <silent><C-S> :update<cr>
"Save all files
nnoremap <silent>qa :confirm wqa<CR>
" Quit
inoremap <C-Q>  <esc>:q<cr>
vnoremap <C-Q>  <esc>

" Use a bunch of standard UNIX commands for quick an dirty
" whitespace-based alignment
function! Align()
  '<,'>!column -t|sed 's/  \(\S\)/ \1/g'
  normal gv=
endfunction

xnoremap <silent> g= :<C-u>silent call Align()<CR>
" ----------------------------------------------------------------------------
" Quickfix
" ----------------------------------------------------------------------------
nnoremap <silent> ]q :cnext<CR>zz
nnoremap <silent> [q :cprev<CR>zz
nnoremap <silent> ]l :lnext<cr>zz
nnoremap <silent> [l :lprev<cr>zz
nnoremap <silent> <localleader>q :cclose<cr>:lclose<cr>:pclose<cr>
" ----------------------------------------------------------------------------
" Tabs
" ----------------------------------------------------------------------------
" Tab navigation
nnoremap <silent> ]t :tabprev<CR>
nnoremap <silent> [t :tabnext<CR>
" Useful <silent> mappings for managing tabs
nnoremap <silent> <silent> tn :tab split<cr>
nnoremap <silent> to :tabonly<cr>
nnoremap <silent> tc :tabclose<cr>
nnoremap <silent> tm :tabmove<Space>
""---------------------------------------------------------------------------//
" Multiple Cursor Replacement
" http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
""---------------------------------------------------------------------------//
let g:mc = "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>"

nnoremap cn *``cgn
nnoremap cN *``cgN

vnoremap <expr> cn g:mc . "``cgn"
vnoremap <expr> cN g:mc . "``cgN"

" 1. Position the cursor over a word; alternatively, make a selection.
" 2. Hit cq to start recording the macro.
" 3. Once you are done with the macro, go back to normal mode.
" 4. Hit Enter to repeat the macro over search matches.
function! SetupCR()
  nnoremap <Enter> :nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z
endfunction

nnoremap cq :call SetupCR()<CR>*``qz
nnoremap cQ :call SetupCR()<CR>#``qz

vnoremap <expr> cq ":\<C-u>call SetupCR()\<CR>" . "gv" . g:mc . "``qz"
vnoremap <expr> cQ ":\<C-u>call SetupCR()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz"
"----------------------------------------------------------------------------
"Buffers
"----------------------------------------------------------------------------
nnoremap <leader>on :w <bar> %bd <bar> e#<CR>
" This lists the open buffers then takes input re. which to delete
" nnoremap <localleader>d :ls<cr>:bd<space>
"Use wildmenu to cycle tabs
nnoremap <localleader><tab> :b <C-Z>
"Tab and Shift + Tab Circular buffer navigation
nnoremap <silent><leader><tab>  :bnext<CR>
nnoremap <silent><S-tab> :bprevious<CR>
" Switch between the last two files
nnoremap <leader><leader> <c-^>
" use ,gf to go to file in a vertical split
nnoremap <silent> <leader>gf   :vertical botright wincmd F<CR>
""---------------------------------------------------------------------------//
" nnoremap <BS> gg
"Change operator arguments to a character representing the desired motion
nnoremap ; :
nnoremap : ;
""---------------------------------------------------------------------------//
" Last Inserted
""---------------------------------------------------------------------------//
" select last paste in visual mode
nnoremap gl `[v`]
""---------------------------------------------------------------------------//
" Capitalize
""---------------------------------------------------------------------------//
" Capitalize.
nnoremap <leader>U <ESC>gUiw`]
inoremap <C-u> <ESC>gUiw`]a
""---------------------------------------------------------------------------//
" Insert Mode Bindings
""---------------------------------------------------------------------------//
inoremap <c-d> <esc>ddi
" ----------------------------------------------------------------------------
" Moving lines
" ----------------------------------------------------------------------------
" Move visual block
if has('mac')
  " Allow using alt in macOS without enabling “Use Option as Meta key”
  nmap ¬ <a-l>
  nmap ˙ <a-h>
  nmap ∆ <a-j>
  nmap ˚ <a-k>
  nnoremap <silent> ∆ :move+<cr>
  nnoremap <silent> ˚ :move-2<cr>
  vnoremap ˚ :m '<-2<CR>gv=gv
  vnoremap ∆ :m '>+1<CR>gv=gv
else
  nnoremap <silent> <a-k> :move-2<cr>
  nnoremap <silent> <a-j> :move+<cr>
  vnoremap <a-k> :m '<-2<CR>gv=gv
  vnoremap <a-j> :m '>+1<CR>gv=gv
endif

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
"Change two horizontally split windows to vertical splits
nnoremap <LocalLeader>h <C-W>t <C-W>K
"Change two vertically split windows to horizontal splits
nnoremap <LocalLeader>v <C-W>t <C-W>H
" find visually selected text
vnoremap * y/<C-R>"<CR>
" make . work with visually selected lines
vnoremap . :norm.<CR>
" Switch from visual to visual block.
xnoremap r <C-v>

xnoremap nu :<C-u>call utils#Numbers()<CR>
onoremap nu :normal vin<CR>

" Move <C-A> functionality to <C-G> is in tmux
" Prevents this useful binding from getting swallowed
if exists('$TMUX')
  noremap <c-g> <c-a>
endif
" ----------------------------------------------------------------------------
" ?ii / ?ai | indent-object
" ?io       | strictly-indent-object
" ----------------------------------------------------------------------------
function! s:indent_object(op, skip_blank, b, e, bd, ed)
  let i = min([s:indent_len(getline(a:b)), s:indent_len(getline(a:e))])
  let x = line('$')
  let d = [a:b, a:e]

  if i == 0 && empty(getline(a:b)) && empty(getline(a:e))
    let [b, e] = [a:b, a:e]
    while b > 0 && e <= line('$')
      let b -= 1
      let e += 1
      let i = min(filter(map([b, e], 's:indent_len(getline(v:val))'), 'v:val != 0'))
      if i > 0
        break
      endif
    endwhile
  endif

  for triple in [[0, 'd[o] > 1', -1], [1, 'd[o] < x', +1]]
    let [o, ev, df] = triple

    while eval(ev)
      let line = getline(d[o] + df)
      let idt = s:indent_len(line)

      if eval('idt '.a:op.' i') && (a:skip_blank || !empty(line)) || (a:skip_blank && empty(line))
        let d[o] += df
      else | break | end
    endwhile
  endfor
  execute printf('normal! %dGV%dG', max([1, d[0] + a:bd]), min([x, d[1] + a:ed]))
endfunction
xnoremap <silent> ii :<c-u>call <SID>indent_object('>=', 1, line("'<"), line("'>"), 0, 0)<cr>
onoremap <silent> ii :<c-u>call <SID>indent_object('>=', 1, line('.'), line('.'), 0, 0)<cr>
xnoremap <silent> ai :<c-u>call <SID>indent_object('>=', 1, line("'<"), line("'>"), -1, 1)<cr>
onoremap <silent> ai :<c-u>call <SID>indent_object('>=', 1, line('.'), line('.'), -1, 1)<cr>
xnoremap <silent> io :<c-u>call <SID>indent_object('==', 0, line("'<"), line("'>"), 0, 0)<cr>
onoremap <silent> io :<c-u>call <SID>indent_object('==', 0, line('.'), line('.'), 0, 0)<cr>

" Remap jumping to the last spot you were editing previously to bk as this is easier form me to remember
nnoremap bk `.
" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$
""---------------------------------------------------------------------------//
" Quick find/replace
""---------------------------------------------------------------------------//
" nnoremap <leader>] :'{,'}s/\<<C-r>=expand("<cword>")<CR>\>/
nnoremap <Leader>[ :%s/\<<C-r>=expand("<cword>")<CR>\>/
nnoremap <leader>] :s/\<<C-r>=expand("<cword>")<CR>\>/
vnoremap <Leader>[ "zy:%s/<C-r><C-o>"/
" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
"Remap back tick for jumping to marks more quickly back
nnoremap ' `
""---------------------------------------------------------------------------//
"Sort a visual selection
vnoremap <leader>s :sort<CR>
"open a new file in the same directory
nnoremap <Leader>nf :e <C-R>=expand("%:p:h") . "/" <CR>
"Open command line window - :<c-f>
nnoremap <localleader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

command! -nargs=+ -complete=command TabMessage call utils#tab_message(<q-args>)
" ----------------------------------------------------------------------------
" CREDIT: JGunn #gi / #gpi | go to next/previous indentation level
" ----------------------------------------------------------------------------
function! s:indent_len(str)
  return type(a:str) == 1 ? len(matchstr(a:str, '^\s*')) : 0
endfunction

function! s:go_indent(times, dir)
  for _ in range(a:times)
    let l = line('.')
    let x = line('$')
    let i = s:indent_len(getline(l))
    let e = empty(getline(l))

    while l >= 1 && l <= x
      let line = getline(l + a:dir)
      let l += a:dir
      if s:indent_len(line) != i || empty(line) != e
        break
      endif
    endwhile
    let l = min([max([1, l]), x])
    execute 'normal! '. l .'G^'
  endfor
endfunction

nnoremap <silent> gi :<c-u>call <SID>go_indent(v:count1, 1)<cr>
nnoremap <silent> gpi :<c-u>call <SID>go_indent(v:count1, -1)<cr>

""---------------------------------------------------------------------------//
" Window resizing bindings
""---------------------------------------------------------------------------//
"Create a vertical split
nnoremap <expr><silent> \| !v:count ? "<C-W>v<C-W><Right>" : '\|'
"Create a horizontal split
nnoremap <expr><silent> _ !v:count ? "<C-W>s<C-W><Down>"  : '_'
"Normalize all split sizes, which is very handy when resizing terminal
nnoremap <leader>= <C-W>=
"Close every window in the current tabview but the current one
nnoremap <leader>q <C-W>o
"Swap top/bottom or left/right split
nnoremap <leader>sw <C-W>R
""---------------------------------------------------------------------------//
"Open Common files
""---------------------------------------------------------------------------//
nnoremap <leader>ez :e ~/.zshrc<cr>
nnoremap <leader>et :e ~/.tmux.conf<cr>
"Indent a page
nnoremap <C-G>f gg=G<CR>

nnoremap <down> <nop>
nnoremap <up> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
" Repeat last substitute with flags
nnoremap & :&&<CR>
xnoremap & :&&<CR>
""---------------------------------------------------------------------------//
" Insert & Commandline mode Paste
""---------------------------------------------------------------------------//
inoremap <C-p> <Esc>pa
cnoremap <C-v> <C-r>"
" ----------------------------------------------------------------------------
" Todo - Check the repo for Todos and add to the qf list
" ----------------------------------------------------------------------------
command! Todo noautocmd vimgrep /TODO\|FIXME/j ** | cw
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

augroup GoToLine
  au!
  autocmd! BufRead * nested call s:goto_line()
augroup END
" ----------------------------------------------------------------------------
" Credit: June Gunn <Leader>?/! | Google it / Feeling lucky
" ----------------------------------------------------------------------------
function! s:goog(pat, lucky)
  let q = '"'.substitute(a:pat, '["\n]', ' ', 'g').'"'
  let q = substitute(q, '[[:punct:] ]',
        \ '\=printf("%%%02X", char2nr(submatch(0)))', 'g')
  call system(printf(g:open_command.' "https://www.google.com/search?%sq=%s"',
        \ a:lucky ? 'btnI&' : '', q))
endfunction

nnoremap <silent><localleader>? :call <SID>goog(expand("<cWORD>"), 0)<cr>
nnoremap <silent><localleader>! :call <SID>goog(expand("<cWORD>"), 1)<cr>
xnoremap <silent><localleader>? "gy:call <SID>goog(@g, 0)<cr>gv
xnoremap <silent><localleader>! "gy:call <SID>goog(@g, 1)<cr>gv

" ----------------------------------------------------------------------------
" Credit: June Gunn  == ConnectChrome
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
"Zero should go to the first non-blank character not to the first column (which could be blank)
noremap 0 ^
" jk is escape, THEN move to the right to preserve the cursor position, unless
" at the first column.  <esc> will continue to work the default way.
inoremap <expr> jk col('.') == 1 ? '<esc>' : '<esc>l'
imap JK jk
imap Jk jk
xnoremap jk <ESC>
cnoremap jk <C-C>

" Toggle top/center/bottom
noremap <expr> zz (winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz'

"This line opens the vimrc in a vertical split
nnoremap <silent><leader>ev :vsplit $MYVIMRC<cr>
nnoremap <silent><localleader>ev :tabnew $MYVIMRC<cr>
"This line allows the current file to source the vimrc allowing me use bindings as they're added
nnoremap <silent><leader>sv :source $MYVIMRC<cr> <bar> :call utils#info_message('Sourced init.vim')<cr>
" Surround word with quotes or braces
nnoremap <leader>" ciw"<c-r>""<esc>
nnoremap <leader>' ciw'<c-r>"'<esc>
nnoremap <leader>) ciw(<c-r>")<esc>
nnoremap <leader>} ciw{<c-r>"}<esc>

" Repeatable window resizing mappings
nnoremap <silent> <Plug>ResizeRight  :vertical resize +10<cr>
      \ :call repeat#set("\<Plug>ResizeRight")<CR>
nmap <leader>ll <Plug>ResizeRight

nnoremap <silent> <Plug>ResizeLeft :vertical resize -10<cr>
      \ :call repeat#set("\<Plug>ResizeLeft")<CR>
nmap <leader>hh <Plug>ResizeLeft

nnoremap <silent> <Plug>ResizeDown :resize +10<cr>
      \ :call repeat#set("\<Plug>ResizeDown")<CR>
nmap <leader>jj <Plug>ResizeDown

nnoremap <silent> <Plug>ResizeUp :resize -10<cr>
      \ :call repeat#set("\<Plug>ResizeUp")<CR>
nmap <leader>kk <Plug>ResizeUp
""---------------------------------------------------------------------------//
" source : https://blog.petrzemek.net/2016/04/06/things-about-vim-i-wish-i-knew-earlier/
""---------------------------------------------------------------------------//
"Move to beginning of a line in insert mode
inoremap <c-a> <c-o>0
inoremap <c-e> <c-o>$
"Map Q to replay q register
nnoremap Q @q
"Replace word under cursor
nnoremap S "_diwP
"}}}

" Shortcut to jump to next conflict marker"
if !has_key(g:plugs, 'conflict-marker.vim')
  nnoremap <silent> ]x /^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>
  " Shortcut to jump to last conflict marker"
  nnoremap <silent> [x ?^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>
endif
" Zoom - This function uses a tab to zoom the current split
nnoremap <silent> <leader>Z :call utils#tab_zoom()<cr>
" Zoom / Restore window. - Zooms by increasing window with smooshing the
" Other window
nnoremap <silent> <leader>z :call utils#buf_zoom()<CR>

command! PU PlugUpdate | PlugUpgrade
" Peekabo plugin handles this currently
command! -nargs=0 Reg call utils#reg()
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
MapToggle <F7> wrap
MapToggle <F8> list
""---------------------------------------------------------------------------//
" Behavior-altering option toggles
""---------------------------------------------------------------------------//
MapToggle <F9> scrollbind

set pastetoggle=<F6>

function! ToggleColorColumn()
  if &colorcolumn
    set colorcolumn=""
  else
    set colorcolumn=80
  endif
endfunction
nnoremap <F5> :call ToggleColorColumn()<CR>
"Re-indent pasted text
" nnoremap p p=`]<c-o>
" nnoremap P P=`]<c-o>
" ----------------------------------------------------------------------------
" Profile
" ----------------------------------------------------------------------------
function! s:profile(bang)
  if a:bang
    profile pause
    noautocmd qall
  else
    profile start /tmp/profile.log
    profile func *
    profile file *
  endif
endfunction
command! -bang Profile call s:profile(<bang>0)
""---------------------------------------------------------------------------//
" GREPPING
""---------------------------------------------------------------------------//
nnoremap <silent> g* :silent! :grep! -w <C-R><C-W><CR>
" Show last search in quickfix - http://travisjeffery.com/b/2011/10/m-x-occur-for-vim/
nnoremap gl/ :vimgrep /<C-R>//j %<CR>\|:cw<CR>
nnoremap <silent> g/ :silent! :grep!<space>
" Conditionally modify character at end of line
nnoremap <silent> <localleader>, :call utils#modify_line_end_delimiter(',')<cr>
nnoremap <silent> <localleader>; :call utils#modify_line_end_delimiter(';')<cr>

