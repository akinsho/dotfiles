local execute = vim.cmd
local fn = vim.fn
local has = function(feature)
  return fn.has(feature) > 0
end

local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  local output =
    fn.system(
    string.format("git clone %s %s", "https://github.com/wbthomason/packer.nvim", install_path)
  )
  print(output)
  print("Downloading packer.nvim...")
  execute "packadd packer.nvim"
  execute "PackerInstall"
else
  execute "packadd packer.nvim"
end

-- cfilter plugin allows filter down an existing quickfix list
execute "packadd! cfilter"

execute "autocmd! BufWritePost */as/plugins/*.lua PackerCompile"

as_utils.map("n", "<leader>pi", [[<Cmd>PackerInstall<CR>]])
as_utils.map("n", "<leader>ps", [[<Cmd>PackerStatus<CR>]])
as_utils.map("n", "<leader>pc", [[<Cmd>PackerClean<CR>]])
as_utils.map("n", "<leader>pu", [[<Cmd>PackerUpdate<CR>]])

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
  function(use)
    local local_use = create_local(use)
    -- Packer can manage itself as an optional plugin
    use {"wbthomason/packer.nvim", opt = true}
    --------------------------------------------------------------------------------
    -- Core {{{
    ---------------------------------------------------------------------------------
    use "airblade/vim-rooter"
    use {"junegunn/fzf", run = "./install --all"}
    use {"junegunn/fzf.vim", config = require("as.plugins.fzf")}
    use {
      "dhruvasagar/vim-prosession",
      requires = {"tpope/vim-obsession"},
      config = function()
        vim.g.prosession_dir = vim.fn.stdpath("data") .. "/session"
        vim.g.prosession_on_startup = 1
      end
    }
    use "christoomey/vim-tmux-navigator"
    use "nvim-lua/plenary.nvim" -- the mother of dependencies
    -----------------------------------------------------------------------------//
    -- LSP,Completion & Debugger
    -----------------------------------------------------------------------------//
    use {"mfussenegger/nvim-dap", config = require("as.plugins.dap")}
    use {"lewis6991/gitsigns.nvim", config = require("as.plugins.gitsigns")}
    if has("mac") then
      use "neoclide/coc.nvim"
      use "honza/vim-snippets"
    else
      use {
        "neovim/nvim-lspconfig",
        requires = {
          "nvim-lua/lsp-status.nvim",
          dev "personal/flutter-tools.nvim",
          {
            "RishabhRD/nvim-lsputils",
            requires = {"RishabhRD/popfix"},
            config = require("as.plugins.lsputils")
          }
        }
      }
      use {
        "nvim-lua/completion-nvim",
        config = require("as.plugins.completion"),
        requires = {
          {"nvim-treesitter/completion-treesitter"},
          {"aca/completion-tabnine", run = "./install.sh"}
        }
      }
      use {
        "hrsh7th/vim-vsnip",
        config = require("as.plugins.vim-vsnip"),
        requires = {"hrsh7th/vim-vsnip-integ"}
      }
    end
    -- }}}
    --------------------------------------------------------------------------------
    -- Utilities {{{
    ---------------------------------------------------------------------------------
    use "arecarn/vim-fold-cycle"
    use "cohama/lexima.vim"
    use "psliwka/vim-smoothie"
    use "mg979/vim-visual-multi"
    use "itchyny/vim-highlighturl"
    use "luochen1990/rainbow"
    -- NOTE: marks are currently broken in neovim i.e.
    -- deleted marks are resurrected on restarting nvim
    -- use {"kshenoy/vim-signature"}
    use {"mhinz/vim-sayonara", cmd = "Sayonara"}
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
      event = {"BufEnter *.wiki"},
      requires = {"tools-life/taskwiki"}
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
      config = require("as.plugins.nvim-tree")
    }
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = require("as.plugins.treesitter"),
      requires = {
        {"p00f/nvim-ts-rainbow"},
        {
          "nvim-treesitter/playground",
          cmd = "TSPlaygroundToggle",
          cond = [[vim.fn.has("mac") == 0]]
        }
      }
    }

    local dep_assist = function()
      return require("dependency_assist").setup()
    end

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

      use {"rafcamlet/nvim-luapad", cmd = "Luapad"}

      local_use {"personal/dependency-assist.nvim", config = dep_assist}
      local_use {"personal/nvim-toggleterm.lua", config = require("as.plugins.toggleterm")}
      local_use {"personal/nvim-bufferline.lua", config = require("as.plugins.nvim-bufferline")}
    else
      use {"akinsho/dependency-assist.nvim", config = dep_assist}
      use {"akinsho/nvim-toggleterm.lua", config = require("as.plugins.toggleterm")}
      use {"akinsho/nvim-bufferline.lua", config = require("as.plugins.nvim-bufferline")}
    end
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
