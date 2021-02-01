local fn = vim.fn
local has = as_utils.has
local is_work = has("mac")

local function setup_packer()
  --- use a wildcard to match on local and upstream versions of packer
  local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/*packer*"
  if fn.empty(fn.glob(install_path)) > 0 then
    print("Downloading packer.nvim...")
    local output =
      fn.system(
      string.format("git clone %s %s", "https://github.com/wbthomason/packer.nvim", install_path)
    )
    print(output)
    vim.cmd "packadd packer.nvim"
    vim.cmd "PackerInstall"
  elseif is_work then
    vim.cmd "packadd packer.nvim"
  else
    vim.cmd "packadd local-packer"
  end
end

-- Make sure packer is installed on the current machine and load
-- the dev or upstream version depending on if we are at work or not
setup_packer()

-- cfilter plugin allows filter down an existing quickfix list
vim.cmd "packadd! cfilter"

vim.cmd "autocmd! BufWritePost */as/plugins/*.lua PackerCompile"
vim.cmd [[autocmd! BufWritePost */as/plugins/init.lua execute "luafile ".expand("%")]]

as_utils.map("n", "<leader>ps", [[<Cmd>PackerSync<CR>]])
as_utils.map("n", "<leader>pc", [[<Cmd>PackerClean<CR>]])

---@param path string
local function dev(path)
  return os.getenv("HOME") .. "/Desktop/projects/" .. path
end

