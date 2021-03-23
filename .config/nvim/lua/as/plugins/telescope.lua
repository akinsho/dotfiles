as_utils.telescope = {}

return function()
  local nnoremap = as_utils.nnoremap
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local sorters = require("telescope.sorters")
  local builtins = require("telescope.builtin")
  local themes = require("telescope.themes")

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

  function as_utils.telescope.files()
    -- Launch file search using Telescope
    if vim.fn.isdirectory(".git") > 0 then
      -- if in a git project, use :Telescope git_files
      builtins.git_files()
    else
      -- otherwise, use :Telescope find_files
      builtins.find_files()
    end
  end

  function as_utils.telescope.dotfiles()
    builtins.find_files {
      prompt_title = "~ dotfiles ~",
      shorten_path = false,
      cwd = vim.g.dotfiles,
      layout_strategy = "horizontal",
      layout_config = {
        preview_width = 0.65
      }
    }
  end

  function as_utils.telescope.nvim_config()
    builtins.find_files {
      prompt_title = "~ nvim config ~",
      shorten_path = false,
      cwd = vim.g.vim_dir,
      layout_strategy = "horizontal",
      layout_config = {
        preview_width = 0.65
      }
    }
  end

  function as_utils.telescope.frecency()
    telescope.extensions.frecency.frecency(
      themes.get_dropdown {
        winblend = 10,
        border = true,
        previewer = false,
        shorten_path = false
      }
    )
  end

  -- Find files using Telescope command-line sugar.
  nnoremap("<C-P>", "<cmd>lua as_utils.telescope.files()<CR>")
  nnoremap("<leader>fa", "<cmd>Telescope<cr>")
  nnoremap("<leader>ff", "<cmd>Telescope find_files<cr>")
  nnoremap("<leader>fh", "<cmd>lua as_utils.telescope.frecency()<cr>")

  nnoremap("<leader>fb", "<cmd>Telescope git_branches theme=get_dropdown<cr>")
  nnoremap("<leader>fd", "<cmd>lua as_utils.telescope.dotfiles()<cr>")
  nnoremap("<leader>fn", "<cmd>lua as_utils.telescope.nvim_config()<cr>")
  nnoremap("<leader>fc", "<cmd>Telescope git_commits<cr>")

  -- LSP mappings, currently only bound on linux since we use coc on mac
  if vim.g.is_linux then
    nnoremap("<leader>cd", "<cmd>Telescope lsp_workspace_diagnostics <cr>")
  end

  nnoremap("<leader>fr", "<cmd>Telescope reloader theme=get_dropdown<cr>")
  nnoremap("<leader>fs", "<cmd>lua require('telescope').extensions.fzf_writer.staged_grep()<CR>")
  nnoremap("<leader>fo", "<cmd>Telescope buffers show_all_buffers=true<cr> ")
  nnoremap("<leader>f?", "<cmd>Telescope help_tags<cr>")
end
