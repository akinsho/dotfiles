as_utils.telescope = {}

return function()
  local nnoremap = as_utils.nnoremap
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

  ---find if passed in directory contains the target
  ---which is the current buffer's path by default
  ---@param path string
  ---@param target string
  ---@return boolean
  local function is_within(path, target)
    target = vim.fn.expand("%")
    return vim.fn.globpath(path, target) ~= ""
  end

  ---General finds files function which changes the picker depending
  ---on the current buffers path.
  function as_utils.telescope.files()
    -- Launch file search using Telescope
    if is_within(vim.g.vim_dir) then
      as_utils.telescope.nvim_config()
    elseif is_within(vim.g.dotfiles) then
      as_utils.telescope.dotfiles()
    elseif vim.fn.isdirectory(".git") > 0 then
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

  function as_utils.telescope.buffers()
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
  nnoremap("<leader>fo", "<cmd>lua as_utils.telescope.buffers()<CR>")
  nnoremap("<leader>f?", "<cmd>Telescope help_tags<cr>")
end
