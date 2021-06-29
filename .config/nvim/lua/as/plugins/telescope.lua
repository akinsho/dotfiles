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
  telescope.load_extension "tmux"

  --- NOTE: this must be required after setting up telescope
  --- otherwise the result will be cached without the updates
  --- from the setup call
  local builtins = require "telescope.builtin"

  local function nvim_config()
    builtins.find_files {
      prompt_title = "~ nvim config ~",
      cwd = vim.g.vim_dir,
      file_ignore_patterns = { ".git/.*", "dotbot/.*" },
    }
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
    ["<leader>f"] = {
      name = "+telescope",
      a = { builtins.builtin, "builtins" },
      b = { builtins.git_branches, "branches" },
      -- c = { builtins.git_commits, "commits" },
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
