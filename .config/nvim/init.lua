----------------------------------------------------------------------------------------------------
--       _/_/    _/    _/
--    _/    _/  _/  _/      Akin Sowemimo's dotfiles
--   _/_/_/_/  _/_/         https://github.com/akinsho
--  _/    _/  _/  _/
-- _/    _/  _/    _/
----------------------------------------------------------------------------------------------------
vim.g.os = vim.loop.os_uname().sysname
vim.g.open_command = vim.g.os == 'Darwin' and 'open' or 'xdg-open'
vim.g.dotfiles = vim.env.DOTFILES or vim.fn.expand('~/.dotfiles')
vim.g.vim_dir = vim.g.dotfiles .. '/.config/nvim'
----------------------------------------------------------------------------------------------------
-- Ensure all autocommands are cleared
vim.api.nvim_create_augroup('vimrc', {})
----------------------------------------------------------------------------------------------------
-- Leader bindings
----------------------------------------------------------------------------------------------------
vim.g.mapleader = ',' -- Remap leader key
vim.g.maplocalleader = ' ' -- Local leader is <Space>

local ok, reload = pcall(require, 'plenary.reload')
RELOAD = ok and reload.reload_module or function(...) return ... end
function R(name)
  RELOAD(name)
  return require(name)
end

----------------------------------------------------------------------------------------------------
-- Global namespace
----------------------------------------------------------------------------------------------------
local namespace = {
  -- for UI elements like the winbar and statusline that need global references
  ui = {
    winbar = { enable = true },
    foldtext = { enable = false },
  },
  -- some vim mappings require a mixture of commandline commands and function calls
  -- this table is place to store lua functions to be called in those mappings
  mappings = { enable = true },
}

_G.as = as or namespace

----------------------------------------------------------------------------------------------------
-- Plugin Configurations
----------------------------------------------------------------------------------------------------
-- Order matters here as globals needs to be instantiated first etc.
R('as.globals')
R('as.styles')
R('as.settings')
R('as.plugins')
-----------------------------------------------------------------------------//
-- Color Scheme {{{1
-----------------------------------------------------------------------------//
as.wrap_err('theme failed to load because', vim.cmd.colorscheme, 'horizon')
