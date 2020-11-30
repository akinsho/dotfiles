""---------------------------------------------------------------------------//
"MAPPINGS
""---------------------------------------------------------------------------//

"---------------------------------------------------------------------------//
" Terminal {{{
"---------------------------------------------------------------------------//
" Terminal settings
function s:add_terminal_mappings()
  if &filetype ==# '' || &filetype ==# 'toggleterm'
    if has('nvim')
      "Add neovim terminal escape with ESC mapping
      tnoremap <buffer><esc> <C-\><C-n>
      tnoremap <buffer>jk <C-\><C-n>
      tnoremap <buffer><C-h> <C-\><C-n><C-W>h
      tnoremap <buffer><C-j> <C-\><C-n><C-W>j
      tnoremap <buffer><C-k> <C-\><C-n><C-W>k
      tnoremap <buffer><C-l> <C-\><C-n><C-W>l
      tnoremap <buffer><silent>]t <C-\><C-n>:tablast<CR>
      tnoremap <buffer><silent>[t <C-\><C-n>:tabnext<CR>
      tnoremap <buffer><silent><S-Tab> <C-\><C-n>:bprev<CR>
      tnoremap <buffer><silent><leader><Tab> <C-\><C-n>:close \| :bnext<cr>
    else
      tmap <C-h> <C-W>h
      tmap <C-j> <C-W>j
      tmap <C-k> <C-W>k
      tmap <C-l> <C-W>l
      tmap <C-x> <C-W><silent>q!<CR>
    endif
  endif
endfunction

augroup AddTerminalMappings
  autocmd!
  autocmd TermEnter,BufEnter term://* call s:add_terminal_mappings()
augroup END
"}}}

nnoremap <silent><localleader>gl :GitPull<CR>
nnoremap <silent><localleader>gp :GitPush<CR>
nnoremap <silent><localleader>gpf :GitPushF<CR>
nnoremap <silent><localleader>gpt :TermGitPush<CR>

""---------------------------------------------------------------------------//
" MACROS {{{
""---------------------------------------------------------------------------//
" Absolutely fantastic function from stoeffel/.dotfiles which allows you to
" repeat macros across a visual range
"-----------------------------------------------------------------------------
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
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
" Add Empty space above and below
""---------------------------------------------------------------------------//
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>
"---------------------------------------------------------------------------//
" Paste in visual mode multiple times
xnoremap p pgvy
" It pastes, visually selects pasted text and then re-indents it.
" In most cases it works quite well.
nnoremap p p`[v`]=
" search visual selection
vnoremap // y/<C-R>"<CR>
" Credit: JustinMK
nnoremap g> :set nomore<bar>40messages<bar>set more<CR>

" Enter key should repeat the last macro recorded or just act as enter
" nnoremap <silent><expr> <CR> empty(&buftype) ? '@@' : '<CR>'
"Evaluates whether there is a fold on the current line if so unfold it else return a normal space
nnoremap <silent> <space> @=(foldlevel('.')?'za':"\<Space>")<CR>
" Refocus folds
nnoremap <localleader>z zMzvzz
" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO
""---------------------------------------------------------------------------//
" => Command mode related
""---------------------------------------------------------------------------//
" Commands {{{1
" source https://superuser.com/a/540519
" write the visual selection to the filename passed in as a command argument then delete the
" selection placing into the black hole register
command! -bang -range -nargs=1 -complete=file MoveWrite  <line1>,<line2>write<bang> <args> | <line1>,<line2>delete _
command! -bang -range -nargs=1 -complete=file MoveAppend <line1>,<line2>write<bang> >> <args> | <line1>,<line2>delete _
" smooth searching
cnoremap <expr> <Tab>   getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>/<C-r>/" : "<C-z>"
cnoremap <expr> <S-Tab> getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>?<C-r>/" : "<S-Tab>"
" Smart mappings on the command line
cmap w!! w !sudo tee % >/dev/null
" insert path of current file into a command
cnoremap %% <C-r>=fnameescape(expand('%'))<cr>
cnoremap :: <C-r>=fnameescape(expand('%:p:h'))<cr>/

