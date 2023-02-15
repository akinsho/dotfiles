----------------------------------------------------------------------------------------------------
-- Styles
----------------------------------------------------------------------------------------------------
-- Consistent store of various UI items to reuse throughout my config

local palette = {
  green = '#98c379',
  dark_green = '#10B981',
  blue = '#82AAFE',
  dark_blue = '#4e88ff',
  bright_blue = '#51afef',
  teal = '#15AABF',
  pale_pink = '#b490c0',
  magenta = '#c678dd',
  pale_red = '#E06C75',
  light_red = '#c43e1f',
  dark_red = '#be5046',
  dark_orange = '#FF922B',
  bright_yellow = '#FAB005',
  light_yellow = '#e5c07b',
  whitesmoke = '#9E9E9E',
  light_gray = '#626262',
  comment_grey = '#5c6370',
  grey = '#3E4556',
}

local border = {
  line = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
  rectangle = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
}

local icons = {
  separators = {
    vert_bottom_half_block = '▄',
    vert_top_half_block = '▀',
    right_block = '🮉',
    medium_shade_block = '▒',
  },
  lsp = {
    error = '', -- '✗'
    warn = '',
    warning = '',
    info = '', -- 
    hint = '', -- ⚑
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
    branch = '',
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
    null = '[]',
    float = '',
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
    clock = '',
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
    arrow_right = '',
    caret_right = '',
    chevron_right = '',
    double_chevron_right = '»',
    table = '',
    calendar = '',
    block = '▌',
  },
}
-- LSP Kinds come via the LSP spec
-- @see: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
local lsp = {
  colors = {
    error = palette.pale_red,
    warn = palette.dark_orange,
    hint = palette.bright_blue,
    info = palette.teal,
  },
  highlights = {
    Text = 'String',
    Method = 'TSMethod',
    Function = 'Function',
    Constructor = 'TSConstructor',
    Field = 'TSField',
    Variable = 'TSVariable',
    Class = 'TSStorageClass',
    Interface = 'Constant',
    Module = 'Include',
    Property = 'TSProperty',
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
    Namespace = 'TSNamespace',
    Package = 'Include',
    String = 'String',
    Number = 'Number',
    Boolean = 'Boolean',
    Array = 'StorageClass',
    Object = 'Type',
    Key = 'TSField',
    Null = 'ErrorMsg',
    EnumMember = 'TSField',
  },
  kinds = {
    codicons = {
      Text = '',
      Method = '',
      Function = '',
      Constructor = '',
      Field = '',
      Variable = '',
      Class = '',
      Interface = '',
      Module = '',
      Property = '',
      Unit = '',
      Value = '',
      Enum = '',
      Keyword = '',
      Snippet = '',
      Color = '',
      File = '',
      Reference = '',
      Folder = '',
      EnumMember = '',
      Constant = '',
      Struct = '',
      Event = '',
      Operator = '',
      TypeParameter = '',
      Namespace = '?',
      Package = '?',
      String = '?',
      Number = '?',
      Boolean = '?',
      Array = '?',
      Object = '?',
      Key = '?',
      Null = '?',
    },
    nerdfonts = {
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
      Namespace = '?',
      Package = '?',
      String = '?',
      Number = '?',
      Boolean = '?',
      Array = '?',
      Object = '?',
      Key = '?',
      Null = '?',
    },
  },
}

----------------------------------------------------------------------------------------------------
-- Global style settings
----------------------------------------------------------------------------------------------------
-- Some styles can be tweaked here to apply globally i.e. by setting the current value for that style

-- The current styles for various UI elements
local current = {
  border = border.line,
  lsp_icons = lsp.kinds.codicons,
}

---@alias UISpec {statusline: 'minimal' | boolean, winbar: boolean, statuscolumn: boolean, number: boolean}
---@alias UISettings {buftypes: table<string, UISpec>, filetypes: table<string, UISpec>}

