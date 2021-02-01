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
  vim.g.system_name = "macOS"
elseif uname.sysname == "Linux" then
  vim.g.open_command = "xdg-open"
  vim.g.system_name = "Linux"
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

------------------------------------------------------------------------
-- Plugin Configurations
------------------------------------------------------------------------
require("as")
-------------------------------------------------------------------------
-- Local vimrc
-------------------------------------------------------------------------
if vim.fn.filereadable(vim.fn.fnamemodify("~/.vimrc.local", ":p")) > 0 then
  vim.cmd [[source ~/.vimrc.local]]
end
-----------------------------------------------------------------------------//
