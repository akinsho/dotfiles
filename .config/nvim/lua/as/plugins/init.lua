local fn = vim.fn
local has = as_utils.has
local is_work = has("mac")
local is_home = not is_work
local fmt = string.format

local function setup_packer()
  --- use a wildcard to match on local and upstream versions of packer
  local install_path = fn.stdpath("data") .. "/site/pack/packer/*/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    print("Downloading packer.nvim...")
    local output =
      fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
    print(output)
    vim.cmd "packadd packer.nvim"
    require("packer").sync()
  elseif not vim.env.DEVELOPING then
    vim.cmd "packadd packer.nvim"
  else
    vim.cmd "packadd local-packer.nvim"
  end
end

-- Make sure packer is installed on the current machine and load
-- the dev or upstream version depending on if we are at work or not
setup_packer()

-- cfilter plugin allows filter down an existing quickfix list
vim.cmd "packadd! cfilter"

vim.cmd "autocmd! BufWritePost */as/plugins/*.lua PackerCompile"
vim.cmd [[autocmd! BufWritePost */as/plugins/init.lua execute "luafile ".expand("%")]]

as_utils.nnoremap("<leader>ps", [[<Cmd>PackerSync<CR>]])
as_utils.nnoremap("<leader>pc", [[<Cmd>PackerClean<CR>]])

---@param path string
local function dev(path)
  return os.getenv("HOME") .. "/Desktop/projects/" .. path
end

local function is_bleeding_edge()
  return not vim.env.STABLE
end

local function is_stable()
  return vim.env.STABLE ~= nil
end

local function developing()
  return vim.env.DEVELOPING ~= nil
end

local function not_developing()
  return not vim.env.DEVELOPING
end

local openssl_dir = has("mac") and "/usr/local/Cellar/openssl@1.1/1.1.1j" or "/usr/"

--- Automagically register local and report plugins as well as when they are enabled or disabled
--- 1. Local plugins that I created should be used but specified with their git urls so they are
--- installed from git on other machines
--- 2. If DEVELOPING is set to true then local plugins I contribute to should be loaded vs their
--- remote counterparts
---@param spec table
local function with_local(spec)
  local path = ""
  if type(spec) ~= "table" then
    return as_utils.echomsg(fmt("spec must be a table", spec[1]))
  end
  local local_spec = vim.deepcopy(spec)
  if not local_spec.local_path then
    return as_utils.echomsg(fmt("%s has no specified local path", spec[1]))
  end

  local name = vim.split(spec[1], "/")[2]
  path = dev(local_spec.local_path .. "/" .. name)
  if not fn.isdirectory(fn.expand(path)) == -1 then
    return spec, nil
  end
  local is_contributing = local_spec.local_path:match("contributing") ~= nil
  local_spec[1] = path
  local_spec.as = local_spec.local_name or fmt("local-%s", name)
  local_spec.cond = is_contributing and developing or local_spec.local_cond
  local_spec.disable = is_work or local_spec.local_disable

  spec.disable = not is_contributing and is_home or false
  spec.cond = is_contributing and not_developing or nil

  spec.local_path = nil
  spec.local_cond = nil
  spec.local_disable = nil

  local_spec.tag = nil
  local_spec.branch = nil
  local_spec.commit = nil
  local_spec.local_path = nil
  local_spec.local_cond = nil
  local_spec.local_disable = nil
  local_spec.local_name = nil

  return spec, local_spec
end

local function use_local(original)
  local use = require("packer").use
  local spec, local_spec = with_local(original)
  if local_spec then
    use(local_spec)
  end
  use(spec)
end

