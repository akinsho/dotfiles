return function()
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  local layout_actions = require('telescope.actions.layout')
  local themes = require('telescope.themes')
  local H = require('as.highlights')
  local icons = as.style.icons

  H.plugin('telescope', {
    TelescopePromptTitle = { fg = { from = 'Directory' }, bold = true },
    TelescopeResultsTitle = { fg = { from = 'Normal' }, bold = true },
    TelescopePreviewTitle = { fg = { from = 'Normal' }, bold = true },

    TelescopePromptPrefix = { link = 'Statement' },
    TelescopeBorder = { foreground = as.style.palette.grey },
    TelescopeMatching = { link = 'Title' },
    TelescopeTitle = { inherit = 'Normal', bold = true },
    TelescopeSelectionCaret = {
      fg = { from = 'Identifier' },
      bg = { from = 'TelescopeSelection' },
    },
  })

  local function rectangular_border(opts)
    return vim.tbl_deep_extend('force', opts or {}, {
      borderchars = {
        prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
        results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
        preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      },
    })
  end

  ---@param opts table?
  ---@return table
  local function dropdown(opts)
    return themes.get_dropdown(rectangular_border(opts))
  end

  telescope.setup({
    defaults = {
      set_env = { ['TERM'] = vim.env.TERM },
      borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      dynamic_preview_title = true,
      prompt_prefix = icons.misc.telescope .. ' ',
      selection_caret = icons.misc.chevron_right .. ' ',
      mappings = {
        i = {
          ['<C-w>'] = actions.send_selected_to_qflist,
          ['<c-c>'] = function()
            vim.cmd('stopinsert!')
          end,
          ['<esc>'] = actions.close,
          ['<c-s>'] = actions.select_horizontal,
          ['<c-j>'] = actions.cycle_history_next,
          ['<c-k>'] = actions.cycle_history_prev,
          ['<c-e>'] = layout_actions.toggle_preview,
          ['<c-l>'] = layout_actions.cycle_layout_next,
        },
        n = {
          ['<C-w>'] = actions.send_selected_to_qflist,
        },
      },
      file_ignore_patterns = { '%.jpg', '%.jpeg', '%.png', '%.otf', '%.ttf', '%.DS_Store' },
      path_display = { 'smart', 'absolute', 'truncate' },
      layout_strategy = 'flex',
      layout_config = {
        horizontal = {
          preview_width = 0.45,
        },
        cursor = { -- FIXME: this does not change the size of the cursor layout
          width = 0.4,
          height = function(self, _, max_lines)
            local results = #self.finder.results
            return (results <= max_lines and results or max_lines - 10) + 4
          end,
        },
      },
      winblend = 5,
      history = {
        path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
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
        override_generic_sorter = true,
        override_file_sorter = true,
      },
    },
    pickers = {
      buffers = dropdown({
        sort_mru = true,
        sort_lastused = true,
        show_all_buffers = true,
        ignore_current_buffer = true,
        previewer = false,
        mappings = {
          i = { ['<c-x>'] = 'delete_buffer' },
          n = { ['<c-x>'] = 'delete_buffer' },
        },
      }),
      oldfiles = dropdown(),
      live_grep = {
        file_ignore_patterns = { '.git/' },
        on_input_filter_cb = function(prompt)
          -- AND operator for live_grep like how fzf handles spaces with wildcards in rg
          return { prompt = prompt:gsub('%s', '.*') }
        end,
      },
      current_buffer_fuzzy_find = dropdown({
        previewer = false,
        shorten_path = false,
      }),
      colorscheme = {
        enable_preview = true,
      },
      find_files = {
        hidden = true,
      },
      git_branches = dropdown(),
      git_bcommits = {
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
      },
      git_commits = {
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
      },
      reloader = dropdown(),
    },
  })

  --- NOTE: this must be required after setting up telescope
  --- otherwise the result will be cached without the updates
  --- from the setup call
  local builtins = require('telescope.builtin')

  local function project_files(opts)
    if not pcall(builtins.git_files, opts) then
      builtins.find_files(opts)
    end
  end

  local function nvim_config()
    builtins.find_files({
      prompt_title = '~ nvim config ~',
      cwd = vim.fn.stdpath('config'),
      file_ignore_patterns = { '.git/.*', 'dotbot/.*' },
    })
  end

  local function dotfiles()
    builtins.find_files({
      prompt_title = '~ dotfiles ~',
      cwd = vim.g.dotfiles,
    })
  end

  local function orgfiles()
    builtins.find_files({
      prompt_title = 'Org',
      cwd = vim.fn.expand('$SYNC_DIR/org/'),
    })
  end

  local function norgfiles()
    builtins.find_files({
      prompt_title = 'Norg',
      cwd = vim.fn.expand('$SYNC_DIR/neorg/'),
    })
  end

  local function frecency()
    telescope.extensions.frecency.frecency(dropdown({
      winblend = 10,
      border = true,
      previewer = false,
      shorten_path = false,
    }))
  end

  local function MRU()
    require('mru').display_cache(dropdown({
      previewer = false,
    }))
  end

  local function MFU()
    require('mru').display_cache(
      vim.tbl_extend('keep', { algorithm = 'mfu' }, dropdown({ previewer = false }))
    )
  end

  local function notifications()
    telescope.extensions.notify.notify(dropdown())
  end

  local function gh_notifications()
    telescope.extensions.ghn.ghn(dropdown())
  end

  local function installed_plugins()
    require('telescope.builtin').find_files({
      prompt_title = '~ plugins ~',
      cwd = vim.fn.stdpath('data') .. '/site/pack/packer',
    })
  end

  require('which-key').register({
    ['<c-p>'] = { project_files, 'telescope: find files' },
    ['<leader>f'] = {
      name = '+telescope',
      a = { builtins.builtin, 'builtins' },
      b = { builtins.current_buffer_fuzzy_find, 'current buffer fuzzy find' },
      d = { dotfiles, 'dotfiles' },
      f = { builtins.find_files, 'find files' },
      n = { notifications, 'notifications' },
      g = {
        name = '+git',
        c = { builtins.git_commits, 'commits' },
        b = { builtins.git_branches, 'branches' },
        n = { gh_notifications, 'notifications' },
      },
      l = {
        name = '+lsp',
        e = { builtins.lsp_workspace_diagnostics, 'telescope: workspace diagnostics' },
        d = { builtins.lsp_document_symbols, 'telescope: document symbols' },
        s = { builtins.lsp_dynamic_workspace_symbols, 'telescope: workspace symbols' },
      },
      m = { MRU, 'Most recently used files' },
      F = { MFU, 'Most frequently used files' },
      h = { frecency, 'Frecency' },
      c = { nvim_config, 'nvim config' },
      o = { builtins.buffers, 'buffers' },
      p = { installed_plugins, 'plugins' },
      O = { orgfiles, 'org files' },
      N = { norgfiles, 'norg files' },
      R = { builtins.reloader, 'module reloader' },
      r = { builtins.resume, 'resume last picker' },
      s = { builtins.live_grep, 'grep string' },
      ['?'] = { builtins.help_tags, 'help' },
    },
  })
end
