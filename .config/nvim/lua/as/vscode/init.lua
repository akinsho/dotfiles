local vscode = require('vscode')
local map = function (...)
   vim.keymap.set(...)
end

vim.notify = vscode.notify
vim.g.clipboard = vim.g.vscode_clipboard

vim.opt.clipboard = 'unnamedplus'
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undolevels = 10000
vim.opt.virtualedit = 'block'
vim.opt.wildmode = 'longest:full,full'

local function vscode_action(cmd)
  return function() vscode.action(cmd) end
end

map('n', '<leader>qq', '<Cmd>Tabclose<CR>')
map('n', ']<space>', "<Cmd>put =repeat(nr2char(10), v:count1) <Bar> '[-1<CR>")
map('n', '[<space>', "<Cmd>put! =repeat(nr2char(10), v:count1) <Bar> ']+1<CR>")
map('n', '<localleader>l', '<Cmd>nohlsearch<CR>')
map('n', '<tab>', vscode_action('workbench.action.nextEditor'))
map('n', '<S-tab>', vscode_action('workbench.action.previousEditor'))
map({ 'n', 'x' }, '<C-h>', vscode_action('workbench.action.navigateLeft'))
map({ 'n', 'x' }, '<C-j>', vscode_action('workbench.action.navigateDown'))
map({ 'n', 'x' }, '<C-k>', vscode_action('workbench.action.navigateUp'))
map({ 'n', 'x' }, '<C-l>', vscode_action('workbench.action.navigateRight'))
map('n', '[d', vscode_action('editor.action.marker.prev'))
map('n', ']d', vscode_action('editor.action.marker.next'))
map('n', '<leader>ff', vscode_action('workbench.action.quickOpen'))
map('n', '<leader>ca', vscode_action('editor.action.quickFix'))
map('n', '<leader>gr', vscode_action('editor.action.rename'))
map('n', '<leader>rf', vscode_action('editor.action.formatDocument'))
map('v', '<leader>rf', vscode_action('editor.action.formatSelection'))
map('n', 'gr', vscode_action('editor.action.goToReferences'))
--------------------------------------------------------------------------------
-- PLUGINS
--------------------------------------------------------------------------------
map('n', '<localleader>gs', vscode_action('magit.status'))
--------------------------------------------------------------------------------
map({ 'n' }, 'm;', vscode_action('bookmarks.toggle'), { desc = 'Toogle Bookmark' })
map({ 'n' }, 'm:', vscode_action('bookmarks.toggleLabeled'), { desc = 'Toogle Bookmark Label' })
map({ 'n' }, 'm/', vscode_action('bookmarks.listFromAllFiles'), { desc = 'List All Bookmarks' })
--------------------------------------------------------------------------------
map('n', '<leader>sv', function()
  vscode.action('vscode-neovim.restart')
  vim.notify('Restarting Neovim', vim.log.levels.INFO, { title = 'vscode' })
end, { silent = true })

map('n', '<leader>ev', function()
  vim.cmd('edit $HOME/.config/nvim/init.lua')
  vim.notify('Opening NVIM config file', vim.log.levels.INFO, { title = 'vscode' })
end, { silent = true })
--------------------------------------------------------------------------------
-- better up/down
--------------------------------------------------------------------------------
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
--------------------------------------------------------------------------------
map('n', '<leader>nf', vscode_action('workbench.action.files.newUntitledFile'), { desc = 'New file' })
map('n', '<leader>ff', vscode_action('workbench.action.quickOpen'), { desc = 'Open file finder' })
map('n', '<leader>fs', vscode_action('workbench.action.findInFiles'), { desc = 'Search in files' })
map('n', '[h', vscode_action('workbench.action.editor.previousChange'), { desc = 'Previous change' })
map('n', ']h', vscode_action('workbench.action.editor.nextChange'), { desc = 'Next change' })

local manageEditorSize = function(...)
  local count = select(1, ...)
  local to = select(2, ...)
  for i = 1, (count and count > 0 and count or 1) do
    vscode.call(to == 'increase' and 'workbench.action.increaseViewSize' or 'workbench.action.decreaseViewSize')
  end
end

-- These keys represent alt left and right
map('n', '¬', function() manageEditorSize(vim.v.count, 'increase') end, { noremap = true, silent = true })
map('n', '˙', function() manageEditorSize(vim.v.count, 'decrease') end, { noremap = true, silent = true })

map('n', '<C-w>>', function() manageEditorSize(vim.v.count, 'increase') end, { noremap = true, silent = true })
map('x', '<C-w>>', function() manageEditorSize(vim.v.count, 'increase') end, { noremap = true, silent = true })
map('n', '<C-w>+', function() manageEditorSize(vim.v.count, 'increase') end, { noremap = true, silent = true })
map('x', '<C-w>+', function() manageEditorSize(vim.v.count, 'increase') end, { noremap = true, silent = true })
map('n', '<C-w><', function() manageEditorSize(vim.v.count, 'decrease') end, { noremap = true, silent = true })
map('x', '<C-w><', function() manageEditorSize(vim.v.count, 'decrease') end, { noremap = true, silent = true })
map('n', '<C-w>-', function() manageEditorSize(vim.v.count, 'decrease') end, { noremap = true, silent = true })
map('x', '<C-w>-', function() manageEditorSize(vim.v.count, 'decrease') end, { noremap = true, silent = true })
