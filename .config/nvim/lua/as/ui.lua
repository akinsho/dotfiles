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
    right_thin_block = '▕',
    vert_bottom_half_block = '▄',
    vert_top_half_block = '▀',
    right_block = '🮉',
    light_shade_block = '░',
  },
  lsp = {
    error = '', -- '✗'
    warn = '', -- 
    info = '󰋼', --  ℹ 󰙎 
    hint = '󰌶', --  ⚑
  },
  git = {
    add = '', -- '',
    mod = '',
    remove = '', -- '',
    ignore = '',
    rename = '',
    untracked = '',
    ignored = '',
    unstaged = '󰄱',
    staged = '',
    conflict = '',
    diff = '',
    repo = '',
    logo = '󰊢',
    branch = '',
  },
  documents = {
    file = '',
    files = '',
    folder = '',
    open_folder = '',
  },
  misc = {
    -- 
    plus = '',
    ellipsis = '…',
    up = '⇡',
    down = '⇣',
    line = '', -- 'ℓ'
    indent = 'Ξ',
    tab = '⇥',
    bug = '', --  '󰠭'
    question = '',
    clock = '',
    lock = '',
    shaded_lock = '',
    circle = '',
    project = '',
    dashboard = '',
    history = '󰄉',
    comment = '󰅺',
    robot = '󰚩',
    lightbulb = '󰌵',
    search = '󰍉',
    code = '',
    telescope = '',
    gear = '',
    package = '',
    list = '',
    sign_in = '',
    check = '󰄬',
    fire = '',
    note = '󰎞',
    bookmark = '',
    pencil = '', -- '󰏫',
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
as.ui.lsp = {
  colors = {
    error = as.ui.palette.pale_red,
    warn = as.ui.palette.dark_orange,
    hint = as.ui.palette.bright_blue,
    info = as.ui.palette.teal,
  },
  --- This is a mapping of LSP Kinds to highlight groups. LSP Kinds come via the LSP spec
  --- see: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
  highlights = {
    File = 'Directory',
    Snippet = 'Label',
    Text = '@string',
    Method = '@method',
    Function = '@function',
    Constructor = '@constructor',
    Field = '@field',
    Variable = '@variable',
    Module = '@namespace',
    Property = '@property',
    Unit = '@constant',
    Value = '@variable',
    Enum = '@type',
    Keyword = '@keyword',
    Reference = '@parameter.reference',
    Constant = '@constant',
    Struct = '@structure',
    Event = '@variable',
    Operator = '@operator',
    Namespace = '@namespace',
    Package = '@include',
    String = '@string',
    Number = '@number',
    Boolean = '@boolean',
    Array = '@repeat',
    Object = '@type',
    Key = '@field',
    Null = '@symbol',
    EnumMember = '@field',
    Class = '@lsp.type.class',
    Interface = '@lsp.type.interface',
    TypeParameter = '@lsp.type.parameter',
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

---@alias DecorationType 'statuscolumn'|'winbar'|'statusline'|'number'|'colorcolumn'

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
    statusline = 'minimal',
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

--- When searching through the filetypes table if a match can't be found then search
--- again but check if there is matching lua pattern. This is useful for filetypes for
--- plugins like Neogit which have a filetype of Neogit<something>.
local filetypes = as.p_table({
  ['Avante'] = presets.tool_panel,
  ['startuptime'] = presets.tool_panel,
  ['checkhealth'] = presets.tool_panel,
  ['log'] = presets.tool_panel,
  ['help'] = presets.tool_panel,
  ['^copilot.*'] = presets.tool_panel,
  ['dbout'] = presets.tool_panel,
  ['dbui'] = presets.tool_panel,
  ['dapui'] = presets.tool_panel,
  ['minimap'] = presets.tool_panel,
  ['Trouble'] = presets.tool_panel,
  ['tsplayground'] = presets.tool_panel,
  ['list'] = presets.tool_panel,
  ['netrw'] = presets.tool_panel,
  ['flutter.*'] = presets.tool_panel,
  ['NvimTree'] = presets.tool_panel,
  ['undotree'] = presets.tool_panel,
  ['dap-repl'] = presets.tool_panel:with({ winbar = 'ignore' }),
  ['neo-tree'] = presets.tool_panel:with({ winbar = 'ignore' }),
  ['toggleterm'] = presets.tool_panel:with({ winbar = 'ignore' }),
  ['neotest.*'] = presets.tool_panel,
  ['^Neogit.*'] = presets.tool_panel,
  ['query'] = presets.tool_panel,
  ['DiffviewFiles'] = presets.tool_panel,
  ['DiffviewFileHistory'] = presets.tool_panel,
  ['mail'] = presets.statusline_only,
  -- The message and cmdline windows created by the core UI, see `:h ui2`
  ['cmd'] = presets.tool_panel:with({ statusline = false, winbar = 'ignore' }),
  ['msg'] = presets.tool_panel:with({ statusline = false, winbar = 'ignore' }),
  ['pager'] = presets.tool_panel:with({ winbar = 'ignore' }),
  ['dialog'] = presets.tool_panel:with({ statusline = false, winbar = 'ignore' }),
  ['diff'] = presets.statusline_only,
  ['qf'] = presets.statusline_only,
  ['alpha'] = presets.tool_panel:with({ statusline = false }),
  ['fugitive'] = presets.statusline_only,
  ['startify'] = presets.statusline_only,
  ['man'] = presets.minimal_editing,
  ['org'] = presets.minimal_editing:with({ winbar = false }),
  ['norg'] = presets.minimal_editing:with({ winbar = false }),
  ['orgagenda'] = presets.minimal_editing:with({ winbar = false }),
  ['markdown'] = presets.minimal_editing,
  ['himalaya'] = presets.minimal_editing,
  ['gitcommit'] = commit_buffer,
  ['NeogitCommitMessage'] = commit_buffer,
})

local filenames = as.p_table({
  ['option-window'] = presets.tool_panel,
})

as.ui.decorations = {}

---@alias ui.OptionValue (boolean | string)

---Get the as.ui setting for a particular filetype
---@param opts {ft: string?, bt: string?, fname: string?, setting: DecorationType}
---@return {ft: ui.OptionValue?, bt: ui.OptionValue?, fname: ui.OptionValue?}
function as.ui.decorations.get(opts)
  local ft, bt, fname, setting = opts.ft, opts.bt, opts.fname, opts.setting
  if (not ft and not bt and not fname) or not setting then return nil end
  return {
    ft = ft and filetypes[ft] and filetypes[ft][setting],
    bt = bt and buftypes[bt] and buftypes[bt][setting],
    fname = fname and filenames[fname] and filenames[fname][setting],
  }
end

----------------------------------------------------------------------------------------------------
as.ui.current = { border = as.ui.border.line }
