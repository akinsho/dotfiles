local fn, env, highlight, ui = vim.fn, vim.env, as.highlight, as.ui
local icons, lsp_hls = ui.icons, ui.lsp.highlights
local P = ui.palette

------------------------------------------------------------------------------------------------------------------------
-- FZF-LUA HELPERS
------------------------------------------------------------------------------------------------------------------------
local function command(c) return ('<Cmd>FzfLua %s<CR>'):format(c) end

local file_picker = function(cwd) require('fzf-lua').files({ cwd = cwd }) end

local function git_files_cwd_aware(opts)
  opts = opts or {}
  local fzf_lua = require('fzf-lua')
  -- git_root() will warn us if we're not inside a git repo
  -- so we don't have to add another warning here, if
  -- you want to avoid the error message change it to:
  -- local git_root = fzf_lua.path.git_root(opts, true)
  local git_root = fzf_lua.path.git_root(opts)
  if not git_root then return fzf_lua.files(opts) end
  local relative = fzf_lua.path.relative(vim.loop.cwd(), git_root)
  opts.fzf_opts = { ['--query'] = git_root ~= relative and relative or nil }
  return fzf_lua.git_files(opts)
end

local function dropdown(opts)
  return vim.tbl_extend('keep', opts or {}, {
    fzf_opts = { ['--layout'] = 'reverse' },
    winopts = {
      height = 0.33,
      width = 0.45,
      preview = { hidden = 'hidden', layout = 'vertical', vertical = 'up:77%' },
    },
  })
end
------------------------------------------------------------------------------------------------------------------------

