local autocommands = require("as.autocommands")
local map = as_utils.map
local buf_map = as_utils.buf_map
local fn = vim.fn
local api = vim.api
local cmd = as_utils.cmd
--- work around to place functions in the global scope but
--- namespaced within a table.
--- TODO refactor this once nvim allows passing lua functions to mappings
_G._mappings = {}
-----------------------------------------------------------------------------//
-- Terminal {{{
------------------------------------------------------------------------------//
function _G._mappings.add_terminal_mappings()
  if vim.bo.filetype == "" or vim.bo.filetype == "toggleterm" then
    local opts = {silent = false, noremap = true}
    buf_map(0, "t", "<esc>", [[<C-\><C-n>]], opts)
    buf_map(0, "t", "jk", [[<C-\><C-n>]], opts)
    buf_map(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
    buf_map(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
    buf_map(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
    buf_map(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
    buf_map(0, "t", "]t", [[<C-\><C-n>:tablast<CR>]])
    buf_map(0, "t", "[t", [[<C-\><C-n>:tabnext<CR>]])
    buf_map(0, "t", "<S-Tab>", [[<C-\><C-n>:bprev<CR>]])
    buf_map(0, "t", "<leader><Tab>", [[<C-\><C-n>:close \| :bnext<cr>]])
  end
end

map("n", "<localleader>gl", [[<cmd>GitPull<CR>]])
map("n", "<localleader>gp", [[<cmd>GitPush<CR>]])
map("n", "<localleader>gpf", [[<cmd>GitPushF<CR>]])
map("n", "<localleader>gpt", [[<cmd>TermGitPush<CR>]])

autocommands.create(
  {
    AddTerminalMappings = {
      {"TermEnter,BufEnter", "term://*", "lua _mappings.add_terminal_mappings()"}
    }
  }
)
--}}}
-----------------------------------------------------------------------------//
-- MACROS {{{
-----------------------------------------------------------------------------//
-- Absolutely fantastic function from stoeffel/.dotfiles which allows you to
-- repeat macros across a visual range
------------------------------------------------------------------------------
function _G._mappings.execute_macro_over_visual_range()
  vim.cmd [[echo "@".getcmdline()]]
  vim.cmd [[":'<,'>normal @".nr2char(getchar())]]
end

map("x", "@", "<cmd>lua _mappings.execute_macro_over_visual_range()<CR>")
--}}}
------------------------------------------------------------------------------
-- Credit: JGunn Choi ?il | inner line
------------------------------------------------------------------------------
-- includes newline
map("x", "al", "$o0")
map("o", "al", "<cmd>normal val<CR>")
--No Spaces or CR
map("x", "il", [[<Esc>^vg_]])
map("o", "il", [[<cmd>normal! ^vg_<CR>]])
-----------------------------------------------------------------------------//
-- Add Empty space above and below
-----------------------------------------------------------------------------//
map("n", "[<space>", [[<cmd>put! =repeat(nr2char(10), v:count1)<cr>'[]])
map("n", "]<space>", [[<cmd>put =repeat(nr2char(10), v:count1)<cr>]])
-----------------------------------------------------------------------------//
-- Paste in visual mode multiple times
map("x", "p", "pgvy")
-- It pastes, visually selects pasted text and then re-indents it.
-- In most cases it works quite well.
map("n", "p", [[p`[v`]=]])
-- search visual selection
map("v", "//", [[y/<C-R>"<CR>]])

-- Credit: Justinmk
map("n", "g>", [[<cmd>set nomore<bar>40messages<bar>set more<CR>]])

-- Enter key should repeat the last macro recorded or just act as enter
map("n", "<leader><CR>", [[empty(&buftype) ? '@@' : '<CR>']], {expr = true})

-- Evaluates whether there is a fold on the current line if so unfold it else return a normal space
map("n", "<space>", [[@=(foldlevel('.')?'za':"\<Space>")<CR>]])
-- Refocus folds
map("n", "<localleader>z", [[zMzvzz]])
-- Make zO recursively open whatever top level fold we're in, no matter where the
-- cursor happens to be.
map("n", "zO", [[zCzO]])
-----------------------------------------------------------------------------//
-- Delimiters
-----------------------------------------------------------------------------//
-- Conditionally modify character at end of line
map("n", "<localleader>,", "<cmd>call utils#modify_line_end_delimiter(',')<cr>")
map("n", "<localleader>;", "<cmd>call utils#modify_line_end_delimiter(';')<cr>")

map("n", "<leader>E", "<cmd>Token<cr>")

map("n", "<ScrollWheelDown>", "<c-d>", {silent = true, noremap = false})
map("n", "<ScrollWheelUp>", "<c-u>", {silent = true, noremap = false})
------------------------------------------------------------------------------
-- Buffers
------------------------------------------------------------------------------
map("n", "<leader>on", [[<cmd>w <bar> %bd <bar> e#<CR>]])
-- Use wildmenu to cycle tabs
map("n", "<localleader><tab>", [[:b <C-Z>]], {silent = false})
-- Switch between the last two files
map("n", "<leader><leader>", [[<c-^>]])
-----------------------------------------------------------------------------//
-- Capitalize
-----------------------------------------------------------------------------//
map("n", "<leader>U", "<cmd>gUiw`]<CR>")
map("i", "<C-u>", "<cmd>gUiw`]a<CR>")
------------------------------------------------------------------------------
-- Moving lines/visual block
------------------------------------------------------------------------------
-- source: https://www.reddit.com/r/vim/comments/i8b5z1/is_there_a_more_elegant_way_to_move_lines_than_eg/
if fn.has("mac") > 0 then
  -- Allow using alt in macOS without enabling “Use Option as Meta key”
  map("n", "¬", "<a-l>", {noremap = false})
  map("n", "˙", "<a-h>", {noremap = false})
  map("n", "∆", "<a-j>", {noremap = false})
  map("n", "˚", "<a-k>", {noremap = false})
  map("n", "∆", "<cmd>move+<CR>==")
  map("n", "˚", "<cmd>move-2<CR>==")
  map("x", "˚", ":move-2<CR>='[gv")
  map("x", "∆", ":move'>+<CR>='[gv")
else
  map("n", "<a-k>", "<cmd>move-2<CR>==")
  map("n", "<a-j>", "<cmd>move+<CR>==")
  map("x", "<a-k>", ":move-2<CR>='[gv")
  map("x", "<a-j>", ":move'>+<CR>='[gv")
end
----------------------------------------------------------------------------------
-- Windows
----------------------------------------------------------------------------------
-- Change two horizontally split windows to vertical splits
map("n", "<localleader>wh", "<C-W>t <C-W>K")
-- Change two vertically split windows to horizontal splits
map("n", "<localleader>wv", "<C-W>t <C-W>H")
-- equivalent to gf but opens the window in a vertical split
-- vim doesn't have a native mapping for this as <C-w>f normally
-- opens a horizontal split
map("n", "<C-w>f", "<C-w>vgf")
-- find visually selected text
map("v", "*", [[y/<C-R>"<CR>]])
-- make . work with visually selected lines
map("v", ".", ":norm.<CR>")
-- Switch from visual to visual block.
map("x", "r", [[:call utils#message('Use <Ctrl-V> instead')<CR>]], {silent = false})
----------------------------------------------------------------------------------
-- Operators
----------------------------------------------------------------------------------
-- Yank from the cursor to the end of the line, to be consistent with C and D.
map("n", "Y", "y$")
-----------------------------------------------------------------------------//
-- Quick find/replace
-----------------------------------------------------------------------------//
map("n", "<leader>[", [[:%s/\<<C-r>=expand("<cword>")<CR>\>/]])
map("n", "<leader>]", [[:s/\<<C-r>=expand("<cword>")<CR>\>/]])
map("v", "<leader>[", [["zy:%s/<C-r><C-o>"/]])
-- Visual shifting (does not exit Visual mode)
map("v", "<", "<gv")
map("v", ">", ">gv")
--Remap back tick for jumping to marks more quickly back
map("n", "'", "`")
-----------------------------------------------------------------------------//
--open a new file in the same directory
map("n", "<Leader>nf", [[:e <C-R>=expand("%:p:h") . "/" <CR>]], {silent = false})
--open a new file in the same directory
map("n", "<Leader>ns", [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], {silent = false})
--Open command line window - :<c-f>
map(
  "n",
  "<localleader>l",
  [[<cmd>nohlsearch<cr><cmd>diffupdate<cr><cmd>syntax sync fromstart<cr><c-l>]]
)
-----------------------------------------------------------------------------//
-- Window bindings
-----------------------------------------------------------------------------//
-- https://vim.fandom.com/wiki/Fast_window_resizing_with_plus/minus_keys
if fn.bufwinnr(1) then
  map("n", "<a-h>", "<C-W><")
  map("n", "<a-l>", "<C-W>>")
end
-----------------------------------------------------------------------------//
-- Open Common files
-----------------------------------------------------------------------------//
map("n", "<leader>ez", ":e ~/.zshrc<cr>")
map("n", "<leader>et", ":e ~/.tmux.conf<cr>")
-----------------------------------------------------------------------------//
-- Arrows
-----------------------------------------------------------------------------//
map("n", "<down>", "<nop>")
map("n", "<up>", "<nop>")
map("n", "<left>", "<nop>")
map("n", "<right>", "<nop>")
map("i", "<up>", "<nop>")
map("i", "<down>", "<nop>")
map("i", "<left>", "<nop>")
map("i", "<right>", "<nop>")
-- Repeat last substitute with flags
map("n", "&", "<cmd>&&<CR>")
map("x", "&", "<cmd>&&<CR>")
----------------------------------------------------------------------------------
-- Commandline mappings
----------------------------------------------------------------------------------
-- https://github.com/tpope/vim-rsi/blob/master/plugin/rsi.vim
-- c-a / c-e everywhere - RSI.vim provides these
map("c", "<C-n>", "<Down>")
map("c", "<C-p>", "<Up>")
-- <C-A> allows you to insert all matches on the command line e.g. bd *.js <c-a>
-- will insert all matching files e.g. :bd a.js b.js c.js
map("c", "<c-x><c-a>", "<c-a>")
map("c", "<C-a>", "<Home>")
map("c", "<C-e>", "<End>")
map("c", "<C-b>", "<Left>")
map("c", "<C-d>", "<Del>")
map("c", "<C-k>", [[<C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos() - 2]<CR>]])
-- move cursor one character backwards unless at the end of the command line
map("c", "<C-f>", [[getcmdpos() > strlen(getcmdline())? &cedit: "\<Lt>Right>"]], {expr = true})
-- see :h cmdline-editing
map("c", "<Esc>b", [[<S-Left>]])
map("c", "<Esc>f", [[<S-Right>]])
-- Insert escaped '/' while inputting a search pattern
map("c", "/", [[getcmdtype() == "/" ? "\/" : "/"]], {expr = true})
-----------------------------------------------------------------------------//
-- Save
map("n", "<c-s>", "<cmd>w<cr>")
-- Write and quit all files
map("n", "qa", [[<cmd>call utils#message('Use ZZ instead')<CR>]])
------------------------------------------------------------------------------
-- Quickfix
------------------------------------------------------------------------------
map("n", "]q", "<cmd>cnext<CR>zz")
map("n", "[q", "<cmd>cprev<CR>zz")
map("n", "]l", "<cmd>lnext<cr>zz")
map("n", "[l", "<cmd>lprev<cr>zz")
------------------------------------------------------------------------------
-- Tab navigation
------------------------------------------------------------------------------
map("n", "<leader>tn", "<cmd>tabedit %<CR>")
map("n", "<leader>tc", "<cmd>tabclose<CR>")
map("n", "<leader>to", "<cmd>tabonly<cr>")
map("n", "<leader>tm", "<cmd>tabmove<Space>")
map("n", "]t", "<cmd>tabprev<CR>")
map("n", "[t", "<cmd>tabnext<CR>")
-------------------------------------------------------------------------------
-- ?ie | entire object
-------------------------------------------------------------------------------
map("x", "ie", [[gg0oG$]])
map("o", "ie", [[<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>]])
----------------------------------------------------------------------------//
-- Core navigation
----------------------------------------------------------------------------//
-- Store relative line number jumps in the jumplist.
map("n", "j", [[(v:count > 1 ? 'm`' . v:count : '') . 'gj']], {expr = true, silent = true})
map("n", "k", [[(v:count > 1 ? 'm`' . v:count : '') . 'gk']], {expr = true, silent = true})
-- Zero should go to the first non-blank character not to the first column (which could be blank)
map("n", "0", "^")
-- when going to the end of the line in visual mode ignore whitespace characters
map("v", "$", "g_")
-- jk is escape, THEN move to the right to preserve the cursor position, unless
-- at the first column.  <esc> will continue to work the default way.
-- NOTE: this is a recursive mapping so anything bound (by a plugin) to <esc> still works
map("i", "jk", [[col('.') == 1 ? '<esc>' : '<esc>l']], {expr = true, noremap = false})
map("x", "jk", [[<ESC>]])
-- Toggle top/center/bottom
map(
  "n",
  "zz",
  [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']],
  {expr = true}
)

-- This line opens the vimrc in a vertical split
map("n", "<leader>ev", [[:vsplit $MYVIMRC<cr>]])

-- This line allows the current file to source the vimrc allowing me use bindings as they're added
map("n", "<leader>sv", [[:luafile $MYVIMRC<cr> <bar> :call utils#message('Sourced init.vim')<cr>]])
-----------------------------------------------------------------------------//
-- Quotes
-----------------------------------------------------------------------------//
map("n", [[<leader>"]], [[ciw"<c-r>""<esc>]])
map("n", "<leader>`", [[ciw`<c-r>"`<esc>]])
map("n", "<leader>'", [[ciw'<c-r>"'<esc>]])
map("n", "<leader>)", [[ciw(<c-r>")<esc>]])
map("n", "<leader>}", [[ciw{<c-r>"}<esc>]])

-- Map Q to replay q register
map("n", "Q", "@q")

if not plugin_loaded("conflict-marker.vim") then
  -- Shortcut to jump to next conflict marker"
  map("n", "]x", [[/^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>]])
  -- Shortcut to jump to last conflict marker"
  map("n", "[x", [[?^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>]])
end

-- Zoom / Restore window. - Zooms by increasing window width squashing the other window
-- z is the zoom/zen prefix
map("n", "<leader>zt", [[:call utils#tab_zoom()<CR>]])
-----------------------------------------------------------------------------//
-- Multiple Cursor Replacement
-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
-----------------------------------------------------------------------------//
map("n", "cn", "*``cgn")
map("n", "cN", "*``cgN")

-- 1. Position the cursor over a word; alternatively, make a selection.
-- 2. Hit cq to start recording the macro.
-- 3. Once you are done with the macro, go back to normal mode.
-- 4. Hit Enter to repeat the macro over search matches.
function _G._mappings.setup_CR()
  map(
    "n",
    "<Enter>",
    [[:nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z]]
  )
end

-- NOTE: this line is done as a vim command as handling the string in lua breaks
vim.cmd [[let g:mc = "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>""]]
map("v", "cn", [[g:mc . "``cgn"]], {expr = true, silent = true})
map("v", "cN", [[g:mc . "``cgN"]], {expr = true, silent = true})
map("n", "cq", [[:lua _mappings.setup_CR()<CR>*``qz]])
map("n", "cQ", [[:lua _mappings.setup_CR()<CR>#``qz]])
map("v", "cq", [[":\<C-u>lua _mappings.setup_CR()\<CR>" . "gv" . g:mc . "``qz"]], {expr = true})
map(
  "v",
  "cQ",
  [[":\<C-u>lua _mappings.setup_CR()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz"]],
  {expr = true}
)

map("n", "gf", "<cmd>lua _mappings.open_file_or_create_new()<CR>")
-- if the file under the cursor doesn't exist create it
-- see :h gf a simpler solution of :edit <cfile> is recommended but doesn't work.
-- If you select require('buffers/file') in lua for example
-- this makes the cfile -> buffers/file rather than my_dir/buffer/file.lua
-- https://www.reddit.com/r/vim/comments/i2x8xc/i_want_gf_to_create_files_if_they_dont_exist/
-- https://github.com/kristijanhusak/neovim-config/blob/5474d932386c3724d2ce02a5963528fe5d5e1015/nvim/lua/partials/mappings.lua#L154
function _G._mappings.open_file_or_create_new()
  local path = fn.expand("<cfile>")
  if not path or path == "" then
    return false
  end

  -- TODO handle terminal buffers

  if pcall(vim.cmd, "norm!gf") then
    return true
  end

  fn.nvim_out_write("Creating new file.\n")
  local new_path = fn.fnamemodify(fn.expand("%:p:h") .. "/" .. path, ":p")
  local ext = fn.fnamemodify(new_path, ":e")

  if ext and ext ~= "" then
    return vim.cmd("edit " .. new_path)
  end

  local suffixes = fn.split(vim.bo.suffixesadd, ",")

  for _, suffix in ipairs(suffixes) do
    if fn.filereadable(new_path .. suffix) then
      return vim.cmd("edit " .. new_path .. suffix)
    end
  end

  return vim.cmd("edit " .. new_path .. suffixes[1])
end
-----------------------------------------------------------------------------//
-- Command mode related
-----------------------------------------------------------------------------//
-- smooth searching, allow tabbing between search results similar to using <c-g>
-- or <c-t> the main difference being tab is easier to hit and remapping those keys
-- to these would swallow up a tab mapping
map(
  "c",
  "<Tab>",
  [[getcmdtype() == "/" || getcmdtype() == "?" ? "<CR>/<C-r>/" : "<C-z>"]],
  {expr = true}
)
map(
  "c",
  "<S-Tab>",
  [[getcmdtype() == "/" || getcmdtype() == "?" ? "<CR>?<C-r>/" : "<S-Tab>"]],
  {expr = true}
)
-- Smart mappings on the command line
map("c", "w!!", [[w !sudo tee % >/dev/null]])
-- insert path of current file into a command
map("c", "%%", "<C-r>=fnameescape(expand('%'))<cr>")
map("c", "::", "<C-r>=fnameescape(expand('%:p:h'))<cr>/")
------------------------------------------------------------------------------
-- Credit: June Gunn <Leader>?/! | Google it / Feeling lucky
------------------------------------------------------------------------------
function _G._mappings.google(pat, lucky)
  local query = '"' .. fn.substitute(pat, '["\n]', " ", "g") .. '"'
  query = fn.substitute(query, "[[:punct:] ]", [[\=printf("%%%02X", char2nr(submatch(0)))]], "g")
  fn.system(
    fn.printf(
      vim.g.open_command .. ' "https://www.google.com/search?%sq=%s"',
      lucky and "btnI&" or "",
      query
    )
  )
end

map("n", "<localleader>?", [[:lua _mappings.google(vim.fn.expand("<cWORD>"), false)<cr>]])
map("n", "<localleader>!", [[:lua _mappings.google(vim.fn.expand("<cWORD>"), true)<cr>]])
map("x", "<localleader>?", [["gy:lua _mappings.google(vim.api.nvim_eval("@g"), false)<cr>gv]])
map("x", "<localleader>!", [["gy:lua _mappings.google(vim.api.nvim_eval("@g"), false, true)<cr>gv]])
----------------------------------------------------------------------------------
-- Grep Operator
----------------------------------------------------------------------------------
api.nvim_exec(
  [[
  function! GrepOperator(type)
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
  ]],
  ""
)

-- http://travisjeffery.com/b/2011/10/m-x-occur-for-vim/
map("n", "<leader>g", [[:silent! set operatorfunc=GrepOperator<cr>g@]])
map("v", "<leader>g", [[:call GrepOperator(visualmode())<cr>]])
map("n", "<localleader>g*", [[:Ggrep --untracked <cword><CR>]])

-----------------------------------------------------------------------------//
-- GX - replicate netrw functionality
-----------------------------------------------------------------------------//
function _G._mappings.open_link()
  local file = fn.expand("<cfile>")
  if fn.isdirectory(file) > 0 then
    vim.cmd("edit " .. file)
  else
    fn.jobstart({vim.g.open_command, file}, {detach = true})
  end
end
map("n", "gx", [[<cmd>lua _mappings.open_link()<CR>]])
---------------------------------------------------------------------------------
-- Toggle list
---------------------------------------------------------------------------------
function _mappings.toggle_list(prefix)
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    local location_list = fn.getloclist(0, {filewinid = 0})
    local is_loc_list = location_list.filewinid > 0
    if vim.bo[buf].filetype == "qf" or is_loc_list then
      fn.execute(prefix .. "close")
      return
    end
  end
  if prefix == "l" and vim.tbl_isempty(fn.getloclist(0)) then
    fn["utils#message"]("Location List is Empty.", "Title")
    return
  end

  local winnr = fn.winnr()
  fn.execute(prefix .. "open")
  if fn.winnr() ~= winnr then
    vim.cmd [[wincmd p]]
  end
end

map("n", "<leader>ls", [[<cmd>lua _mappings.toggle_list('c')<CR>]])
map("n", "<leader>li", [[<cmd>lua _mappings.toggle_list('l')<CR>]])
-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
function _G._mappings.toggle_bg()
  vim.o.background = vim.o.background == "dark" and "light" or "dark"
end

cmd("ToggleBackground", [[lua _mappings.toggle_bg()]])
------------------------------------------------------------------------------
-- Profile
------------------------------------------------------------------------------
function _G._mappings.vim_profile(bang)
  if bang then
    vim.cmd [[profile pause]]
    vim.cmd [[noautocmd qall]]
  else
    vim.cmd [[profile start /tmp/profile.log]]
    vim.cmd [[profile func *]]
    vim.cmd [[profile file *]]
  end
end
cmd("Profile", "call s:profile(<bang>0)", {"-bang"})
------------------------------------------------------------------------------
cmd("Token", [[call utils#token_inspect()]], {"-nargs=0"}) -- FIXME this doesn't work with tree sitter
cmd("Todo", [[noautocmd silent! grep! 'TODO\|FIXME' | copen]])
cmd("ReloadModule", [[lua require('plenary.reload').reload_module(<q-args>)]], {"-nargs=1"})
cmd("TabMessage", [[call utils#tab_message(<q-args>)]], {"-nargs=+", "-complete=command"})
-- source https://superuser.com/a/540519
-- write the visual selection to the filename passed in as a command argument then delete the
-- selection placing into the black hole register
cmd(
  "MoveWrite",
  [[<line1>,<line2>write<bang> <args> | <line1>,<line2>delete _]],
  {"-bang", "-range", "-nargs=1", "-complete=file"}
)
cmd(
  "MoveAppend",
  [[<line1>,<line2>write<bang> >> <args> | <line1>,<line2>delete _]],
  {"-bang", "-range", "-nargs=1", "-complete=file"}
)
cmd("AutoResize", [[call utils#auto_resize(<args>)]], {"-nargs=?"})
