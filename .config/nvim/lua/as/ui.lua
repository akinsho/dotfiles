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
-- UI Settings
----------------------------------------------------------------------------------------------------
---@class UiSetting {
---@field winbar boolean
---@field number boolean
---@field statusline 'minimal' | boolean
---@field statuscolumn boolean
---@field colorcolumn boolean

---@alias UiSettings {buftypes: table<string, UiSetting>, filetypes: table<string, UiSetting>}

---@class UiSetting
local Preset = {}

---@param o UiSetting
function Preset:new(o)
  assert(o, 'a present must be defined')
  self.__index = self
  return setmetatable(o, self)
end

--- WARNING: deep extend does not copy lua meta methods
function Preset:with(o) return vim.tbl_deep_extend('force', self, o) end

---@type table<string, UiSetting>
local presets = {
  statusline_only = Preset:new({
    number = false,
    winbar = false,
    colorcolumn = false,
    statusline = true,
    statuscolumn = false,
  }),
  minimal_editing = Preset:new({
    number = false,
    winbar = true,
    colorcolumn = false,
    statusline = true,
    statuscolumn = false,
  }),
  tool_panel = Preset:new({
    number = false,
    winbar = false,
    colorcolumn = false,
    statusline = 'minimal',
    statuscolumn = false,
  }),
}

local commit_buffer = presets.minimal_editing:with({
  colorcolumn = true,
  winbar = false,
})

---@type UiSettings
local settings = {
  buftypes = {
    ['terminal'] = presets.tool_panel,
    ['quickfix'] = presets.tool_panel,
    ['nofile'] = presets.tool_panel,
    ['nowrite'] = presets.tool_panel,
    ['acwrite'] = presets.tool_panel,
  },
  filetypes = {
    ['help'] = presets.tool_panel,
    ['dapui'] = presets.tool_panel,
    ['minimap'] = presets.tool_panel,
    ['Trouble'] = presets.tool_panel,
    ['dap-repl'] = presets.tool_panel,
    ['tsplayground'] = presets.tool_panel,
    ['toggleterm'] = presets.tool_panel,
    ['list'] = presets.tool_panel,
    ['netrw'] = presets.tool_panel,
    ['NvimTree'] = presets.tool_panel,
    ['undotree'] = presets.tool_panel,
    ['NeogitPopup'] = presets.tool_panel,
    ['NeogitStatus'] = presets.tool_panel,
    ['neo-tree'] = presets.tool_panel:with({ winbar = true }),
    ['NeogitCommitSelectView'] = presets.tool_panel,
    ['NeogitRebaseTodo'] = presets.tool_panel,
    ['DiffviewFiles'] = presets.tool_panel,
    ['DiffviewFileHistory'] = presets.tool_panel,
    ['mail'] = presets.statusline_only,
    ['noice'] = presets.statusline_only,
    ['diff'] = presets.statusline_only,
    ['qf'] = presets.statusline_only,
    ['alpha'] = presets.statusline_only,
    ['vimwiki'] = presets.statusline_only,
    ['vim-plug'] = presets.statusline_only,
    ['fugitive'] = presets.statusline_only,
    ['startify'] = presets.statusline_only,
    ['man'] = presets.minimal_editing,
    ['org'] = presets.minimal_editing,
    ['norg'] = presets.minimal_editing,
    ['markdown'] = presets.minimal_editing,
    ['himalaya'] = presets.minimal_editing,
    ['orgagenda'] = presets.minimal_editing,
    ['gitcommit'] = commit_buffer,
    ['NeogitCommitMessage'] = commit_buffer,
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

----------------------------------------------------------------------------------------------------
local current = { border = border.line, lsp_icons = lsp.kinds.codicons }

as.ui.icons = icons
as.ui.lsp = lsp
as.ui.border = border
as.ui.current = current
as.ui.palette = palette
as.ui.settings = settings
