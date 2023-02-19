local fmt, fn, highlight, ui = string.format, vim.fn, as.highlight, as.ui
local icons = ui.icons
local P = ui.palette

local function b() return require('telescope.builtin') end
local function t() return require('telescope') end

---@param opts table
---@return table
local function dropdown(opts)
  opts = opts or {}
  opts.borderchars = {
    { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
    results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
    preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  }
  return require('telescope.themes').get_dropdown(opts)
end

local function delta_opts(opts, is_buf)
  opts = opts or {}
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
  opts.previewer = { delta, previewers.git_commit_message.new(opts) }
  return opts
end

local function nvim_config()
  b().find_files({
    prompt_title = '~ nvim config ~',
    cwd = vim.fn.stdpath('config'),
    file_ignore_patterns = { '.git/.*', 'dotbot/.*', 'zsh/plugins/.*' },
  })
end

local function find_near_files()
  local cwd = require('telescope.utils').buffer_dir()
  b().find_files({
    prompt_title = fmt('Searching %s', fn.fnamemodify(cwd, ':~:.')),
    cwd = cwd,
  })
end

local function live_grep_args()
  t().extensions.live_grep_args.live_grep_args(require('telescope.themes').get_ivy())
end

local function orgfiles()
  b().find_files({ prompt_title = 'Org', cwd = vim.fn.expand('$SYNC_DIR/notes/org/') })
end

local function norgfiles()
  b().find_files({ prompt_title = 'Norg', cwd = vim.fn.expand('$SYNC_DIR/notes/neorg/') })
end

local function project_files()
  if not pcall(b().git_files, { show_untracked = true }) then b().find_files() end
end

local function frecency() t().extensions.frecency.frecency(dropdown({ previewer = false })) end
local function pickers() b().builtin({ include_extensions = true }) end
local function dotfiles() b().find_files({ prompt_title = 'dotfiles', cwd = vim.g.dotfiles }) end
local function notifications() t().extensions.notify.notify(dropdown()) end
local function luasnips() t().extensions.luasnip.luasnip(dropdown()) end
local function delta_git_commits(opts) b().git_commits(delta_opts(opts)) end
local function delta_git_bcommits(opts) b().git_bcommits(delta_opts(opts, true)) end

local function stopinsert(callback)
  return function(prompt_bufnr)
    vim.cmd.stopinsert()
    vim.schedule(function() callback(prompt_bufnr) end)
  end
end

return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  keys = {
    { '<c-p>', project_files, desc = 'find files' },
    { '<leader>fa', pickers, desc = 'builtins' },
    { '<leader>fn', notifications, desc = 'notifications' },
    { '<leader>fb', function() b().current_buffer_fuzzy_find() end, desc = 'search buffer' },
    { '<leader>fls', function() b().lsp_dynamic_workspace_symbols() end, desc = 'symbols' },
    { '<leader>fld', function() b().lsp_document_symbols() end, desc = 'document symbols' },
    { '<leader>fle', function() b().diagnostics() end, desc = 'workspace diagnostics' },
    { '<leader>fva', function() b().autocommands() end, desc = 'autocommands' },
    { '<leader>fvh', function() b().highlights() end, desc = 'highlights' },
    { '<leader>fvk', function() b().keymaps() end, desc = 'autocommands' },
    { '<leader>fvo', function() b().vim_options() end, desc = 'options' },
    { '<leader>fr', function() b().resume() end, desc = 'resume last picker' },
    { '<leader>ff', function() b().find_files() end, desc = 'find files' },
    { '<leader>f?', function() b().help_tags() end, desc = 'help' },
    { '<leader>fL', luasnips, desc = 'luasnip: available snippets' },
    { '<leader>ffn', find_near_files, desc = 'find near files' },
    { '<leader>fh', frecency, desc = 'Most (f)recently used files' },
    { '<leader>fgc', delta_git_commits, desc = 'commits' },
    { '<leader>fgB', delta_git_bcommits, desc = 'buffer commits' },
    { '<leader>fgb', function() b().git_branches() end, desc = 'branches' },
    { '<leader>fo', function() b().buffers() end, desc = 'buffers' },
    { '<leader>fs', live_grep_args, desc = 'live grep' },
    { '<leader>fd', dotfiles, desc = 'dotfiles' },
    { '<leader>fc', nvim_config, desc = 'nvim config' },
    { '<leader>fO', orgfiles, desc = 'org files' },
    { '<leader>fN', norgfiles, desc = 'norg files' },
  },
  dependencies = {
    {
      'natecraddock/telescope-zf-native.nvim',
      config = function() t().load_extension('zf-native') end,
    },
    {
      'nvim-telescope/telescope-smart-history.nvim',
      dependencies = { { 'kkharji/sqlite.lua' } },
      config = function() t().load_extension('smart_history') end,
    },
    {
      'nvim-telescope/telescope-frecency.nvim',
      dependencies = { { 'kkharji/sqlite.lua' } },
      config = function() t().load_extension('frecency') end,
    },
    {
      'nvim-telescope/telescope-live-grep-args.nvim',
      config = function() t().load_extension('live_grep_args') end,
    },
  },
  config = function()
    local actions = require('telescope.actions')
    local themes = require('telescope.themes')
    local layout_actions = require('telescope.actions.layout')
    local lga_actions = require('telescope-live-grep-args.actions')

    as.augroup('TelescopePreviews', {
      {
        event = 'User',
        pattern = 'TelescopePreviewerLoaded',
        command = function(args)
          --- TODO: Contribute upstream change to telescope to pass preview buffer data in autocommand
          local bufname = vim.tbl_get(args, 'data', 'bufname')
          local ft = bufname and require('plenary.filetype').detect(bufname) or nil
          vim.opt_local.number = not ft or ui.settings.get(ft, 'number', 'ft') ~= false
        end,
      },
    })

    highlight.plugin('telescope', {
      theme = {
        ['*'] = {
          { TelescopeBorder = { foreground = P.grey } },
          { TelescopePromptPrefix = { link = 'Statement' } },
          { TelescopeTitle = { inherit = 'Normal', bold = true } },
          { TelescopePromptTitle = { fg = { from = 'Normal' }, bold = true } },
          { TelescopeResultsTitle = { fg = { from = 'Normal' }, bold = true } },
          { TelescopeMatching = { bold = false, foreground = { from = 'Variable', attr = 'fg' } } },
          { TelescopePreviewTitle = { fg = { from = 'Normal' }, bold = true } },
        },
        ['doom-one'] = {
          { TelescopeMatching = { link = 'Title' } },
        },
      },
    })

    require('telescope').setup({
      defaults = {
        borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
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
        history = { path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3' },
        layout_strategy = 'flex',
        layout_config = {
          horizontal = { preview_width = 0.55 },
          -- TODO: I don't think this works but don't know why
          cursor = {
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
          workspaces = { conf = vim.env.DOTFILES, project = vim.env.PROJECTS_DIR },
        },
        live_grep_args = {
          mappings = { -- extend mappings
            i = {
              ['<C-k>'] = lga_actions.quote_prompt(),
              ['<C-i>'] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
            },
          },
        },
      },
      pickers = {
        buffers = dropdown({
          sort_mru = true,
          sort_lastused = true,
          show_all_buffers = true,
          ignore_current_buffer = true,
          previewer = false,
          mappings = { i = { ['<c-x>'] = 'delete_buffer' }, n = { ['<c-x>'] = 'delete_buffer' } },
        }),
        registers = dropdown({ layout_config = { height = 25 } }),
        oldfiles = dropdown(),
        live_grep = themes.get_ivy({
          file_ignore_patterns = { '.git/', '%.svg', '%.lock' },
          max_results = 2000,
        }),
        current_buffer_fuzzy_find = dropdown({ previewer = false, shorten_path = false }),
        colorscheme = { enable_preview = true },
        find_files = { hidden = true },
        keymaps = dropdown({ layout_config = { height = 18, width = 0.5 } }),
        git_branches = dropdown(),
        git_bcommits = { layout_config = { horizontal = { preview_width = 0.55 } } },
        git_commits = { layout_config = { horizontal = { preview_width = 0.55 } } },
        diagnostics = dropdown(),
        reloader = dropdown(),
      },
    })
  end,
}
