return function()
  local fn = vim.fn
  require('as.highlights').plugin('org', {
    OrgDone = { fg = 'Green', bold = true },
    OrgAgendaScheduled = { fg = 'Teal' },
  })
  require('orgmode').setup_ts_grammar()
  require('orgmode').setup({
    org_agenda_files = { fn.expand('$SYNC_DIR/org/*') },
    org_default_notes_file = fn.expand('$SYNC_DIR/org/refile.org'),
    org_hide_leading_stars = true,
    org_agenda_skip_scheduled_if_done = true,
    org_agenda_skip_deadline_if_done = true,
    org_agenda_templates = {
      t = { description = 'Task', template = '* TODO %?\n SCHEDULED: %t' },
      l = { description = 'Link', template = '* %?\n%a' },
      p = {
        description = 'Project Todo',
        template = '* TODO %? \nSCHEDULED: %t',
        target = fn.expand('$SYNC_DIR/org/projects.org'),
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
  local which_key = require('which-key')
  which_key.register({
    ['<leader>o'] = {
      name = '+org',
      a = 'agenda',
      c = 'capture',
    },
  })
end
