if not as or not as.mappings.enable then return end

local fn, api, uv, cmd, command, fmt = vim.fn, vim.api, vim.uv, vim.cmd, as.command, string.format

local recursive_map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.remap = true
  map(mode, lhs, rhs, opts)
end

local nmap = function(...) recursive_map('n', ...) end
local imap = function(...) recursive_map('i', ...) end
local nnoremap = function(...) map('n', ...) end
local xnoremap = function(...) map('x', ...) end
local vnoremap = function(...) map('v', ...) end
local inoremap = function(...) map('i', ...) end
local onoremap = function(...) map('o', ...) end
local cnoremap = function(...) map('c', ...) end
local tnoremap = function(...) map('t', ...) end

-----------------------------------------------------------------------------//
-- Terminal {{{
------------------------------------------------------------------------------//
as.augroup('AddTerminalMappings', {
  event = { 'TermOpen' },
  pattern = { 'term://*' },
  command = function()
    if vim.bo.filetype == '' or vim.bo.filetype == 'toggleterm' then
      local opts = { silent = false, buffer = 0 }
      tnoremap('<esc>', [[<C-\><C-n>]], opts)
      tnoremap('jk', [[<C-\><C-n>]], opts)
      tnoremap('<C-h>', '<Cmd>wincmd h<CR>', opts)
      tnoremap('<C-j>', '<Cmd>wincmd j<CR>', opts)
      tnoremap('<C-k>', '<Cmd>wincmd k<CR>', opts)
      tnoremap('<C-l>', '<Cmd>wincmd l<CR>', opts)
      tnoremap(']t', '<Cmd>tablast<CR>')
      tnoremap('[t', '<Cmd>tabnext<CR>')
      tnoremap('<S-Tab>', '<Cmd>bprev<CR>')
      tnoremap('<leader><Tab>', '<Cmd>close \\| :bnext<cr>')
    end
  end,
})
--}}}
-----------------------------------------------------------------------------//
-- MACROS {{{
-----------------------------------------------------------------------------//
-- Absolutely fantastic function from stoeffel/.dotfiles which allows you to
-- repeat macros across a visual range
------------------------------------------------------------------------------
xnoremap('@', function()
  vim.ui.input({ prompt = 'Macro Register: ' }, function(reg) vim.cmd([['<,'>normal @]] .. reg) end)
end, { silent = false })
--}}}
------------------------------------------------------------------------------
-- Credit: JGunn Choi ?il | inner line
------------------------------------------------------------------------------
-- includes newline
xnoremap('al', '$o0')
onoremap('al', '<cmd>normal val<CR>')
--No Spaces or CR
xnoremap('il', [[<Esc>^vg_]])
onoremap('il', [[<cmd>normal! ^vg_<CR>]])
-----------------------------------------------------------------------------//
-- Add Empty space above and below
-----------------------------------------------------------------------------//
nnoremap('[<space>', [[<cmd>put! =repeat(nr2char(10), v:count1)<cr>'[]], {
  desc = 'add space above',
})
nnoremap(']<space>', [[<cmd>put =repeat(nr2char(10), v:count1)<cr>]], {
  desc = 'add space below',
})
-----------------------------------------------------------------------------//
-- Paste in visual mode multiple times
xnoremap('p', 'pgvy')
-- search visual selection
vnoremap('//', [[y/<C-R>"<CR>]])

-- Credit: Justinmk
nnoremap('g>', [[<cmd>set nomore<bar>40messages<bar>set more<CR>]], {
  desc = 'show message history',
})

-- Evaluates whether there is a fold on the current line if so unfold it else return a normal space
nnoremap('<space><space>', [[@=(foldlevel('.')?'za':"\<Space>")<CR>]], {
  desc = 'toggle fold under cursor',
})
-- Refocus folds
nnoremap('<localleader>z', [[zMzvzz]], { desc = 'center viewport' })
-- Make zO recursively open whatever top level fold we're in, no matter where the
-- cursor happens to be.
nnoremap('zO', [[zCzO]])

-- TLDR: Conditionally modify character at end of line
-- Description:
-- This function takes a delimiter character and:
--   * removes that character from the end of the line if the character at the end
--     of the line is that character
--   * removes the character at the end of the line if that character is a
--     delimiter that is not the input character and appends that character to
--     the end of the line
--   * adds that character to the end of the line if the line does not end with
--     a delimiter
-- Delimiters:
-- - ","
-- - ";"
---@param character string
---@return function
local function modify_line_end_delimiter(character)
  local delimiters = { ',', ';' }
  return function()
    local line = api.nvim_get_current_line()
    local last_char = line:sub(-1)
    if last_char == character then
      api.nvim_set_current_line(line:sub(1, #line - 1))
    elseif vim.tbl_contains(delimiters, last_char) then
      api.nvim_set_current_line(line:sub(1, #line - 1) .. character)
    else
      api.nvim_set_current_line(line .. character)
    end
  end
end

nnoremap('<localleader>,', modify_line_end_delimiter(','), { desc = "add ',' to end of line" })
nnoremap('<localleader>;', modify_line_end_delimiter(';'), { desc = "add ';' to end of line" })

-----------------------------------------------------------------------------//
nnoremap('<leader>E', '<Cmd>Inspect<CR>', { desc = 'Inspect the cursor position' })
-----------------------------------------------------------------------------//

if as.falsy(fn.mapcheck('<ScrollWheelDown>')) then nmap('<ScrollWheelDown>', '<c-d>') end
if as.falsy(fn.mapcheck('<ScrollWheelUp>')) then nmap('<ScrollWheelUp>', '<c-u>') end
------------------------------------------------------------------------------
-- Buffers
------------------------------------------------------------------------------
nnoremap('<leader>on', [[<cmd>w <bar> %bd <bar> e#<CR>]], { desc = 'close all other buffers' })
nnoremap('<localleader><tab>', [[:b <Tab>]], { silent = false, desc = 'open buffer list' })
nnoremap('<leader><leader>', [[<c-^>]], { desc = 'switch to last buffer' })
-----------------------------------------------------------------------------//
-- Capitalize
-----------------------------------------------------------------------------//
nnoremap('<leader>U', 'gUiw`]', { desc = 'capitalize word' })
------------------------------------------------------------------------------
-- Moving lines/visual block
------------------------------------------------------------------------------
-- source: https://www.reddit.com/r/vim/comments/i8b5z1/is_there_a_more_elegant_way_to_move_lines_than_eg/
-- Alternatively to allow using alt in macOS without enabling “Use Option as Meta key”
-- nmap('∆', '<a-j>')
-- nmap('˚', '<a-k>')
nnoremap('<a-k>', '<cmd>move-2<CR>==')
nnoremap('<a-j>', '<cmd>move+<CR>==')
xnoremap('<a-k>', ":move-2<CR>='[gv", { silent = true })
xnoremap('<a-j>', ":move'>+<CR>='[gv", { silent = true })
----------------------------------------------------------------------------------
-- Windows
----------------------------------------------------------------------------------
nnoremap('<localleader>wh', '<C-W>t <C-W>K', {
  desc = 'change two horizontally split windows to vertical splits',
})
nnoremap('<localleader>wv', '<C-W>t <C-W>H', {
  desc = 'change two vertically split windows to horizontal splits',
})
-- equivalent to gf but opens the window in a vertical split
-- vim doesn't have a native mapping for this as <C-w>f normally
-- opens a horizontal split
nnoremap('<C-w>f', '<C-w>vgf', { desc = 'open file in vertical split' })
-- make . work with visually selected lines
vnoremap('.', ':norm.<CR>')
nnoremap('<leader>qw', '<cmd>bd!<CR>', { desc = 'Close current buffer (and window)' })
-----------------------------------------------------------------------------//
-- Quick find/replace
-----------------------------------------------------------------------------//
nnoremap('<leader>[', [[:%s/\<<C-r>=expand("<cword>")<CR>\>/]], {
  silent = false,
  desc = 'replace word under the cursor(file)',
})
nnoremap('<leader>]', [[:s/\<<C-r>=expand("<cword>")<CR>\>/]], {
  silent = false,
  desc = 'replace word under the cursor (line)',
})
vnoremap('<leader>[', [["zy:%s/<C-r><C-o>"/]], {
  silent = false,
  desc = 'replace word under the cursor (visual)',
})
-- Visual shifting (does not exit Visual mode)
vnoremap('<', '<gv')
vnoremap('>', '>gv')
--Remap back tick for jumping to marks more quickly back
nnoremap("'", '`')
-----------------------------------------------------------------------------//
nnoremap('<leader>nf', [[:e <C-R>=expand("%:p:h") . "/" <CR>]], {
  silent = false,
  desc = 'Open a new file in the same directory',
})
nnoremap('<leader>ns', [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], {
  silent = false,
  desc = 'Split to a new file in the same directory',
})
-----------------------------------------------------------------------------//
-- Window bindings
-----------------------------------------------------------------------------//
-- https://vim.fandom.com/wiki/Fast_window_resizing_with_plus/minus_keys
if fn.bufwinnr(1) then
  nnoremap('<a-h>', '<C-W><')
  nnoremap('<a-l>', '<C-W>>')
end
-----------------------------------------------------------------------------//
-- Arrows
-----------------------------------------------------------------------------//
nnoremap('<down>', '<nop>')
nnoremap('<up>', '<nop>')
nnoremap('<left>', '<nop>')
nnoremap('<right>', '<nop>')
inoremap('<up>', '<nop>')
inoremap('<down>', '<nop>')
inoremap('<left>', '<nop>')
inoremap('<right>', '<nop>')
----------------------------------------------------------------------------------
-- Commandline mappings
----------------------------------------------------------------------------------
-- https://github.com/tpope/vim-rsi/blob/master/plugin/rsi.vim
-- c-a / c-e everywhere - RSI.vim provides these
cnoremap('<C-n>', '<Down>')
cnoremap('<C-p>', '<Up>')
-- <C-A> allows you to insert all matches on the command line e.g. bd *.js <c-a>
-- will insert all matching files e.g. :bd a.js b.js c.js
cnoremap('<c-x><c-a>', '<c-a>')
-- move cursor one character backwards unless at the end of the command line
cnoremap('<C-f>', function()
  if fn.getcmdpos() == fn.strlen(fn.getcmdline()) then return '<c-f>' end
  return '<Right>'
end, { expr = true })
cnoremap('<C-b>', '<Left>')
cnoremap('<C-d>', '<Del>')
-- see :h cmdline-editing
cnoremap('<Esc>b', [[<S-Left>]])
cnoremap('<Esc>f', [[<S-Right>]])

cmd.cabbrev('options', 'vert options')

-- smooth searching, allow tabbing between search results similar to using <c-g>
-- or <c-t> the main difference being tab is easier to hit and remapping those keys
-- to these would swallow up a tab mapping
local function search(direction_key, default)
  local c_type = fn.getcmdtype()
  return (c_type == '/' or c_type == '?') and fmt('<CR>%s<C-r>/', direction_key) or default
end
cnoremap('<Tab>', function() return search('/', '<Tab>') end, { expr = true })
cnoremap('<S-Tab>', function() return search('?', '<S-Tab>') end, { expr = true })
-- insert path of current file into a command
cnoremap('%%', "<C-r>=fnameescape(expand('%'))<cr>")
cnoremap('::', "<C-r>=fnameescape(expand('%:p:h'))<cr>/")
-----------------------------------------------------------------------------//
-- Save
-----------------------------------------------------------------------------//
-- NOTE: this uses write specifically because we need to trigger a filesystem event
-- even if the file isn't changed so that things like hot reload work
nnoremap('<c-s>', '<Cmd>silent! write ++p<CR>')
-- Write and quit all files, ZZ is NOT equivalent to this
nnoremap('qa', '<cmd>qa<CR>')
------------------------------------------------------------------------------
-- Quickfix
------------------------------------------------------------------------------
nnoremap(']q', '<cmd>cnext<CR>zz')
nnoremap('[q', '<cmd>cprev<CR>zz')
nnoremap(']l', '<cmd>lnext<cr>zz')
nnoremap('[l', '<cmd>lprev<cr>zz')
------------------------------------------------------------------------------
-- Tab navigation
------------------------------------------------------------------------------
nnoremap('<leader>tn', '<cmd>tabedit %<CR>')
nnoremap('<leader>tc', '<cmd>tabclose<CR>')
nnoremap('<leader>to', '<cmd>tabonly<cr>')
nnoremap('<leader>tm', '<cmd>tabmove<Space>')
nnoremap(']t', '<cmd>tabprev<CR>')
nnoremap('[t', '<cmd>tabnext<CR>')
-------------------------------------------------------------------------------
-- ?ie | entire object
-------------------------------------------------------------------------------
xnoremap('ie', [[gg0oG$]])
onoremap('ie', [[<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>]])
----------------------------------------------------------------------------//
-- Core navigation
----------------------------------------------------------------------------//
-- Store relative line number jumps in the jumplist.
nnoremap('j', [[(v:count > 1 ? 'm`' . v:count : '') . 'gj']], { expr = true, silent = true })
nnoremap('k', [[(v:count > 1 ? 'm`' . v:count : '') . 'gk']], { expr = true, silent = true })
-- Zero should go to the first non-blank character not to the first column (which could be blank)
-- but if already at the first character then jump to the beginning
--@see: https://github.com/yuki-yano/zero.nvim/blob/main/lua/zero.lua
nnoremap('0', "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", { expr = true })
-- when going to the end of the line in visual mode ignore whitespace characters
vnoremap('$', 'g_')
-- jk is escape, THEN move to the right to preserve the cursor position, unless
-- at the first column.  <esc> will continue to work the default way.
-- NOTE: this is a recursive mapping so anything bound (by a plugin) to <esc> still works
imap('jk', [[col('.') == 1 ? '<esc>' : '<esc>l']], { expr = true })
-- Toggle top/center/bottom
nmap('zz', [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']], { expr = true })

-----------------------------------------------------------------------------//
-- Open Common files
-----------------------------------------------------------------------------//
nnoremap('<leader>ev', [[<Cmd>edit $MYVIMRC<CR>]], { desc = 'open $VIMRC' })
nnoremap('<leader>ez', '<Cmd>edit $ZDOTDIR/.zshrc<CR>', { desc = 'open zshrc' })
nnoremap('<leader>et', '<Cmd>edit $XDG_CONFIG_HOME/tmux/tmux.conf<CR>', {
  desc = 'open tmux.conf',
})
nnoremap('<leader>ep', fmt('<Cmd>edit %s/lua/as/plugins/init.lua<CR>', fn.stdpath('config')), {
  desc = 'open plugins file',
})
-- This line allows the current file to source the vimrc allowing me use bindings as they're added
nnoremap('<leader>sv', [[<Cmd>source $MYVIMRC<cr> <bar> :lua vim.notify('Sourced init.vim')<cr>]], {
  desc = 'source $VIMRC',
})
nnoremap('<leader>yf', ":let @*=expand('%:p')<CR>", { desc = 'yank file path into the clipboard' })
-----------------------------------------------------------------------------//
-- Quotes
-----------------------------------------------------------------------------//
nnoremap([[<leader>"]], [[ciw"<c-r>""<esc>]], { desc = 'surround with double quotes' })
nnoremap('<leader>`', [[ciw`<c-r>"`<esc>]], { desc = 'surround with backticks' })
nnoremap("<leader>'", [[ciw'<c-r>"'<esc>]], { desc = 'surround with single quotes' })
nnoremap('<leader>)', [[ciw(<c-r>")<esc>]], { desc = 'surround with parentheses' })
nnoremap('<leader>}', [[ciw{<c-r>"}<esc>]], { desc = 'surround with curly braces' })
-----------------------------------------------------------------------------//
-- Multiple Cursor Replacement
-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
-----------------------------------------------------------------------------//
nnoremap('cn', '*``cgn')
nnoremap('cN', '*``cgN')

-- 1. Position the cursor over a word; alternatively, make a selection.
-- 2. Hit cq to start recording the macro.
-- 3. Once you are done with the macro, go back to normal mode.
-- 4. Hit Enter to repeat the macro over search matches.
function as.mappings.setup_map() nnoremap('M', [[:nnoremap M n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z]]) end

vim.g.mc = vim.keycode([[y/\V<C-r>=escape(@", '/')<CR><CR>]])
xnoremap('cn', [[g:mc . "``cgn"]], { expr = true, silent = true })
xnoremap('cN', [[g:mc . "``cgN"]], { expr = true, silent = true })
nnoremap('cq', [[:\<C-u>call v:lua.as.mappings.setup_map()<CR>*``qz]])
nnoremap('cQ', [[:\<C-u>call v:lua.as.mappings.setup_map()<CR>#``qz]])
xnoremap('cq', [[":\<C-u>call v:lua.as.mappings.setup_map()<CR>gv" . g:mc . "``qz"]], { expr = true })
xnoremap(
  'cQ',
  [[":\<C-u>call v:lua.as.mappings.setup_map()<CR>gv" . substitute(g:mc, '/', '?', 'g') . "``qz"]],
  { expr = true }
)
----------------------------------------------------------------------------------
-- Grep Operator
----------------------------------------------------------------------------------
-- http://travisjeffery.com/b/2011/10/m-x-occur-for-vim/

---@param type string
---@return nil
function as.mappings.grep_operator(type)
  local saved_unnamed_register = fn.getreg('@@')
  if type:match('v') then
    vim.cmd([[normal! `<v`>y]])
  elseif type:match('char') then
    vim.cmd([[normal! `[v`]y']])
  else
    return
  end
  -- Store the current window so if it changes we can restore it
  local win = api.nvim_get_current_win()
  vim.cmd.grep({ fn.shellescape(fn.getreg('@@')) .. ' .', bang = true, mods = { silent = true } })
  fn.setreg('@@', saved_unnamed_register)
  if api.nvim_get_current_win() ~= win then vim.cmd.wincmd('p') end
end

nnoremap('<leader>g', function()
  vim.o.operatorfunc = 'v:lua.as.mappings.grep_operator'
  return 'g@'
end, { expr = true, desc = 'grep operator' })
xnoremap('<leader>g', ':call v:lua.as.mappings.grep_operator(visualmode())<CR>')
-----------------------------------------------------------------------------//

nnoremap('gf', '<Cmd>e <cfile><CR>')

-----------------------------------------------------------------------------//
nnoremap('<leader>ls', as.list.qf.toggle, { desc = 'toggle quickfix list' })
nnoremap('<leader>ll', as.list.loc.toggle, { desc = 'toggle location list' })
-----------------------------------------------------------------------------//
-- Completion
-----------------------------------------------------------------------------//
-- cycle the completion menu with <TAB>
inoremap('<tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
inoremap('<s-tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
command('ToggleBackground', function() vim.o.background = vim.o.background == 'dark' and 'light' or 'dark' end)
nnoremap('<leader>Ow', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify('wrap ' .. (vim.o.wrap and 'on' or 'off'))
end, { desc = 'toggle wrap' })
------------------------------------------------------------------------------
command('Todo', [[noautocmd silent! grep! 'TODO\|FIXME\|BUG\|HACK' | copen]])
command('ReloadModule', function(tbl) require('plenary.reload').reload_module(tbl.args) end, {
  nargs = 1,
})
-- source https://superuser.com/a/540519
-- write the visual selection to the filename passed in as a command argument then delete the
-- selection placing into the black hole register
command('MoveWrite', [[<line1>,<line2>write<bang> <args> | <line1>,<line2>delete _]], {
  nargs = 1,
  bang = true,
  range = true,
  complete = 'file',
})
command('MoveAppend', [[<line1>,<line2>write<bang> >> <args> | <line1>,<line2>delete _]], {
  nargs = 1,
  bang = true,
  range = true,
  complete = 'file',
})

command('Reverse', '<line1>,<line2>g/^/m<line1>-1', {
  range = '%',
  bar = true,
})

command('Exrc', function()
  local cwd = fn.getcwd()
  local p1, p2 = ('%s/.nvim.lua'):format(cwd), ('%s/.nvimrc'):format(cwd)
  local path = uv.fs_stat(p1) and p1 or uv.fs_stat(p2) and p2
  if not path then
    local _, err = io.open(p1, 'w')
    assert(err == nil, err)
    path = p1
  end
  if not path then return end
  local ok, err = pcall(vim.cmd.edit, path)
  if not ok then vim.notify(err, 'error', { title = 'Exrc Opener' }) end
end)

command('ClearRegisters', function()
  local regs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-'
  for r in regs:gmatch('.') do
    fn.setreg(r, {})
  end
end)

-----------------------------------------------------------------------------//
-- References
-----------------------------------------------------------------------------//
-- 1.) https://www.reddit.com/r/vim/comments/i2x8xc/i_want_gf_to_create_files_if_they_dont_exist/
-- 2.) https://github.com/kristijanhusak/neovim-config/blob/5474d932386c3724d2ce02a5963528fe5d5e1015/nvim/lua/partials/mappings.lua#L154
