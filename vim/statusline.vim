"DIY STATUS LINE ==========================={{{
" =====================================================================
" stolen from https://gabri.me/blog/diy-vim-statusline
" =====================================================================
 " Dynamically getting the fg/bg colors from the current colorscheme, returns hex 
let fgcolor=synIDattr(synIDtrans(hlID("Normal")), "fg", "gui")
let bgcolor=synIDattr(synIDtrans(hlID("Normal")), "bg", "gui")
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids

let g:currentmode={
    \ 'n'  : 'Normal ',
    \ 'no' : 'N·Operator Pending ',
    \ 'v'  : 'Visual ',
    \ 'V'  : 'V·Line ',
    \ '' : 'V·Block ',
    \ 's'  : 'Select ',
    \ 'S'  : 'S·Line ',
    \ '^S' : 'S·Block ',
    \ 'i'  : 'Insert ',
    \ 'R'  : 'Replace ',
    \ 'Rv' : 'V·Replace ',
    \ 'c'  : 'Command ',
    \ 'cv' : 'Vim Ex ',
    \ 'ce' : 'Ex ',
    \ 'r'  : 'Prompt ',
    \ 'rm' : 'More ',
    \ 'r?' : 'Confirm ',
    \ '!'  : 'Shell ',
    \ 't'  : 'Terminal '
    \}

