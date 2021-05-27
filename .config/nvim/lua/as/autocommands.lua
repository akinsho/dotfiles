local fn = vim.fn
local api = vim.api
local fmt = string.format
local contains = vim.tbl_contains

as.augroup(
  "VimrcIncSearchHighlight",
  {
    {
      -- automatically clear search highlight once leaving the commandline
      events = {"CmdlineEnter"},
      targets = {"[/\\?]"},
      command = ":set hlsearch  | redrawstatus"
    },
    {
      events = {"CmdlineLeave"},
      targets = {"[/\\?]"},
      command = ":set nohlsearch | redrawstatus"
    }
  }
)

local smart_close_filetypes = {
  "help",
  "git-status",
  "git-log",
  "gitcommit",
  "dbui",
  "fugitive",
  "fugitiveblame",
  "LuaTree",
  "log",
  "tsplayground",
  "qf"
}

local function smart_close()
  if fn.winnr("$") ~= 1 then
    api.nvim_win_close(0, true)
  end
end

as.augroup(
  "SmartClose",
  {
    {
      -- Auto open grep quickfix window
      events = {"QuickFixCmdPost"},
      targets = {"*grep*"},
      command = "cwindow"
    },
    {
      -- Close certain filetypes by pressing q.
      events = {"FileType"},
      targets = {"*"},
      command = function()
        local is_readonly =
          (vim.bo.readonly or not vim.bo.modifiable) and fn.hasmapto("q", "n") == 0

        local is_eligible =
          vim.bo.buftype ~= "" or is_readonly or vim.wo.previewwindow or
          contains(smart_close_filetypes, vim.bo.filetype)

        if is_eligible then
          as.nnoremap("q", smart_close, {buffer = 0, nowait = true})
        end
      end
    },
    {
      -- Close quick fix window if the file containing it was closed
      events = {"BufEnter"},
      targets = {"*"},
      command = function()
        if fn.winnr("$") == 1 and vim.bo.buftype == "quickfix" then
          api.nvim_buf_delete(0, {force = true})
        end
      end
    },
    {
      -- automatically close corresponding loclist when quitting a window
      events = {"QuitPre"},
      targets = {"*"},
      modifiers = {"nested"},
      command = function()
        if vim.bo.filetype ~= "qf" then
          vim.cmd("silent! lclose")
        end
      end
    }
  }
)

as.augroup(
  "DotooOverrides",
  {
    {
      events = {"Filetype"},
      targets = {"dotoocapture", "dotoo"},
      command = function()
        vim.bo.bufhidden = "wipe"
        as.nnoremap("q", "<Cmd>wq<CR>", {buffer = 0, nowait = true})
      end
    }
  }
)

as.augroup(
  "ExternalCommands",
  {
    {
      -- Open images in an image viewer (probably Preview)
      events = {"BufEnter"},
      targets = {"*.png,*.jpg,*.gif"},
      command = function()
        vim.cmd(fmt('silent! "%s | :bw"', vim.g.open_command .. " " .. fn.expand("%")))
      end
    }
  }
)

as.augroup(
  "CheckOutsideTime",
  {
    {
      -- automatically check for changed files outside vim
      events = {"WinEnter", "BufWinEnter", "BufWinLeave", "BufRead", "BufEnter", "FocusGained"},
      targets = {"*"},
      command = "silent! checktime"
    }
  }
)

-- See :h skeleton
as.augroup(
  "Templates",
  {
    {
      events = {"BufNewFile"},
      targets = {"*.sh"},
      command = "0r $DOTFILES/.config/nvim/templates/skeleton.sh"
    },
    {
      events = {"BufNewFile"},
      targets = {"*.lua"},
      command = "0r $DOTFILES/.config/nvim/templates/skeleton.lua"
    }
  }
)

--- automatically clear commandline messages after a few seconds delay
--- source: http//unix.stackexchange.com/a/613645
as.augroup(
  "ClearCommandMessages",
  {
    {
      events = {"CmdlineLeave", "CmdlineChanged"},
      targets = {":"},
      command = function()
        vim.defer_fn(
          function()
            if fn.mode() == "n" then
              vim.cmd([[echon '']])
            end
          end,
          2000
        )
      end
    }
  }
)

if vim.env.TMUX ~= nil then
  as.augroup(
    "TmuxConfig",
    {
      {
        events = {"FocusGained", "BufReadPost", "BufReadPost", "BufReadPost", "BufEnter"},
        targets = {"*"},
        command = function()
          require("as.tmux").on_enter()
        end
      },
      {
        events = {"VimLeave"},
        targets = {"*"},
        command = function()
          require("as.tmux").on_leave()
        end
      },
      {
        events = {"ColorScheme", "FocusGained"},
        targets = {"*"},
        command = require("as.tmux").statusline_colors
      }
    }
  )
end

as.augroup(
  "TextYankHighlight",
  {
    {
      -- don't execute silently in case of errors
      events = {"TextYankPost"},
      targets = {"*"},
      command = function()
        require("vim.highlight").on_yank(
          {
            timeout = 500,
            on_visual = false,
            higroup = "Visual"
          }
        )
      end
    }
  }
)

local column_exclude = {"gitcommit"}
local column_clear = {"startify", "vimwiki", "vim-plug", "help", "fugitive", "mail"}

--- Set or unset the color column depending on the filetype of the buffer and its eligibility
---@param leaving boolean?
local function check_color_column(leaving)
  if contains(column_exclude, vim.bo.filetype) then
    return
  end

  local not_eligible = not vim.bo.modifiable or not vim.bo.buflisted or vim.bo.buftype ~= ""
  if contains(column_clear, vim.bo.filetype) or not_eligible then
    vim.wo.colorcolumn = ""
    return
  end
  if api.nvim_win_get_width(0) <= 120 or leaving then
    -- only reset this value when it doesn't already exist
    vim.wo.colorcolumn = ""
  elseif vim.wo.colorcolumn == "" then
    vim.cmd("setlocal colorcolumn=+1")
  end
end

as.augroup(
  "CustomColorColumn",
  {
    {
      -- Update the cursor column to match current window size
      events = {"BufEnter", "VimResized", "FocusGained", "WinEnter"},
      targets = {"*"},
      command = function()
        check_color_column()
      end
    },
    {
      events = {"WinLeave"},
      targets = {"*"},
      command = function()
        check_color_column(true)
      end
    }
  }
)
