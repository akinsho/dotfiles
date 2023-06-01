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

if vim.loader then vim.loader.enable() end

g.os = loop.os_uname().sysname
g.open_command = g.os == 'Darwin' and 'open' or 'xdg-open'

g.dotfiles = env.DOTFILES or fn.expand('~/.dotfiles')
g.vim_dir = g.dotfiles .. '/.config/nvim'
g.projects_dir = env.PROJECTS_DIR or fn.expand('~/projects')
g.work_dir = g.projects_dir .. '/work'
----------------------------------------------------------------------------------------------------
-- Leader bindings
----------------------------------------------------------------------------------------------------
g.mapleader = ',' -- Remap leader key
g.maplocalleader = ' ' -- Local leader is <Space>
----------------------------------------------------------------------------------------------------
-- Global namespace
----------------------------------------------------------------------------------------------------

local namespace = {
  ui = {
    winbar = { enable = false },
    statuscolumn = { enable = true },
    statusline = { enable = true },
  },
  -- some vim mappings require a mixture of commandline commands and function calls
  -- this table is place to store lua functions to be called in those mappings
  mappings = { enable = true },
}

-- This table is a globally accessible store to facilitating accessing
-- helper functions and variables throughout my config
_G.as = as or namespace
_G.map = vim.keymap.set
_G.P = vim.print

----------------------------------------------------------------------------------------------------
-- Settings
----------------------------------------------------------------------------------------------------
-- Order matters here as globals needs to be instantiated first etc.
require('as.globals')
require('as.highlights')
require('as.ui')
require('as.settings')
------------------------------------------------------------------------------------------------------
-- Plugins
------------------------------------------------------------------------------------------------------
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
  vim.notify('Installed lazy.nvim')
end
opt.runtimepath:prepend(lazypath)
----------------------------------------------------------------------------------------------------
--  $NVIM
----------------------------------------------------------------------------------------------------
-- NOTE: this must happen after the lazy path is setup

-- If opening from inside neovim terminal then do not load other plugins
if env.NVIM then return require('lazy').setup({ { 'willothy/flatten.nvim', config = true } }) end
------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------
-- Builtin Packages
------------------------------------------------------------------------------------------------------
-- cfilter plugin allows filtering down an existing quickfix list
cmd.packadd('cfilter')
------------------------------------------------------------------------------------------------------
-- Colour Scheme {{{1
------------------------------------------------------------------------------------------------------
as.pcall('theme failed to load because', cmd.colorscheme, 'horizon')
