as.telescope = {}

return function()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local builtins = require("telescope.builtin")
  local themes = require("telescope.themes")
  local action_state = require("telescope.actions.state")

  telescope.setup {
    defaults = {
      prompt_prefix = "❯ ",
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<c-s>"] = actions.select_horizontal
        }
      },
      file_ignore_patterns = {"%.jpg", "%.jpeg", "%.png", "%.otf", "%.ttf"},
      -- set this value to 'flex' once telescope/#823 is merged
      layout_strategy = "horizontal",
      winblend = 7
    },
    extensions = {
      frecency = {
        workspaces = {
          ["conf"] = vim.env.DOTFILES,
          ["project"] = vim.env.PROJECTS_DIR,
          ["wiki"] = vim.g.wiki_path
        }
      },
      fzf_writer = {
        minimum_grep_characters = 2,
        minimum_files_characters = 2,
        use_highlighter = true
      },
      fzf = {
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true -- override the file sorter
      }
    }
  }

  telescope.load_extension("fzf")
  telescope.load_extension("arecibo")

  local function dotfiles()
    builtins.find_files {
      prompt_title = "~ dotfiles ~",
      shorten_path = false,
      cwd = vim.g.dotfiles,
      hidden = true,
      -- set this value to 'flex' once telescope/#823 is merged
      layout_strategy = "horizontal",
      file_ignore_patterns = {".git/.*", "dotbot/.*"},
      layout_config = {
        preview_width = 0.65
      }
    }
  end

  local function nvim_config()
    builtins.find_files {
      prompt_title = "~ nvim config ~",
      shorten_path = false,
      cwd = vim.g.vim_dir,
      hidden = true,
      -- set this value to 'flex' once telescope/#823 is merged
      layout_strategy = "horizontal",
      file_ignore_patterns = {".git/.*", "dotbot/.*"},
      layout_config = {
        preview_width = 0.65
      }
    }
  end

  ---find if passed in directory contains the target
  ---which is the current buffer's path by default
  ---@param path string
  ---@param target string
  ---@return boolean
  local function is_within(path, target)
    target = target or vim.fn.expand("%:p")
    if not target then
      return false
    end
    return target:match(vim.fn.fnamemodify(path, ":p"))
  end

  ---General finds files function which changes the picker depending
  ---on the current buffers path.
  local function files()
    if is_within(vim.g.vim_dir) then
      nvim_config()
    elseif is_within(vim.g.dotfiles) then
      dotfiles()
    elseif vim.fn.isdirectory(".git") > 0 then
      -- if in a git project, use :Telescope git_files
      builtins.git_files()
    else
      -- otherwise, use :Telescope find_files
      builtins.find_files()
    end
  end

  local function frecency()
    telescope.extensions.frecency.frecency(
      themes.get_dropdown {
        winblend = 10,
        border = true,
        previewer = false,
        shorten_path = false
      }
    )
  end

  local function websearch()
    telescope.extensions.arecibo.websearch(
      themes.get_dropdown {
        winblend = 10,
        border = true,
        previewer = false,
        shorten_path = false
      }
    )
  end

  local function buffers()
    builtins.buffers {
      sort_lastused = true,
      show_all_buffers = true,
      attach_mappings = function(prompt_bufnr, map)
        local delete_buf = function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.api.nvim_buf_delete(selection.bufnr, {force = true})
        end
        map("i", "<c-x>", delete_buf)
        return true
      end
    }
  end

  local function workspace_symbols()
    builtins.lsp_workspace_symbols {
      query = vim.fn.input("Query > ")
    }
  end

  local function git_branches()
    builtins.git_branches(themes.get_dropdown())
  end

  local function grep()
    telescope.extensions.fzf_writer.staged_grep()
  end

  local function reloader()
    builtins.reloader(themes.get_dropdown())
  end

  require("which-key").register(
    {
      ["<C-P>"] = {files, "open project files"},
      ["<leader>f"] = {
        name = "+telescope",
        a = {"<cmd>Telescope<cr>", "builtins"},
        b = {git_branches, "branches"},
        c = {builtins.git_commits, "commits"},
        d = {dotfiles, "dotfiles"},
        f = {builtins.find_files, "files"},
        g = {websearch, "websearch"},
        o = {buffers, "buffers"},
        m = {builtins.man_pages, "man pages"},
        h = {frecency, "history"},
        n = {nvim_config, "nvim config"},
        r = {reloader, "module reloader"},
        s = {grep, "grep"},
        w = {workspace_symbols, "workspace symbols", silent = false},
        ["?"] = {builtins.help_tags, "help"}
      },
      ["<leader>c"] = {
        d = {builtins.lsp_workspace_diagnostics, "telescope: workspace diagnostics"}
      }
    }
  )
end
