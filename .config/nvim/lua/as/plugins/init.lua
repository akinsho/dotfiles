local fn = vim.fn
local has = as_utils.has
local is_work = has("mac")
local is_home = not is_work

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
  elseif not vim.env.DEVELOPING then
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

--- Helper function to allow deriving the base path for local plugins.
--- If this is hard coded moving things around becomes painful.
--- This helper also automatically disables any local plugins on work machines
--- @param use function
local function create_local(use)
  ---@param spec any
  return function(spec)
    local path = ""
    if type(spec) == "table" then
      path = dev(spec[1])
      spec[1] = path
      spec.disable = spec.disable or is_work
    elseif type(spec) == "string" then
      path = dev(spec)
      spec = {path, disable = is_work}
    end
    if fn.isdirectory(fn.expand(path)) == 1 then
      use(spec)
    end
  end
end

local function developing()
  return vim.env.DEVELOPING ~= nil
end

local function not_developing()
  return not vim.env.DEVELOPING
end

local function hunspell_install_if_needed()
  if vim.fn.executable("hunspell") == 0 then
    if vim.fn.has("mac") > 0 then
      -- on mac os need to download GB dictionary
      -- and place in ~/Library/Spelling
      -- these are available
      -- https://wiki.openoffice.org/wiki/Dictionaries
      vim.fn.system("brew install hunspell")
    else
      vim.fn.system("apt install hunspell hunspell_en_gb")
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
    local use_local = create_local(use)

    -- Packer can manage itself as an optional plugin
    use {"wbthomason/packer.nvim", cond = not_developing}
    use_local {"contributing/packer.nvim", as = "local-packer", cond = developing}
    --------------------------------------------------------------------------------
    -- Core {{{
    ---------------------------------------------------------------------------------
    use_rocks {"penlight", "lua-resty-http", "lua-cjson"}
    use_rocks {"luaformatter", server = "https://luarocks.org/dev"}

    use {
      "airblade/vim-rooter",
      config = function()
        vim.g.rooter_silent_chdir = 1
        vim.g.rooter_resolve_links = 1
      end
    }
    -- TODO FZF vs Telescope
    use {"junegunn/fzf", run = "./install --all", disable = false}
    use {
      "nvim-telescope/telescope.nvim",
      config = require("as.plugins.telescope"),
      requires = {
        "nvim-lua/popup.nvim",
        {
          "nvim-telescope/telescope-github.nvim",
          config = function()
            require("telescope").load_extension("gh")
          end
        },
        {
          "nvim-telescope/telescope-frecency.nvim",
          requires = {"tami5/sql.nvim"},
          config = function()
            require("telescope").load_extension("frecency")
          end
        },
        {
          "nvim-telescope/telescope-fzy-native.nvim",
          config = function()
            require("telescope").load_extension("fzy_native")
          end
        },
        {"nvim-telescope/telescope-fzf-writer.nvim"}
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
    use {"christoomey/vim-tmux-navigator", config = require("as.plugins.tmux-navigator")}
    use "nvim-lua/plenary.nvim"
    -- }}}
    -----------------------------------------------------------------------------//
    -- LSP,Completion & Debugger {{{
    -----------------------------------------------------------------------------//
    use {"mfussenegger/nvim-dap", config = require("as.plugins.dap"), ft = {"dart"}}
    use {"lewis6991/gitsigns.nvim", config = require("as.plugins.gitsigns"), commit = "63ba88f"}

    use {"neoclide/coc.nvim", config = require("as.plugins.coc"), disable = is_home}
    use {"honza/vim-snippets", disable = is_home}

    use {
      "neovim/nvim-lspconfig",
      config = require("as.plugins.lspconfig"),
      event = "VimEnter",
      disable = is_work,
      requires = {
        {
          "nvim-lua/lsp-status.nvim",
          config = function()
            local status = require("lsp-status")
            status.config {
              indicator_hint = "",
              indicator_info = "",
              indicator_errors = "✗",
              indicator_warnings = "",
              status_symbol = " "
            }
            status.register_progress()
          end
        },
        {
          dev "personal/flutter-tools.nvim",
          config = require("as.plugins.flutter"),
          after = "nvim-lspconfig"
        },
        {
          "glepnir/lspsaga.nvim",
          config = require("as.plugins.lspsaga"),
          after = "nvim-lspconfig"
        },
        {"alexaandru/nvim-lspupdate", cmd = "LspUpdate"},
        {"kosayoda/nvim-lightbulb", config = require("as.plugins.lightbulb")}
      }
    }

    use {
      "hrsh7th/nvim-compe",
      event = "InsertEnter",
      disable = is_work,
      config = require("as.plugins.compe"),
      requires = {{"tzachar/compe-tabnine", run = "./install.sh"}}
    }
    use {
      "hrsh7th/vim-vsnip",
      disable = is_work,
      config = require("as.plugins.vim-vsnip"),
      event = "InsertEnter"
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Utilities {{{
    ---------------------------------------------------------------------------------
    use {
      "arecarn/vim-fold-cycle",
      config = function()
        vim.g.fold_cycle_default_mapping = 0
        as_utils.map("n", "<BS>", "<Plug>(fold-cycle-close)", {silent = true})
      end
    }
    use {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup()
      end
    }
    use "psliwka/vim-smoothie"
    use {
      "luochen1990/rainbow",
      config = function()
        vim.g.rainbow_active = 1
        -- enable only for dart
        vim.g.rainbow_conf = {
          separately = {
            ["*"] = 0,
            dart = {
              operators = "",
              parentheses = {[[start=/(/ end=/)/ fold]], [[start=/\[/ end=/\]/ fold]]}
            }
          }
        }
      end
    }
    use {"mg979/vim-visual-multi", config = require("as.plugins.vim-visual-multi")}
    use {"itchyny/vim-highlighturl", config = [[vim.g.highlighturl_guifg = "NONE"]]}
    -- NOTE: marks are currently broken in neovim i.e. deleted marks are resurrected on restarting nvim
    use {"kshenoy/vim-signature", disable = true}
    use {
      "mbbill/undotree",
      cmd = "UndotreeToggle",
      keys = "<leader>u",
      config = function()
        vim.g.undotree_TreeNodeShape = "◦" -- Alternative: '◉'
        vim.g.undotree_SetFocusWhenToggle = 1
        as_utils.map("n", "<leader>u", "<cmd>UndotreeToggle<CR>")
      end
    }
    use {
      "vim-test/vim-test",
      cmd = {"TestFile", "TestNearest", "TestSuite"},
      keys = {"<localleader>tt", "<localleader>tf", "<localleader>tn", "<localleader>ts"},
      config = require("as.plugins.vim-test")
    }
    use {"liuchengxu/vim-which-key", config = require("as.plugins.whichkey")}
    use {"AndrewRadev/tagalong.vim", ft = {"typescriptreact", "javascriptreact", "html"}}
    use {
      "iamcco/markdown-preview.nvim",
      run = ":call mkdp#util#install()",
      ft = {"markdown"},
      config = function()
        vim.g.mkdp_auto_start = 0
        vim.g.mkdp_auto_close = 1
      end
    }
    use {
      "rrethy/vim-hexokinase",
      run = "make hexokinase",
      ft = {
        "lua",
        "dart",
        "css",
        "html",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact"
      },
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
      keys = {"<leader>ww", "<leader>wt", "<leader>wi"},
      event = {"BufEnter *.wiki"},
      setup = require("as.plugins.vimwiki").setup,
      config = require("as.plugins.vimwiki").config
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
    use "tpope/vim-eunuch"
    use "tpope/vim-repeat"
    use {"tpope/vim-abolish", config = require("as.plugins.abolish")}
    -- sets searchable path for filetypes like go so 'gf' works
    use "tpope/vim-apathy"
    use {"tpope/vim-projectionist", config = require("as.plugins.vim-projectionist")}
    use {
      "tpope/vim-surround",
      config = function()
        as_utils.map("v", "s", "<Plug>VSurround", {silent = true})
        as_utils.map("v", "s", "<Plug>VSurround", {silent = true})
      end
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Syntax {{{
    --------------------------------------------------------------------------------
    use {
      "lukas-reineke/indent-blankline.nvim",
      branch = "lua",
      event = "BufRead",
      config = require("as.plugins.indentline")
    }
    use {
      "sheerun/vim-polyglot",
      config = require("as.plugins.polyglot").config,
      setup = require("as.plugins.polyglot").setup
    }
    ---}}}
    --------------------------------------------------------------------------------
    -- Git {{{
    --------------------------------------------------------------------------------
    use {"tpope/vim-fugitive", config = require("as.plugins.fugitive")}
    use {
      "rhysd/conflict-marker.vim",
      config = function()
        -- disable the default highlight group
        vim.g.conflict_marker_highlight_group = ""
        -- Include text after begin and end markers
        vim.g.conflict_marker_begin = "^<<<<<<< .*$"
        vim.g.conflict_marker_end = "^>>>>>>> .*$"
      end
    }
    use {
      "TimUntersberger/neogit",
      cmd = "Neogit",
      keys = "<localleader>gS",
      config = function()
        as_utils.map(
          "n",
          "<localleader>gS",
          [[<cmd>lua require("neogit").status.create("split")<CR>]]
        )
      end
    }
    use {
      "kdheepak/lazygit.nvim",
      cmd = "LazyGit",
      keys = "<leader>lg",
      config = function()
        as_utils.map("n", "<leader>lg", "<cmd>LazyGit<CR>")
        vim.g.lazygit_floating_window_winblend = 2
      end
    }
    ---}}}
    --------------------------------------------------------------------------------
    -- Text Objects {{{
    --------------------------------------------------------------------------------
    use "AndrewRadev/splitjoin.vim"
    use {"AndrewRadev/dsf.vim", config = require("as.plugins.dsf")}
    use {"AndrewRadev/sideways.vim", config = require("as.plugins.sideways")}
    use {"svermeulen/vim-subversive", config = require("as.plugins.subversive")}
    use {"chaoren/vim-wordmotion", config = require("as.plugins.vim-wordmotion")}
    use {
      "b3nj5m1n/kommentary",
      config = function()
        require("kommentary.config").configure_language(
          "lua",
          {prefer_single_line_comments = true, single_line_comment_string = "--"}
        )
      end
    }
    use {
      "tommcdo/vim-exchange",
      config = function()
        vim.g.exchange_no_mappings = 1
        as_utils.map("x", "X", "<Plug>(Exchange)", {silent = true})
        as_utils.map("n", "X", "<Plug>(Exchange)", {silent = true})
        as_utils.map("n", "Xc", "<Plug>(ExchangeClear)", {silent = true})
      end
    }
    use "wellle/targets.vim"
    use {
      "kana/vim-textobj-user",
      requires = {
        "kana/vim-operator-user",
        {
          "glts/vim-textobj-comment",
          config = function()
            vim.g.textobj_comment_no_default_key_mappings = 1
            local opts = {noremap = false, silent = true}
            as_utils.map("x", "ax", "<Plug>(textobj-comment-a)", opts)
            as_utils.map("o", "ax", "<Plug>(textobj-comment-a)", opts)
            as_utils.map("x", "ix", "<Plug>(textobj-comment-i)", opts)
            as_utils.map("o", "ix", "<Plug>(textobj-comment-i)", opts)
          end
        }
      }
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Search Tools {{{
    --------------------------------------------------------------------------------
    use {
      "phaazon/hop.nvim",
      keys = {{"n", "s"}},
      config = function()
        require("hop").setup {winblend = 100}
        as_utils.map("n", "s", [[<cmd>HopChar1<CR>]])
      end
    }
    use {"junegunn/goyo.vim", ft = {"vimwiki", "markdown"}, config = require("as.plugins.goyo")}
    use "junegunn/vim-peekaboo"
    -- }}}
    ---------------------------------------------------------------------------------
    -- Themes  {{{
    ----------------------------------------------------------------------------------
    -- vim-one has a MUCH better startup time than onedark and has a light theme
    use {"rakr/vim-one", disable = false}
    use {"joshdick/onedark.vim", disable = true}
    use {"bluz71/vim-nightfly-guicolors", disable = true}
    -- }}}
    ---------------------------------------------------------------------------------
    -- Dev plugins  {{{
    ---------------------------------------------------------------------------------
    use "kyazdani42/nvim-web-devicons"
    use {
      "kyazdani42/nvim-tree.lua",
      cmd = "NvimTreeOpen",
      keys = "<c-n>",
      config = require("as.plugins.nvim-tree"),
      cond = not_developing
    }
    use_local {
      "contributing/nvim-tree.lua",
      as = "local-nvim-tree",
      config = require("as.plugins.nvim-tree"),
      cond = developing
    }
    -- Treesitter cannot be run as an optional plugin and most be available on start
    -- if not it obscurely breaks nvim-lspconfig...
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = require("as.plugins.treesitter"),
      requires = {
        {
          "lewis6991/spellsitter.nvim",
          run = hunspell_install_if_needed,
          config = function()
            require("spellsitter").setup {captures = {"comment"}}
          end
        },
        {"nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter"},
        {"nvim-treesitter/playground", cmd = "TSPlaygroundToggle", disable = is_work}
      }
    }
    use_local {"contributing/nvim-treesitter", as = "local-treesitter", disable = true}

    local dep_assist = function()
      return require("dependency_assist").setup()
    end

    -----------------------------------------------------------------------------//
    -- Work plugins
    -----------------------------------------------------------------------------//
    use {
      "akinsho/dependency-assist.nvim",
      config = dep_assist,
      disable = is_home,
      ft = {"dart", "rust"}
    }
    use {
      "akinsho/nvim-toggleterm.lua",
      config = require("as.plugins.toggleterm"),
      branch = "feature/allow-specifying-directory",
      keys = [[<c-\>]],
      disable = is_home
    }
    use {
      "akinsho/nvim-bufferline.lua",
      config = require("as.plugins.nvim-bufferline"),
      disable = is_home
    }
    -----------------------------------------------------------------------------//
    -- Personal plugins
    -----------------------------------------------------------------------------//
    use {"rafcamlet/nvim-luapad", cmd = "Luapad", disable = is_work}
    use_local {
      "personal/dependency-assist.nvim",
      config = dep_assist,
      as = "local-dep-assist",
      ft = {"dart", "rust"}
    }
    use_local {
      "personal/nvim-toggleterm.lua",
      config = require("as.plugins.toggleterm"),
      as = "local-toggleterm",
      keys = [[<c-\>]]
    }
    -- TODO could be lazy loaded if the color library was separate functionality
    use_local {
      "personal/nvim-bufferline.lua",
      as = "local-bufferline",
      config = require("as.plugins.nvim-bufferline")
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
