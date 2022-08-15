local M = {}

as.telescope = {}

local function rectangular_border(opts)
  return vim.tbl_deep_extend('force', opts or {}, {
    borderchars = {
      prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
      results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
      preview = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    },
  })
end

---@param opts table?
---@return table
function as.telescope.dropdown(opts)
  return require('telescope.themes').get_dropdown(rectangular_border(opts))
end

function as.telescope.ivy(opts)
  return require('telescope.themes').get_ivy(vim.tbl_deep_extend('keep', opts or {}, {
    borderchars = {
      preview = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    },
  }))
end

function M.config()
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  local layout_actions = require('telescope.actions.layout')
  local which_key = require('which-key')
  local H = require('as.highlights')
  local icons = as.style.icons

  as.augroup('TelescopePreviews', {
    {
      event = 'User',
      pattern = 'TelescopePreviewerLoaded',
      command = 'setlocal number',
    },
  })

  H.plugin('telescope', {
    theme = {
      ['*'] = {
        {
          TelescopePromptTitle = {
            bg = as.style.palette.grey,
            fg = { from = 'Directory' },
            bold = true,
          },
        },
        {
          TelescopeResultsTitle = {
            bg = as.style.palette.grey,
            fg = { from = 'Normal' },
            bold = true,
          },
        },
        {
          TelescopePreviewTitle = {
            bg = as.style.palette.grey,
            fg = { from = 'Normal' },
            bold = true,
          },
        },
        {
          TelescopePreviewBorder = {
            fg = as.style.palette.grey,
            bg = { from = 'PanelBackground' },
          },
        },
        { TelescopePreviewNormal = { link = 'PanelBackground' } },
        { TelescopePromptPrefix = { link = 'Statement' } },
        { TelescopeBorder = { foreground = as.style.palette.grey } },
        { TelescopeTitle = { inherit = 'Normal', bold = true } },
        {
          TelescopeSelectionCaret = {
            fg = { from = 'Identifier' },
            bg = { from = 'TelescopeSelection' },
          },
        },
      },
      ['horizon'] = {
        { TelescopeMatching = { bold = false, foreground = { from = 'Variable', attr = 'fg' } } },
      },
      ['doom-one'] = {
        { TelescopeMatching = { link = 'Title' } },
      },
    },
  })

  telescope.setup({
    defaults = {
      set_env = { ['TERM'] = vim.env.TERM },
      borderchars = {
        prompt = { ' ', '▕', '▁', '▏', '▏', '▕', '🭿', '🭼' },
        results = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
        preview = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
      },
      dynamic_preview_title = true,
      prompt_prefix = icons.misc.telescope .. ' ',
      selection_caret = icons.misc.chevron_right .. ' ',
      cycle_layout_list = { 'flex', 'horizontal', 'vertical', 'bottom_pane', 'center' },
      mappings = {
        i = {
          ['<C-w>'] = actions.send_selected_to_qflist,
          ['<c-c>'] = function() vim.cmd.stopinsert({ bang = true }) end,
          ['<esc>'] = actions.close,
          ['<c-s>'] = actions.select_horizontal,
          ['<c-j>'] = actions.cycle_history_next,
          ['<c-k>'] = actions.cycle_history_prev,
          ['<c-e>'] = layout_actions.toggle_preview,
          ['<c-l>'] = layout_actions.cycle_layout_next,
          ['<c-/>'] = actions.which_key,
          ['<Tab>'] = actions.toggle_selection,
        },
        n = {
          ['<C-w>'] = actions.send_selected_to_qflist,
        },
      },
      file_ignore_patterns = {
        '%.jpg',
        '%.jpeg',
        '%.png',
        '%.otf',
        '%.ttf',
        '%.DS_Store',
        '^.git/',
        '^node_modules/',
        '^site-packages/',
      },
      path_display = { 'truncate' },
      winblend = 5,
      history = {
        path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
      },
      layout_strategy = 'flex',
      layout_config = {
        horizontal = {
          preview_width = 0.55,
        },
        cursor = { -- TODO: I don't think this works but don't know why
          width = 0.4,
          height = function(self, _, max_lines)
            local results = #self.finder.results
            local PADDING = 4 -- this represents the size of the telescope window
            local LIMIT = math.floor(max_lines / 2)
            return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
          end,
        },
      },
    },
    extensions = {
      fzf = {
        override_generic_sorter = true,
        override_file_sorter = true,
      },
    },
    pickers = {
      buffers = as.telescope.dropdown({
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
      oldfiles = as.telescope.dropdown(),
      live_grep = as.telescope.ivy({
        file_ignore_patterns = { '.git/', '%.svg', '%.lock' },
        max_results = 2000,
        on_input_filter_cb = function(prompt)
          -- AND operator for live_grep like how fzf handles spaces with wildcards in rg
          return { prompt = prompt:gsub('%s', '.*') }
        end,
      }),
      current_buffer_fuzzy_find = as.telescope.dropdown({
        previewer = false,
        shorten_path = false,
      }),
      colorscheme = {
        enable_preview = true,
      },
      find_files = {
        hidden = true,
      },
      keymaps = as.telescope.dropdown({
        layout_config = {
          height = 18,
          width = 0.5,
        },
      }),
      git_branches = as.telescope.dropdown(),
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
      reloader = as.telescope.dropdown(),
    },
  })

  --- NOTE: this must be required after setting up telescope
  --- otherwise the result will be cached without the updates
  --- from the setup call
  local builtins = require('telescope.builtin')

  local function nvim_config()
    builtins.find_files({
      prompt_title = '~ nvim config ~',
      cwd = vim.fn.stdpath('config'),
      file_ignore_patterns = {
        '.git/.*',
        'dotbot/.*',
        'zsh/plugins/.*',
      },
    })
  end

  local function delta_opts(opts, is_buf)
    local previewers = require('telescope.previewers')
    local delta = previewers.new_termopen_previewer({
      get_command = function(entry)
        local args = {
          'git',
          '-c',
          'core.pager=delta',
          '-c',
          'delta.side-by-side=false',
          'diff',
          entry.value .. '^!',
        }
        if is_buf then vim.list_extend(args, { '--', entry.current_file }) end
        return args
      end,
    })
    opts = opts or {}
    opts.previewer = {
      delta,
      previewers.git_commit_message.new(opts),
    }
    return opts
  end

  local function delta_git_commits(opts) builtins.git_commits(delta_opts(opts)) end

  local function delta_git_bcommits(opts) builtins.git_bcommits(delta_opts(opts, true)) end

  local function dotfiles()
    builtins.find_files({
      prompt_title = 'dotfiles',
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

  local function project_files(opts)
    if not pcall(builtins.git_files, opts) then builtins.find_files(opts) end
  end

  local function pickers() builtins.builtin({ include_extensions = true }) end

  local function find_files() builtins.find_files() end

  local function buffers() builtins.buffers() end

  local function live_grep() builtins.live_grep() end

  local function MRU()
    require('mru').display_cache(as.telescope.dropdown({
      previewer = false,
    }))
  end

  local function MFU()
    require('mru').display_cache(
      vim.tbl_extend('keep', { algorithm = 'mfu' }, as.telescope.dropdown({ previewer = false }))
    )
  end

  local function notifications() telescope.extensions.notify.notify(as.telescope.dropdown()) end

  local function gh_notifications() telescope.extensions.ghn.ghn(as.telescope.dropdown()) end

  local function installed_plugins()
    builtins.find_files({
      prompt_title = 'Installed plugins',
      cwd = vim.fn.stdpath('data') .. '/site/pack/packer',
    })
  end

  which_key.register({
    ['<c-p>'] = { project_files, 'telescope: find files' },
    ['<leader>f'] = {
      name = '+telescope',
      a = { pickers, 'builtins' },
      b = { builtins.current_buffer_fuzzy_find, 'current buffer fuzzy find' },
      n = { notifications, 'notifications' },
      v = {
        name = '+vim',
        h = { builtins.highlights, 'highlights' },
        a = { builtins.autocommands, 'autocommands' },
        o = { builtins.vim_options, 'options' },
      },
      l = {
        name = '+lsp',
        e = { builtins.diagnostics, 'telescope: workspace diagnostics' },
        d = { builtins.lsp_document_symbols, 'telescope: document symbols' },
        s = { builtins.lsp_dynamic_workspace_symbols, 'telescope: workspace symbols' },
      },
      p = { installed_plugins, 'plugins' },
      r = { builtins.resume, 'resume last picker' },
      ['?'] = { builtins.help_tags, 'help' },
      f = { find_files, 'find files' },
      u = { MRU, 'Most recently used files' },
      h = { MFU, 'Most frequently used files' },
      g = {
        name = '+git',
        b = { builtins.git_branches, 'branches' },
        n = { gh_notifications, 'notifications' },
        c = { delta_git_commits, 'commits' },
        B = { delta_git_bcommits, 'buffer commits' },
      },
      o = { buffers, 'buffers' },
      s = { live_grep, 'live grep' },
      d = { dotfiles, 'dotfiles' },
      c = { nvim_config, 'nvim config' },
      O = { orgfiles, 'org files' },
      N = { norgfiles, 'norg files' },
    },
  })

  vim.api.nvim_exec_autocmds('User', { pattern = 'TelescopeConfigComplete', modeline = false })
end

return M