-- stylua: ignore
---@type UISettings
local settings = {
  buftypes = {
    ['terminal'] = { statuscolumn = true, winbar = true, statusline = 'minimal', colorcolumn = false },
    ['quickfix'] = { statuscolumn = false, winbar = true, statusline = 'minimal', colorcolumn = false },
    ['nofile'] = { statuscolumn = false, winbar = true, statusline = 'minimal', colorcolumn = false },
    ['nowrite'] = { statuscolumn = false, winbar = true, statusline = 'minimal', colorcolumn = false },
    ['acwrite'] = { statuscolumn = false, winbar = true, statusline = 'minimal', colorcolumn = false },
  },
  filetypes = {
    ['NeogitCommitSelectView'] = { statuscolumn = false, winbar = false, statusline = true, number = false, colorcolumn = false },
    ['DiffviewFileHistory'] = { statuscolumn = false, winbar = false, statusline = true, number = false, colorcolumn = false },
    ['mail'] = { statuscolumn = false, winbar = false, statusline = true, number = false, colorcolumn = false },
    ['noice'] = { statuscolumn = false, winbar = false, statusline = true, number = false, colorcolumn = false },
    ['diff'] = { statuscolumn = false, winbar = false, statusline = true, number = false, colorcolumn = false },
    ['qf'] = { statuscolumn = false, winbar = false, statusline = true, number = false, colorcolumn = false },
    ['alpha'] = { statuscolumn = false, winbar = false, statusline = true, number = false, colorcolumn = false },
    ['netrw'] = { statuscolumn = false, winbar = false, statusline = true, number = false, colorcolumn = false },
    ['coc-explorer'] = { statuscolumn = false, winbar = false, statusline = true, number = false, colorcolumn = false },
    ['coc-list'] = { statuscolumn = false, winbar = true, statusline = true, number = false, colorcolumn = false },
    ['NeogitStatus'] = { statuscolumn = false, winbar = true, statusline = 'minimal', colorcolumn = false },
    ['undotree'] = { statuscolumn = false, winbar = true, statusline = 'minimal', number = false, colorcolumn = false },
    ['minimap'] = { statuscolumn = false, winbar = true, statusline = 'minimal', colorcolumn = false },
    ['tsplayground'] = { statuscolumn = false, winbar = true, statusline = 'minimal', colorcolumn = false },
    ['dapui'] = { statuscolumn = false, winbar = true, statusline = 'minimal', colorcolumn = false },
    ['neo-tree'] = { statuscolumn = false, winbar = true, statusline = true, colorcolumn = false },
    ['log'] = { statuscolumn = false, winbar = true, statusline = true, number = false, colorcolumn = false },
    ['man'] = { statuscolumn = false, winbar = true, statusline = true, number = false },
    ['dap-repl'] = { statuscolumn = false, winbar = true, statusline = true, number = false, colorcolumn = false },
    ['markdown'] = { statuscolumn = false, winbar = true, statusline = true, number = false },
    ['vimwiki'] = { statuscolumn = false, winbar = true, statusline = true, number = false, colorcolumn = false },
    ['vim-plug'] = { statuscolumn = false, winbar = true, statusline = true, number = false, colorcolumn = false },
    ['gitcommit'] = { statuscolumn = false, winbar = true, statusline = true, number = false },
    ['toggleterm'] = { statuscolumn = false, winbar = true, statusline = true, number = false },
    ['fugitive'] = { statuscolumn = false, winbar = true, statusline = true, number = false, colorcolumn = false },
    ['list'] = { statuscolumn = false, winbar = true, statusline = true, number = false },
    ['NvimTree'] = { statuscolumn = false, winbar = true, statusline = true, number = false },
    ['startify'] = { statuscolumn = false, winbar = true, statusline = true, number = false, colorcolumn = false },
    ['help'] = { statuscolumn = false, winbar = true, statusline = true, number = false, colorcolumn = false },
    ['orgagenda'] = { statuscolumn = false, winbar = true, statusline = true, number = false, colorcolumn = false },
    ['org'] = { statuscolumn = false, winbar = true, statusline = true, number = false, colorcolumn = false },
    ['himalaya'] = { statuscolumn = false, winbar = true, statusline = true, number = false },
    ['Trouble'] = { statuscolumn = false, winbar = true, statusline = true, number = false },
    ['norg'] = { statuscolumn = false, winbar = true, statusline = true, number = false, colorcolumn = false },
    ['NeogitCommitMessage'] = { statuscolumn = false, winbar = true, statusline = true, number = false },
    ['NeogitRebaseTodo'] = { statuscolumn = false, winbar = true, statusline = true, number = false },
  },
}

---Get the UI setting for a particular filetype
---@param key string
---@param setting 'statuscolumn'|'winbar'|'statusline'|'number'|'colorcolumn'
---@param t 'ft'|'bt'
---@return (boolean | string)?
function settings.get(key, setting, t)
  if not key or not setting then return nil end
  if t == 'ft' then return settings.filetypes[key] and settings.filetypes[key][setting] end
  if t == 'bt' then return settings.buftypes[key] and settings.buftypes[key][setting] end
end

as.ui.icons = icons
as.ui.lsp = lsp
as.ui.border = border
as.ui.current = current
as.ui.palette = palette
as.ui.settings = settings
