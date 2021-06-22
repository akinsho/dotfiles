return function()
  local telescope = require "telescope"
  local actions = require "telescope.actions"
  local themes = require "telescope.themes"

  telescope.setup {
    defaults = {
      prompt_prefix = "❯ ",
      mappings = {
        i = {
          ["<c-c>"] = function()
            vim.cmd "stopinsert!"
          end,
          ["<esc>"] = actions.close,
          ["<c-s>"] = actions.select_horizontal,
        },
      },
      file_ignore_patterns = { "%.jpg", "%.jpeg", "%.png", "%.otf", "%.ttf" },
      -- set this value to 'flex' once telescope/#823 is merged
      layout_strategy = "horizontal",
      winblend = 7,
    },
    extensions = {
      frecency = {
        workspaces = {
          ["conf"] = vim.env.DOTFILES,
          ["project"] = vim.env.PROJECTS_DIR,
          ["wiki"] = vim.g.wiki_path,
        },
      },
      fzf = {
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
      },
    },
    pickers = {
      buffers = {
        sort_lastused = true,
        show_all_buffers = true,
        mappings = {
          i = { ["<c-x>"] = "delete_buffer" },
          n = { ["<c-x>"] = "delete_buffer" },
        },
      },
      find_files = {
        hidden = true,
        layout_config = {
          preview_width = 0.65,
        },
      },
      git_branches = {
        theme = "dropdown",
      },
      reloader = {
        theme = "dropdown",
      },
    },
  }

  telescope.load_extension "fzf"

  --- NOTE: this must be required after setting up telescope
  --- otherwise the result will be cached without the updates
  --- from the setup call
  local builtins = require "telescope.builtin"

  local function dotfiles()
    builtins.find_files {
      prompt_title = "~ dotfiles ~",
      cwd = vim.g.dotfiles,
      file_ignore_patterns = { ".git/.*", "dotbot/.*" },
    }
  end

  local function nvim_config()
    builtins.find_files {
      prompt_title = "~ nvim config ~",
      cwd = vim.g.vim_dir,
      file_ignore_patterns = { ".git/.*", "dotbot/.*" },
    }
  end

  ---find if passed in directory contains the target
  ---which is the current buffer's path by default
  ---@param path string
  ---@param target string
  ---@return boolean
  local function is_within(path, target)
    target = target or vim.fn.expand "%:p"
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
    elseif vim.fn.isdirectory ".git" > 0 then
      -- if in a git project, use :Telescope git_files
      builtins.git_files()
    else
      -- otherwise, use :Telescope find_files
      builtins.find_files()
    end
  end

  local function frecency()
    telescope.extensions.frecency.frecency(themes.get_dropdown {
      winblend = 10,
      border = true,
      previewer = false,
      shorten_path = false,
    })
  end

  require("which-key").register {
    ["<C-P>"] = { files, "open project files" },
    ["<leader>f"] = {
      name = "+telescope",
      a = { builtins.builtin, "builtins" },
      b = { builtins.git_branches, "branches" },
      c = { builtins.git_commits, "commits" },
      d = { dotfiles, "dotfiles" },
      o = { builtins.buffers, "buffers" },
      m = { builtins.man_pages, "man pages" },
      h = { frecency, "history" },
      n = { nvim_config, "nvim config" },
      r = { builtins.reloader, "module reloader" },
      w = { builtins.lsp_dynamic_workspace_symbols, "workspace symbols", silent = false },
      ["?"] = { builtins.help_tags, "help" },
    },
    ["<leader>c"] = {
      d = { builtins.lsp_workspace_diagnostics, "telescope: workspace diagnostics" },
    },
  }
end
