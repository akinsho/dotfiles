--- =====================================================================
--- Resources:
--- =====================================================================
--- 1. https://gabri.me/blog/diy-vim-statusline
--- 2. https://github.com/elenapan/dotfiles/blob/master/config/nvim/statusline.vim
--- 3. https://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
--- 4. Right sided truncation - https://stackoverflow.com/questions/20899651/how-to-truncate-a-vim-statusline-field-from-the-right

local utils = require "statusline/utils"

local M = {}

local st_warning = {color = "%#StWarning#", sep_color = "%#StWarningSep#"}

local dark_red = "#be5046"
local green = "#98c379"
local light_yellow = "#e5c07b"
local dark_blue = "#4e88ff"
local magenta = "#c678dd"
local comment_grey = "#5c6370"
local inc_search_bg = utils.get_hl_color("Search", "bg")

--- NOTE: Unicode characters including vim devicons should NOT be highlighted
--- as italic or bold, this is because the underlying bold font is not necessarily
--- patched with the nerd font characters
--- terminal emulators like kitty handle this by fetching nerd fonts elsewhere
--- but this is not universal across terminals so should be avoided
function M.colors()
  local normal_bg = utils.get_hl_color("Normal", "bg")
  local normal_fg = utils.get_hl_color("Normal", "fg")
  local pmenu_bg = utils.get_hl_color("Pmenu", "bg")
  local string_fg = utils.get_hl_color("String", "fg")
  local error_fg = utils.get_hl_color("ErrorMsg", "fg")
  local comment_fg = utils.get_hl_color("Comment", "fg")
  local warning_fg =
    vim.g.colors_name == "one" and light_yellow or
    utils.get_hl_color("WarningMsg", "fg")

  local highlights = {
    {"StMetadata", {guifg = comment_fg, gui = "italic,bold"}},
    {"StMetadataPrefix", {guifg = comment_fg}},
    {"StModified", {guifg = string_fg, guibg = pmenu_bg}},
    {"StPrefix", {guibg = pmenu_bg, guifg = normal_fg}},
    {"StPrefixSep", {guibg = normal_bg, guifg = pmenu_bg}},
    {"StDirectory", {guibg = normal_bg, guifg = "Gray", gui = "italic"}},
    {
      "StFilename",
      {guibg = normal_bg, guifg = "LightGray", gui = "italic,bold"}
    },
    {
      "StFilenameInactive",
      {guifg = comment_grey, guibg = normal_bg, gui = "italic,bold"}
    },
    {"StItem", {guibg = normal_fg, guifg = normal_bg, gui = "italic"}},
    {"StSep", {guifg = normal_fg}},
    {"StInfo", {guifg = dark_blue, guibg = normal_bg, gui = "bold"}},
    {"StInfoSep", {guifg = pmenu_bg}},
    {"StInactive", {guifg = normal_bg, guibg = comment_grey}},
    {"StInactiveSep", {guifg = comment_grey}},
    {"StatusLine", {guibg = normal_bg}},
    {"StatusLineNC", {guibg = normal_bg}},
    {"StWarning", {guifg = warning_fg, guibg = pmenu_bg}},
    {"StWarningSep", {guifg = pmenu_bg, guibg = normal_bg}},
    {"StError", {guifg = error_fg, guibg = pmenu_bg}},
    {"StErrorSep", {guifg = pmenu_bg, guibg = normal_bg}}
  }

  for _, hl in ipairs(highlights) do
    utils.set_highlight(unpack(hl))
  end
end

local function mode_highlight(mode)
  local visual_regex = vim.regex([[\(v\|V\|\)]])
  local command_regex = vim.regex([[\(c\|cv\|ce\)]])
  if mode == "i" then
    utils.set_highlight("StModeText", {guifg = dark_blue, gui = "bold"})
  elseif visual_regex:match_str(mode) then
    utils.set_highlight("StModeText", {guifg = magenta, gui = "bold"})
  elseif mode == "R" then
    utils.set_highlight("StModeText", {guifg = dark_red, gui = "bold"})
  elseif command_regex:match_str(mode) then
    utils.set_highlight("StModeText", {guifg = inc_search_bg, gui = "bold"})
  else
    utils.set_highlight("StModeText", {guifg = green, gui = "bold"})
  end
end