command! -nargs=? AutoResize call utils#auto_resize(<args>)
"--------------------------------------------------------------------------------
" Grep Operator
"--------------------------------------------------------------------------------
function! s:GrepOperator(type)
  let l:saved_unnamed_register = @@

  if a:type ==# 'v'
    execute 'normal! `<v`>y'
  elseif a:type ==# 'char'
    execute 'normal! `[v`]y'
  else
    return
  endif
  "Use Winnr to check if the cursor has moved it if has restore it
  let l:winnr = winnr()
  silent execute 'grep! ' . shellescape(@@) . ' .'
  let @@ = l:saved_unnamed_register
  if winnr() != l:winnr
    wincmd p
  endif
endfunction

nnoremap <silent><leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <silent><leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>
" http://travisjeffery.com/b/2011/10/m-x-occur-for-vim/
nnoremap <silent><localleader>g* :Ggrep --untracked <cword><CR>

"--------------------------------------------------------------------------------
" Toggle list
"--------------------------------------------------------------------------------
function! s:get_buffer_list()
  redir => l:buflist
  silent! ls!
  redir END
  return l:buflist
endfunction

function! ToggleList(bufname, pfx)
  let l:buflist = s:get_buffer_list()
  for l:bufnum in map(filter(split(l:buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(l:bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx ==# 'l' && len(getloclist(0)) ==# 0
    echohl ErrorMsg
    echo 'Location List is Empty.'
    return
  endif
  let l:winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != l:winnr
    wincmd p
  endif
endfunction

nnoremap <silent> <leader>ls :call ToggleList("Quickfix List", 'c')<CR>
nnoremap <silent> <leader>li :call ToggleList("Location List", 'l')<CR>
" Store relative line number jumps in the jumplist.
nnoremap <expr><silent> j (v:count > 1 ? 'm`' . v:count : '') . 'gj'
nnoremap <expr><silent> k (v:count > 1 ? 'm`' . v:count : '') . 'gk'

" if the file under the cursor doesn't exist create it
" see :h gf a simpler solution of :edit <cfile> is recommended but doesn't work.
"
" If you select require('buffers/file') in lua for example
" this makes the cfile -> buffers/file rather than my_dir/buffer/file.lua
" CREDIT: https://www.reddit.com/r/vim/comments/i2x8xc/i_want_gf_to_create_files_if_they_dont_exist/
nnoremap <silent> gf :call <sid>open_file_or_create_new()<CR>

function! s:open_file_or_create_new() abort
  let path = expand('<cfile>')
  if empty(path)
    return
  endif

  try
    exe 'norm!gf'
  catch /.*/
    let new_path = fnamemodify(expand('%:p:h') . '/' . path, ':p')
    if !empty(fnamemodify(new_path, ':e')) " Edit immediately if file has extension
      return execute('edit '.new_path)
    endif
    let extensions = split(&suffixesadd, ',')
    if empty(extensions)
      echoerr "No extensions for this filetype found"
      return
    endif
    let full_path = new_path . extensions[0]
    call utils#message('creating new file: '.full_path, 'Title')
    return execute('edit '.full_path)
  endtry
endfunction
"--------------------------------------------------------------------------------
" Commandline mappings
"--------------------------------------------------------------------------------
" https://github.com/tpope/vim-rsi/blob/master/plugin/rsi.vim
" c-a / c-e everywhere - RSI.vim provides these
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
" TODO <C-A> allows you to insert all matches on the command line e.g. bd *.js <c-a>
" will insert all matching files e.g. :bd a.js b.js c.js
cnoremap <c-x><c-a> <c-a>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos() - 2]<CR>
" move cursor one character backwards unless at the end of the command line
cnoremap <expr> <C-f> getcmdpos() > strlen(getcmdline())? &cedit: "\<Lt>Right>"
" see :h cmdline-editing
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>
" Insert escaped '/' while inputting a search pattern
cnoremap <expr> / getcmdtype() == "/" ? "\/" : "/"
""---------------------------------------------------------------------------//
" source : https://blog.petrzemek.net/2016/04/06/things-about-vim-i-wish-i-knew-earlier/
""---------------------------------------------------------------------------//
"Move to beginning of a line in insert mode
inoremap <c-a> <c-o>0
inoremap <c-e> <c-o>$
""---------------------------------------------------------------------------//
" Save
nnoremap <silent><c-s> :silent w<cr>
" Write and quit all files
nnoremap <silent>qa :confirm wqa<CR>
""---------------------------------------------------------------------------//
" TABS
""---------------------------------------------------------------------------//
nnoremap <silent><leader>tn :tabedit %<CR>
nnoremap <silent><leader>tc :tabclose<CR>
" ----------------------------------------------------------------------------
" Quickfix
" ----------------------------------------------------------------------------
nnoremap <silent> ]q :cnext<CR>zz
nnoremap <silent> [q :cprev<CR>zz
nnoremap <silent> ]l :lnext<cr>zz
nnoremap <silent> [l :lprev<cr>zz
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

"--------------------------------------------------------------------------------
" Search
"--------------------------------------------------------------------------------
nnoremap <localleader>/ :g//#<Left><Left>

"--------------------------------------------------------------------------------
" Clever commandline <CR>
"--------------------------------------------------------------------------------
" https://gist.github.com/romainl/047aca21e338df7ccf771f96858edb86
function! CCR()
  let cmdline = getcmdline()
  if getcmdtype() isnot# ':'
    return "\<CR>"
  endif
  if cmdline =~ '\v\C^(ls|files|buffers)'
    " like :ls but prompts for a buffer command
    return "\<CR>:b"
  elseif cmdline =~ '\v\C/(#|nu|num|numb|numbe|number)$'
    " like :g//# but prompts for a command
    return "\<CR>:"
  elseif cmdline =~ '\v\C^(dli|il)'
    " like :dlist or :ilist but prompts for a count for :djump or :ijump
    let parts = split(cmdline, " ")
    return len(parts) >= 2 ?
          \ "\<CR>:" . cmdline[0] . "j  " . parts[1] . "\<S-Left>\<Left>" :
          \ "\<c-]>\<CR>"
  elseif cmdline =~ '\v\C^(cli|lli)'
    " like :clist or :llist but prompts for an error/location number
    return "\<CR>:sil " . repeat(cmdline[0], 2) . "\<Space>"
  elseif cmdline =~ '\C^old'
    " like :oldfiles but prompts for an old file to edit
    set nomore
    return "\<CR>:sil se more|e #<"
  elseif cmdline =~ '\C^changes'
    " like :changes but prompts for a change to jump to
    set nomore
    return "\<CR>:sil se more|norm! g;\<S-Left>"
  elseif cmdline =~ '\C^ju'
    " like :jumps but prompts for a position to jump to
    set nomore
    return "\<CR>:sil se more|norm! \<C-o>\<S-Left>"
  elseif cmdline =~ '\C^marks'
    " like :marks but prompts for a mark to jump to
    return "\<CR>:norm! `"
  elseif cmdline =~ '\C^undol'
    " like :undolist but prompts for a change to undo
    return "\<CR>:u "
  elseif cmdline =~ '\C^reg'
    set nomore
    return "\<CR>:norm! \"p\<Left>"
  else
    return "\<c-]>\<CR>"
  endif
endfunction
" map '<CR>' in command-line mode to execute the function above
cnoremap <expr> <CR> CCR()
"----------------------------------------------------------------------------
" Buffers
"----------------------------------------------------------------------------
nnoremap <leader>on :w <bar> %bd <bar> e#<CR>
"Use wildmenu to cycle tabs
nnoremap <localleader><tab> :b <C-Z>
" Switch between the last two files
nnoremap <leader><leader> <c-^>
""---------------------------------------------------------------------------//
" Last Inserted
""---------------------------------------------------------------------------//
" select last paste in visual mode
" source: https://vim.fandom.com/wiki/Selecting_your_pasted_text
" TODO find a free mapping for this or delete it
" nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
""---------------------------------------------------------------------------//
" Capitalize
""---------------------------------------------------------------------------//
" Capitalize.
nnoremap <leader>U <ESC>gUiw`]
inoremap <C-u> <ESC>gUiw`]a
" ----------------------------------------------------------------------------
" Moving lines
" ----------------------------------------------------------------------------
" source: https://www.reddit.com/r/vim/comments/i8b5z1/is_there_a_more_elegant_way_to_move_lines_than_eg/
" Move visual block
if has('mac')
  " Allow using alt in macOS without enabling “Use Option as Meta key”
  nmap ¬ <a-l>
  nmap ˙ <a-h>
  nmap ∆ <a-j>
  nmap ˚ <a-k>
  nnoremap <silent> ∆ :<C-u>move+<CR>==
  nnoremap <silent> ˚ :<C-u>move-2<CR>==
  xnoremap ˚ :move-2<CR>='[gv
  xnoremap ∆ :move'>+<CR>='[gv
else
  nnoremap <silent><a-k> :<C-u>move-2<CR>==
  nnoremap <silent><a-j> :<C-u>move+<CR>==
  xnoremap <silent><a-k> :move-2<CR>='[gv
  xnoremap <silent><a-j> :move'>+<CR>='[gv
endif

"--------------------------------------------------------------------------------
" Windows
"--------------------------------------------------------------------------------
" Change two horizontally split windows to vertical splits
nnoremap <localleader>wh <C-W>t <C-W>K
" Change two vertically split windows to horizontal splits
nnoremap <localleader>wv <C-W>t <C-W>H
" Resize window downwards
nnoremap <localleader>wj <C-W>-
" Resize window upwards
nnoremap <localleader>wk <C-W>+

" find visually selected text
vnoremap * y/<C-R>"<CR>
" make . work with visually selected lines
vnoremap . :norm.<CR>
" Switch from visual to visual block.
xnoremap r <C-v>

"--------------------------------------------------------------------------------
" Operators
"--------------------------------------------------------------------------------
" Move <C-A> functionality to <C-G> is in tmux
" Prevents this useful binding from getting swallowed
if exists('$TMUX')
  noremap <c-g> <c-a>
endif
" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$
""---------------------------------------------------------------------------//
" Quick find/replace
""---------------------------------------------------------------------------//
nnoremap <leader>[ :%s/\<<C-r>=expand("<cword>")<CR>\>/
nnoremap <leader>] :s/\<<C-r>=expand("<cword>")<CR>\>/
vnoremap <leader>[ "zy:%s/<C-r><C-o>"/
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
"open a new file in the same directory
nnoremap <Leader>ns :vsp <C-R>=expand("%:p:h") . "/" <CR>
"Open command line window - :<c-f>
nnoremap <silent><localleader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

command! -nargs=+ -complete=command TabMessage call utils#tab_message(<q-args>)
""---------------------------------------------------------------------------//
" Window bindings
""---------------------------------------------------------------------------//
if !exists('$TMUX')
  nnoremap <c-j> <c-w>j
  nnoremap <c-k> <c-w>k
  nnoremap <c-h> <c-w>h
  nnoremap <c-l> <c-w>l
endif
" Swap top/bottom or left/right split
nnoremap <leader>sw <C-W>R
" https://vim.fandom.com/wiki/Fast_window_resizing_with_plus/minus_keys
if bufwinnr(1)
  nnoremap <a-h> <C-W><
  nnoremap <a-l> <C-W>>
endif
""---------------------------------------------------------------------------//
"Open Common files
""---------------------------------------------------------------------------//
nnoremap <leader>ez :e ~/.zshrc<cr>
nnoremap <leader>et :e ~/.tmux.conf<cr>

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
" ----------------------------------------------------------------------------
" Todo - Check for todos and add to the qf list
" ----------------------------------------------------------------------------
" Use the external grepprg which is set to ag or rg
" which is much faster than internal vimgrep progream
command! Todo noautocmd silent! grep! 'TODO\|FIXME' | copen

"--------------------------------------------------------------------------------
" GX - replicate netrw functionality
"--------------------------------------------------------------------------------
if has('nvim')
  function! s:open_link() abort
    let file = expand('<cfile>')
    if isdirectory(file)
      execute 'edit '. file
    else
      call jobstart([g:open_command, file], {'detach': v:true})
    endif
  endfunction
  nnoremap gx <Cmd>call <SID>open_link()<CR>
endif

" ----------------------------------------------------------------------------
" Credit: June Gunn <Leader>?/! | Google it / Feeling lucky
" ----------------------------------------------------------------------------
function! s:google(pat, lucky)
  let q = '"'.substitute(a:pat, '["\n]', ' ', 'g').'"'
  let q = substitute(q, '[[:punct:] ]',
        \ '\=printf("%%%02X", char2nr(submatch(0)))', 'g')
  call system(printf(g:open_command.' "https://www.google.com/search?%sq=%s"',
        \ a:lucky ? 'btnI&' : '', q))
endfunction

nnoremap <silent><localleader>? :call <SID>google(expand("<cWORD>"), 0)<cr>
nnoremap <silent><localleader>! :call <SID>google(expand("<cWORD>"), 1)<cr>
xnoremap <silent><localleader>? "gy:call <SID>google(@g, 0)<cr>gv
xnoremap <silent><localleader>! "gy:call <SID>google(@g, 1)<cr>gv

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
" Zero should go to the first non-blank character not to the first column (which could be blank)
noremap 0 ^
" when going to the end of the line in visual mode ignore whitespace characters
vnoremap $ g_
" jk is escape, THEN move to the right to preserve the cursor position, unless
" at the first column.  <esc> will continue to work the default way.
" NOTE: this is a recursive mapping so anything bound (by a plugin) to <esc> still works
imap <expr> jk col('.') == 1 ? '<esc>' : '<esc>l'
imap JK jk
imap Jk jk
xnoremap jk <ESC>
cnoremap jk <C-C>

" Toggle top/center/bottom
noremap <expr> zz (winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz'

"This line opens the vimrc in a vertical split
nnoremap <silent><leader>ev :vsplit $MYVIMRC<cr>
"This line allows the current file to source the vimrc allowing me use bindings as they're added
nnoremap <silent><leader>sv :source $MYVIMRC<cr> <bar> :call utils#info_message('Sourced init.vim')<cr>
" Surround word with quotes or braces
nnoremap <leader>" ciw"<c-r>""<esc>
nnoremap <leader>` ciw`<c-r>"`<esc>
nnoremap <leader>' ciw'<c-r>"'<esc>
nnoremap <leader>) ciw(<c-r>")<esc>
nnoremap <leader>} ciw{<c-r>"}<esc>
"Map Q to replay q register
nnoremap Q @q
"}}}

if !PluginLoaded('conflict-marker.vim')
  " Shortcut to jump to next conflict marker"
  nnoremap <silent> ]x /^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>
  " Shortcut to jump to last conflict marker"
  nnoremap <silent> [x ?^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>
endif

command! PU PlugUpdate | PlugUpgrade
" Peekabo plugin handles this currently
command! -nargs=0 Reg call utils#reg()

" Zoom / Restore window. - Zooms by increasing window width squashing the other window
" z is the zoom/zen prefix
nnoremap <silent> <leader>zt :call utils#tab_zoom()<CR>
""---------------------------------------------------------------------------//
" Display-altering option toggles
""---------------------------------------------------------------------------//

function! s:toggle_bg() abort
  if &background == 'dark'
    set background=light
  else
    set background=dark
  endif
endfunction

command! ToggleBackground call s:toggle_bg()
""---------------------------------------------------------------------------//
" Behavior-altering option toggles
""---------------------------------------------------------------------------//
set pastetoggle=<F6>

function! ToggleColorColumn()
  if &colorcolumn
    set colorcolumn=""
  else
    set colorcolumn=80
  endif
endfunction
nnoremap <F5> :call ToggleColorColumn()<CR>
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
" Delimiters
""---------------------------------------------------------------------------//
" Conditionally modify character at end of line
nnoremap <silent> <localleader>, :call utils#modify_line_end_delimiter(',')<cr>
nnoremap <silent> <localleader>; :call utils#modify_line_end_delimiter(';')<cr>

command! -nargs=0 Token call utils#token_inspect()
nnoremap <leader>E :Token<cr>

nmap <silent> <ScrollWheelDown> <c-d>
nmap <silent> <ScrollWheelUp>   <c-u>

" "in number" (next number after cursor on current line)
xnoremap <silent> in :<c-u>call utils#in_number()<cr>
onoremap <silent> in :<c-u>call utils#in_number()<cr>

" "around number" (next number on line and possible surrounding white-space)
xnoremap <silent> an :<c-u>call utils#around_number()<cr>
onoremap <silent> an :<c-u>call utils#around_number()<cr>
