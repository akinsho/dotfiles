--------------------------------------------------------------------------------
--       _/_/    _/    _/
--    _/    _/  _/  _/      Akin Sowemimo's dotfiles
--   _/_/_/_/  _/_/         https://github.com/akinsho
--  _/    _/  _/  _/
-- _/    _/  _/    _/
---------------------------------------------------------------------------------
-- NOTE: this is set by nvim by default but maybe too late
vim.cmd 'syntax enable'

vim.g.os = vim.loop.os_uname().sysname
vim.g.open_command = vim.g.os == 'Darwin' and 'open' or 'xdg-open'
vim.g.dotfiles = vim.env.DOTFILES or vim.fn.expand '~/.dotfiles'
vim.g.vim_dir = vim.g.dotfiles .. '/.config/nvim'

------------------------------------------------------------------------
-- Leader bindings
------------------------------------------------------------------------
vim.g.mapleader = ',' -- Remap leader key
vim.g.maplocalleader = ' ' -- Local leader is <Space>

------------------------------------------------------------------------
-- Plugin Configurations
------------------------------------------------------------------------
require 'as.globals'
require 'as.settings'
require 'as.highlights'
require 'as.statusline'
require 'as.plugins'
-------------------------------------------------------------------------
-- Local vimrc
-------------------------------------------------------------------------
if vim.fn.filereadable(vim.fn.fnamemodify('~/.vimrc.local', ':p')) > 0 then
  vim.cmd [[source ~/.vimrc.local]]
end
-----------------------------------------------------------------------------//
