----------------------------------------------------------------------------------------------------
--       _/_/    _/    _/
--    _/    _/  _/  _/      Akin Sowemimo's dotfiles
--   _/_/_/_/  _/_/         https://github.com/akinsho
--  _/    _/  _/  _/
-- _/    _/  _/    _/
----------------------------------------------------------------------------------------------------
local g, fn, opt, loop, env = vim.g, vim.fn, vim.opt, vim.loop, vim.env
local data = fn.stdpath('data')

g.os = loop.os_uname().sysname
g.open_command = g.os == 'Darwin' and 'open' or 'xdg-open'

g.dotfiles = env.DOTFILES or fn.expand('~/.dotfiles')
g.vim_dir = g.dotfiles .. '/.config/nvim'
g.projects_dir = env.PROJECTS_DIR or fn.expand('~/projects')
----------------------------------------------------------------------------------------------------
-- Ensure all autocommands are cleared
vim.api.nvim_create_augroup('vimrc', {})
----------------------------------------------------------------------------------------------------
-- Leader bindings
----------------------------------------------------------------------------------------------------
g.mapleader = ',' -- Remap leader key
g.maplocalleader = ' ' -- Local leader is <Space>

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
-- Settings
----------------------------------------------------------------------------------------------------
-- Order matters here as globals needs to be instantiated first etc.
R('as.globals')
R('as.styles')
R('as.settings')
R('as.plugins')
-----------------------------------------------------------------------------//
-- Plugins
-----------------------------------------------------------------------------//
local lazypath = data .. '/lazy/lazy.nvim'
if not loop.fs_stat(lazypath) then
  fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
opt.runtimepath:prepend(lazypath)
-----------------------------------------------------------------------------
require('lazy').setup('as.plugins', {
  defaults = { lazy = true },
  rtp = {
    paths = { data .. '/site' },
    disabled_plugins = {
      'netrw',
      'netrwPlugin',
      'tarPlugin',
      'tutor',
      'tohtml',
      'logipat',
    },
  },
  ui = { border = as.style.current.border },
  dev = { path = g.projects_dir .. '/personal/', patterns = { 'akinsho' } },
  install = { colorscheme = { 'horizon' } },
})

as.nnoremap('<leader>ps', '<Cmd>Lazy<CR>')
as.nnoremap('<leader>pc', '<Cmd>Lazy clean<CR>')
-----------------------------------------------------------------------------//
-- Builtin Packages
-----------------------------------------------------------------------------//
-- cfilter plugin allows filtering down an existing quickfix list
vim.cmd.packadd('cfilter')
-----------------------------------------------------------------------------//
-- Color Scheme {{{1
-----------------------------------------------------------------------------//
as.wrap_err('theme failed to load because', vim.cmd.colorscheme, 'horizon')
