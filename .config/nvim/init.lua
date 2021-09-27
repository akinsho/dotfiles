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

------------------------------------------------------------------------
-- Leader bindings
------------------------------------------------------------------------
vim.g.mapleader = ',' -- Remap leader key
vim.g.maplocalleader = ' ' -- Local leader is <Space>

if pcall(require, 'plenary') then
  RELOAD = require('plenary.reload').reload_module
  function R(name)
    RELOAD(name)
    return require(name)
  end
end

------------------------------------------------------------------------
-- Plugin Configurations
------------------------------------------------------------------------
R 'as.globals'
R 'as.settings'
R 'as.highlights'
R 'as.statusline'
R 'as.plugins'
