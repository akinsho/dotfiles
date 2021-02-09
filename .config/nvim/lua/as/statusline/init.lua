--- =====================================================================
--- Resources:
--- =====================================================================
--- 1. https://gabri.me/blog/diy-vim-statusline
--- 2. https://github.com/elenapan/dotfiles/blob/master/config/nvim/statusline.vim
--- 3. https://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
--- 4. Right sided truncation - https://stackoverflow.com/a/20899652

local utils = require "as.statusline.utils"
local P = require "as.statusline.palette"
local H = require "as.highlights"
local autocommands = require "as.autocommands"

local M = {}

M.git_updates = utils.git_updates
M.git_toggle_updates = utils.git_update_toggle
M.git_updates_refresh = utils.git_updates_refresh

--- NOTE: Unicode characters including vim devicons should NOT be highlighted
--- as italic or bold, this is because the underlying bold font is not necessarily
--- patched with the nerd font characters
--- terminal emulators like kitty handle this by fetching nerd fonts elsewhere
--- but this is not universal across terminals so should be avoided
function M.colors()
  local normal_bg = H.hl_value("Normal", "bg")
  local bg_color = require("bufferline").shade_color(normal_bg, -5)

  local normal_fg = H.hl_value("Normal", "fg")
  local pmenu_bg = H.hl_value("Pmenu", "bg")
  local string_fg = H.hl_value("String", "fg")
  local error_fg = H.hl_value("ErrorMsg", "fg")
  local comment_fg = H.hl_value("Comment", "fg")
  local comment_gui = H.hl_value("Comment", "gui")
  local title_fg = H.hl_value("Title", "fg")
  local title_gui = H.hl_value("Title", "gui")
  local tabline_sel_bg = H.hl_value("TabLineSel", "bg")
  local number_fg = H.hl_value("Number", "fg")
  local warning_fg = vim.g.colors_name == "one" and P.light_yellow or H.hl_value("WarningMsg", "fg")

  H.all {
    {"StMetadata", {guifg = comment_fg, guibg = bg_color, gui = "italic,bold"}},
    {"StMetadataPrefix", {guibg = bg_color, guifg = comment_fg}},
    {"StIndicator", {guibg = bg_color, guifg = tabline_sel_bg}},
    {"StModified", {guifg = string_fg, guibg = pmenu_bg}},
    {"StGreen", {guifg = string_fg, guibg = bg_color}},
    {"StNumber", {guifg = number_fg, guibg = bg_color}},
    {"StPrefix", {guibg = pmenu_bg, guifg = normal_fg}},
    {"StPrefixSep", {guibg = bg_color, guifg = pmenu_bg}},
    {"StDirectory", {guibg = bg_color, guifg = "Gray", gui = "italic"}},
    {"StDim", {guibg = bg_color, guifg = comment_fg}},
    {"StTitle", {guibg = bg_color, guifg = title_fg, gui = title_gui}},
    {"StComment", {guibg = bg_color, guifg = comment_fg, gui = comment_gui}},
    {"StItem", {guibg = normal_fg, guifg = bg_color, gui = "italic"}},
    {"StSep", {guifg = normal_fg}},
    {"StInfo", {guifg = P.dark_blue, guibg = bg_color, gui = "bold"}},
    {"StInfoSep", {guifg = pmenu_bg}},
    {"StInactive", {guifg = bg_color, guibg = P.comment_grey}},
    {"StInactiveSep", {guibg = bg_color, guifg = P.comment_grey}},
    {"StatusLine", {guibg = bg_color}},
    {"StatusLineNC", {guibg = bg_color, gui = "NONE"}},
    {"StWarning", {guifg = warning_fg, guibg = bg_color}},
    {"StWarningSep", {guifg = pmenu_bg, guibg = bg_color}},
    {"StError", {guifg = error_fg, guibg = bg_color}},
    {"StErrorSep", {guifg = pmenu_bg, guibg = bg_color}},
    {
      "StFilename",
      {guibg = bg_color, guifg = "LightGray", gui = "italic,bold"}
    },
    {
      "StFilenameInactive",
      {guifg = P.comment_grey, guibg = bg_color, gui = "italic,bold"}
    }
  }
end

--- @param tbl table
--- @param next string
--- @param priority table
local function append(tbl, next, priority)
  priority = priority or 0
  local component, length = unpack(next)
  if component and component ~= "" and next and tbl then
    table.insert(tbl, {component = component, priority = priority, length = length})
  end
