""---------------------------------------------------------------------------//
"MAPPINGS
""---------------------------------------------------------------------------//
function! JSXIsSelfCloseTag()
  let l:line_number = line(".")
  let l:line = getline(".")
  let l:tag_name = matchstr(matchstr(line, "<\\w\\+"), "\\w\\+")

  exec "normal! 0f<vat\<esc>"

  cal cursor(line_number, 1)

  let l:selected_text = join(getline(getpos("'<")[1], getpos("'>")[1]))

  let l:match_tag = matchstr(matchstr(selected_text, "</\\w\\+>*$"), "\\w\\+")

  return tag_name != match_tag
endfunction

function! JSXSelectTag()
  if JSXIsSelfCloseTag()
    exec "normal! \<esc>0f<v/\\/>$\<cr>l"
  else
    exec "normal! \<esc>0f<vat"
  end
endfunction
" transform this:
"   <p>Hello</p>
" into this:
"   return (
"     <p>Hello</p>
"   );
function! JSXEncloseReturn()
  let l:previous_q_reg = @q
  let l:tab = &expandtab ? repeat(" ", &shiftwidth) : "\t"
  let l:line = getline(".")
  let l:line_number = line(".")
  let l:distance = len(matchstr(line, "^\[\\t|\\ \]*"))
  if &expandtab
    let l:distance = (distance / &shiftwidth)
  endif

  call JSXSelectTag()
  exec "normal! \"qc"

  let @q = repeat(tab, distance) . "return (\n" . repeat(tab, distance + 1) . substitute(getreg("q"), "\\n", ("\\n" . tab), "g") .  "\n" . repeat(tab, distance) . ");\n"

  exec "normal! dd\"qP"

  let @q = previous_q_reg
endfunction

""---------------------------------------------------------------------------//
"Terminal {{{
""---------------------------------------------------------------------------//
" Terminal settings
if has('nvim')
  "Add neovim terminal escape with ESC mapping
  tmap <ESC> <C-\><C-n>
  tmap jk <C-\><C-n>
  tmap <C-h> <C-\><C-n><C-h>
  tmap <C-j> <C-\><C-n><C-j>
  tmap <C-k> <C-\><C-n><C-k>
  tmap <C-l> <C-\><C-n><C-l>
  tmap <leader>x <c-\><c-n>:bp! <BAR> bd! #<CR>
  tmap <leader>. <C-\><C-n>:bprev<CR>
  tmap <leader>, <C-\><C-n>:bnext<cr>
else
  tmap <C-h> <C-W>h
  tmap <C-j> <C-W>j
  tmap <C-k> <C-W>k
  tmap <C-l> <C-W>l
  tmap <C-x> <C-W>:q!<CR>
endif
nnoremap <leader>to :term<cr>
"Opening splits with terminal in all directions
nnoremap <leader>h<CR> :leftabove 30vnew<CR>:terminal<CR>
nnoremap <leader>l<CR> :rightbelow 30vnew<CR>:terminal<CR>
nnoremap <leader>k<CR> :leftabove 10new<CR>:terminal<CR>
nnoremap <leader>j<CR> :rightbelow 10new<CR>:terminal<CR>
nnoremap <Leader>te :tabnew<CR>:te<CR>
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
nnoremap w> "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o>/\w\+\_W\+<CR><C-l>

" move the current word to the left and keep the cursor on it
nnoremap w< "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o><C-l>
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
inoremap <expr><S-TAB> pumvisible()?"\<C-p>":{}TAB>"
" <C-h>, <BS>: close popup and delete backword char.
if has('nvim')
  inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
endif
" To open a new empty buffer
nnoremap <localleader>n :enew<cr>
nnoremap <leader>q :bd!<cr>
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
" Commands {{{
command! -bang -range -nargs=1 -complete=file MoveWrite  <line1>,<line2>write<bang> <args> | <line1>,<line2>delete _
command! -bang -range -nargs=1 -complete=file MoveAppend <line1>,<line2>write<bang> >> <args> | <line1>,<line2>delete _
" smooth searching
cnoremap <expr> <Tab>   getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>/<C-r>/" : "<C-z>"
cnoremap <expr> <S-Tab> getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>?<C-r>/" : "<S-Tab>"
" Smart mappings on the command line
cno $d e ~/Desktop/
" insert path of current file into a command
cmap <c-f> <c-r>=expand("%:p:h") . "/" <cr>
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h
cmap w!! w !sudo tee % >/dev/null
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
nnoremap <expr> j (v:count > 1 ? 'm`' . v:count : '') . 'gj'
nnoremap <expr> k (v:count > 1 ? 'm`' . v:count : '') . 'gk'
" c-a / c-e everywhere - RSI.vim provides these
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
" Scroll command history
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
"Save
nnoremap <C-S> :update<cr>
inoremap <leader>s <C-O>:update<cr>
"Save all files
nnoremap qa :wqa<CR>
" Quit
inoremap <C-Q>  <esc>:q<cr>
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
" Switch between tabs
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt
" ========== Multiple Cursor Replacement ========
" http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/

