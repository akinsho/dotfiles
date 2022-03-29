--------------------------------------------------------------------------------
--       _/_/    _/    _/
--    _/    _/  _/  _/      Akin Sowemimo's dotfiles
--   _/_/_/_/  _/_/         https://github.com/akinsho
--  _/    _/  _/  _/
-- _/    _/  _/    _/
---------------------------------------------------------------------------------
vim.g.os = vim.loop.os_uname().sysname
vim.g.open_command = vim.g.os == 'Darwin' and 'open' or 'xdg-open'
vim.g.dotfiles = vim.env.DOTFILES or vim.fn.expand '~/.dotfiles'
vim.g.vim_dir = vim.g.dotfiles .. '/.config/nvim'

vim.g.did_load_filetypes = 0 -- deactivate vim based filetype detection
------------------------------------------------------------------------
-- Leader bindings
------------------------------------------------------------------------
vim.g.mapleader = ',' -- Remap leader key
vim.g.maplocalleader = ' ' -- Local leader is <Space>

local ok, reload = pcall(require, 'plenary.reload')
RELOAD = ok and reload.reload_module or function(...)
  return ...
end
function R(name)
  RELOAD(name)
  return require(name)
end

------------------------------------------------------------------------
-- Plugin Configurations
------------------------------------------------------------------------
-- Order matters here as globals needs to be instantiated first etc.
R 'as.globals'
R 'as.styles'
R 'as.settings'
R 'as.highlights'
R 'as.statusline'
R 'as.plugins'
