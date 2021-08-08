return function()
  local org_dir = '~/Dropbox/org'
  require('as.highlights').plugin(
    'org',
    { 'OrgDone', { guifg = 'Green', gui = 'bold' } },
    { 'OrgAgendaScheduled', { guifg = 'Teal' } }
  )
  require('which-key').register({
    o = {
      name = '+org-mode',
      a = 'agenda',
      c = 'capture',
    },
  }, {
    prefix = '<leader>',
  })
  require('orgmode').setup {
    org_agenda_files = { org_dir .. '/**/*', '~/org/**/*' },
    org_default_notes_file = org_dir .. '/refile.org',
    org_todo_keywords = { 'TODO(t)', 'WAITING', 'NEXT', '|', 'DONE', 'CANCELLED' },
    org_todo_keyword_faces = {
      NEXT = ':foreground royalblue :weight bold :slant italic',
      CANCELLED = ':foreground darkred',
      HOLD = ':foreground orange :weight bold',
    },
    org_hide_emphasis_markers = true,
    org_hide_leading_stars = true,
    org_agenda_skip_scheduled_if_done = true,
    org_agenda_skip_deadline_if_done = true,
    org_agenda_templates = {
      t = { description = 'Task', template = '* TODO %?\n SCHEDULED: %t' },
      l = { description = 'Link', template = '* %?\n%a' },
      j = {
        description = 'Journal',
        template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
        target = org_dir .. '/journal.org',
      },
      p = {
        description = 'Project Todo',
        template = '* TODO %? \nSCHEDULED: %t',
        target = org_dir .. '/projects.org',
      },
    },
    mappings = {
      org = {
        org_toggle_checkbox = '<leader>t',
      },
    },
    notifications = {
      enabled = true,
    },
  }
end
