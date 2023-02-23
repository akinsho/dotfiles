----------------------------------------------------------------------------------------------------
-- Styles
----------------------------------------------------------------------------------------------------

as.ui.palette = {
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

as.ui.border = {
  line = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
  rectangle = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
}

as.ui.icons = {
  separators = {
    left_thin_block = '▏',
    vert_bottom_half_block = '▄',
    vert_top_half_block = '▀',
    right_block = '🮉',
    light_shade_block = '░',
  },
  lsp = {
    error = '', -- '✗'
    warn = '',
    info = '', -- 
    hint = '', --  ⚑
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
    -- 
    plus = '',
    ellipsis = '…',
    up = '⇡',
    down = '⇣',
    line = 'ℓ', -- ''
    indent = 'Ξ',
    tab = '⇥',
    bug = '', --  'ﴫ'
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
    pencil = '', -- '',
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
--- LSP Kinds come via the LSP spec
--- see: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
as.ui.lsp = {
  colors = {
    error = as.ui.palette.pale_red,
    warn = as.ui.palette.dark_orange,
    hint = as.ui.palette.bright_blue,
    info = as.ui.palette.teal,
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
---@class Decorations {
---@field winbar 'ignore' | boolean
---@field number boolean
---@field statusline 'minimal' | boolean
---@field statuscolumn boolean
---@field colorcolumn boolean | string

---@alias UiSettings {buftypes: table<string, Decorations>, filetypes: table<string, Decorations>}

---@class Decorations
local Preset = {}

---@param o Decorations
function Preset:new(o)
  assert(o, 'a preset must be defined')
  self.__index = self
  return setmetatable(o, self)
end

--- WARNING: deep extend does not copy lua meta methods
function Preset:with(o) return vim.tbl_deep_extend('force', self, o) end

---@type table<string, Decorations>
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

local commit_buffer = presets.minimal_editing:with({ colorcolumn = '50,72', winbar = false })

local buftypes = {
  ['quickfix'] = presets.tool_panel,
  ['nofile'] = presets.tool_panel,
  ['nowrite'] = presets.tool_panel,
  ['acwrite'] = presets.tool_panel,
  ['terminal'] = presets.tool_panel,
}

local filetypes = {
  ['checkhealth'] = presets.tool_panel,
  ['help'] = presets.tool_panel,
  ['dapui'] = presets.tool_panel,
  ['minimap'] = presets.tool_panel,
  ['Trouble'] = presets.tool_panel,
  ['tsplayground'] = presets.tool_panel,
  ['list'] = presets.tool_panel,
  ['netrw'] = presets.tool_panel,
  ['NvimTree'] = presets.tool_panel,
  ['undotree'] = presets.tool_panel,
  ['dap-repl'] = presets.tool_panel:with({ winbar = 'ignore' }),
  ['neo-tree'] = presets.tool_panel:with({ winbar = 'ignore' }),
  ['toggleterm'] = presets.tool_panel:with({ winbar = 'ignore' }),
  ['^Neogit.*'] = presets.tool_panel,
  ['DiffviewFiles'] = presets.tool_panel,
  ['DiffviewFileHistory'] = presets.tool_panel,
  ['mail'] = presets.statusline_only,
  ['noice'] = presets.statusline_only,
  ['diff'] = presets.statusline_only,
  ['qf'] = presets.statusline_only,
  ['alpha'] = presets.tool_panel:with({ statusline = false }),
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
}

---@type UiSettings
as.ui.decorations = {
  filetypes = filetypes,
  buftypes = buftypes,
}

--- When searching through the filetypes table if a match can't be found then search
--- again but check if there is matching lua pattern. This is useful for filetypes for
--- plugins like Neogit which have a filetype of Neogit<something>.
setmetatable(filetypes, {
  __index = function(tbl, key)
    if not key then return end
    for k, v in pairs(tbl) do
      if key:match(k) then return v end
    end
  end,
})

---Get the as.ui setting for a particular filetype
---@param key string
---@param setting 'statuscolumn'|'winbar'|'statusline'|'number'|'colorcolumn'
---@param t 'ft'|'bt'
---@return (boolean | string)?
function as.ui.decorations.get(key, setting, t)
  if not key or not setting then return nil end
  if t == 'ft' then return filetypes[key] and filetypes[key][setting] end
  if t == 'bt' then return buftypes[key] and buftypes[key][setting] end
end

---A helper to set the value of the colorcolumn option, to my preferences, this can be used
---in an autocommand to set the `vim.opt_local.colorcolumn` or by a plugin such as `virtcolumn.nvim`
---to set it's virtual column
---@param bufnr integer
---@param fn fun(virtcolumn: string)
function as.ui.decorations.set_colorcolumn(bufnr, fn)
  local buf = vim.bo[bufnr]
  local ft_ccol = as.ui.decorations.get(buf.ft, 'colorcolumn', 'ft')
  local bt_ccol = as.ui.decorations.get(buf.bt, 'colorcolumn', 'bt')
  if buf.ft == '' or buf.bt ~= '' or ft_ccol == false or bt_ccol == false then return end
  local ccol = ft_ccol or bt_ccol or ''
  local virtcolumn = not as.empty(ccol) and ccol or '+1'
  if vim.is_callable(fn) then fn(virtcolumn) end
end

----------------------------------------------------------------------------------------------------
as.ui.current = { border = as.ui.border.line, lsp_icons = as.ui.lsp.kinds.codicons }