end

local function add_min_width(item, minwid, trunc_amount)
  if not item or item == "" then
    return item
  end
  return "%" .. minwid .. "." .. trunc_amount .. "(" .. item .. "%)"
end

--- @param statusline table
--- @param available_space number
local function display(statusline, available_space)
  local str = ""
  local items = utils.prioritize(statusline, available_space)
  for _, item in ipairs(items) do
    if type(item.component) == "string" then
      str = str .. item.component
    end
  end
  return str
end

function _G.statusline()
  -- use the statusline global variable which is set inside of statusline
  -- functions to the window for *that* statusline
  local curwin = vim.g.statusline_winid or 0
  local curbuf = vim.api.nvim_win_get_buf(curwin)

  -- TODO reduce the available space whenever we add
  -- a component so we can use it to determine what to add
  local available_space = vim.fn.winwidth(curwin)

  local ctx = {
    bufnum = curbuf,
    winid = curwin,
    bufname = vim.fn.bufname(curbuf),
    preview = vim.wo[curwin].previewwindow,
    readonly = vim.bo[curbuf].readonly,
    filetype = vim.bo[curbuf].ft,
    buftype = vim.bo[curbuf].bt,
    modified = vim.bo[curbuf].modified,
    fileformat = vim.bo[curbuf].fileformat,
    shiftwidth = vim.bo[curbuf].shiftwidth,
    expandtab = vim.bo[curbuf].expandtab
  }
  ----------------------------------------------------------------------------//
  -- Modifiers
  ----------------------------------------------------------------------------//
  local plain = utils.is_plain(ctx)

  local current_mode = utils.mode()
  local file_modified = utils.modified(ctx, "●")
  local inactive = vim.api.nvim_get_current_win() ~= curwin
  local focused = vim.g.vim_in_focus or true
  local minimal = plain or inactive or not focused

  ----------------------------------------------------------------------------//
  -- Setup
  ----------------------------------------------------------------------------//
  local statusline = {}
  append(
    statusline,
    utils.item_if(
      "▌",
      not minimal,
      "StIndicator",
      {
        before = "",
        after = ""
      }
    ),
    0
  )
  append(statusline, utils.spacer(1))

  ----------------------------------------------------------------------------//
  -- Filename
  ----------------------------------------------------------------------------//
  -- The filename component should be 20% of the screen width but has a minimum
  -- width of 10 since smaller than that is likely to be unintelligible
  -- although if the window is plain i.e. terminal or tree buffer allow the file
  -- name to take up more space
  local percentage = plain and 0.4 or 0.5
  local minwid = 5

  -- Don't set a minimum width for plain status line filenames
  local trunc_amount = math.ceil(available_space * percentage)

  -- highlight the filename component separately
  local filename_hl = minimal and "StFilenameInactive" or "StFilename"
  local directory_hl = minimal and "StInactiveSep" or "StDirectory"

  if H.has_win_highlight(curwin) then
    directory_hl = H.adopt_winhighlight(curwin, "StatusLine", "StCustomDirectory", "StTitle")
    filename_hl = H.adopt_winhighlight(curwin, "StatusLine", "StCustomFilename", "StTitle")
  end

  local directory, filename = utils.filename(ctx)
  local ft_icon, icon_highlight =
    utils.filetype(ctx, {icon_bg = "StatusLine", default = "StComment"})

  local opts = {prefix = ft_icon, before = "", after = ""}
  local file_opts = {before = "", after = ""}

  if not minimal then
    opts.prefix_color = icon_highlight
  end

  if not directory or directory == "" then
    file_opts.prefix = ft_icon
    if not minimal then
      file_opts.prefix_color = icon_highlight
    end
  end

  directory = add_min_width(directory, minwid, trunc_amount)
  local dir_item = utils.item(directory, directory_hl, opts)
  local file_item = utils.item(filename, filename_hl, file_opts)

  ----------------------------------------------------------------------------//
  -- Mode
  ----------------------------------------------------------------------------//
  -- show a minimal statusline with only the mode and file component
  if minimal then
    append(statusline, dir_item, 1)
    append(statusline, file_item, 0)
    return display(statusline, available_space)
  end

  append(statusline, utils.item(current_mode, "StModeText"), 0)

  append(statusline, dir_item, 1)
  append(statusline, file_item, 0)
  -- show the alternate buffer name
  local alternate_buf = vim.fn.expand("#:t")
  append(
    statusline,
    utils.item_if("(#:" .. alternate_buf .. ")", #alternate_buf > 0, "StDim", {before = " "}),
    3
  )

  append(
    statusline,
    utils.sep_if(
      file_modified,
      ctx.modified,
      {
        small = 1,
        color = "StModified",
        sep_color = "StPrefixSep"
      }
    ),
    1
  )

  -- If local plugins are loaded and I'm developing locally show an indicator
  local develop_text = available_space > 100 and "local dev" or ""
  append(
    statusline,
    utils.item_if(
      develop_text,
      vim.env.DEVELOPING ~= nil,
      "StComment",
      {
        prefix = "",
        padding = "none",
        before = "  ",
        prefix_color = "StWarning",
        small = 1
      }
    ),
    2
  )

  -- Neovim allows unlimited alignment sections so we can put things in the
  -- middle of our statusline - https://neovim.io/doc/user/vim_diff.html#vim-differences
  -- local statusline .= '%='

  -- Start of the right side layout
  append(statusline, {"%="})

  -- Current line number/total line number,  alternatives 
  append(
    statusline,
    utils.line_info(
      {
        prefix = "ℓ",
        prefix_color = "StMetadataPrefix",
        current_hl = "StTitle",
        total_hl = "StComment",
        sep_hl = "StComment"
      }
    ),
    4
  )

  -- Git Status
  local prefix, git_status = utils.git_status()
  append(statusline, utils.item(git_status, "StInfo", {prefix = prefix}), 1)

  local updates = vim.g.git_statusline_updates or {}
  local ahead = updates.ahead and tonumber(updates.ahead) or 0
  local behind = updates.behind and tonumber(updates.behind) or 0
  append(
    statusline,
    utils.item_if(
      ahead,
      ahead > 0,
      "StTitle",
      {
        prefix = "⇡",
        prefix_color = "StGreen",
        after = behind > 0 and "" or " ",
        before = ""
      }
    )
  )
  append(
    statusline,
    utils.item_if(
      behind,
      behind > 0,
      "StTitle",
      {prefix = "⇣", prefix_color = "StNumber", after = " "}
    )
  )

  -- LSP Diagnostics
  local info = utils.diagnostic_info()
  if info and not vim.tbl_isempty(info) then
    append(statusline, utils.item(info.error, "StError"), 1)
    append(statusline, utils.item(info.warning, "StWarning"), 2)
    append(statusline, utils.item(info.information, "StGreen"), 3)
  end

  -- LSP Status
  append(statusline, utils.item(utils.lsp_status(), "StMetadata"), 3)
  append(statusline, utils.item(utils.current_fn(), "StMetadata"), 4)

  -- Indentation
  local unexpected_indentation = ctx.shiftwidth > 2 or not ctx.expandtab
  append(
    statusline,
    utils.item_if(
      ctx.shiftwidth,
      unexpected_indentation,
      "StTitle",
      {prefix = ctx.expandtab and "Ξ" or "⇥", prefix_color = "PmenuSbar"}
    ),
    4
  )

  append(statusline, {"%<"})
  -- removes 5 columns to add some padding
  return display(statusline, available_space - 5)
end

local function setup_autocommands()
  autocommands.create(
    {
      CustomStatusline = {
        {"FocusGained", "*", "let g:vim_in_focus = v:true"},
        {"FocusLost", "*", "let g:vim_in_focus = v:false"},
        {
          "VimEnter,ColorScheme",
          "*",
          "lua require'as.statusline'.colors()"
        },
        {"VimEnter", "*", "lua require'as.statusline'.git_updates()"},
        {
          "DirChanged",
          "*",
          "lua require'as.statusline'.git_toggle_updates()"
        },
        {
          "User AsyncGitJobComplete",
          "lua require'as.statusline'.git_updates_refresh()"
        },
        {
          "User FugitiveChanged",
          "lua require'as.statusline'.git_updates_refresh()"
        },
        {
          "User FugitiveChanged",
          "redrawstatus!"
        }
      }
    }
  )
end

-- attach autocommands
setup_autocommands()

-- :h qf.vim, disable qf statusline
vim.g.qf_disable_statusline = 1

-- set the statusline
vim.o.statusline = "%!v:lua.statusline()"

return M