-- helper function to allow deriving the base path
-- for local plugins. If this is hard coded
-- moving things around (which I've done previously) becomes painful
---@param use function
local function create_local(use)
  ---@param spec string | table
  return function(spec)
    local path = ""
    if type(spec) == "table" then
      path = dev(spec[1])
      spec[1] = path
    elseif type(spec) == "string" then
      path = dev(spec)
      spec = path
    end
    if fn.isdirectory(fn.expand(path)) == 1 then
      use(spec)
    end
  end
end

--[[
    NOTE "use" functions cannot call *upvalues* i.e. the functions
    passed to setup or config etc. cannot reference aliased function
    or local variables
--]]
return require("packer").startup {
  function(use, use_rocks)
    local local_use = create_local(use)

    -- Packer can manage itself as an optional plugin
    use {"wbthomason/packer.nvim", opt = true, disable = not is_work}
    local_use {"contributing/packer.nvim", opt = true, as = "local-packer", disable = is_work}
    --------------------------------------------------------------------------------
    -- Core {{{
    ---------------------------------------------------------------------------------
    use_rocks "penlight" -- lua utility library

    use "airblade/vim-rooter"
    -- TODO FZF vs Telescope
    use {"junegunn/fzf", run = "./install --all", disable = false}
    use {"junegunn/fzf.vim", config = require("as.plugins.fzf"), disable = true}
    use {
      "nvim-telescope/telescope.nvim",
      config = require("as.plugins.telescope"),
      requires = {
        "nvim-lua/popup.nvim",
        {"nvim-telescope/telescope-frecency.nvim", requires = {"tami5/sql.nvim"}}
      }
    }
    use {
      "dhruvasagar/vim-prosession",
      requires = {"tpope/vim-obsession"},
      config = function()
        vim.g.prosession_dir = vim.fn.stdpath("data") .. "/session"
        vim.g.prosession_on_startup = 1
        vim.g.prosession_per_branch = 1
      end
    }
    use "christoomey/vim-tmux-navigator"
    use "nvim-lua/plenary.nvim"
    -- }}}
    -----------------------------------------------------------------------------//
    -- LSP,Completion & Debugger {{{
    -----------------------------------------------------------------------------//
    use {"mfussenegger/nvim-dap", config = require("as.plugins.dap")}
    use {"lewis6991/gitsigns.nvim", config = require("as.plugins.gitsigns")}
    use {"neoclide/coc.nvim", config = require("as.plugins.coc"), disable = not is_work}
    use {"honza/vim-snippets", disable = not is_work}

    use {"anott03/nvim-lspinstall", cmd = "InstallLS", disable = is_work}
    use {
      "neovim/nvim-lspconfig",
      disable = is_work,
      requires = {
        "nvim-lua/lsp-status.nvim",
        dev "personal/flutter-tools.nvim",
        {
          "glepnir/lspsaga.nvim",
          config = require("as.plugins.lspsaga")
        }
      }
    }
    use {
      "hrsh7th/nvim-compe",
      disable = is_work,
      config = require("as.plugins.compe")
    }
    use {
      "hrsh7th/vim-vsnip",
      disable = is_work,
      config = require("as.plugins.vim-vsnip")
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Utilities {{{
    ---------------------------------------------------------------------------------
    use "arecarn/vim-fold-cycle"
    use "cohama/lexima.vim"
    use "psliwka/vim-smoothie"
    use "mg979/vim-visual-multi"
    use "luochen1990/rainbow"
    use {"itchyny/vim-highlighturl", config = [[vim.g.highlighturl_guifg = "NONE"]]}
    -- NOTE: marks are currently broken in neovim i.e.
    -- deleted marks are resurrected on restarting nvim
    -- use {"kshenoy/vim-signature"}
    use {"mbbill/undotree", cmd = "UndotreeToggle"}
    use {"vim-test/vim-test", cmd = {"TestFile", "TestNearest", "TestSuite"}}
    use {"liuchengxu/vim-which-key", config = require("as.plugins.whichkey")}
    use {"AndrewRadev/tagalong.vim", ft = {"typescriptreact", "javascriptreact", "html"}}
    use {"iamcco/markdown-preview.nvim", run = ":call mkdp#util#install()", ft = {"markdown"}}
    use {
      "rrethy/vim-hexokinase",
      run = "make hexokinase",
      setup = function()
        vim.g.Hexokinase_ftDisabled = {"vimwiki"}
      end
    }
    --}}}
    ---------------------------------------------------------------------------------
    -- Knowledge and task management {{{
    ---------------------------------------------------------------------------------
    use {
      "vimwiki/vimwiki",
      branch = "dev",
      keys = {",ww", ",wt", ",wi"},
      event = {"BufEnter *.wiki"}
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Profiling {{{
    --------------------------------------------------------------------------------
    use {"tweekmonster/startuptime.vim", cmd = "StartupTime"}
    -- }}}
    --------------------------------------------------------------------------------
    -- TPOPE {{{
    --------------------------------------------------------------------------------
    use "tpope/vim-commentary"
    use "tpope/vim-surround"
    use "tpope/vim-eunuch"
    use "tpope/vim-repeat"
    use "tpope/vim-abolish"
    -- sets searchable path for filetypes like go so 'gf' works
    use "tpope/vim-apathy"
    use "tpope/vim-projectionist"
    -- }}}
    --------------------------------------------------------------------------------
    -- Syntax {{{
    --------------------------------------------------------------------------------
    use {"Yggdroot/indentLine", config = require("as.plugins.indentline")}
    use {
      "sheerun/vim-polyglot",
      config = require("as.plugins.polyglot"),
      setup = [[vim.g.polyglot_disabled = {"sensible"}]]
    }
    ---}}}
    --------------------------------------------------------------------------------
    -- Git {{{
    --------------------------------------------------------------------------------
    use "tpope/vim-fugitive"
    use "rhysd/conflict-marker.vim"
    use {"kdheepak/lazygit.nvim", cmd = "LazyGit"}
    ---}}}
    --------------------------------------------------------------------------------
    -- Text Objects {{{
    --------------------------------------------------------------------------------
    use "AndrewRadev/splitjoin.vim"
    use "svermeulen/vim-subversive"
    use "AndrewRadev/dsf.vim"
    use "AndrewRadev/sideways.vim"
    use "chaoren/vim-wordmotion"
    use "tommcdo/vim-exchange"
    use "wellle/targets.vim"
    use {"kana/vim-textobj-user", requires = {"kana/vim-operator-user", "glts/vim-textobj-comment"}}
    -- }}}
    --------------------------------------------------------------------------------
    -- Search Tools {{{
    --------------------------------------------------------------------------------
    use "justinmk/vim-sneak"
    use "junegunn/vim-peekaboo"
    use {"junegunn/goyo.vim", ft = {"vimwiki", "markdown"}}
    -- }}}
    ---------------------------------------------------------------------------------
    -- Themes  {{{
    ----------------------------------------------------------------------------------
    -- vim-one has a MUCH better startup time than onedark and has a light theme
    use "rakr/vim-one"
    -- use "bluz71/vim-nightfly-guicolors"
    -- }}}
    ---------------------------------------------------------------------------------
    -- Dev plugins  {{{
    ---------------------------------------------------------------------------------
    use "kyazdani42/nvim-web-devicons"
    use {
      "kyazdani42/nvim-tree.lua",
      cmd = "NvimTreeOpen",
      keys = {"<c-n>"},
      config = require("as.plugins.nvim-tree"),
      disable = vim.env.DEVELOPING
    }
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = require("as.plugins.treesitter"),
      disable = vim.env.DEVELOPING,
      requires = {
        {"p00f/nvim-ts-rainbow"},
        {
          "nvim-treesitter/playground",
          cmd = "TSPlaygroundToggle",
          cond = function()
            return vim.fn.has("mac") == 0
          end
        }
      }
    }
    local_use {
      "contributing/nvim-tree.lua",
      as = "local-nvim-tree",
      disable = not vim.env.DEVELOPING
    }
    local_use {
      "contributing/nvim-treesitter",
      as = "local-treesitter",
      disable = not vim.env.DEVELOPING
    }

    local dep_assist = function()
      return require("dependency_assist").setup()
    end

    -----------------------------------------------------------------------------//
    -- Work plugins
    -----------------------------------------------------------------------------//
    use {
      "akinsho/dependency-assist.nvim",
      config = dep_assist,
      disable = not is_work
    }
    use {
      "akinsho/nvim-toggleterm.lua",
      config = require("as.plugins.toggleterm"),
      disable = not is_work
    }
    use {
      "akinsho/nvim-bufferline.lua",
      config = require("as.plugins.nvim-bufferline"),
      disable = not is_work
    }
    -----------------------------------------------------------------------------//
    -- Personal plugins
    -----------------------------------------------------------------------------//
    use {"rafcamlet/nvim-luapad", cmd = "Luapad", disable = is_work}
    local_use {
      "personal/dependency-assist.nvim",
      config = dep_assist,
      disable = is_work,
      as = "local-dep-assist"
    }
    local_use {
      "personal/nvim-toggleterm.lua",
      config = require("as.plugins.toggleterm"),
      as = "local-toggleterm",
      disable = is_work
    }
    local_use {
      "personal/nvim-bufferline.lua",
      as = "local-bufferline",
      config = require("as.plugins.nvim-bufferline"),
      disable = is_work
    }
    -- }}}
    ---------------------------------------------------------------------------------
  end,
  config = {
    display = {
      open_cmd = "topleft 65vnew [packer]"
    }
  }
}
-- }}}

-- vim:foldmethod=marker
