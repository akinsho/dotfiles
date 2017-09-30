""---------------------------------------------------------------------------//
"MAPPINGS {{{
""---------------------------------------------------------------------------//
""---------------------------------------------------------------------------//
"Terminal {{{
""---------------------------------------------------------------------------//
" Terminal settings
if has('nvim')
  " set guicursor=n-v-c-i-ci-ve:block
  "Add neovim terminal escape with ESC mapping
  tmap <ESC> <C-\><C-n>
  " escape from terminal mode to normal mode
  tnoremap jk <C-\><C-n>
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
  tmap <leader>, <C-\><C-n>:bnext<cr>
  nmap <leader>t :term<cr>
"Opening splits with terminal in all directions
nnoremap <leader>h<CR> :leftabove 30vnew<CR>:terminal<CR>
nnoremap <leader>l<CR> :rightbelow 30vnew<CR>:terminal<CR>
nnoremap <leader>k<CR> :leftabove 10new<CR>:terminal<CR>
nnoremap <leader>j<CR> :rightbelow 10new<CR>:terminal<CR>
endif
"}}}

"}}}
""---------------------------------------------------------------------------//
" MACROS {{{
""---------------------------------------------------------------------------//
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
nnoremap <silent> <cr>q :call <SID>Unfocus()<cr>

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
"}}}
""---------------------------------------------------------------------------//
" Find and Jump Mapping
""---------------------------------------------------------------------------//"
" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
  nnoremap <localleader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
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
" http://superuser.com/questions/290360
"/how-to-switch-words-in-an-easy-manner-in-vim/290449#290449
""---------------------------------------------------------------------------//
" exchange word under cursor with the next word without moving the cursor
nnoremap gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o><C-l>

" move the current word to the right and keep the cursor on it
nnoremap ]w "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o>/\w\+\_W\+<CR><C-l>

" move the current word to the left and keep the cursor on it
nnoremap [w "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o><C-l>
""---------------------------------------------------------------------------//
" Add Empty space above and below
""---------------------------------------------------------------------------//
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>
"Use enter to create new lines w/o entering insert mode
nnoremap <CR> o<Esc>
"Below is to fix issues with the ABOVE mappings in quickfix window
augroup EnterMapping
  au!
  autocmd BufReadPost quickfix nnoremap <CR> <CR>
augroup END
""---------------------------------------------------------------------------//
" Make the given command repeatable using repeat.vim
command! -nargs=* Repeatable call s:Repeatable(<q-args>)
function! s:Repeatable(command)
  exe a:command
  call repeat#set(':Repeatable '.a:command."\<cr>")
endfunction

""---------------------------------------------------------------------------//
"Tab completion
""---------------------------------------------------------------------------//
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" To open a new empty buffer
nnoremap <localleader>n :enew<cr>
nnoremap <leader>q :q!<cr>
" Paste in visual mode multiple times
xnoremap p pgvy
" " Show all open buffers and their status
nnoremap <leader>bl :ls<CR>
" search visual selection
vnoremap // y/<C-R>"<CR>
" Toggle background with <leader>bg
nnoremap <leader>bg :let &background = (&background == "dark" ? "light" : "dark")<cr>

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
""---------------------------------------------------------------------------//
" => Command mode related
""---------------------------------------------------------------------------//
" Smart mappings on the command line
cno $d e ~/Desktop/
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
nnoremap <expr> j v:count > 1 ? 'm`' . v:count . 'j' : 'gj'
nnoremap <expr> k v:count > 1 ? 'm`' . v:count . 'k' : 'gk'
" inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
" inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))
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
" Quit
inoremap <C-Q>     <esc>:q<cr>
vnoremap <C-Q>  <esc>
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
" Tab navigation
nnoremap th :tabprev<CR>
nnoremap tl :tabnext<CR>
" Useful mappings for managing tabs
nnoremap tn :tab split<cr>
nnoremap to :tabonly<cr>
nnoremap tc :tabclose<cr>
nnoremap tm :tabmove<Space>

"File completion made a little less painful
"inoremap <c-f> <c-x><c-f>
"----------------------------------------------------------------------------
"Buffers
"----------------------------------------------------------------------------
"Tab and Shift + Tab Circular buffer navigation
nnoremap <tab>  :bnext<CR>
nnoremap <S-tab> :bprevious<CR>
" Switch between the last two files
nnoremap <leader><leader> <c-^>

" use ,gf to go to file in a vertical split
nnoremap <silent> <leader>gf   :vertical botright wincmd F<CR>
""---------------------------------------------------------------------------//
nnoremap <BS> gg
"Change operator arguments to a character representing the desired motion
nnoremap ; :
nnoremap : ;
" Allow using alt in macOS without enabling “Use Option as Meta key”
nmap ¬ <a-l>
nmap ˙ <a-h>
nmap ∆ <a-j>
nmap ˚ <a-k>
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

""---------------------------------------------------------------------------//
 " Insert Mode Bindings
""---------------------------------------------------------------------------//
inoremap <c-d> <esc>ddi
" ----------------------------------------------------------------------------
" Moving lines
" ----------------------------------------------------------------------------
nnoremap <silent> ß :move+<cr>
nnoremap <silent> ∂ :move-2<cr>
nnoremap <silent> - :move+<cr>
nnoremap <silent> _ :move-2<cr>
" Move visual block
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv

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
"---------------------------------------------------------------------------//
" Inner Indent Text Object - Courtesty of http://vim.wikia.com/wiki/Indent_text_object
"---------------------------------------------------------------------------//
" Changes to allow blank lines in blocks, and
" Top level blocks (zero indent) separated by two or more blank lines.
" Usage: source <thisfile> in pythonmode and
" Press: vai, vii to select outer/inner python blocks by indetation.
" Press: vii, yii, dii, cii to select/yank/delete/change an indented block.
onoremap <silent>ai :<C-u>call IndTxtObj(0)<CR>
onoremap <silent>ii :<C-u>call IndTxtObj(1)<CR>
vnoremap <silent>ai <Esc>:call IndTxtObj(0)<CR><Esc>gv
vnoremap <silent>ii <Esc>:call IndTxtObj(1)<CR><Esc>gv

function! IndTxtObj(inner)
  let curcol = col(".")
  let curline = line(".")
  let lastline = line("$")
  let i = indent(line("."))
  if getline(".") !~ "^\\s*$"
    let p = line(".") - 1
    let pp = line(".") - 2
    let nextblank = getline(p) =~ "^\\s*$"
    let nextnextblank = getline(pp) =~ "^\\s*$"
    while p > 0 && ((i == 0 && (!nextblank || (pp > 0 && !nextnextblank)))
          \ || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner))
          \ || (nextblank && !a:inner))))
      -
      let p = line(".") - 1
      let pp = line(".") - 2
      let nextblank = getline(p) =~ "^\\s*$"
      let nextnextblank = getline(pp) =~ "^\\s*$"
    endwhile
    normal! 0V
    call cursor(curline, curcol)
    let p = line(".") + 1
    let pp = line(".") + 2
    let nextblank = getline(p) =~ "^\\s*$"
    let nextnextblank = getline(pp) =~ "^\\s*$"
    while p <= lastline && ((i == 0 && (!nextblank || pp < lastline && !nextnextblank))
          \ || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner))
          \ || (nextblank && !a:inner))))
      +
      let p = line(".") + 1
      let pp = line(".") + 2
      let nextblank = getline(p) =~ "^\\s*$"
      let nextnextblank = getline(pp) =~ "^\\s*$"
    endwhile
    normal! $
  endif
