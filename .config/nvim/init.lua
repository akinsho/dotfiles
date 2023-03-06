----------------------------------------------------------------------------------------------------
--       _/_/    _/    _/
--    _/    _/  _/  _/      Akin Sowemimo's dotfiles
--   _/_/_/_/  _/_/         https://github.com/akinsho
--  _/    _/  _/  _/
-- _/    _/  _/    _/
----------------------------------------------------------------------------------------------------
if vim.g.vscode then return end -- if someone has forced me to use vscode don't load my config

local g, fn, opt, loop, env, cmd = vim.g, vim.fn, vim.opt, vim.loop, vim.env, vim.cmd
local data = fn.stdpath('data')

g.os = loop.os_uname().sysname
g.open_command = g.os == 'Darwin' and 'open' or 'xdg-open'

g.dotfiles = env.DOTFILES or fn.expand('~/.dotfiles')
g.vim_dir = g.dotfiles .. '/.config/nvim'
g.projects_dir = env.PROJECTS_DIR or fn.expand('~/projects')
g.work_dir = vim.env.PROJECTS_DIR .. '/work'
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
  ui = {
    winbar = { enable = true },
    foldtext = { enable = false },
  },
  -- some vim mappings require a mixture of commandline commands and function calls
  -- this table is place to store lua functions to be called in those mappings
  mappings = { enable = true },
}

-- This table is a globally accessible store to facilitating accessing
-- helper functions and variables throughout my config
_G.as = as or namespace

_G.map = vim.keymap.set
----------------------------------------------------------------------------------------------------
-- Settings
----------------------------------------------------------------------------------------------------
-- Order matters here as globals needs to be instantiated first etc.
R('as.globals')
R('as.highlights')
R('as.ui')
R('as.settings')
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
  ui = { border = as.ui.current.border },
  defaults = { lazy = true },
  change_detection = { notify = false },
  checker = {
    enabled = true,
    concurrency = 30,
    notify = false,
    frequency = 3600, -- check for updates every hour
  },
  performance = {
    rtp = {
      paths = { data .. '/site' },
      disabled_plugins = { 'netrw', 'netrwPlugin' },
    },
  },
  dev = {
    path = g.projects_dir .. '/personal/',
    patterns = { 'akinsho' },
    fallback = true,
  },
})

map('n', '<leader>pm', '<Cmd>Lazy<CR>', { desc = 'manage' })
-----------------------------------------------------------------------------//
-- Builtin Packages
-----------------------------------------------------------------------------//
-- cfilter plugin allows filtering down an existing quickfix list
cmd.packadd('cfilter')
-----------------------------------------------------------------------------//
-- Color Scheme {{{1
-----------------------------------------------------------------------------//
as.wrap_err('theme failed to load because', cmd.colorscheme, 'horizon')
