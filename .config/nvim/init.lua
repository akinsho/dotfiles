--------------------------------------------------------------------------------
--       _/_/    _/    _/
--    _/    _/  _/  _/      Akin Sowemimo's dotfiles
--   _/_/_/_/  _/_/         https://github.com/akinsho
--  _/    _/  _/  _/
-- _/    _/  _/    _/
---------------------------------------------------------------------------------
vim.cmd [[augroup vimrc]] -- Ensure all autocommands are cleared
vim.cmd [[autocmd!]]
vim.cmd [[augroup END]]

-- The operating system is assigned to a global variable that
-- that can be used elsewhere for conditional system based logic
local uname = vim.loop.os_uname()
if uname.sysname == "Darwin" then
  vim.g.open_command = "open"
elseif uname.sysname == "Linux" then
  vim.g.open_command = "xdg-open"
end

function _G.plugin_loaded(plugin_name)
  local path = vim.fn.globpath(vim.o.rtp, "pack/packer/*/" .. plugin_name)
  return path ~= nil and path ~= ""
end

vim.g.dotfiles = vim.env.DOTFILES ~= nil and vim.env.DOTFILES or "~/.dotfiles"
vim.g.vim_dir = vim.g.dotfiles .. "/.config/nvim"

------------------------------------------------------------------------
-- Leader bindings
------------------------------------------------------------------------
vim.g.mapleader = "," -- Remap leader key
vim.g.maplocalleader = " " -- Local leader is <Space>

-------------------------------------------------------------------------
-- Essential Settings
-------------------------------------------------------------------------
vim.cmd [[filetype plugin indent on]]
vim.cmd [[syntax enable]]
------------------------------------------------------------------------
-- Plugin Configurations
------------------------------------------------------------------------
-- ORDER MATTERS HERE
--
-- :h runtime - this fuzzy matches files within vim's runtime path
require("as.globals")
require("as.plugins")

-- TODO: eventually refactor to lua
vim.cmd [[runtime configs/general.vim]]
vim.cmd [[runtime configs/highlight.vim]]
vim.cmd [[runtime configs/mappings.vim]]
vim.cmd [[runtime configs/autocommands.vim]]

require("as")

vim.cmd [[runtime! configs/plugins/*.vim]]
-------------------------------------------------------------------------
-- Local vimrc
-------------------------------------------------------------------------
if vim.fn.filereadable(vim.fn.fnamemodify("~/.vimrc.local", ":p")) > 0 then
  vim.cmd [[source ~/.vimrc.local]]
end
-----------------------------------------------------------------------------//
