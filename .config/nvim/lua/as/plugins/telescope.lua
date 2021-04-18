as.telescope = {}

return function()
  local nnoremap = as.nnoremap
  local command = as.command
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local sorters = require("telescope.sorters")
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
      file_sorter = sorters.get_fzy_sorter,
      generic_sorter = sorters.get_fzy_sorter,
      -- layout_strategy = "flex",
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

  require("telescope").load_extension("fzf")

  local function dotfiles()
    builtins.find_files {
      prompt_title = "~ dotfiles ~",
      shorten_path = false,
      cwd = vim.g.dotfiles,
      hidden = true,
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

  local function grep()
    telescope.extensions.fzf_writer.staged_grep()
  end

  -- Find files using Telescope command-line sugar.
  nnoremap("<C-P>", files)
  command {"TelescopeFindFiles", files}

  nnoremap("<leader>fa", "<cmd>Telescope<cr>")
  nnoremap("<leader>ff", "<cmd>Telescope find_files<cr>")

  nnoremap("<leader>fd", dotfiles)
  nnoremap("<leader>fn", nvim_config)
  nnoremap("<leader>fo", buffers)

  --- Git
  nnoremap("<leader>fb", "<cmd>Telescope git_branches theme=get_dropdown<cr>")
  nnoremap("<leader>fc", "<cmd>Telescope git_commits<cr>")

  --- LSP
  nnoremap("<leader>cd", "<cmd>Telescope lsp_workspace_diagnostics<cr>")
  nnoremap("<leader>ws", workspace_symbols, {silent = false})

  --- Extensions
  nnoremap("<leader>fh", frecency)
  command {"TelescopeFrecent", frecency}
  nnoremap("<leader>fw", websearch)
  nnoremap("<leader>fr", "<cmd>Telescope reloader theme=get_dropdown<cr>")
  nnoremap("<leader>fs", grep)
  nnoremap("<leader>f?", "<cmd>Telescope help_tags<cr>")
end