endfunction

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
nnoremap <leader>- :sp<CR>
"Create a horizontal split
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
" Repeat last substitute with flags
nnoremap & :&&<CR>
xnoremap & :&&<CR>
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
  autocmd! BufNewFile * nested call s:goto_line()
augroup END
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
nnoremap 0 ^
"Remaps native ctrl k - deleting to the end of a line to control e
" Map jk to esc key
inoremap jk <ESC>
xnoremap jk <ESC>
cnoremap jk <C-C>
"@= makes the motions take counts
nnoremap K  @='10gk'<CR>
nnoremap J  @='10gj'<CR>

"This line opens the vimrc in a vertical split
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <localleader>ev :tabnew $MYVIMRC<cr>
command! Vimrc :e $MYVIMRC
"This line allows the current file to source the vimrc allowing me use bindings as they're added
nnoremap <leader>sv :source $MYVIMRC<cr>
" Surround word with quotes or braces
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel
nnoremap <leader>( viw<esc>a)<esc>bi(<esc>lel
nnoremap <leader>) viw<esc>a)<esc>bi(<esc>lel
nnoremap <leader>{ viw<esc>a}<esc>bi{<esc>lel
nnoremap <leader>} viw<esc>a}<esc>bi{<esc>lel
" To the leftmost non-blank character of the current line
nnoremap H g^
" To the rightmost character of the current line
nnoremap L g$

nnoremap <leader>ll :vertical resize +10<cr>
nnoremap <leader>hh :vertical resize -10<cr>
nnoremap <leader>jj :res +10<cr>
nnoremap <leader>kk :res -10<cr>

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif
" source : https://blog.petrzemek.net/2016/04/06/things-about-vim-i-wish-i-knew-earlier/
"Move to beginning of a line in insert mode
inoremap <c-a> <c-o>0
inoremap <c-e> <c-o>$

"Map Q to remove a CR
" nnoremap Q J
" Quick macro invocation with q register
nnoremap Q @q
"Replace word under curosor
nnoremap S "_diwP
"}}}

" Shortcut to jump to next conflict marker"
nnoremap <silent> <localleader>co /^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>

" Zoom - This function uses a tab to zoom the current split
function! s:zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
        \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction
nnoremap <silent> <leader>z :call <sid>zoom()<cr>
" Zoom / Restore window. - Zooms by increasing window with smooshing the
" Other window
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
nnoremap <silent> <localleader>z :ZoomToggle<CR>

command! PU PlugUpdate | PlugUpgrade

" Peekabo Like functionality
function! Reg()
  reg
  echo "Register: "
  let char = nr2char(getchar())
  if char != "\<Esc>"
    execute "normal! \"".char."p"
  endif
  redraw
endfunction

command! -nargs=0 Reg call Reg()
nnoremap <localleader>r :Reg<CR>
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

fu! ToggleColorColumn()
  if &colorcolumn
    set colorcolumn=""
  else
    set colorcolumn=80
  endif
endfunction
nnoremap <F5> :call ToggleColorColumn()<CR>
"Re-indent pasted text
nnoremap p p=`]<c-o>
nnoremap P P=`]<c-o>
""---------------------------------------------------------------------------//
" GREPPING
""---------------------------------------------------------------------------//
nnoremap <silent> g* :silent! :grep! -w <C-R><C-W><CR>
" Show last search in quickfix
" (http://travisjeffery.com/b/2011/10/m-x-occur-for-vim/)
nnoremap gl/ :vimgrep /<C-R>//j %<CR>\|:cw<CR>
nnoremap <silent> g/ :silent! :grep!<space>
