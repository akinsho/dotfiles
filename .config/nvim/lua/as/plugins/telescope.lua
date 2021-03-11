return function()
  local map = as_utils.map
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local sorters = require("telescope.sorters")
  local builtins = require("telescope.builtin")

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
      layout_strategy = "flex",
      winblend = 7,
      set_env = {COLORTERM = "truecolor"}
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
      }
    }
  }

  function _G.__telescope_files()
    -- Launch file search using Telescope
    if vim.fn.isdirectory(".git") > 0 then
      -- if in a git project, use :Telescope git_files
      builtins.git_files()
    else
      -- otherwise, use :Telescope find_files
      builtins.find_files()
    end
  end

  vim.cmd [[autocmd! FileType TelescopePrompt let b:lexima_disabled = 1]]

  -- Find files using Telescope command-line sugar.
  map("n", "<C-P>", "<cmd>lua __telescope_files()<CR>")
  map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
  map("n", "<leader>fh", "<cmd>Telescope frecency theme=get_dropdown<cr>")

  map("n", "<leader>fb", "<cmd>Telescope git_branches theme=get_dropdown<cr>")
  map("n", "<leader>fd", "<cmd>Telescope git_files cwd=~/.dotfiles<cr>")
  map("n", "<leader>fc", "<cmd>Telescope git_commits <cr>")

  -- LSP mappings, currently only bound on linux since we use coc on mac
  if vim.g.is_linux then
    map("n", "<leader>cd", "<cmd>Telescope lsp_workspace_diagnostics <cr>")
  end

  map("n", "<leader>fr", "<cmd>Telescope reloader theme=get_dropdown<cr>")
  map("n", "<leader>fs", "<cmd>lua require('telescope').extensions.fzf_writer.staged_grep()<CR>")
  map("n", "<leader>fo", "<cmd>Telescope buffers show_all_buffers=true<cr> ")
  map("n", "<leader>f?", "<cmd>Telescope help_tags<cr>")
end
