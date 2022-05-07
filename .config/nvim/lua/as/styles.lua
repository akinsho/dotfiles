----------------------------------------------------------------------------------------------------
-- Styles
----------------------------------------------------------------------------------------------------
-- Consistent store of various UI items to reuse throughout my config

local palette = {
  pale_red = '#E06C75',
  dark_red = '#be5046',
  light_red = '#c43e1f',
  dark_orange = '#FF922B',
  green = '#98c379',
  bright_yellow = '#FAB005',
  light_yellow = '#e5c07b',
  dark_blue = '#4e88ff',
  magenta = '#c678dd',
  comment_grey = '#5c6370',
  grey = '#3E4556',
  whitesmoke = '#626262',
  bright_blue = '#51afef',
  teal = '#15AABF',
}

as.style = {
  border = {
    line = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
  },
  icons = {
    lsp = {
      error = '✗',
      warn = '',
      info = '',
      hint = '',
    },
    git = {
      add = '', -- '',
      mod = '',
      remove = '', -- '',
      ignore = '',
      rename = '',
      diff = '',
      repo = '',
      logo = '',
    },
    documents = {
      file = '',
      files = '',
      folder = '',
      open_folder = '',
    },
    type = {
      array = '',
      number = '',
      object = '',
    },
    misc = {
      ellipsis = '…',
      up = '⇡',
      down = '⇣',
      line = 'ℓ', -- ''
      indent = 'Ξ',
      tab = '⇥',
      bug = '', -- 'ﴫ'
      question = '',
      lock = '',
      circle = '',
      project = '',
      dashboard = '',
      history = '',
      comment = '',
      robot = 'ﮧ',
      lightbulb = '',
      search = '',
      code = '',
      telescope = '',
      gear = '',
      package = '',
      list = '',
      sign_in = '',
      check = '',
      fire = '',
      note = '',
      bookmark = '',
      pencil = '',
      tools = '',
      chevron_right = '',
      double_chevron_right = '»',
      table = '',
      calendar = '',
      block = '▌',
    },
  },
  lsp = {
    colors = {
      error = palette.pale_red,
      warn = palette.dark_orange,
      hint = palette.light_yellow,
      info = palette.teal,
    },
    kind_highlights = {
      Text = 'String',
      Method = 'Method',
      Function = 'Function',
      Constructor = 'TSConstructor',
      Field = 'Field',
      Variable = 'Variable',
      Class = 'Class',
      Interface = 'Constant',
      Module = 'Include',
      Property = 'Property',
      Unit = 'Constant',
      Value = 'Variable',
      Enum = 'Type',
      Keyword = 'Keyword',
      File = 'Directory',
      Reference = 'PreProc',
      Constant = 'Constant',
      Struct = 'Type',
      Snippet = 'Label',
      Event = 'Variable',
      Operator = 'Operator',
      TypeParameter = 'Type',
    },
    kinds = {
      Text = '',
      Method = '',
      Function = '',
      Constructor = '',
      Field = '', -- '',
      Variable = '', -- '',
      Class = '', -- '',
      Interface = '',
      Module = '',
      Property = 'ﰠ',
      Unit = '塞',
      Value = '',
      Enum = '',
      Keyword = '', -- '',
      Snippet = '', -- '', '',
      Color = '',
      File = '',
      Reference = '', -- '',
      Folder = '',
      EnumMember = '',
      Constant = '', -- '',
      Struct = '', -- 'פּ',
      Event = '',
      Operator = '',
      TypeParameter = '',
    },
  },
  palette = palette,
}

----------------------------------------------------------------------------------------------------
-- Global style settings
----------------------------------------------------------------------------------------------------
-- Some styles can be tweaked here to apply globally i.e. by setting the current value for that style

-- The current styles for various UI elements
as.style.current = {
  border = as.style.border.line,
}
