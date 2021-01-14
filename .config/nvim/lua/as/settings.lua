local fn = vim.fn
local api = vim.api
local executable = function(e)
  return fn.executable(e) > 0
end

local function opt_mt(_, scope)
  if scope ~= "bo" and scope ~= "wo" then
    return require("as.utils").echomsg(
      "You should use this for 'window' or 'buffer' options",
      "Error"
    )
  end
  return setmetatable(
    {},
    {
      __newindex = function(_, option, value)
        vim.o[option] = value
        vim[scope][option] = value
      end
    }
  )
end

local opt = setmetatable({}, {__index = setmetatable({}, {__index = opt_mt})})

local function add(value, str, sep)
  sep = sep or ","
  str = str or ""
  value = type(value) == "table" and table.concat(value, sep) or value
  return str ~= "" and table.concat({value, str}, sep) or value
end
-----------------------------------------------------------------------------//
-- Message output on vim actions {{{1
-----------------------------------------------------------------------------//
vim.o.shortmess =
  table.concat(
  {
    "t", -- truncate file messages at start
    "A", -- ignore annoying swap file messages
    "o", -- file-read message overwrites previous
    "O", -- file-read message overwrites previous
    "T", -- truncate non-file messages in middle
    "f", -- (file x of x) instead of just (x of x
    "F", -- Don't give file info when editing a file
    "s",
    "c",
    "W" -- Dont show [w] or written when writing
  }
)
-----------------------------------------------------------------------------//
-- Timings {{{1
-----------------------------------------------------------------------------//
vim.o.updatetime = 300
vim.o.timeout = true
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 10
-----------------------------------------------------------------------------//
-- Window splitting and buffers {{{1
-----------------------------------------------------------------------------//
vim.o.hidden = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.eadirection = "hor"
-- exclude usetab as we do not want to jump to buffers in already open tabs
-- do not use split or vsplit to ensure we don't open any new windows
vim.o.switchbuf = "useopen,uselast"
vim.o.fillchars =
  add {
  "vert:▕", -- alternatives │
  "fold: ",
  "eob: ", -- suppress ~ at EndOfBuffer
  "diff:", -- alternatives: ⣿ ░
  "msgsep:‾",
  "foldopen:▾",
  "foldsep:│",
  "foldclose:▸"
}
-----------------------------------------------------------------------------//
-- Diff {{{1
-----------------------------------------------------------------------------//
-- Use in vertical diff mode, blank lines to keep sides aligned, Ignore whitespace changes
vim.o.diffopt =
  add(
  {
    "vertical",
    "iwhite",
    "hiddenoff",
    "foldcolumn:0",
    "context:4",
    "algorithm:histogram",
    "indent-heuristic"
  },
  vim.o.diffopt
)
-----------------------------------------------------------------------------//
-- Format Options {{{1
-----------------------------------------------------------------------------//
vim.o.formatoptions =
  table.concat(
  {
    "1",
    "q", -- continue comments with gq"
    "c", -- Auto-wrap comments using textwidth
    "r", -- Continue comments when pressing Enter
    "o", -- do not continue comment using o or O
    "n", -- Recognize numbered lists
    "2", -- Use indent from 2nd line of a paragraph
    "t", -- autowrap lines using text width value
    "j", -- remove a comment leader when joining lines.
    -- Only break if the line was not longer than 'textwidth' when the insert
    -- started and only at a white character that has been entered during the
    -- current insert command.
    "lv"
  }
)
---------------------------------------------------------------------------//
-- Folds {{{1
-----------------------------------------------------------------------------//
vim.o.foldtext = "folds#render()"
vim.o.foldopen = add(vim.o.foldopen, "search")
vim.o.foldlevelstart = 10
opt.wo.foldmethod = "syntax"
-----------------------------------------------------------------------------//
-- Grepprg {{{1
-----------------------------------------------------------------------------//
-- Use faster grep alternatives if possible
if executable("rg") then
  vim.o.grepprg = [[rg --hidden --glob "!.git" --no-heading --smart-case --vimgrep --follow $*]]
  vim.o.grepformat = add("%f:%l:%c:%m", vim.o.grepformat)
elseif executable("ag") then
  vim.o.grepprg = [[ag --nogroup --nocolor --vimgrep]]
  vim.o.grepformat = add("%f:%l:%c:%m", vim.o.grepformat)
end
-----------------------------------------------------------------------------//
-- Wild and file globbing stuff in command mode {{{1
-----------------------------------------------------------------------------//
vim.o.wildcharm = api.nvim_eval([[char2nr("\<C-Z>")]]) -- FIXME: what's the correct way to do this?
vim.o.wildmenu = true
vim.o.wildmode = "full" -- Shows a menu bar as opposed to an enormous list
vim.o.wildignorecase = true -- Ignore case when completing file names and directories
-- Binary
vim.o.wildignore =
  add {
  "*.aux,*.out,*.toc",
  "*.o,*.obj,*.dll,*.jar,*.pyc,*.rbc,*.class",
  "*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp",
  "*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm",
  "*.eot,*.otf,*.ttf,*.woff",
  "*.doc,*.pdf",
  "*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz",
  -- Cache
  ".sass-cache",
  "*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*.gem",
  -- Temp/System
  "*.*~,*~ ",
  "*.swp,.lock,.DS_Store,._*,tags.lock"
}
vim.o.wildoptions = "pum"
vim.o.pumblend = 3 -- Make popup window translucent
-----------------------------------------------------------------------------//
-- Display {{{1
-----------------------------------------------------------------------------//
opt.wo.conceallevel = 2
opt.wo.breakindentopt = "sbr"
opt.wo.linebreak = true -- lines wrap at words rather than random characters
opt.bo.synmaxcol = 1024 -- don't syntax highlight long lines
opt.wo.signcolumn = "yes:2"
opt.wo.colorcolumn = "+1" -- Set the colour column to highlight one column after the 'textwidth'
vim.o.cmdheight = 2 -- Set command line height to two lines
vim.o.showbreak = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
vim.g.vimsyn_embed = "lPr" -- allow embedded syntax highlighting for lua,python and ruby
-----------------------------------------------------------------------------//
-- List chars {{{1
-----------------------------------------------------------------------------//
vim.o.list = true -- invisible chars
vim.o.listchars =
  add {
  "eol: ",
  "tab:│ ",
  "extends:…",
  "precedes:…",
  "trail:•" -- BULLET (U+2022, UTF-8: E2 80 A2)
}
-----------------------------------------------------------------------------//
-- Indentation
-----------------------------------------------------------------------------//
opt.wo.wrap = true
opt.bo.wrapmargin = 2
opt.bo.softtabstop = 2
opt.bo.textwidth = 80
opt.bo.shiftwidth = 2
opt.bo.expandtab = true
opt.bo.autoindent = true
opt.bo.autoindent = true
vim.o.shiftround = true
-----------------------------------------------------------------------------//
vim.o.joinspaces = false
vim.o.gdefault = true
vim.o.pumheight = 15
vim.o.confirm = true -- make vim prompt me to save before doing destructive things
vim.o.completeopt = add {"menu", "noinsert", "noselect", "longest"}
vim.o.hlsearch = false
vim.o.autowriteall = true -- automatically :write before running commands and changing files
vim.o.clipboard = "unnamedplus"
vim.o.lazyredraw = true
vim.o.laststatus = 2
vim.o.ttyfast = true
vim.o.belloff = "all"
vim.o.termguicolors = true
-----------------------------------------------------------------------------//
-- Emoji {{{1
-----------------------------------------------------------------------------//
-- emoji is true by default but makes (n)vim treat all emoji as double width
-- which breaks rendering so we turn this off.
-- CREDIT: https://www.youtube.com/watch?v=F91VWOelFNE
vim.o.emoji = false
-----------------------------------------------------------------------------//
vim.o.inccommand = "nosplit"
-- This is from the help docs, it enables mode shapes, "Cursor" highlight, and blinking
vim.o.guicursor =
  table.concat(
  {
    [[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50]],
    [[a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor]],
    [[sm:block-blinkwait175-blinkoff150-blinkon175]]
  },
  ","
)
-----------------------------------------------------------------------------//
-- Title {{{1
-----------------------------------------------------------------------------//
vim.o.titlestring = " ❐ %t %r %m"
vim.o.titleold = '%{fnamemodify(getcwd(), ":t")}'
vim.o.title = true
vim.o.titlelen = 70
-----------------------------------------------------------------------------//
-- Utilities {{{1
-----------------------------------------------------------------------------//
vim.o.showmode = false
vim.o.sessionoptions =
  add {
  "globals",
  "buffers",
  "curdir",
  "tabpages",
  "help",
  "winpos"
}
vim.o.viewoptions = add {"cursor", "folds"} -- save/restore just these (with `:{mk,load}view`)
vim.o.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
vim.o.dictionary = "/usr/share/dict/words"
-------------------------------------------------------------------------------
-- BACKUP AND SWAPS {{{
-------------------------------------------------------------------------------
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
if fn.isdirectory(vim.o.undodir) == 0 then
  fn.mkdir(vim.o.undodir, "p")
end
opt.bo.undofile = true
--}}}
-----------------------------------------------------------------------------//
-- Match and search {{{1
-----------------------------------------------------------------------------//
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrapscan = true -- Searches wrap around the end of the file
vim.o.scrolloff = 9
vim.o.sidescrolloff = 10
vim.o.sidescroll = 1
-----------------------------------------------------------------------------//
-- Spelling {{{1
-----------------------------------------------------------------------------//
vim.o.spellfile = "$DOTFILES/.config/nvim/.vim-spell-en.utf-8.add"
vim.o.spellsuggest = add(12, vim.o.spellsuggest)
vim.o.spelloptions = "camel"
vim.o.spellcapcheck = "" -- don't check for capital letters at start of sentence
vim.o.fileformats = "unix,mac,dos"
vim.o.complete = add("kspell", vim.o.complete)
-----------------------------------------------------------------------------//
-- Mouse {{{1
-----------------------------------------------------------------------------//
vim.o.mouse = "a"
vim.o.mousefocus = true
-- FIXME - these don't work in lua
-- vim.o.mousehide = true -- Raise issue on Neovim as this errors
-----------------------------------------------------------------------------//
-- FIXME - these don't work in lua
-- vim.o.secure  -- Disable autocmd etc for project local vimrc files.
-- vim.o.exrc -- Allow project local vimrc files example .nvimrc see :h exrc
-----------------------------------------------------------------------------//
-- Git editor
-----------------------------------------------------------------------------//
if executable("nvr") then
  vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
  vim.env.EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end
-- vim:foldmethod=marker
