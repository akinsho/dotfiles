local execute = vim.cmd
local has = function(feature)
  return vim.fn.has(feature) > 0
end

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  local output =
    vim.fn.system(
    string.format("git clone %s %s", "https://github.com/wbthomason/packer.nvim", install_path)
  )
  print(output)
  print("Downloading packer.nvim...")
end

execute "packadd packer.nvim"

-- cfilter plugin allows filter down an existing quickfix list
execute "packadd! cfilter"

execute "autocmd BufWritePost plugins.lua PackerCompile"

as_utils.map("n", "<leader>pi", [[<Cmd>PackerInstall<CR>]])
as_utils.map("n", "<leader>ps", [[<Cmd>PackerStatus<CR>]])
as_utils.map("n", "<leader>pc", [[<Cmd>PackerClean<CR>]])
as_utils.map("n", "<leader>pu", [[<Cmd>PackerUpdate<CR>]])

--[[
    NOTE "use" functions cannot call *upvalues* i.e. the functions
    passed to setup or config etc. cannot reference aliased function
    or local variables
--]]
return require("packer").startup {
  function(use)
    local function local_use(path)
      local home = "~/Desktop/projects/"
      local plug_path = home .. path
      if vim.fn.isdirectory(vim.fn.expand(plug_path)) == 1 then
        use(plug_path)
      end
    end

    -- Packer can manage itself as an optional plugin
    use {"wbthomason/packer.nvim", opt = true}
    --------------------------------------------------------------------------------
    -- Core {{{1
    ---------------------------------------------------------------------------------
    use "airblade/vim-rooter"
    use {"junegunn/fzf", run = "./install --all"}
    use "junegunn/fzf.vim"
    use "mhinz/vim-startify"
    use {
      "christoomey/vim-tmux-navigator",
      opt = true,
      cond = function()
        return vim.env.TMUX ~= nil
      end
    }

    if has("mac") then
      use "neoclide/coc.nvim"
      use "honza/vim-snippets"
    else
      use "neovim/nvim-lspconfig"
      use "nvim-lua/plenary.nvim"
      use {"RishabhRD/nvim-lsputils", requires = {"RishabhRD/popfix"}}
      use {
        "nvim-lua/completion-nvim",
        requires = {{"aca/completion-tabnine", run = "version=3.1.9 ./install.sh"}}
      }
      use "hrsh7th/vim-vsnip"
      use "hrsh7th/vim-vsnip-integ"
      use "nvim-lua/lsp-status.nvim"
      use "lewis6991/gitsigns.nvim"
    end
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
    use {"AndrewRadev/tagalong.vim", ft = {"typescriptreact", "javascriptreact", "html"}}
    use "mg979/vim-visual-multi"
    use "itchyny/vim-highlighturl"
    use "luochen1990/rainbow"
    use "liuchengxu/vim-which-key"
    -- TODO marks are currently broken in neovim i.e. deleted marks are resurrected on restarting nvim
    -- so disable mark related plugins. Remove this guard when this problem is fixed
    use {"kshenoy/vim-signature", disable = true}
    ---------------------------------------------------------------------------------
    -- Knowledge and task management
    ---------------------------------------------------------------------------------
    use {
      "vimwiki/vimwiki",
      branch = "dev",
      keys = {",ww", ",wt", ",wi"},
      event = {"BufEnter *.wiki"},
      requires = {"tools-life/taskwiki"}
    }
    --------------------------------------------------------------------------------
    -- Profiling {{{1
    --------------------------------------------------------------------------------
    use {"tweekmonster/startuptime.vim", cmd = "StartupTime"}
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
    use {"kdheepak/lazygit.nvim", cmd = "LazyGit"}
    --------------------------------------------------------------------------------
    -- Text Objects {{{1
    --------------------------------------------------------------------------------
    use "AndrewRadev/splitjoin.vim"
    use "svermeulen/vim-subversive"
    use "AndrewRadev/dsf.vim"
    use "AndrewRadev/sideways.vim"
    use "chaoren/vim-wordmotion"
    use "tommcdo/vim-exchange"
    use "wellle/targets.vim"
    use {"kana/vim-textobj-user", requires = {"kana/vim-operator-user", "glts/vim-textobj-comment"}}
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
    ---------------------------------------------------------------------------------
    -- Dev plugins  {{{1
    ---------------------------------------------------------------------------------
    if not has("mac") then
      -- Plugin for visualising the tree sitter tree whilst developing
      use {"nvim-treesitter/playground", cmd = {"TSPlaygroundToggle"}}
      use {"rafcamlet/nvim-luapad", cmd = {"Luapad"}}
    end

    use "kyazdani42/nvim-tree.lua"
    use "kyazdani42/nvim-web-devicons"
    use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate", requires = {"p00f/nvim-ts-rainbow"}}

    if not has("mac") then
      -- FIXME: toggling plugins with "vim.env.DEVELOPING" doesn't work
      -- packer doesn't swap between both groups of plugins
      -- as it doesn't recognise that the plugin set have changed so local
      -- plugins aren't loaded. awaiting:
      -- https://github.com/wbthomason/packer.nvim/issues/137
      -- https://github.com/wbthomason/packer.nvim/issues/118
      -- local_use "contributing/nvim-tree.lua"
      -- local_use "contributing/nvim-web-devicons"
      -- local_use "contributing/nvim-treesitter"

      local_use "personal/nvim-toggleterm.lua"
      local_use "personal/nvim-bufferline.lua"
      local_use "personal/dependency-assist.nvim"
      local_use "personal/flutter-tools.nvim"
    else
      use "akinsho/nvim-toggleterm.lua"
      use "akinsho/nvim-bufferline.lua"
      use "akinsho/dependency-assist.nvim"
      use "akinsho/flutter-tools.nvim"
    end
  end,
  config = {
    display = {
      open_cmd = "topleft 65vnew [packer]"
    }
  }
}

-- vim:foldmethod=marker
