return function()
  local telescope = require 'telescope'
  local actions = require 'telescope.actions'
  local themes = require 'telescope.themes'

  require('as.highlights').plugin(
    'telescope',
    { 'TelescopePathSeparator', { guifg = as.style.palette.dark_blue } },
    { 'TelescopeQueryFilter', { link = 'IncSearch' } },
    { 'TelescopeMatching', { link = 'Search', force = true } }
  )

  telescope.setup {
    defaults = {
      set_env = { ['TERM'] = vim.env.TERM },
      prompt_prefix = ' ',
      mappings = {
        i = {
          ['<c-c>'] = function()
            vim.cmd 'stopinsert!'
          end,
          ['<esc>'] = actions.close,
          ['<c-s>'] = actions.select_horizontal,
          ['<c-j>'] = actions.cycle_history_next,
          ['<c-k>'] = actions.cycle_history_prev,
        },
      },
      file_ignore_patterns = { '%.jpg', '%.jpeg', '%.png', '%.otf', '%.ttf' },
      layout_strategy = 'flex',
      winblend = 7,
      history = {
        -- TODO: automate creating this file or create an issue to do that by default
        path = '~/.local/share/nvim/telescope_history.sqlite3',
      },
    },
    extensions = {
      frecency = {
        workspaces = {
          conf = vim.env.DOTFILES,
          project = vim.env.PROJECTS_DIR,
          wiki = vim.g.wiki_path,
        },
      },
      fzf = {
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
      },
    },
    pickers = {
      buffers = {
        sort_lastused = true,
        show_all_buffers = true,
        mappings = {
          i = { ['<c-x>'] = 'delete_buffer' },
          n = { ['<c-x>'] = 'delete_buffer' },
        },
      },
      lsp_code_actions = {
        theme = 'cursor',
      },
      colorscheme = {
        enable_preview = true,
      },
      find_files = {
        hidden = true,
      },
      git_branches = {
        theme = 'dropdown',
      },
      reloader = {
        theme = 'dropdown',
      },
    },
  }

  telescope.load_extension 'fzf'
  telescope.load_extension 'tmux'
  telescope.load_extension 'smart_history'

  --- NOTE: this must be required after setting up telescope
  --- otherwise the result will be cached without the updates
  --- from the setup call
  local builtins = require 'telescope.builtin'

  local function nvim_config()
    builtins.find_files {
      prompt_title = '~ nvim config ~',
      cwd = vim.g.vim_dir,
      file_ignore_patterns = { '.git/.*', 'dotbot/.*' },
    }
  end

  local function frecency()
    telescope.extensions.frecency.frecency(themes.get_dropdown {
      winblend = 10,
      border = true,
      previewer = false,
      shorten_path = false,
    })
  end

  local function tmux_sessions()
    telescope.extensions.tmux.sessions {}
  end

  local function tmux_windows()
    telescope.extensions.tmux.windows {}
  end

  require('which-key').register {
    ['<leader>f'] = {
      name = '+telescope',
      a = { builtins.builtin, 'builtins' },
      g = {
        name = '+git',
        c = { builtins.git_commits, 'commits' },
        b = { builtins.git_branches, 'branches' },
      },
      m = { builtins.man_pages, 'man pages' },
      h = { frecency, 'history' },
      n = { nvim_config, 'nvim config' },
      r = { builtins.reloader, 'module reloader' },
      w = { builtins.lsp_dynamic_workspace_symbols, 'workspace symbols', silent = false },
      t = {
        name = '+tmux',
        s = { tmux_sessions, 'sessions' },
        w = { tmux_windows, 'windows' },
      },
      ['?'] = { builtins.help_tags, 'help' },
    },
    ['<leader>c'] = {
      d = { builtins.lsp_workspace_diagnostics, 'telescope: workspace diagnostics' },
    },
  }
end
