local fmt, fn = string.format, vim.fn
local highlight, border = as.highlight, as.ui.current.border
local function sync(path) return fmt('%s/notes/%s', fn.expand('$SYNC_DIR'), path) end

return {
  {
    'vhyrro/neorg',
    ft = 'norg',
    build = ':Neorg sync-parsers',
    dependencies = { 'vhyrro/neorg-telescope' },
    opts = {
      configure_parsers = true,
      load = {
        ['core.defaults'] = {},
        ['core.integrations.telescope'] = {},
        ['core.keybinds'] = {
          config = {
            default_keybinds = true,
            neorg_leader = '<localleader>',
            hook = function(keybinds)
              keybinds.unmap('norg', 'n', '<C-s>')
              keybinds.map_event('norg', 'n', '<C-x>', 'core.integrations.telescope.find_linkable')
            end,
          },
        },
        ['core.norg.completion'] = { config = { engine = 'nvim-cmp' } },
        ['core.norg.concealer'] = {},
        ['core.norg.dirman'] = {
          config = {
            workspaces = {
              notes = sync('neorg/notes/'),
              dotfiles = fn.expand('$DOTFILES/neorg/'),
            },
          },
        },
      },
    },
  },
  {
    'nvim-orgmode/orgmode',
    keys = { '<leader>oa', '<leader>oc' },
    dependencies = {
      {
        'akinsho/org-bullets.nvim',
        dev = true,
        opts = { symbols = { checkboxes = { todo = { '⛌', 'OrgTODO' } } } },
      },
    },
    opts = {
      org_agenda_files = { sync('org/**/*') },
      org_default_notes_file = sync('org/refile.org'),
      org_todo_keywords = { 'TODO(t)', 'WAITING', 'IN-PROGRESS', '|', 'DONE(d)', 'CANCELLED' },
      org_todo_keyword_faces = {
        ['IN-PROGRESS'] = ':foreground royalblue :weight bold',
        ['CANCELLED'] = ':foreground darkred :weight bold',
      },
      org_hide_leading_stars = true,
      org_agenda_skip_scheduled_if_done = true,
      org_agenda_skip_deadline_if_done = true,
      org_agenda_templates = {
        t = { description = 'Task', template = '* TODO %?\n %u' },
        l = { description = 'Link', template = '* %?\n%a' },
        n = { description = 'Note', template = '* %?\n', target = sync('org/notes.org') },
        p = {
          description = 'Project Todo',
          template = '* TODO %? \nSCHEDULED: %t',
          target = sync('org/projects.org'),
        },
      },
      win_border = border,
      mappings = { org = { org_global_cycle = '<leader><S-TAB>' } },
      notifications = {
        enabled = true,
        repeater_reminder_time = false,
        deadline_warning_reminder_time = true,
        reminder_time = 10,
        deadline_reminder = true,
        scheduled_reminder = true,
      },
    },
    config = function(_, opts)
      highlight.plugin('org', {
        { OrgDone = { fg = 'Green', bold = true } },
        { OrgAgendaScheduled = { fg = 'Teal' } },
      })
      require('orgmode').setup_ts_grammar()
      require('orgmode').setup(opts)
    end,
  },
  {
    'lukas-reineke/headlines.nvim',
    ft = { 'org', 'norg', 'markdown', 'yaml' },
    config = function()
      highlight.plugin('Headlines', {
        theme = {
          ['*'] = {
            { Dash = { bg = '#0B60A1', bold = true } },
          },
          ['horizon'] = {
            { Headline = { bold = true, italic = true, bg = { from = 'Normal', alter = 0.2 } } },
            { Headline1 = { inherit = 'Headline', fg = { from = 'Type' } } },
          },
        },
      })
      require('headlines').setup({
        org = { headline_highlights = false },
        norg = { headline_highlights = { 'Headline' }, codeblock_highlight = false },
        markdown = { headline_highlights = { 'Headline1' } },
      })
    end,
  },
}
