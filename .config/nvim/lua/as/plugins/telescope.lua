local fn, highlight, ui = vim.fn, as.highlight, as.ui
local icons = ui.icons
local P = ui.palette

-- A helper function to limit the size of a telescope window to fit the maximum available
-- space on the screen. This is useful for dropdowns e.g. the cursor or dropdown theme
local function fit_to_available_height(self, _, max_lines)
  local results, PADDING = #self.finder.results, 4 -- this represents the size of the telescope window
  local LIMIT = math.floor(max_lines / 2)
  return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
end

---@param opts table
---@return table
local function dropdown(opts)
  return require('telescope.themes').get_dropdown(vim.tbl_extend('keep', opts or {}, {
    borderchars = {
      { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
      results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    },
  }))
end

local function cursor(opts)
  return require('telescope.themes').get_cursor(vim.tbl_extend('keep', opts or {}, {
    layout_config = {
      width = 0.4,
      height = fit_to_available_height,
    },
  }))
end

as.telescope = {
  cursor = cursor,
  dropdown = dropdown,
  adaptive_dropdown = function(_) return dropdown({ height = fit_to_available_height }) end,
}

local function extensions(name) return require('telescope').extensions[name] end

local function live_grep(opts) return extensions('menufacture').live_grep(opts) end
local function find_files(opts) return extensions('menufacture').find_files(opts) end
local function git_files(opts) return extensions('menufacture').git_files(opts) end

local function project_files()
  if not pcall(git_files) then find_files() end
end

local function orgfiles()
  find_files({ prompt_title = 'Org', cwd = fn.expand('$SYNC_DIR/notes/org/') })
end

local function norgfiles()
  find_files({ prompt_title = 'Norg', cwd = fn.expand('$SYNC_DIR/notes/neorg/') })
end

local function frecency() extensions('frecency').frecency(dropdown({ previewer = false })) end
local function luasnips() extensions('luasnip').luasnip(dropdown()) end
local function notifications() extensions('notify').notify(dropdown()) end
local function pickers() require('telescope.builtin').builtin({ include_extensions = true }) end

local function dotfiles()
  find_files({
    prompt_title = 'dotfiles',
    cwd = vim.g.dotfiles,
    file_ignore_patterns = { '.git/.*', 'dotbot/.*', 'zsh/plugins/.*' },
  })
end

local function stopinsert(callback)
  return function(prompt_bufnr)
    vim.cmd.stopinsert()
    vim.schedule(function() callback(prompt_bufnr) end)
  end
end

local function b(picker) return require('telescope.builtin')[picker] end

return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  keys = {
    { '<leader>fa', pickers, desc = 'builtins' },
    { '<leader>fd', dotfiles, desc = 'dotfiles' },
    { '<leader>fs', live_grep, desc = 'live grep' },
    { '<leader>fO', orgfiles, desc = 'org files' },
    { '<leader>fN', norgfiles, desc = 'norg files' },
    { '<leader>ff', find_files, desc = 'find files' },
    { '<c-p>', project_files, desc = 'find project files' },
    { '<leader>fn', notifications, desc = 'notifications' },
    { '<leader>fL', luasnips, desc = 'luasnip: available snippets' },
    { '<leader>fh', frecency, desc = 'Most (f)recently used files' },
    { '<leader>fls', b('lsp_dynamic_workspace_symbols'), desc = 'symbols' },
    { '<leader>fld', b('lsp_document_symbols'), desc = 'document symbols' },
    { '<leader>fle', b('diagnostics'), desc = 'workspace diagnostics' },
    { '<leader>fva', b('autocommands'), desc = 'autocommands' },
    { '<leader>fvh', b('highlights'), desc = 'highlights' },
    { '<leader>fvk', b('keymaps'), desc = 'autocommands' },
    { '<leader>fvo', b('vim_options'), desc = 'options' },
    { '<leader>fgc', b('git_commits'), desc = 'commits' },
    { '<leader>fgB', b('git_bcommits'), desc = 'buffer commits' },
    { '<leader>fgb', b('git_branches'), desc = 'branches' },
    { '<leader>fr', b('resume'), desc = 'resume last picker' },
    { '<leader>f?', b('help_tags'), desc = 'help' },
    { '<leader>fb', b('current_buffer_fuzzy_find'), desc = 'search buffer' },
    { '<leader>fo', b('buffers'), desc = 'buffers' },
    { '<localleader>p', b('registers'), desc = 'registers' },
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
      'nvim-telescope/telescope-live-grep-args.nvim',
      config = function() require('telescope').load_extension('live_grep_args') end,
    },
    'molecule-man/telescope-menufacture',
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
          vim.opt_local.number = not ft or ui.decorations.get(ft, 'number', 'ft') ~= false
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
        prompt_prefix = ' ' .. icons.misc.telescope .. ' ',
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
        history = { path = fn.stdpath('data') .. '/telescope_history.sqlite3' },
        layout_strategy = 'flex',
        layout_config = {
          horizontal = { preview_width = 0.55 },
        },
      },
      extensions = {
        persisted = dropdown(),
        menufacture = {
          mappings = {
            main_menu = { [{ 'i', 'n' }] = '<C-;>' },
          },
        },
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
        ['zf-native'] = {
          generic = { enable = true, match_filename = true },
        },
      },
      pickers = {
        git_files = dropdown({
          show_untracked = true,
          previewer = false,
        }),
        buffers = dropdown({
          sort_mru = true,
          sort_lastused = true,
          show_all_buffers = true,
          ignore_current_buffer = true,
          previewer = false,
          mappings = { i = { ['<c-x>'] = 'delete_buffer' }, n = { ['<c-x>'] = 'delete_buffer' } },
        }),
        registers = cursor(),
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

    -- Extensions (sometimes need to be explicitly loaded after telescope is setup)
    require('telescope').load_extension('noice')
    require('telescope').load_extension('persisted')
    require('telescope').load_extension('menufacture')
  end,
}
