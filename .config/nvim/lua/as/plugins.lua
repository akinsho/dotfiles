local execute = vim.cmd
local api = vim.api
local fn = vim.fn
local env = vim.env
local has = function(feature)
  return fn.has(feature) > 0
end

local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

-- cfilter plugin allows filter down an existing quickfix list
execute "packadd! cfilter"
execute "packadd packer.nvim"

execute "autocmd BufWritePost plugins.lua PackerCompile"

local opts = {noremap = true, silent = true}
api.nvim_set_keymap("n", "<leader>pi", [[:PlugInstall<CR>]], opts)
api.nvim_set_keymap("n", "<leader>ps", [[:PlugStatus<CR>]], opts)
api.nvim_set_keymap("n", "<leader>pc", [[:PlugClean<CR>]], opts)
api.nvim_set_keymap("n", "<leader>pu", [[:PlugUpdate<CR>]], opts)

return require("packer").startup(
  function()
    -- Packer can manage itself as an optional plugin
    use {"wbthomason/packer.nvim", opt = true}

    use "airblade/vim-rooter"
    use {"junegunn/fzf", dir = "~/.fzf", run = "./install --all"}
    use "junegunn/fzf.vim"
    use "mhinz/vim-startify"
    use {
      "christoomey/vim-tmux-navigator",
      opt = true,
      cond = function()
        return vim.env["TMUX"] ~= nil
      end
    }
    use {
      "RishabhRD/nvim-lsputils",
      requires = {"RishabhRD/popfix"}
    }
    -- configs for neovim's lsp
    use "neovim/nvim-lspconfig"
    use "nvim-lua/plenary.nvim"
    use {
      "nvim-lua/completion-nvim",
      opt = true,
      requires = {
        {
          "aca/completion-tabnine",
          run = "version=3.1.9 ./install.sh",
          opt = true
        }
      }
    }
    -- lsp + snippets
    use "hrsh7th/vim-vsnip"
    use "hrsh7th/vim-vsnip-integ"
    -- lsp status line
    use "nvim-lua/lsp-status.nvim"
    use "lewis6991/gitsigns.nvim"
    --------------------------------------------------------------------------------
    -- Utilities {{{1
    ---------------------------------------------------------------------------------
    use {"chip/vim-fat-finger", event = "CursorHoldI * "}
    use "arecarn/vim-fold-cycle"
    -- https://github.com/iamcco/markdown-preview.nvim/issues/50
    use {
      "iamcco/markdown-preview.nvim",
      opt = true,
      run = ":call mkdp#util#install()",
      ft = {"markdown"}
    }
    use "cohama/lexima.vim"
    use "psliwka/vim-smoothie"
    use {"mbbill/undotree", cmd = {"UndotreeToggle"}}
    use {"mhinz/vim-sayonara", cmd = "Sayonara"}
    use {"vim-test/vim-test", cmd = {"TestFile", "TestNearest", "TestSuite"}}
    use {"rrethy/vim-hexokinase", run = "make hexokinase"}
    use {
      "AndrewRadev/tagalong.vim",
      ft = {"typescriptreact", "javascriptreact", "html"}
    }
    use {"mg979/vim-visual-multi", branch = "master"}
    use "itchyny/vim-highlighturl"
    use "luochen1990/rainbow"
    use {"kshenoy/vim-signature", disabled = true}
    use {
      "liuchengxu/vim-which-key",
      setup = function()
        vim.g.which_leader_key_map = {}
        vim.g.which_localleader_key_map = {}
      end
    }
    ---------------------------------------------------------------------------------
    -- Knowledge and task management
    ---------------------------------------------------------------------------------
    -- TODO marks are currently broken in neovim i.e. deleted marks are resurrected on restarting nvim
    -- so disable mark related plugins. Remove this guard when this problem is fixed
    use {"vimwiki/vimwiki", ft = {"<Plug>VimwikiIndex", "<Plug>ViwikiTabIndex"}}
    --------------------------------------------------------------------------------
    -- Profiling {{{1
    --------------------------------------------------------------------------------
    use {"tweekmonster/startuptime.vim", cmd = "StartupTime", opt = true}
    --------------------------------------------------------------------------------
    -- TPOPE {{{1
    --------------------------------------------------------------------------------
    use "tpope/vim-commentary"
    use "tpope/vim-surround"
    use "tpope/vim-eunuch"
    use "tpope/vim-repeat"
    use "tpope/vim-abolish"
    -- sets searchable path for filetypes like go so 'gf' works
    use "tpope/vim-apathy"
    use "tpope/vim-projectionist"
    --------------------------------------------------------------------------------
    -- Syntax {{{1
    --------------------------------------------------------------------------------
    use "Yggdroot/indentLine"
    use {
      "sheerun/vim-polyglot",
      setup = function()
        vim.g.polyglot_disabled = {"sensible"}
      end
    }
    --------------------------------------------------------------------------------
    -- Git {{{1
    --------------------------------------------------------------------------------
    use "tpope/vim-fugitive"
    use "rhysd/conflict-marker.vim"
    use {"kdheepak/lazygit.nvim", cmd = "LazyGit", opt = true}
    --------------------------------------------------------------------------------
    -- Text Objects {{{1
    --------------------------------------------------------------------------------
    use "AndrewRadev/splitjoin.vim"
    use "svermeulen/vim-subversive"
    use "AndrewRadev/dsf.vim"
    ----------------------------------------------------------------------------//
    -- Deprecated: Word transposition mappings from in favour of the plugin below:
    -- http://superuser.com/questions/290360/how-to-switch-words-in-an-easy-manner-in-vim/290449#290449
    ----------------------------------------------------------------------------//
    use "AndrewRadev/sideways.vim"
    use "chaoren/vim-wordmotion"
    use "tommcdo/vim-exchange"
    use "wellle/targets.vim"
    use {
      "kana/vim-textobj-user",
      requires = {"kana/vim-operator-user", "glts/vim-textobj-comment"}
    }
    --------------------------------------------------------------------------------
    -- Search Tools {{{1
    --------------------------------------------------------------------------------
    use "justinmk/vim-sneak"
    use "junegunn/vim-peekaboo"
    use {"junegunn/goyo.vim", ft = {"vimwiki", "markdown"}}
    ---------------------------------------------------------------------------------
    -- Themes  {{{1
    ----------------------------------------------------------------------------------
    -- vim-one has a MUCH better startup time than onedark and has a light theme
    use "rakr/vim-one"
    -- More actively maintained that vim-one
    -- use {'joshdick/onedark.vim'}
    ---------------------------------------------------------------------------------
    -- Dev plugins  {{{1
    ---------------------------------------------------------------------------------
    if not has("mac") then
      use "lukas-reineke/format.nvim"
      -- Plugin for visualising the tree sitter tree whilst developing
      use {"nvim-treesitter/playground", cmd = {"TSPlaygroundToggle"}}
      use {"rafcamlet/nvim-luapad", cmd = {"Luapad"}}
      use "p00f/nvim-ts-rainbow"
    end

    if env.DEVELOPING then
      use "~/Desktop/projects/personal/nvim-toggleterm.lua"
      use "~/Desktop/projects/personal/nvim-bufferline.lua"
      use "~/Desktop/projects/personal/dependency-assist.nvim"
      use "~/Desktop/projects/personal/flutter-tools.nvim"

      use "~/Desktop/projects/contributing/nvim-web-devicons"
      use "~/Desktop/projects/contributing/nvim-treesitter"
      use "~/Desktop/projects/contributing/nvim-tree.lua"
    else
      use "kyazdani42/nvim-tree.lua"
      use "akinsho/nvim-toggleterm.lua"
      use "akinsho/nvim-bufferline.lua"
      use "akinsho/dependency-assist.nvim"
      use "akinsho/flutter-tools.nvim"
      use "kyazdani42/nvim-web-devicons"
      use {"nvim-treesitter/nvim-treesitter", run = "TSUpdate"}
    end
  end
)

-- vim:foldmethod=marker