local function mode()
  local current_mode = vim.fn.mode()
  mode_highlight(current_mode)

  local mode_map = {
    ["n"] = "NORMAL",
    ["no"] = "N·OPERATOR PENDING ",
    ["v"] = "VISUAL",
    ["V"] = "V·LINE",
    [""] = "V·BLOCK",
    ["s"] = "SELECT",
    ["S"] = "S·LINE",
    ["^S"] = "S·BLOCK",
    ["i"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rv"] = "V·REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "VIM EX",
    ["ce"] = "EX",
    ["r"] = "PROMPT",
    ["rm"] = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL"
  }
  return mode_map[current_mode] or "UNKNOWN"
end

local function append(tbl, next)
  if next and tbl then
    table.insert(tbl, next)
  end
end

function _G.statusline()
  -- use the statusline global variable which is set inside of statusline
  -- functions to the window for *that* statusline
  local curwin = vim.g.statusline_winid or 0
  local curbuf = vim.api.nvim_win_get_buf(curwin)

  -- TODO reduce the available space whenever we add
  -- a component so we can use it to determine what to add
  local available_space = vim.fn.winwidth(curwin)

  local context = {
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
  local plain = utils.is_plain(context)

  local current_mode = mode()
  local line_info = utils.line_info()
  local file_modified = utils.modified(context, "●")
  local inactive = vim.api.nvim_get_current_win() ~= curwin
  local focused = vim.g.vim_in_focus or true
  local minimal = plain or inactive or not focused

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

  local directory, filename = utils.filename(context)
  local ft_icon, icon_highlight = utils.filetype(context)

  filename = directory .. "%#" .. filename_hl .. "#" .. filename
  local title_component =
    "%" .. minwid .. "." .. trunc_amount .. "(" .. filename .. "%)"

  ----------------------------------------------------------------------------//
  -- Mode
  ----------------------------------------------------------------------------//
  -- show a minimal statusline with only the mode and file component
  if minimal then
    return utils.item(
      title_component,
      "StInactiveSep",
      {prefix = ft_icon, before = " "}
    )
  end
  ----------------------------------------------------------------------------//
  -- Setup
  ----------------------------------------------------------------------------//
  local statusline = {}
  append(statusline, utils.item(current_mode, "StModeText", {before = ""}))

  append(
    statusline,
    utils.item(
      title_component,
      "StDirectory",
      {
        prefix = ft_icon,
        prefix_color = icon_highlight,
        after = ""
      }
    )
  )

  append(
    statusline,
    utils.sep_if(
      file_modified,
      context.modified,
      {
        small = 1,
        color = "%#StModified#",
        sep_color = "%#StPrefixSep#"
      }
    )
  )

  -- If local plugins are loaded and I'm developing locally show an indicator
  local develop_text = available_space > 100 and "local dev" or ""
  append(
    statusline,
    utils.sep_if(
      develop_text,
      vim.env.DEVELOPING and available_space > 50,
      vim.fn.extend(
        {
          prefix = " ",
          padding = "none",
          prefix_color = "%#StWarning#",
          small = 1
        },
        st_warning
      )
    )
  )

  -- Neovim allows unlimited alignment sections so we can put things in the
  -- middle of our statusline - https://neovim.io/doc/user/vim_diff.html#vim-differences
  -- local statusline .= '%='

  -- Start of the right side layout
  append(statusline, "%=")

  -- Git Status
  local prefix, git_status = utils.git_status()
  append(statusline, utils.item(git_status, "StInfo", {prefix = prefix}))

  -- LSP Diagnostics
  local info = utils.diagnostic_info()
  append(statusline, utils.item(info.error, "Error"))
  append(statusline, utils.item(info.warning, "PreProc"))
  append(statusline, utils.item(info.information, "String"))

  -- LSP Status
  append(statusline, utils.item(utils.lsp_status(), "Comment"))
  append(statusline, utils.item(utils.current_fn(), "StMetadata"))

  -- Indentation
  local unexpected_indentation = context.shiftwidth > 2 or not context.expandtab
  append(
    statusline,
    utils.item_if(
      context.shiftwidth,
      unexpected_indentation,
      "Title",
      {prefix = context.expandtab and "Ξ" or "⇥", prefix_color = "PmenuSbar"}
    )
  )

  -- Current line number/total line number,  alternatives 
  append(
    statusline,
    utils.item(
      line_info,
      "StMetadata",
      {prefix = "ℓ", prefix_color = "StMetadataPrefix"}
    )
  )

  append(statusline, "%<")
  return table.concat(statusline)
end

local function setup_autocommands()
  vim.cmd [[augroup custom_statusline]]
  vim.cmd [[autocmd!]]
  vim.cmd [[autocmd FocusGained *  let g:vim_in_focus = v:true]]
  vim.cmd [[autocmd FocusLost * let g:vim_in_focus = v:false]]
  -- The quickfix window sets it's own statusline, so we override it here
  vim.cmd [[autocmd FileType qf setlocal statusline=%!v:lua.statusline()]]
  vim.cmd [[autocmd VimEnter,ColorScheme * lua require'statusline'.colors()]]
  vim.cmd [[augroup END]]
end

-- attach autocommands
setup_autocommands()

-- set the statusline
vim.o.statusline = "%!v:lua.statusline()"

return M