let g:mc = "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>"

nnoremap cn *``cgn
nnoremap cN *``cgN

vnoremap <expr> cn g:mc . "``cgn"
vnoremap <expr> cN g:mc . "``cgN"

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
"File completion made a little less painful
inoremap <c-x>f <c-x><c-f>
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
" Last Inserted or Changed object
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
" Move visual block
nnoremap <silent> ∆ :move+<cr>
nnoremap <silent> ˚ :move-2<cr>
vnoremap ˚ :m '<-2<CR>gv=gv
vnoremap ∆ :m '>+1<CR>gv=gv

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
" nnoremap Y y$
""---------------------------------------------------------------------------//
" Quick find/replace
""---------------------------------------------------------------------------//
nnoremap <Leader>[ :%s/\<<C-r>=expand("<cword>")<CR>\>/
nnoremap <localleader>[ :'{,'}s/\<<C-r>=expand("<cword>")<CR>\>/
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
"Open command line window
nnoremap <localleader>C :<c-f>
nnoremap <leader>hl :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

""---------------------------------------------------------------------------//
" Window resizing bindings
""---------------------------------------------------------------------------//
"Create a horizontal split
nnoremap <leader>- :sp<CR>
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
nnoremap <leader>q <C-W>o
"Swap top/bottom or left/right split
nnoremap <leader>sw <C-W>R
""---------------------------------------------------------------------------//
"Open Common files
""---------------------------------------------------------------------------//
nnoremap <leader>a :argadd <c-r>=fnameescape(expand('%:p:h'))<cr>/*<C-d>
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
cnoremap <C-v> <C-r>"
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
  autocmd! BufRead * nested call s:goto_line()
augroup END
" ----------------------------------------------------------------------------
" Credit: June Gunn <Leader>?/! | Google it / Feeling lucky
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
nnoremap 0 ^
"Remaps native ctrl k - deleting to the end of a line to control e
" Map jk to esc key
inoremap jk <ESC>
xnoremap jk <ESC>
cnoremap jk <C-C>

nnoremap J 10j
nnoremap K 10k


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

" source : https://blog.petrzemek.net/2016/04/06/things-about-vim-i-wish-i-knew-earlier/
"Move to beginning of a line in insert mode
inoremap <c-a> <c-o>0
inoremap <c-e> <c-o>$

" Quick macro invocation with q register
nnoremap <localleader>q @q
"Map Q to remove a CR
nnoremap Q J
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
nnoremap <silent> <localleader>z :call <sid>zoom()<cr>
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
nnoremap <silent> <leader>z :ZoomToggle<CR>

command! PU PlugUpdate | PlugUpgrade

" Use D to delete a range then move cursor back
com! -range D <line1>,<line2>d | norm <C-o>

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

cnoremap <expr> <CR> <SID>CCR()
function! s:CCR()
  command! -bar Z silent set more|delcommand Z
  if getcmdtype() == ":"
    let cmdline = getcmdline()
    if cmdline =~ '\v\C^(dli|il)' | return "\<CR>:" . cmdline[0] . "jump   " . split(cmdline, " ")[1] . "\<S-Left>\<Left>\<Left>"
    elseif cmdline =~ '\v\C^(cli|lli)' | return "\<CR>:silent " . repeat(cmdline[0], 2) . "\<Space>"
    elseif cmdline =~ '\C^changes' | set nomore | return "\<CR>:Z|norm! g;\<S-Left>"
    elseif cmdline =~ '\C^ju' | set nomore | return "\<CR>:Z|norm! \<C-o>\<S-Left>"
    elseif cmdline =~ '\v\C(#|nu|num|numb|numbe|number)$' | return "\<CR>:"
    elseif cmdline =~ '\C^ol' | set nomore | return "\<CR>:Z|e #<"
    elseif cmdline =~ '\v\C^(ls|files|buffers)' | return "\<CR>:b"
    elseif cmdline =~ '\C^marks' | return "\<CR>:norm! `"
    elseif cmdline =~ '\C^undol' | return "\<CR>:u "
    else | return "\<CR>" | endif
  else | return "\<CR>" | endif
endfunction
