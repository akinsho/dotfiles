local vscode = require('vscode-neovim')
local map = vim.keymap.set

vim.opt.clipboard = 'unnamedplus'
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.virtualedit = 'block'
vim.opt.wildmode = 'longest:full,full' -- Command-line completion mode

map('n', '<tab>', '<Cmd>Tabnext<CR>')
map('n', '<S-tab>', '<Cmd>Tabprevious<CR>')
map('n', '<leader>qq', '<Cmd>Tabclose<CR>')

-- add space line
map('n', ']<space>', "<Cmd>put =repeat(nr2char(10), v:count1) <Bar> '[-1<CR>")
map('n', '[<space>', "<Cmd>put! =repeat(nr2char(10), v:count1) <Bar> ']+1<CR>")

map({ 'n', 'x' }, '<C-h>', function() vscode.call('workbench.action.navigateLeft') end, { silent = true })
map({ 'n', 'x' }, '<C-j>', function() vscode.call('workbench.action.navigateDown') end, { silent = true })
map({ 'n', 'x' }, '<C-k>', function() vscode.call('workbench.action.navigateUp') end, { silent = true })
map({ 'n', 'x' }, '<C-l>', function() vscode.call('workbench.action.navigateRight') end, { silent = true })
-- better up/down
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map('n', '<leader>ff', function() vscode.call('workbench.action.quickOpen') end, {
  desc = 'Open file finder',
})

map('n', '<leader>fs', function() vscode.call('workbench.action.findInFiles') end, {
  desc = 'Search in files',
})

map('n', '[h', function() vscode.call('workbench.action.editor.previousChange') end, {
  desc = 'Previous change',
})
map('n', ']h', function() vscode.call('workbench.action.editor.nextChange') end, {
  desc = 'Next change',
})