---Require a plugin config
---@param name string
---@return function
local function conf(name)
  return require(fmt("as.plugins.%s", name))
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
    use_local {"wbthomason/packer.nvim", local_path = "contributing"}
    --------------------------------------------------------------------------------
    -- Core {{{
    ---------------------------------------------------------------------------------
    use_rocks {"penlight", "lua-resty-http", "lua-cjson"}

    use {
      "airblade/vim-rooter",
      config = function()
        vim.g.rooter_silent_chdir = 1
        vim.g.rooter_resolve_links = 1
      end
    }
    use {"glepnir/dashboard-nvim", config = conf("dashboard")}
    use {
      "nvim-telescope/telescope.nvim",
      config = conf("telescope"),
      requires = {
        "nvim-lua/popup.nvim",
        {
          "nvim-telescope/telescope-frecency.nvim",
          requires = {"tami5/sql.nvim"},
          after = "telescope.nvim"
        },
        {"nvim-telescope/telescope-fzy-native.nvim", after = "telescope.nvim"},
        {
          "nvim-telescope/telescope-arecibo.nvim",
          rocks = {{"openssl", env = {OPENSSL_DIR = openssl_dir}}, "lua-http-parser"}
        },
        {"nvim-telescope/telescope-fzf-writer.nvim"}
      }
    }
    use {
      "dhruvasagar/vim-dotoo",
      config = function()
        vim.g["dotoo#agenda#files"] = {"~/Dropbox/todos/*.dotoo", "~/Documents/dotoo-files/*.dotoo"}
        vim.g["dotoo#capture#refile"] = vim.fn.expand("~/Documents/dotoo-files/refile.dotoo")
      end
    }
    use {"christoomey/vim-tmux-navigator", config = conf("tmux-navigator")}
    use "nvim-lua/plenary.nvim"
    -- }}}
    -----------------------------------------------------------------------------//
    -- LSP,Completion & Debugger {{{
    -----------------------------------------------------------------------------//
    use {"mfussenegger/nvim-dap", config = conf("dap")}

    use {"neoclide/coc.nvim", config = conf("coc"), cond = is_stable, disable = is_home}
    use {"honza/vim-snippets", cond = is_stable, disable = is_home}

    use {
      "neovim/nvim-lspconfig",
      config = conf("lspconfig"),
      cond = is_bleeding_edge,
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
        {"glepnir/lspsaga.nvim", config = conf("lspsaga")},
        {
          "kabouzeid/nvim-lspinstall",
          opt = true,
          config = function()
            require("lspinstall").post_install_hook = function()
              as_utils.lsp.setup_servers()
              vim.cmd("bufdo e")
            end
          end
        }
      }
    }

    use_local {
      "akinsho/flutter-tools.nvim",
      after = "nvim-lspconfig",
      config = conf("flutter"),
      cond = is_bleeding_edge,
      requires = {"nvim-dap", "nvim-lspconfig"},
      local_path = "personal"
    }

    use {
      "hrsh7th/nvim-compe",
      cond = is_bleeding_edge,
      config = conf("compe"),
      requires = {{"tzachar/compe-tabnine", run = "./install.sh", after = "nvim-compe"}}
    }
    use {
      "hrsh7th/vim-vsnip",
      cond = is_bleeding_edge,
      config = conf("vim-vsnip"),
      event = "InsertEnter",
      requires = {"rafamadriz/friendly-snippets"}
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Utilities {{{
    ---------------------------------------------------------------------------------
    use {
      "arecarn/vim-fold-cycle",
      config = function()
        vim.g.fold_cycle_default_mapping = 0
        as_utils.nmap("<BS>", "<Plug>(fold-cycle-close)")
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
    use {"mg979/vim-visual-multi", config = conf("vim-visual-multi")}
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
        as_utils.nnoremap("<leader>u", "<cmd>UndotreeToggle<CR>")
      end
    }
    use {
      "vim-test/vim-test",
      cmd = {"TestFile", "TestNearest", "TestSuite"},
      keys = {"<localleader>tt", "<localleader>tf", "<localleader>tn", "<localleader>ts"},
      config = conf("vim-test")
    }
    use {"liuchengxu/vim-which-key", config = conf("whichkey")}
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
      setup = conf("vimwiki").setup,
      config = conf("vimwiki").config
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Profiling {{{
    --------------------------------------------------------------------------------
    use {"dstein64/vim-startuptime", cmd = "StartupTime"}
    -- }}}
    --------------------------------------------------------------------------------
    -- TPOPE {{{
    --------------------------------------------------------------------------------
    use "tpope/vim-eunuch"
    use "tpope/vim-repeat"
    use {"tpope/vim-abolish", config = conf("abolish")}
    -- sets searchable path for filetypes like go so 'gf' works
    use {"tpope/vim-apathy", ft = {"go", "python", "javascript", "typescript"}}
    use {"tpope/vim-projectionist", config = conf("vim-projectionist")}
    use {
      "tpope/vim-surround",
      config = function()
        as_utils.vmap("s", "<Plug>VSurround")
        as_utils.vmap("s", "<Plug>VSurround")
      end
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Syntax {{{
    --------------------------------------------------------------------------------
    use {
      "lukas-reineke/indent-blankline.nvim",
      branch = "lua",
      config = conf("indentline")
    }
    use {
      "sheerun/vim-polyglot",
      config = conf("polyglot").config,
      setup = conf("polyglot").setup
    }
    ---}}}
    --------------------------------------------------------------------------------
    -- Git {{{
    --------------------------------------------------------------------------------
    use {"tpope/vim-fugitive", keys = {"<localleader>gS"}, config = conf("fugitive")}
    use {"lewis6991/gitsigns.nvim", config = conf("gitsigns")}
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
    use_local {
      "RianFuro/neogit",
      cmd = "Neogit",
      keys = {"<localleader>gs", "<localleader>gl", "<localleader>gp"},
      local_path = "contributing",
      local_disable = true,
      branch = "sane-folds",
      config = function()
        require("neogit").setup {
          disable_signs = true, -- BUG: currently show signs in incorrect places
          signs = {
            section = {"", ""},
            item = {"▸", "▾"},
            hunk = {"樂", ""}
          }
        }
        local nnoremap = as_utils.nnoremap
        nnoremap("<localleader>gs", "<cmd>Neogit kind=vsplit<CR>")
        nnoremap("<localleader>gc", "<cmd>Neogit commitCR>")
        nnoremap("<localleader>gl", "<cmd>lua require('neogit.popups.pull').create()<CR>")
        nnoremap("<localleader>gp", "<cmd>lua require('neogit.popups.push').create()<CR>")
      end
    }

    use {
      "kdheepak/lazygit.nvim",
      cmd = "LazyGit",
      keys = "<leader>lg",
      config = function()
        as_utils.nnoremap("<leader>lg", "<cmd>LazyGit<CR>")
        vim.g.lazygit_floating_window_winblend = 2
      end
    }
    use {
      "pwntester/octo.nvim",
      cmd = "Octo",
      config = function()
        require("telescope").load_extension("octo")
      end
    }
    ---}}}
    --------------------------------------------------------------------------------
    -- Text Objects {{{
    --------------------------------------------------------------------------------
    use "AndrewRadev/splitjoin.vim"
    use {"AndrewRadev/dsf.vim", config = conf("dsf")}
    use {"AndrewRadev/sideways.vim", config = conf("sideways")}
    use {"svermeulen/vim-subversive", config = conf("subversive")}
    use {"chaoren/vim-wordmotion", config = conf("vim-wordmotion")}
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
        as_utils.xmap("X", "<Plug>(Exchange)")
        as_utils.nmap("X", "<Plug>(Exchange)")
        as_utils.nmap("Xc", "<Plug>(ExchangeClear)")
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
            as_utils.xmap("ax", "<Plug>(textobj-comment-a)")
            as_utils.omap("ax", "<Plug>(textobj-comment-a)")
            as_utils.xmap("ix", "<Plug>(textobj-comment-i)")
            as_utils.omap("ix", "<Plug>(textobj-comment-i)")
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
        -- remove h,j,k,l from hops list of keys
        require("hop").setup {keys = "etovxqpdygfbzcisuran"}
        as_utils.nnoremap("s", [[<cmd>HopChar1<CR>]])
      end
    }
    use {"junegunn/goyo.vim", ft = {"vimwiki", "markdown"}, config = conf("goyo")}
    use "tversteeg/registers.nvim"
    -- }}}
    ---------------------------------------------------------------------------------
    -- Themes  {{{
    ----------------------------------------------------------------------------------
    use "Th3Whit3Wolf/one-nvim"
    use {"romgrk/doom-one.vim", opt = true}
    use {"joshdick/onedark.vim", opt = true}
    use {"bluz71/vim-nightfly-guicolors", opt = true}
    -- }}}
    ---------------------------------------------------------------------------------
    -- Dev plugins  {{{
    ---------------------------------------------------------------------------------
    use "kyazdani42/nvim-web-devicons"

    use_local {
      "kyazdani42/nvim-tree.lua",
      cmd = "NvimTreeOpen",
      keys = "<c-n>",
      config = conf("nvim-tree"),
      local_path = "contributing"
    }

    -- Treesitter cannot be run as an optional plugin and most be available on start
    -- if not it obscurely breaks nvim-lspconfig...
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = conf("treesitter"),
      requires = {
        {
          "lewis6991/spellsitter.nvim",
          cond = "false",
          run = hunspell_install_if_needed,
          config = function()
            require("spellsitter").setup {captures = {"comment"}}
          end
        },
        {"nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter"},
        {"nvim-treesitter/playground", cmd = "TSPlaygroundToggle", disable = is_work}
      },
      local_path = "contributing"
    }

    use {"rafcamlet/nvim-luapad", cmd = "Luapad", disable = is_work}
    -----------------------------------------------------------------------------//
    -- Personal plugins
    -----------------------------------------------------------------------------//
    use_local {
      "akinsho/dependency-assist.nvim",
      config = function()
        return require("dependency_assist").setup()
      end,
      ft = {"dart", "rust"},
      local_path = "personal"
    }
    use_local {
      "akinsho/nvim-toggleterm.lua",
      config = conf("toggleterm"),
      keys = [[<c-\>]],
      local_path = "personal"
    }
    -- TODO: could be lazy loaded if the color library was separate functionality
    use_local {
      "akinsho/nvim-bufferline.lua",
      config = conf("nvim-bufferline"),
      local_path = "personal"
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
