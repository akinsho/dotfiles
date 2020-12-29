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
end

execute "packadd packer.nvim"

-- cfilter plugin allows filter down an existing quickfix list
execute "packadd! cfilter"

execute "autocmd BufWritePost plugins.lua PackerCompile"

as_utils.map("n", "<leader>pi", [[<Cmd>PackerInstall<CR>]])
as_utils.map("n", "<leader>ps", [[<Cmd>PackerStatus<CR>]])
as_utils.map("n", "<leader>pc", [[<Cmd>PackerClean<CR>]])
as_utils.map("n", "<leader>pu", [[<Cmd>PackerUpdate<CR>]])

---@param path string
local function dev(path)
  return "~/Desktop/projects/" .. path
end

--[[
    NOTE "use" functions cannot call *upvalues* i.e. the functions
    passed to setup or config etc. cannot reference aliased function
    or local variables
--]]
return require("packer").startup {
  function(use)
    ---@param path string
    local function local_use(path)
      local plug_path = dev(path)
      if fn.isdirectory(fn.expand(plug_path)) == 1 then
        use(plug_path)
      end
    end

    -- Packer can manage itself as an optional plugin
    use {"wbthomason/packer.nvim", opt = true}
    --------------------------------------------------------------------------------
    -- Core {{{
    ---------------------------------------------------------------------------------
    use "nvim-lua/plenary.nvim" -- the mother of dependencies
    use "airblade/vim-rooter"
    use {"junegunn/fzf", run = "./install --all"}
    use "junegunn/fzf.vim"
    use "mhinz/vim-startify"
    use {
      "christoomey/vim-tmux-navigator",
      cond = function()
        return vim.env.TMUX ~= nil
      end
    }

    if has("mac") then
      use "neoclide/coc.nvim"
      use "honza/vim-snippets"
    else
      use {
        "neovim/nvim-lspconfig",
        config = [[require("as.lsp")]],
        requires = {
          {"nvim-lua/lsp-status.nvim"},
          {"RishabhRD/nvim-lsputils", requires = {"RishabhRD/popfix"}},
          dev "personal/flutter-tools.nvim"
        }
      }
      use "RishabhRD/nvim-cheat.sh"
      use {
        "nvim-lua/completion-nvim",
        config = require("as.settings.completion"),
        requires = {{"aca/completion-tabnine", run = "./install.sh"}}
      }
      use {"lewis6991/gitsigns.nvim", config = require("as.settings.gitsigns")}
      use {"mfussenegger/nvim-dap", config = require("as.settings.dap")}
      use {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          vim.g.dap_virtual_text = true
        end
      }
      use {
        "hrsh7th/vim-vsnip",
        config = require("as.settings.vim-vsnip"),
        requires = {"hrsh7th/vim-vsnip-integ"}
      }
    end
    --}}}
    --------------------------------------------------------------------------------
    -- Utilities {{{
    ---------------------------------------------------------------------------------
    use {"chip/vim-fat-finger", event = "CursorHoldI * "}
    use "arecarn/vim-fold-cycle"
    use "cohama/lexima.vim"
    use "psliwka/vim-smoothie"
    use "mg979/vim-visual-multi"
    use "itchyny/vim-highlighturl"
    use "luochen1990/rainbow"
    use "liuchengxu/vim-which-key"
    -- TODO marks are currently broken in neovim i.e. deleted marks are resurrected
    -- on restarting nvim so disable mark related plugins.
    use {"kshenoy/vim-signature", disable = true}
    use {"mbbill/undotree", cmd = "UndotreeToggle"}
    use {"mhinz/vim-sayonara", cmd = "Sayonara"}
    use {"vim-test/vim-test", cmd = {"TestFile", "TestNearest", "TestSuite"}}
    use {
      "rrethy/vim-hexokinase",
      run = "make hexokinase",
      config = function()
        vim.g.Hexokinase_ftDisabled = {"vimwiki"}
      end
    }
    use {"AndrewRadev/tagalong.vim", ft = {"typescriptreact", "javascriptreact", "html"}}
    -- https://github.com/iamcco/markdown-preview.nvim/issues/50
    use {"iamcco/markdown-preview.nvim", run = ":call mkdp#util#install()", ft = {"markdown"}}
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
    --}}}
    --------------------------------------------------------------------------------
    -- Profiling {{{
    --------------------------------------------------------------------------------
    use {"tweekmonster/startuptime.vim", cmd = "StartupTime"}
    --}}}
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
    --}}}
    --------------------------------------------------------------------------------
    -- Syntax {{{
    --------------------------------------------------------------------------------
    use "Yggdroot/indentLine"
    use {
      "sheerun/vim-polyglot",
      setup = function()
        vim.g.polyglot_disabled = {"sensible"}
      end
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
    --}}}
    --------------------------------------------------------------------------------
    -- Search Tools {{{
    --------------------------------------------------------------------------------
    use "justinmk/vim-sneak"
    use "junegunn/vim-peekaboo"
    use {"junegunn/goyo.vim", ft = {"vimwiki", "markdown"}}
    --}}}
    ---------------------------------------------------------------------------------
    -- Themes  {{{
    ----------------------------------------------------------------------------------
    -- vim-one has a MUCH better startup time than onedark and has a light theme
    use "rakr/vim-one"
    --}}}
    ---------------------------------------------------------------------------------
    -- Dev plugins  {{{
    ---------------------------------------------------------------------------------
    use "kyazdani42/nvim-web-devicons"
    use {
      "kyazdani42/nvim-tree.lua",
      cmd = "NvimTreeOpen",
      keys = {"<c-n>"},
      config = require("as.settings.nvim-tree")
    }
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = require("as.settings.treesitter"),
      requires = {
        "p00f/nvim-ts-rainbow",
        {
          "nvim-treesitter/playground",
          cmd = "TSPlaygroundToggle",
          cond = function()
            return vim.fn.has("mac") == 0
          end
        }
      }
    }
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

      local_use "personal/dependency-assist.nvim"
      local_use "personal/nvim-toggleterm.lua"
      use {dev "personal/nvim-bufferline.lua", config = require("as.settings.nvim-bufferline")}
    else
      use "akinsho/dependency-assist.nvim"
      use "akinsho/nvim-toggleterm.lua"
      use {"akinsho/nvim-bufferline.lua", config = require("as.settings.nvim-bufferline")}
    end
    --}}}
    ---------------------------------------------------------------------------------
  end,
  config = {
    display = {
      open_cmd = "topleft 65vnew [packer]"
    }
  }
}
--}}}

-- vim:foldmethod=marker
