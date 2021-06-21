local has = as.has
local fn = vim.fn
local api = vim.api
local command = as.command

local nmap = as.nmap
local imap = as.imap
local nnoremap = as.nnoremap
local xnoremap = as.xnoremap
local vnoremap = as.vnoremap
local inoremap = as.inoremap
local onoremap = as.onoremap
local cnoremap = as.cnoremap
local tnoremap = as.tnoremap

--- work around to place functions in the global scope but
--- namespaced within a table.
--- TODO refactor this once nvim allows passing lua functions to mappings
_G._mappings = {}
-----------------------------------------------------------------------------//
-- Terminal {{{
------------------------------------------------------------------------------//
as.augroup("AddTerminalMappings", {
  {
    events = { "TermOpen" },
    targets = { "term://*" },
    command = function()
      if vim.bo.filetype == "" or vim.bo.filetype == "toggleterm" then
        local opts = { silent = false, buffer = 0 }
        tnoremap("<esc>", [[<C-\><C-n>]], opts)
        tnoremap("jk", [[<C-\><C-n>]], opts)
        tnoremap("<C-h>", [[<C-\><C-n><C-W>h]], opts)
        tnoremap("<C-j>", [[<C-\><C-n><C-W>j]], opts)
        tnoremap("<C-k>", [[<C-\><C-n><C-W>k]], opts)
        tnoremap("<C-l>", [[<C-\><C-n><C-W>l]], opts)
        tnoremap("]t", [[<C-\><C-n>:tablast<CR>]])
        tnoremap("[t", [[<C-\><C-n>:tabnext<CR>]])
        tnoremap("<S-Tab>", [[<C-\><C-n>:bprev<CR>]])
        tnoremap("<leader><Tab>", [[<C-\><C-n>:close \| :bnext<cr>]])
      end
    end,
  },
})
--}}}
-----------------------------------------------------------------------------//
-- MACROS {{{
-----------------------------------------------------------------------------//
-- Absolutely fantastic function from stoeffel/.dotfiles which allows you to
-- repeat macros across a visual range
------------------------------------------------------------------------------
local function execute_macro_over_visual_range()
  vim.cmd [[echo "@".getcmdline()]]
  vim.cmd [[":'<,'>normal @".nr2char(getchar())]]
end

xnoremap("@", execute_macro_over_visual_range)
--}}}
------------------------------------------------------------------------------
-- Credit: JGunn Choi ?il | inner line
------------------------------------------------------------------------------
-- includes newline
xnoremap("al", "$o0")
onoremap("al", "<cmd>normal val<CR>")
--No Spaces or CR
xnoremap("il", [[<Esc>^vg_]])
onoremap("il", [[<cmd>normal! ^vg_<CR>]])
-----------------------------------------------------------------------------//
-- Add Empty space above and below
-----------------------------------------------------------------------------//
nnoremap("[<space>", [[<cmd>put! =repeat(nr2char(10), v:count1)<cr>'[]])
nnoremap("]<space>", [[<cmd>put =repeat(nr2char(10), v:count1)<cr>]])
-----------------------------------------------------------------------------//
-- Paste in visual mode multiple times
xnoremap("p", "pgvy")
-- search visual selection
vnoremap("//", [[y/<C-R>"<CR>]])

-- Credit: Justinmk
nnoremap("g>", [[<cmd>set nomore<bar>40messages<bar>set more<CR>]])

-- Enter key should repeat the last macro recorded or just act as enter
nnoremap("<leader><CR>", [[empty(&buftype) ? '@@' : '<CR>']], { expr = true })

-- Evaluates whether there is a fold on the current line if so unfold it else return a normal space
nnoremap("<space><space>", [[@=(foldlevel('.')?'za':"\<Space>")<CR>]])
-- Refocus folds
nnoremap("<localleader>z", [[zMzvzz]])
-- Make zO recursively open whatever top level fold we're in, no matter where the
-- cursor happens to be.
nnoremap("zO", [[zCzO]])
-----------------------------------------------------------------------------//
-- Delimiters
-----------------------------------------------------------------------------//
-- Conditionally modify character at end of line
nnoremap("<localleader>,", "<cmd>call utils#modify_line_end_delimiter(',')<cr>")
nnoremap("<localleader>;", "<cmd>call utils#modify_line_end_delimiter(';')<cr>")

nmap("<ScrollWheelDown>", "<c-d>")
nmap("<ScrollWheelUp>", "<c-u>")
------------------------------------------------------------------------------
-- Buffers
------------------------------------------------------------------------------
nnoremap("<leader>on", [[<cmd>w <bar> %bd <bar> e#<CR>]])
-- Use wildmenu to cycle tabs
nnoremap("<localleader><tab>", [[:b <C-Z>]], { silent = false })
-- Switch between the last two files
nnoremap("<leader><leader>", [[<c-^>]])
-----------------------------------------------------------------------------//
-- Capitalize
-----------------------------------------------------------------------------//
nnoremap("<leader>U", "gUiw`]")
inoremap("<C-u>", "<cmd>norm!gUiw`]a<CR>")
------------------------------------------------------------------------------
-- Moving lines/visual block
------------------------------------------------------------------------------
-- source: https://www.reddit.com/r/vim/comments/i8b5z1/is_there_a_more_elegant_way_to_move_lines_than_eg/
if has "mac" then
  -- Allow using alt in macOS without enabling “Use Option as Meta key”
  nmap("¬", "<a-l>")
  nmap("˙", "<a-h>")
  nmap("∆", "<a-j>")
  nmap("˚", "<a-k>")
  nnoremap("∆", "<cmd>move+<CR>==")
  nnoremap("˚", "<cmd>move-2<CR>==")
  xnoremap("˚", ":move-2<CR>='[gv")
  xnoremap("∆", ":move'>+<CR>='[gv")
else
  nnoremap("<a-k>", "<cmd>move-2<CR>==")
  nnoremap("<a-j>", "<cmd>move+<CR>==")
  xnoremap("<a-k>", ":move-2<CR>='[gv")
  xnoremap("<a-j>", ":move'>+<CR>='[gv")
end
----------------------------------------------------------------------------------
-- Windows
----------------------------------------------------------------------------------
-- Change two horizontally split windows to vertical splits
nnoremap("<localleader>wh", "<C-W>t <C-W>K")
-- Change two vertically split windows to horizontal splits
nnoremap("<localleader>wv", "<C-W>t <C-W>H")
-- equivalent to gf but opens the window in a vertical split
-- vim doesn't have a native mapping for this as <C-w>f normally
-- opens a horizontal split
nnoremap("<C-w>f", "<C-w>vgf")
-- find visually selected text
vnoremap("*", [[y/<C-R>"<CR>]])
-- make . work with visually selected lines
vnoremap(".", ":norm.<CR>")
-- Switch from visual to visual block.
xnoremap("r", [[:call utils#message('Use <Ctrl-V> instead')<CR>]], { silent = false })
-- https://www.reddit.com/r/neovim/comments/l8vyl8/a_plugin_to_improve_the_deletion_of_buffers/
-- alternatives: https://www.reddit.com/r/vim/comments/8drccb/vimsayonara_or_vimbbye
local function buf_kill()
  local buflisted = fn.getbufinfo { buflisted = 1 }
  local cur_winid, cur_bufnr = api.nvim_get_current_win(), api.nvim_get_current_buf()
  if #buflisted < 2 then
    vim.cmd "confirm qall"
    return
  end
  for _, winid in ipairs(fn.getbufinfo(cur_bufnr)[1].windows) do
    api.nvim_set_current_win(winid)
    vim.cmd(cur_bufnr == buflisted[#buflisted].bufnr and "bp" or "bn")
  end
  api.nvim_set_current_win(cur_winid)
  if not api.nvim_buf_is_valid(cur_bufnr) then
    return
  end
  local is_terminal = vim.bo[cur_bufnr].buftype == "terminal"
  api.nvim_buf_delete(cur_bufnr, { force = is_terminal })
end
nnoremap("<leader>qq", buf_kill)
nnoremap("<leader>qw", "<cmd>bd!<CR>")
----------------------------------------------------------------------------------
-- Operators
----------------------------------------------------------------------------------
-- Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap("Y", "y$")
-----------------------------------------------------------------------------//
-- Quick find/replace
-----------------------------------------------------------------------------//
local noisy = { silent = false }
nnoremap("<leader>[", [[:%s/\<<C-r>=expand("<cword>")<CR>\>/]], noisy)
nnoremap("<leader>]", [[:s/\<<C-r>=expand("<cword>")<CR>\>/]], noisy)
vnoremap("<leader>[", [["zy:%s/<C-r><C-o>"/]], noisy)
-- Visual shifting (does not exit Visual mode)
vnoremap("<", "<gv")
vnoremap(">", ">gv")
--Remap back tick for jumping to marks more quickly back
nnoremap("'", "`")
-----------------------------------------------------------------------------//
--open a new file in the same directory
nnoremap("<leader>nf", [[:e <C-R>=expand("%:p:h") . "/" <CR>]], { silent = false })
--open a new file in the same directory
nnoremap("<leader>ns", [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], { silent = false })
--Open command line window - :<c-f>
nnoremap(
  "<localleader>l",
  [[<cmd>nohlsearch<cr><cmd>diffupdate<cr><cmd>syntax sync fromstart<cr><c-l>]]
)
-----------------------------------------------------------------------------//
-- Window bindings
-----------------------------------------------------------------------------//
-- https://vim.fandom.com/wiki/Fast_window_resizing_with_plus/minus_keys
if fn.bufwinnr(1) then
  nnoremap("<a-h>", "<C-W><")
  nnoremap("<a-l>", "<C-W>>")
end
-----------------------------------------------------------------------------//
-- Open Common files
-----------------------------------------------------------------------------//
nnoremap("<leader>ez", ":e ~/.zshrc<cr>")
nnoremap("<leader>et", ":e ~/.tmux.conf<cr>")
-----------------------------------------------------------------------------//
-- Arrows
-----------------------------------------------------------------------------//
nnoremap("<down>", "<nop>")
nnoremap("<up>", "<nop>")
nnoremap("<left>", "<nop>")
nnoremap("<right>", "<nop>")
inoremap("<up>", "<nop>")
inoremap("<down>", "<nop>")
inoremap("<left>", "<nop>")
inoremap("<right>", "<nop>")
-- Repeat last substitute with flags
nnoremap("&", "<cmd>&&<CR>")
xnoremap("&", "<cmd>&&<CR>")
----------------------------------------------------------------------------------
-- Commandline mappings
----------------------------------------------------------------------------------
-- https://github.com/tpope/vim-rsi/blob/master/plugin/rsi.vim
-- c-a / c-e everywhere - RSI.vim provides these
cnoremap("<C-n>", "<Down>")
cnoremap("<C-p>", "<Up>")
-- <C-A> allows you to insert all matches on the command line e.g. bd *.js <c-a>
-- will insert all matching files e.g. :bd a.js b.js c.js
cnoremap("<c-x><c-a>", "<c-a>")
cnoremap("<C-a>", "<Home>")
cnoremap("<C-e>", "<End>")
cnoremap("<C-b>", "<Left>")
cnoremap("<C-d>", "<Del>")
cnoremap("<C-k>", [[<C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos() - 2]<CR>]])
-- move cursor one character backwards unless at the end of the command line
cnoremap("<C-f>", [[getcmdpos() > strlen(getcmdline())? &cedit: "\<Lt>Right>"]], { expr = true })
-- see :h cmdline-editing
cnoremap("<Esc>b", [[<S-Left>]])
cnoremap("<Esc>f", [[<S-Right>]])
-- Insert escaped '/' while inputting a search pattern
cnoremap("/", [[getcmdtype() == "/" ? "\/" : "/"]], { expr = true })
-----------------------------------------------------------------------------//
-- Save
nnoremap("<c-s>", function()
  -- NOTE: this uses write specifically because we need to trigger a filesystem event
  -- even if the file isn't change so that things like hot reload work
  vim.cmd "silent! write"
  as.notify("Saved " .. vim.fn.expand "%:t", { timeout = 1000 })
end)
-- Write and quit all files, ZZ is NOT equivalent to this
nnoremap("qa", "<cmd>qa<CR>")
------------------------------------------------------------------------------
-- Quickfix
------------------------------------------------------------------------------
nnoremap("]q", "<cmd>cnext<CR>zz")
nnoremap("[q", "<cmd>cprev<CR>zz")
nnoremap("]l", "<cmd>lnext<cr>zz")
nnoremap("[l", "<cmd>lprev<cr>zz")
------------------------------------------------------------------------------
-- Tab navigation
------------------------------------------------------------------------------
nnoremap("<leader>tn", "<cmd>tabedit %<CR>")
nnoremap("<leader>tc", "<cmd>tabclose<CR>")
nnoremap("<leader>to", "<cmd>tabonly<cr>")
nnoremap("<leader>tm", "<cmd>tabmove<Space>")
nnoremap("]t", "<cmd>tabprev<CR>")
nnoremap("[t", "<cmd>tabnext<CR>")
-------------------------------------------------------------------------------
-- ?ie | entire object
-------------------------------------------------------------------------------
xnoremap("ie", [[gg0oG$]])
onoremap("ie", [[<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>]])
----------------------------------------------------------------------------//
-- Core navigation
----------------------------------------------------------------------------//
-- Store relative line number jumps in the jumplist.
nnoremap("j", [[(v:count > 1 ? 'm`' . v:count : '') . 'gj']], { expr = true, silent = true })
nnoremap("k", [[(v:count > 1 ? 'm`' . v:count : '') . 'gk']], { expr = true, silent = true })
-- Zero should go to the first non-blank character not to the first column (which could be blank)
-- but if already at the first character then jump to the beginning
--@see: https://github.com/yuki-yano/zero.nvim/blob/main/lua/zero.lua
nnoremap("0", "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", { expr = true })
-- when going to the end of the line in visual mode ignore whitespace characters
vnoremap("$", "g_")
-- jk is escape, THEN move to the right to preserve the cursor position, unless
-- at the first column.  <esc> will continue to work the default way.
-- NOTE: this is a recursive mapping so anything bound (by a plugin) to <esc> still works
imap("jk", [[col('.') == 1 ? '<esc>' : '<esc>l']], { expr = true })
-- Toggle top/center/bottom
nmap(
  "zz",
  [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']],
  { expr = true }
)

-- This line opens the vimrc in a vertical split
nnoremap("<leader>ev", [[:vsplit $MYVIMRC<cr>]])

-- This line allows the current file to source the vimrc allowing me use bindings as they're added
nnoremap("<leader>sv", [[:luafile $MYVIMRC<cr> <bar> :call utils#message('Sourced init.vim')<cr>]])
-----------------------------------------------------------------------------//
-- Quotes
-----------------------------------------------------------------------------//
nnoremap([[<leader>"]], [[ciw"<c-r>""<esc>]])
nnoremap("<leader>`", [[ciw`<c-r>"`<esc>]])
nnoremap("<leader>'", [[ciw'<c-r>"'<esc>]])
nnoremap("<leader>)", [[ciw(<c-r>")<esc>]])
nnoremap("<leader>}", [[ciw{<c-r>"}<esc>]])

-- Map Q to replay q register
nnoremap("Q", "@q")
-----------------------------------------------------------------------------//
-- Multiple Cursor Replacement
-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
-----------------------------------------------------------------------------//
nnoremap("cn", "*``cgn")
nnoremap("cN", "*``cgN")

-- 1. Position the cursor over a word; alternatively, make a selection.
-- 2. Hit cq to start recording the macro.
-- 3. Once you are done with the macro, go back to normal mode.
-- 4. Hit Enter to repeat the macro over search matches.
function _G._mappings.setup_CR()
  nmap("<Enter>", [[:nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z]])
end

-- NOTE: this line is done as a vim command as handling the string in lua breaks
vim.cmd [[let g:mc = "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>""]]
xnoremap("cn", [[g:mc . "``cgn"]], { expr = true, silent = true })
xnoremap("cN", [[g:mc . "``cgN"]], { expr = true, silent = true })
nnoremap("cq", [[:lua _mappings.setup_CR()<CR>*``qz]])
nnoremap("cQ", [[:lua _mappings.setup_CR()<CR>#``qz]])
xnoremap("cq", [[":\<C-u>lua _mappings.setup_CR()\<CR>" . "gv" . g:mc . "``qz"]], { expr = true })
xnoremap(
  "cQ",
  [[":\<C-u>lua _mappings.setup_CR()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz"]],
  { expr = true }
)

-- if the file under the cursor doesn't exist create it
-- see :h gf a simpler solution of :edit <cfile> is recommended but doesn't work.
-- If you select require('buffers/file') in lua for example
-- this makes the cfile -> buffers/file rather than my_dir/buffer/file.lua
-- Credit: 1,2
local function open_file_or_create_new()
  local path = fn.expand "<cfile>"
  if not path or path == "" then
    return false
  end

  -- TODO handle terminal buffers

  if pcall(vim.cmd, "norm!gf") then
    return true
  end

  local answer = fn.input "Create a new file, (Y)es or (N)o? "
  if not answer or string.lower(answer) ~= "y" then
    return vim.cmd "redraw"
  end
  vim.cmd "redraw"
  local new_path = fn.fnamemodify(fn.expand "%:p:h" .. "/" .. path, ":p")
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

nnoremap("gf", open_file_or_create_new)
-----------------------------------------------------------------------------//
-- Command mode related
-----------------------------------------------------------------------------//
-- smooth searching, allow tabbing between search results similar to using <c-g>
-- or <c-t> the main difference being tab is easier to hit and remapping those keys
-- to these would swallow up a tab mapping
cnoremap(
  "<Tab>",
  [[getcmdtype() == "/" || getcmdtype() == "?" ? "<CR>/<C-r>/" : "<C-z>"]],
  { expr = true }
)
cnoremap(
  "<S-Tab>",
  [[getcmdtype() == "/" || getcmdtype() == "?" ? "<CR>?<C-r>/" : "<S-Tab>"]],
  { expr = true }
)
-- Smart mappings on the command line
cnoremap("w!!", [[w !sudo tee % >/dev/null]])
-- insert path of current file into a command
cnoremap("%%", "<C-r>=fnameescape(expand('%'))<cr>")
cnoremap("::", "<C-r>=fnameescape(expand('%:p:h'))<cr>/")
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

nnoremap("<localleader>?", [[:lua _mappings.google(vim.fn.expand("<cWORD>"), false)<cr>]])
nnoremap("<localleader>!", [[:lua _mappings.google(vim.fn.expand("<cWORD>"), true)<cr>]])
xnoremap("<localleader>?", [["gy:lua _mappings.google(vim.api.nvim_eval("@g"), false)<cr>gv]])
xnoremap("<localleader>!", [["gy:lua _mappings.google(vim.api.nvim_eval("@g"), false, true)<cr>gv]])
----------------------------------------------------------------------------------
-- Grep Operator
----------------------------------------------------------------------------------
function _mappings.grep_operator(type)
  local saved_unnamed_register = fn.getreg "@@"
  if type:match "v" then
    vim.cmd [[normal! `<v`>y]]
  elseif type:match "char" then
    vim.cmd [[normal! `[v`]y']]
  else
    return
  end
  -- Use Winnr to check if the cursor has moved it if has restore it
  local winnr = fn.winnr()
  vim.cmd [[silent execute 'grep! ' . shellescape(@@) . ' .']]
  fn.setreg("@@", saved_unnamed_register)
  if fn.winnr() ~= winnr then
    vim.cmd [[wincmd p]]
  end
end

-- http://travisjeffery.com/b/2011/10/m-x-occur-for-vim/
nnoremap("<leader>g", [[:silent! set operatorfunc=v:lua._mappings.grep_operator<cr>g@]])
vnoremap("<leader>g", [[:call v:lua._mappings.grep_operator(visualmode())<cr>]])
nnoremap("<localleader>g*", [[:Ggrep --untracked <cword><CR>]])

-----------------------------------------------------------------------------//
-- GX - replicate netrw functionality
-----------------------------------------------------------------------------//
local function open_link()
  local file = fn.expand "<cfile>"
  if fn.isdirectory(file) > 0 then
    vim.cmd("edit " .. file)
  else
    fn.jobstart({ vim.g.open_command, file }, { detach = true })
  end
end
nnoremap("gx", open_link)
---------------------------------------------------------------------------------
-- Toggle list
---------------------------------------------------------------------------------
local function toggle_list(prefix)
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    local location_list = fn.getloclist(0, { filewinid = 0 })
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

nnoremap("<leader>ls", function()
  toggle_list "c"
end)
nnoremap("<leader>li", function()
  toggle_list "l"
end)

-----------------------------------------------------------------------------//
-- Completion
-----------------------------------------------------------------------------//
-- cycle the completion menu with <TAB>
inoremap("<tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
inoremap("<s-tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
command {
  "ToggleBackground",
  function()
    vim.o.background = vim.o.background == "dark" and "light" or "dark"
  end,
}
------------------------------------------------------------------------------
command { "Todo", [[noautocmd silent! grep! 'TODO\|FIXME\|BUG\|HACK' | copen]] }
command {
  "ReloadModule",
  function(args)
    require("plenary.reload").reload_module(args)
  end,
  nargs = 1,
}
command {
  "TabMessage",
  [[call utils#tab_message(<q-args>)]],
  nargs = "+",
  types = { "-complete=command" },
}
-- source https://superuser.com/a/540519
-- write the visual selection to the filename passed in as a command argument then delete the
-- selection placing into the black hole register
command {
  "MoveWrite",
  [[<line1>,<line2>write<bang> <args> | <line1>,<line2>delete _]],
  types = { "-bang", "-range", "-complete=file" },
  nargs = 1,
}
command {
  "MoveAppend",
  [[<line1>,<line2>write<bang> >> <args> | <line1>,<line2>delete _]],
  types = { "-bang", "-range", "-complete=file" },
  nargs = 1,
}
command { "AutoResize", [[call utils#auto_resize(<args>)]], { "-nargs=?" } }

command {
  "LuaInvalidate",
  function(pattern)
    require("as.utils").invalidate(pattern, true)
  end,
  nargs = 1,
}
-----------------------------------------------------------------------------//
-- References
-----------------------------------------------------------------------------//
-- 1.) https://www.reddit.com/r/vim/comments/i2x8xc/i_want_gf_to_create_files_if_they_dont_exist/
-- 2.) https://github.com/kristijanhusak/neovim-config/blob/5474d932386c3724d2ce02a5963528fe5d5e1015/nvim/lua/partials/mappings.lua#L154
