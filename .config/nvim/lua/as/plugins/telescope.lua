as.telescope = {}

local fmt, fn, highlight = string.format, vim.fn, as.highlight

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

local function config()
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  local layout_actions = require('telescope.actions.layout')
  local icons = as.style.icons
  local P = as.style.palette

  as.augroup('TelescopePreviews', {
    {
      event = 'User',
      pattern = 'TelescopePreviewerLoaded',
      command = 'setlocal number',
    },
  })

  highlight.plugin('telescope', {
    theme = {
      ['*'] = {
        { TelescopePromptTitle = { bg = P.grey, fg = { from = 'Directory' }, bold = true } },
        { TelescopeResultsTitle = { bg = P.grey, fg = { from = 'Normal' }, bold = true } },
        { TelescopePreviewTitle = { bg = P.grey, fg = { from = 'Normal' }, bold = true } },
        { TelescopePreviewBorder = { fg = P.grey, bg = { from = 'PanelBackground' } } },
        { TelescopePreviewNormal = { link = 'PanelBackground' } },
        { TelescopePromptPrefix = { link = 'Statement' } },
        { TelescopeBorder = { foreground = P.grey } },
        { TelescopeTitle = { inherit = 'Normal', bold = true } },
        {
          TelescopeSelectionCaret = {
            fg = { from = 'Identifier' },
            bg = { from = 'TelescopeSelection' },
          },
        },
      },
      ['horizon'] = {
        { TelescopePromptTitle = { bg = P.grey, fg = 'fg', bold = true } },
        { TelescopeMatching = { bold = false, foreground = { from = 'Variable', attr = 'fg' } } },
        { TelescopePreviewBorder = { fg = P.grey, bg = { from = 'PanelDarkBackground' } } },
        { TelescopePreviewNormal = { link = 'PanelDarkBackground' } },
      },
      ['doom-one'] = {
        { TelescopeMatching = { link = 'Title' } },
      },
    },
  })
  local function stopinsert(callback)
    return function(prompt_bufnr)
      vim.cmd.stopinsert()
      vim.schedule(function() callback(prompt_bufnr) end)
    end
  end

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
          ['<c-c>'] = function() vim.cmd.stopinsert() end,
          ['<esc>'] = actions.close,
          ['<c-s>'] = actions.select_horizontal,
          ['<c-j>'] = actions.cycle_history_next,
          ['<c-k>'] = actions.cycle_history_prev,
          ['<c-e>'] = layout_actions.toggle_preview,
          ['<c-l>'] = layout_actions.cycle_layout_next,
          ['<c-/>'] = actions.which_key,
          ['<Tab>'] = actions.toggle_selection,
          ['<CR>'] = stopinsert(actions.select_default),
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
        '^.yarn/',
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
      frecency = {
        default_workspace = 'CWD',
        show_unindexed = false, -- Show all files or only those that have been indexed
        ignore_patterns = { '*.git/*', '*/tmp/*', '*node_modules/*', '*vendor/*' },
        workspaces = {
          conf = vim.env.DOTFILES,
          project = vim.env.PROJECTS_DIR,
        },
      },
      live_grep_args = (function()
        local lga_actions = require('telescope-live-grep-args.actions')
        return {
          mappings = { -- extend mappings
            i = {
              ['<C-k>'] = lga_actions.quote_prompt(),
              ['<C-i>'] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
            },
          },
        }
      end)(),
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
      registers = as.telescope.dropdown({
        layout_config = {
          height = 25,
        },
      }),
      oldfiles = as.telescope.dropdown(),
      live_grep = as.telescope.ivy({
        file_ignore_patterns = { '.git/', '%.svg', '%.lock' },
        max_results = 2000,
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
end

local function builtins() return require('telescope.builtin') end
local function telescope() return require('telescope') end

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
  opts.previewer = { delta, previewers.git_commit_message.new(opts) }
  return opts
end

local function nvim_config()
  builtins().find_files({
    prompt_title = '~ nvim config ~',
    cwd = vim.fn.stdpath('config'),
    file_ignore_patterns = { '.git/.*', 'dotbot/.*', 'zsh/plugins/.*' },
  })
end

local function find_near_files()
  local cwd = require('telescope.utils').buffer_dir()
  builtins().find_files({
    prompt_title = fmt('Searching %s', fn.fnamemodify(cwd, ':~:.')),
    cwd = cwd,
  })
end

local function live_grep_args()
  telescope().extensions.live_grep_args.live_grep_args(as.telescope.ivy())
end

local function orgfiles()
  builtins().find_files({ prompt_title = 'Org', cwd = vim.fn.expand('$SYNC_DIR/org/') })
end

local function norgfiles()
  builtins().find_files({ prompt_title = 'Norg', cwd = vim.fn.expand('$SYNC_DIR/neorg/') })
end

local function project_files(opts)
  if not pcall(builtins().git_files, opts) then builtins().find_files(opts) end
end

local function frecency()
  telescope().extensions.frecency.frecency(as.telescope.dropdown({ previewer = false }))
end

local function pickers() builtins().builtin({ include_extensions = true }) end
local function dotfiles() builtins().find_files({ prompt_title = 'dotfiles', cwd = vim.g.dotfiles }) end
local function notifications() telescope().extensions.notify.notify(as.telescope.dropdown()) end
local function luasnips() telescope().extensions.luasnip.luasnip(as.telescope.dropdown()) end
local function delta_git_commits(opts) builtins().git_commits(delta_opts(opts)) end
local function delta_git_bcommits(opts) builtins().git_bcommits(delta_opts(opts, true)) end

return {
  {
    'nvim-telescope/telescope.nvim',
    config = config,
    keys = {
      { '<c-p>', project_files, desc = 'find files' },
      { '<leader>fa', pickers, desc = 'builtins' },
      {
        '<leader>fb',
        function() builtins().current_buffer_fuzzy_find() end,
        desc = 'current buffer fuzzy find',
      },
      { '<leader>fn', notifications, desc = 'notifications' },
      { '<leader>fvh', function() builtins().highlights() end, desc = 'highlights' },
      { '<leader>fva', function() builtins().autocommands() end, desc = 'autocommands' },
      { '<leader>fvo', function() builtins().vim_options() end, desc = 'options' },
      { '<leader>fvk', function() builtins().keymaps() end, desc = 'autocommands' },
      { '<leader>fle', function() builtins().diagnostics() end, desc = 'workspace diagnostics' },
      {
        '<leader>fld',
        function() builtins().lsp_document_symbols() end,
        desc = 'document symbols',
      },
      {
        '<leader>fls',
        function() builtins().lsp_dynamic_workspace_symbols() end,
        desc = 'workspace symbols',
      },
      { '<leader>fL', luasnips, desc = 'luasnip: available snippets' },
      { '<leader>fr', function() builtins().resume() end, desc = 'resume last picker' },
      { '<leader>f?', function() builtins().help_tags() end, desc = 'help' },
      { '<leader>ff', function() builtins().find_files() end, desc = 'find files' },
      { '<leader>ffn', find_near_files, desc = 'find near files' },
      { '<leader>fh', frecency, desc = 'Most (f)recently used files' },
      { '<leader>fgb', function() builtins().git_branches() end, desc = 'branches' },
      { '<leader>fgc', delta_git_commits, desc = 'commits' },
      { '<leader>fgB', delta_git_bcommits, desc = 'buffer commits' },
      { '<leader>fo', function() builtins().buffers() end, desc = 'buffers' },
      { '<leader>fs', live_grep_args, desc = 'live grep' },
      { '<leader>fd', dotfiles, desc = 'dotfiles' },
      { '<leader>fc', nvim_config, desc = 'nvim config' },
      { '<leader>fO', orgfiles, desc = 'org files' },
      { '<leader>fN', norgfiles, desc = 'norg files' },
    },
    dependencies = {
      {
        'natecraddock/telescope-zf-native.nvim',
        config = function() require('telescope').load_extension('zf-native') end,
      },
      {
        'nvim-telescope/telescope-smart-history.nvim',
        dependencies = { { 'kkharji/sqlite.lua' } },
        config = function() require('telescope').load_extension('smart_history') end,
      },
      {
        'nvim-telescope/telescope-frecency.nvim',
        dependencies = { { 'kkharji/sqlite.lua' } },
        config = function() require('telescope').load_extension('frecency') end,
      },
      {
        'benfowler/telescope-luasnip.nvim',
        config = function() require('telescope').load_extension('luasnip') end,
      },
      {
        'nvim-telescope/telescope-live-grep-args.nvim',
        config = function() require('telescope').load_extension('live_grep_args') end,
      },
    },
  },
}