return {
  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<c-p>', git_files_cwd_aware, desc = 'find files' },
      { '<leader>fa', '<Cmd>FzfLua<CR>', desc = 'builtins' },
      { '<leader>ff', file_picker, desc = 'find files' },
      { '<leader>fb', command('grep_curbuf'), desc = 'current buffer fuzzy find' },
      { '<leader>fr', command('resume'), desc = 'resume picker' },
      { '<leader>fvh', command('highlights'), desc = 'highlights' },
      { '<leader>fvk', command('keymaps'), desc = 'autocommands' },
      { '<leader>fle', command('diagnostics_workspace'), desc = 'workspace diagnostics' },
      { '<leader>fld', command('lsp_document_symbols'), desc = 'document symbols' },
      { '<leader>fls', command('lsp_live_workspace_symbols'), desc = 'workspace symbols' },
      { '<leader>f?', command('help_tags'), desc = 'help' },
      { '<leader>fh', command('oldfiles'), desc = 'Most (f)recently used files' },
      { '<leader>fgb', command('git_branches'), desc = 'branches' },
      { '<leader>fgc', command('git_commits'), desc = 'commits' },
      { '<leader>fgB', command('git_bcommits'), desc = 'buffer commits' },
      { '<leader>fo', command('buffers'), desc = 'buffers' },
      { '<leader>fs', command('live_grep'), desc = 'live grep' },
      { '<leader>fva', command('autocmds'), desc = 'autocommands' },
      { '<leader>fd', function() file_picker(vim.env.DOTFILES) end, desc = 'dotfiles' },
      { '<leader>fc', function() file_picker(vim.g.vim_dir) end, desc = 'nvim config' },
      { '<leader>fO', function() file_picker(fn.resolve(env.SYNC_DIR .. '/org')) end, desc = 'org files' },
      { '<leader>fN', function() file_picker(fn.resolve(env.SYNC_DIR .. '/neorg')) end, desc = 'norg files' },
    },
    config = function()
      local lsp_kind = require('lspkind')

      require('fzf-lua').setup({
        fzf_opts = {
          ['--info'] = 'default', -- hidden OR inline:⏐
          ['--reverse'] = false,
          ['--layout'] = 'default',
          ['--prompt'] = ' ',
          ['--marker'] = '',
          ['--scrollbar'] = '▓',
          ['--ellipsis'] = icons.misc.ellipsis,
        },
        fzf_colors = {
          ['fg'] = { 'fg', 'CursorLine' },
          ['bg'] = { 'bg', 'Normal' },
          ['hl'] = { 'fg', 'Comment' },
          ['fg+'] = { 'fg', 'Normal' },
          ['bg+'] = { 'bg', 'PmenuSel' },
          ['hl+'] = { 'fg', 'Statement', 'italic' },
          ['info'] = { 'fg', 'Comment', 'italic' },
          ['prompt'] = { 'fg', 'Underlined' },
          ['pointer'] = { 'fg', 'Exception' },
          ['marker'] = { 'fg', '@character' },
          ['spinner'] = { 'fg', 'Label' },
          ['header'] = { 'fg', 'Comment' },
          ['gutter'] = { 'bg', 'Normal' },
          ['separator'] = { 'fg', 'Comment' },
        },
        border = as.ui.border.rectangle,
        winopts = {
          hl = { border = 'PickerBorder' },
        },
        keymap = {
          builtin = {
            ['?'] = 'toggle-help',
            ['<c-e>'] = 'toggle-preview',
          },
          fzf = {
            ['esc'] = 'abort',
          },
        },
        helptags = {
          prompt = 'Help ',
        },
        oldfiles = dropdown({
          prompt = 'History  ',
          cwd_only = true,
        }),
        files = dropdown({
          prompt = 'Files  ',
        }),
        buffers = dropdown({
          prompt = 'Buffers  ',
        }),
        lsp = {
          cwd_only = true,
          symbols = {
            symbol_style = 1,
            symbol_icons = lsp_kind.symbols,
            symbol_hl = function(s) return lsp_hls[s] end,
          },
        },
        diagnostics = dropdown({
          prompt = 'Diagnostics  ',
        }),
        git = {
          files = dropdown({
            prompt = 'Files (Git)  ',
          }),
          status = {
            prompt = 'Git status  ',
            preview_pager = 'delta --width=$FZF_PREVIEW_COLUMNS',
          },
          bcommits = {
            prompt = 'Buffer commits  ',
            preview_pager = 'delta --width=$FZF_PREVIEW_COLUMNS',
          },
          commits = {
            prompt = 'Git commits  ',
            preview_pager = 'delta --width=$FZF_PREVIEW_COLUMNS',
          },
          icons = {
            ['M'] = { icon = icons.git.mod, color = 'yellow' },
            ['D'] = { icon = icons.git.remove, color = 'red' },
            ['A'] = { icon = icons.git.add, color = 'green' },
            ['R'] = { icon = icons.git.rename, color = 'yellow' },
            ['C'] = { icon = icons.git.mod, color = 'yellow' },
            ['T'] = { icon = icons.git.mod, color = 'magenta' },
            ['?'] = { icon = '?', color = 'magenta' },
          },
        },
      })
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    enabled = false,
    cmd = 'Telescope',
    config = function()
      local actions = require('telescope.actions')
      local themes = require('telescope.themes')
      local layout_actions = require('telescope.actions.layout')

      -- A helper function to limit the size of a telescope window to fit the maximum available
      -- space on the screen. This is useful for dropdowns e.g. the cursor or dropdown theme
      local function fit_to_available_height(self, _, max_lines)
        local results, PADDING = #self.finder.results, 4 -- this represents the size of the telescope window
        local LIMIT = math.floor(max_lines / 2)
        return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
      end

      ---@param opts table
      ---@return table
      ---@diagnostic disable-next-line: redefined-local
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

      local function stopinsert(callback)
        return function(prompt_bufnr)
          vim.cmd.stopinsert()
          vim.schedule(function() callback(prompt_bufnr) end)
        end
      end

      as.augroup('TelescopePreviews', {
        event = 'User',
        pattern = 'TelescopePreviewerLoaded',
        command = function(args)
          --- TODO: Contribute upstream change to telescope to pass preview buffer data in autocommand
          local ft = vim.tbl_get(args, 'data', 'filetype')
          vim.opt_local.number = ui.decorations.get({ ft = ft, setting = 'number' }).ft ~= false
        end,
      })

      highlight.plugin('telescope', {
        { TelescopeBorder = { fg = P.grey } },
        { TelescopePromptPrefix = { link = 'Statement' } },
        { TelescopeTitle = { inherit = 'Normal', bold = true } },
        { TelescopePromptTitle = { fg = { from = 'Normal' }, bold = true } },
        { TelescopeResultsTitle = { fg = { from = 'Normal' }, bold = true } },
        { TelescopePreviewTitle = { fg = { from = 'Normal' }, bold = true } },
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
              ['<c-r>'] = actions.to_fuzzy_refine,
              ['<Tab>'] = actions.toggle_selection,
              ['<CR>'] = stopinsert(actions.select_default),
            },
            n = {
              ['<C-w>'] = actions.send_selected_to_qflist,
            },
          },
        -- stylua: ignore
        file_ignore_patterns = {
          '%.jpg', '%.jpeg', '%.png', '%.otf', '%.ttf', '%.DS_Store',
          '^.git/', 'node%_modules/.*', '^site-packages/', '%.yarn/.*',
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
    end,
  },
}
