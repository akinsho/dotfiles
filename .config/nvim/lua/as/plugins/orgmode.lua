local function config()
  local fn = vim.fn
  local fmt = string.format

  local orgmode = require('orgmode')
  local highlights = as.highlight

  highlights.plugin('org', {
    { OrgDone = { fg = 'Green', bold = true } },
    { OrgAgendaScheduled = { fg = 'Teal' } },
  })

  local function sync(path) return fmt('%s/%s', fn.expand('$SYNC_DIR'), path) end

  orgmode.setup_ts_grammar()

  orgmode.setup({
    org_agenda_files = { sync('org/**/*') },
    org_default_notes_file = sync('org/refile.org'),
    org_todo_keywords = {
      'TODO(t)',
      'WAITING',
      'IN-PROGRESS',
      '|',
      'DONE(d)',
      'CANCELLED',
    },
    org_todo_keyword_faces = {
      ['IN-PROGRESS'] = ':foreground royalblue :weight bold',
      CANCELLED = ':foreground darkred :weight bold',
    },
    org_hide_leading_stars = true,
    org_agenda_skip_scheduled_if_done = true,
    org_agenda_skip_deadline_if_done = true,
    org_agenda_templates = {
      t = { description = 'Task', template = '* TODO %?\n %u' },
      l = { description = 'Link', template = '* %?\n%a' },
      n = {
        description = 'Note',
        template = '* %?\n',
        target = sync('org/notes.org'),
      },
      p = {
        description = 'Project Todo',
        template = '* TODO %? \nSCHEDULED: %t',
        target = sync('org/projects.org'),
      },
    },
    mappings = {
      org = {
        org_global_cycle = '<leader><S-TAB>',
      },
    },
    notifications = {
      enabled = true,
      repeater_reminder_time = false,
      deadline_warning_reminder_time = true,
      reminder_time = 10,
      deadline_reminder = true,
      scheduled_reminder = true,
    },
  })
end

return { { 'nvim-orgmode/orgmode', lazy = false, config = config } }