" Automatically change the statusline color depending on mode - requires gui colors as using termguicolors
function! ChangeStatuslineColor()
  if (mode() =~# '\v(n|no)')
    exe 'hi! StatusLine guibg=#425762'
  elseif (mode() =~# '\v(v|V)' || g:currentmode[mode()] ==# 'V·Block' || get(g:currentmode, mode(), '') ==# 't')
    exe 'hi! StatusLine guibg=#5f5fd7'
  elseif (mode() ==# 'i')
    exe 'hi! StatusLine guibg=#005f87'
  else
    exe 'hi! StatusLine guibg=#005faf'
  endif
  return ''
endfunction

" Find out current buffer's size and output it.
function! FileSize()
  let bytes = getfsize(expand('%:p'))
  if (bytes >= 1024)
    let kbytes = bytes / 1024
  endif
  if (exists('kbytes') && kbytes >= 1000)
    let mbytes = kbytes / 1000
  endif

  if bytes <= 0
    return '0'
  endif

  if (exists('mbytes'))
    return mbytes . 'MB '
  elseif (exists('kbytes'))
    return kbytes . 'KB '
  else
    return bytes . 'B '
  endif
endfunction

function! ReadOnly()
  if &readonly || !&modifiable
    return ''
  elseif &modified
    return g:mod_sym
  else
    return ''
endfunction

function! GitInfo()
  let git = fugitive#head()
  if git != ''
    return ' '.fugitive#head()
  else
    return ''
  endfunction

" Returns true if paste mode is enabled
function! HasPaste()
  if &paste
    exe 'hi! StatusLine guibg=#00875f'
    return 'PASTE MODE  '
  endif
  return ''
endfunction

" Determine the name of the session or terminal
if (strlen(v:servername)>0)
  if v:servername =~ 'nvim'
    let g:session = 'neovim'
  else
    " If running a GUI vim with servername, then use that
    let g:session = v:servername
  endif
elseif !has('gui_running')
  " If running CLI vim say TMUX or use the terminal name.
  if (exists("$TMUX"))
    let g:session = 'Tmux'
  else
    " Giving preference to color-term because that might be more
    " meaningful in graphical environments. Eg. my $TERM is
    " usually screen256-color 90% of the time.
    let g:session = exists("$COLORTERM") ? $COLORTERM : $TERM
  endif
else
  " idk, my bff jill
  let g:session = 'NARNIA'
endif

" Shamelessly stolen from statline plugin, shows buffer count and buffer number
function! BufCount()
  if !exists("s:statline_n_buffers")
    let s:statline_n_buffers = len(filter(range(1,bufnr('$')), 'buflisted(v:val)'))
  endif
  return s:statline_n_buffers
endfunction

if !exists('g:statline_show_n_buffers')
  let g:statline_show_n_buffers = 1
endif

" Always display the status line even if only one window is displayed
set laststatus=2
set statusline=
set statusline+=%{ChangeStatuslineColor()}               " Changing the statusline color
set statusline+=\ %{toupper(g:currentmode[mode()])} " Current mode
" ---- number of buffers : buffer number ----
if g:statline_show_n_buffers
  set statusline+=\ %{BufCount()}\:%n\ %< " only calculate buffers after adding/removing buffers
  augroup statline_nbuf
    autocmd!
    autocmd BufAdd,BufDelete * unlet! s:statline_n_buffers
  augroup END
else
  set statusline=[%n]\ %<
endif
" --------------------------------------------
set statusline+=\ %{HasPaste()}
set statusline+=\ %{g:session}
set statusline+=\ %{GitInfo()}
set statusline+=\ %<%.30F\ %w
set statusline+=%{ReadOnly()}\ 
set statusline+=%{exists('*CapsLockStatusline')?CapsLockStatusline():''}
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=\ %=                                     " Space
set statusline+=\ %{&ft}\ %q\   " FileType & quick fix or loclist given as variable with '&' so nice and lowercase
set statusline+=%{get(g:ff_map,&ff,'?').(&expandtab?'\ ˽\ ':'\ ⇥\ ').&tabstop} "Get method finds the fileformat array and returns the matching key the &ff or ? expand tab shows whether i'm using spaces or tabs
set statusline+=\ %-3(%{FileSize()}%)                 " File size
set statusline+=\ %3p%%\ \ %l\ of\ %1L\                 " The numbers after the % represent degrees of padding
set statusline+=%{ale#statusline#Status()}\ 
" =============================================================
"Truncated file path %<%t
" set statusline+=\CWD:\ %r%.35{getcwd(winnr)}%h\ 
" set statusline+=%2*\ %<%.30F\ %{ReadOnly()}\ %M\ %w\        " File+path .30 prefix is for the degree of truncation
" set statusline+=%7*\ %{(&fenc!=''?&fenc:&enc)}\ %{&ff}\ " Encoding & Fileformat, No current use for this info
" set statusline+=%{strlen(&fenc)?&fenc:&enc}\ %{(&ff==#'unix')?'':(&ff==#'dos')?'CRLF':&ff}
"==============================================================
"Need to figure this our in order to change statusline colors
if has('termguicolors')
  "filename
  hi default link User1 Identifier
  " flags
  hi default link User2 Statement
  " errors
  hi default link User3 Error
  " fugitive
  hi default link User4 Special
endif
  " hi User1 ctermbg=green ctermfg=red   guibg=green guifg=red
  " hi User2 ctermbg=red   ctermfg=blue  guibg=red   guifg=blue
  " hi User3 ctermbg=blue  ctermfg=green guibg=blue  guifg=green
  " hi User4 ctermfg=008 " guifg=fgcolor
  " hi User8 ctermfg=008 " guifg=fgcolor
  " hi User9 ctermfg=007 " guifg=fgcolor
  " hi User5 guifg=Blue guibg=White
  " hi User7 guibg=#005faf
"==============================================================}}}

"ALTERNATE STATUSLINE ==============================={{{
" Statusline (requires Powerline font, with highlight groups using Solarized theme)
" set statusline=
" set statusline+=%(%{'help'!=&filetype?bufnr('%'):''}\ \ %)
" set statusline+=%< " Where to truncate line
" set statusline+=%f " Path to the file in the buffer, as typed or relative to current directory
" set statusline+=%{&modified?'\ +':''}
" set statusline+=%{&readonly?'\ ':''}
" set statusline+=\ %1*%= " Separation point between left and right aligned items.
" set statusline+=\ %{''!=#&filetype?&filetype:'none'}
" set statusline+=%(\ %{(&bomb\|\|'^$\|utf-8'!~#&fileencoding?'\ '.&fileencoding.(&bomb?'-bom':''):'')
"   \.('unix'!=#&fileformat?'\ '.&fileformat:'')}%)
" set statusline+=%(\ \ %{&modifiable?(&expandtab?'et\ ':'noet\ ').&shiftwidth:''}%)
" set statusline+=\ %*\ %2v " Virtual column number.
" set statusline+=\ %3p%% " Percentage through file in lines as in |CTRL-G|
"====================================================}}}

"LIFEPILLAR'S STATUSLINE ============================{{{
" Logic for customizing the User1 highlight group is the following
" - fg = StatusLine fg (if StatusLine colors are reverse)
" - bg = StatusLineNC bg (if StatusLineNC colors are reverse)
hi StatusLine term=reverse cterm=reverse gui=reverse ctermfg=14 ctermbg=8 guifg=#93a1a1 guibg=#002b36
hi StatusLineNC term=reverse cterm=reverse gui=reverse ctermfg=11 ctermbg=0 guifg=#657b83 guibg=#073642
hi User1 ctermfg=14 ctermbg=0 guifg=#93a1a1 guibg=#073642
let g:mode_map = {
        \  'n': ['NORMAL',  'NormalMode' ],     'no': ['PENDING', 'NormalMode'  ],  'v': ['VISUAL',  'VisualMode' ],
        \  'V': ['V-LINE',  'VisualMode' ], "\<c-v>": ['V-BLOCK', 'VisualMode'  ],  's': ['SELECT',  'VisualMode' ],
        \  'S': ['S-LINE',  'VisualMode' ], "\<c-s>": ['S-BLOCK', 'VisualMode'  ],  'i': ['INSERT',  'InsertMode' ],
        \ 'ic': ['COMPLETE','InsertMode' ],     'ix': ['CTRL-X',  'InsertMode'  ],  'R': ['REPLACE', 'ReplaceMode'],
        \ 'Rc': ['COMPLETE','ReplaceMode'],     'Rv': ['REPLACE', 'ReplaceMode' ], 'Rx': ['CTRL-X',  'ReplaceMode'],
        \  'c': ['COMMAND', 'CommandMode'],     'cv': ['COMMAND', 'CommandMode' ], 'ce': ['COMMAND', 'CommandMode'],
        \  'r': ['PROMPT',  'CommandMode'],     'rm': ['-MORE-',  'CommandMode' ], 'r?': ['CONFIRM', 'CommandMode'],
        \  '!': ['SHELL',   'CommandMode'],      't': ['TERMINAL', 'CommandMode']}

  let g:ro_sym  = ''
  let g:ma_sym  = "✗"
  let g:mod_sym = "◇"
  let g:ff_map  = { "unix": "␊", "mac": "␍", "dos": "␍␊" }

  " newMode may be a value as returned by mode(1) or the name of a highlight group
  fun! s:updateStatusLineHighlight(newMode)
    execute 'hi! link CurrMode' get(g:mode_map, a:newMode, ["", a:newMode])[1]
    return 1
  endf

  " Setting highlight groups while computing the status line may cause the
  " startup screen to disappear. See: https://github.com/powerline/powerline/issues/250
  fun! SetupStl(nr)
    " In a %{} context, winnr() always refers to the window to which the status line being drawn belongs.
    return get(extend(w:, {
          \ "lf_active": winnr() != a:nr
            \ ? 0
            \ : (mode(1) ==# get(g:, "lf_cached_mode", "")
              \ ? 1
              \ : s:updateStatusLineHighlight(get(extend(g:, { "lf_cached_mode": mode(1) }), "lf_cached_mode"))
              \ ),
          \ "lf_winwd": winwidth(winnr())
          \ }), "", "")
  endf

" set statusline=%!BuildStatusLine(winnr())
" Build the status line the way I want - no fat light plugins!
fun! BuildStatusLine(nr)
  return '%{SetupStl('.a:nr.')}
        \%#CurrMode#%{w:["lf_active"] ? "  " . get(g:mode_map, mode(1), [mode(1)])[0] . (&paste ? " PASTE " : " ") : ""}%*
        \ %n %t %{&modified ? g:mod_sym : " "} %{&modifiable ? (&readonly ? g:ro_sym : "  ") : g:ma_sym}
        \ %<%{w:["lf_winwd"] < 80 ? (w:["lf_winwd"] < 50 ? "" : expand("%:p:h:t")) : expand("%:p:h")}
        \ %=
        \ %w %{&ft} %{w:["lf_winwd"] < 80 ? "" : " " . (strlen(&fenc) ? &fenc : &enc) . (&bomb ? ",BOM " : " ")
        \ . get(g:ff_map, &ff, "?") . (&expandtab ? " ˽ " : " ⇥ ") . &tabstop}
        \ %#CurrMode#%{w:["lf_active"] ? (w:["lf_winwd"] < 60 ? ""
        \ : printf(" %d:%-2d %2d%% ", line("."), virtcol("."), 100 * line(".") / line("$"))) : ""}
        \%#Warnings#%{w:["lf_active"] ? get(b:, "lf_stl_warnings", "") : ""}%*'
endf
" ========================================================= {{{{


" =========================================================
" MyTabLine {{{
" =========================================================
" This is an attempt to emulate the default Vim-7 tabs as closely as possible but with numbered tabs.- Not currently in use

if exists("+showtabline")
set showtabline=1
  function! MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
      " set up some oft-used variables
      let tab = i + 1 " range() starts at 0
      let winnr = tabpagewinnr(tab) " gets current window of current tab
      let buflist = tabpagebuflist(tab) " list of buffers associated with the windows in the current tab
      let bufnr = buflist[winnr - 1] " current buffer number
      let bufname = bufname(bufnr) " gets the name of the current buffer in the current window of the current tab

      let s .= '%' . tab . 'T' " start a tab
      let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#') " if this tab is the current tab...set the right highlighting
      let s .= ' ' . tab " current tab number
      let n = tabpagewinnr(tab,'$') " get the number of windows in the current tab
      if n > 1
        let s .= ':' . n " if there's more than one, add a colon and display the count
      endif
      let bufmodified = getbufvar(bufnr, "&mod")
      if bufmodified
        let s .= ' +'
      endif
      if bufname != ''
        let s .= ' ' . pathshorten(bufname) . ' ' " outputs the one-letter-path shorthand & filename
      else
        let s .= ' [No Name] '
      endif
    endfor
    let s .= '%#TabLineFill#' " blank highlighting between the tabs and the righthand close 'X'
    let s .= '%T' " resets tab page number?
    let s .= '%=' " seperate left-aligned from right-aligned
    let s .= '%#TabLine#' " set highlight for the 'X' below
    let s .= '%999XX' " places an 'X' at the far-right
    return s
  endfunction
  " set tabline=%!MyTabLine()
endif

  fun! BuildTabLabel(nr)
    return " " . a:nr
          \ . (empty(filter(tabpagebuflist(a:nr), 'getbufvar(v:val, "&modified")')) ? " " : " " . g:mod_sym . " ")
          \ . (get(extend(t:, {
          \ "tablabel": fnamemodify(bufname(tabpagebuflist(a:nr)[tabpagewinnr(a:nr) - 1]), ":t")
          \ }), "tablabel") == "" ? "[No Name]" : get(t:, "tablabel")) . "  "
  endf

  fun! BuildTabLine()
    return join(map(
          \ range(1, tabpagenr('$')),
          \ '(v:val == tabpagenr() ? "%#TabLineSel#" : "%#TabLine#") . "%".v:val."T %{BuildTabLabel(".v:val.")}"'
          \), '') . "%#TabLineFill#%T" . (tabpagenr('$') > 1 ? "%=%999X✕ " : "")
  endf

  set tabline=%!BuildTabLine()
  set showtabline=2
"===============================================================================================}}}
