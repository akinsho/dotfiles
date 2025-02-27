---@diagnostic disable: undefined-global
local vscode = require('vscode')
local map = vim.keymap.set

vim.notify = vscode.notify

vim.opt.clipboard = 'unnamedplus'
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.virtualedit = 'block'
vim.opt.wildmode = 'longest:full,full'

map('n', '<leader>qq', '<Cmd>Tabclose<CR>')

-- add space line
map('n', ']<space>', "<Cmd>put =repeat(nr2char(10), v:count1) <Bar> '[-1<CR>")
map('n', '[<space>', "<Cmd>put! =repeat(nr2char(10), v:count1) <Bar> ']+1<CR>")
map('n', '<localleader>l', "<Cmd>nohlsearch<CR>")

map('n', '<tab>', function() vscode.action('workbench.action.nextEditor') end, { silent = true })
map('n', '<S-tab>', function() vscode.action('workbench.action.previousEditor') end, { silent = true })
map({ 'n', 'x' }, '<C-h>', function() vscode.action('workbench.action.navigateLeft') end, { silent = true })
map({ 'n', 'x' }, '<C-j>', function() vscode.action('workbench.action.navigateDown') end, { silent = true })
map({ 'n', 'x' }, '<C-k>', function() vscode.action('workbench.action.navigateUp') end, { silent = true })
map({ 'n', 'x' }, '<C-l>', function() vscode.action('workbench.action.navigateRight') end, { silent = true })
map('n', '[d', function() vscode.action('editor.action.marker.prev') end, { silent = true })
map('n', ']d', function() vscode.action('editor.action.marker.next') end, { silent = true })
map('n', '<leader>ff', function() vscode.action('workbench.action.quickOpen') end, { silent = true })
map('n', '<leader>ca', function() vscode.action('editor.action.quickFix') end, { silent = true })
map('n', '<leader>gr', function() vscode.action('editor.action.rename') end, { silent = true })
map('n', '<leader>rf', function() vscode.action('editor.action.formatDocument') end, { silent = true })
map('v', '<leader>rf', function() vscode.action('editor.action.formatSelection') end, { silent = true })
map('n', 'gr', function() vscode.action('editor.action.goToReferences') end, { silent = true })
map('n', '<localleader>gs', function() vscode.action('magit.status') end, { silent = true })

map('n', '<leader>sv', function()
  vscode.action('vscode-neovim.restart')
  vim.notify('Restarting Neovim', vim.log.levels.INFO, { title = 'vscode' })
end, { silent = true })

map('n', '<leader>ev', function()
  vim.cmd('edit $HOME/.config/nvim/init.lua')
  vim.notify('Opening NVIM config file', vim.log.levels.INFO, { title = 'vscode' })
end, { silent = true })

-- better up/down
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map('n', '<leader>nf', function() vscode.call('workbench.action.files.newUntitledFile') end, { desc = 'New file' })
map('n', '<leader>ff', function() vscode.call('workbench.action.quickOpen') end, { desc = 'Open file finder' })
map('n', '<leader>fs', function() vscode.call('workbench.action.findInFiles') end, { desc = 'Search in files' })
map('n', '[h', function() vscode.call('workbench.action.editor.previousChange') end, { desc = 'Previous change' })
map('n', ']h', function() vscode.call('workbench.action.editor.nextChange') end, { desc = 'Next change' })

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
