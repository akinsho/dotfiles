local fn = vim.fn
local has = as.has
local is_work = has("mac")
local is_home = not is_work
local fmt = string.format

local PACKER_COMPILED_PATH = fn.stdpath("cache") .. "/packer/packer_compiled.vim"

local function setup_packer()
  --- use a wildcard to match on local and upstream versions of packer
  local install_path = fn.stdpath("data") .. "/site/pack/packer/*/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    print("Downloading packer.nvim...")
    print(fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path}))
    vim.cmd "packadd! packer.nvim"
    require("packer").sync()
  elseif not vim.env.DEVELOPING then
    vim.cmd "packadd! packer.nvim"
  else
    vim.cmd "packadd! local-packer.nvim"
  end
end

-- Make sure packer is installed on the current machine and load
-- the dev or upstream version depending on if we are at work or not
setup_packer()

-- cfilter plugin allows filter down an existing quickfix list
vim.cmd("packadd! cfilter")

as.augroup(
  "PackerSetupInit",
  {
    {
      events = {"BufWritePost"},
      targets = {"*/as/plugins/*.lua"},
      command = function()
        as.invalidate("as.plugins", true)
        require("packer").compile()
        vim.notify("packer compiled...")
      end
    }
  }
)
as.nnoremap("<leader>ps", [[<Cmd>PackerSync<CR>]])
as.nnoremap("<leader>pc", [[<Cmd>PackerClean<CR>]])

---@param path string
local function dev(path)
  return os.getenv("HOME") .. "/Desktop/projects/" .. path
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
    return as.echomsg(fmt("spec must be a table", spec[1]))
  end
  local local_spec = vim.deepcopy(spec)
  if not local_spec.local_path then
    return as.echomsg(fmt("%s has no specified local path", spec[1]))
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

---local variant of packer's use function that specifies both a local and
---upstream version of a plugin
---@param original table|string
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

--[[
  NOTE "use" functions cannot call *upvalues* i.e. the functions
  passed to setup or config etc. cannot reference aliased function
  or local variables
--]]
require("packer").startup {
  function(use, use_rocks)
    use_local {"wbthomason/packer.nvim", local_path = "contributing"}
    --------------------------------------------------------------------------------
    -- Core {{{
    ---------------------------------------------------------------------------------
    use_rocks "penlight"

    use {
      "airblade/vim-rooter",
      config = function()
        vim.g.rooter_silent_chdir = 1
        vim.g.rooter_resolve_links = 1
      end
    }
    use {
      "rmagatti/auto-session",
      config = function()
        require("auto-session").setup {
          auto_session_root_dir = vim.fn.stdpath("data") .. "/session/auto/"
        }
      end
    }
    use {
      "nvim-telescope/telescope.nvim",
      event = "CursorHold",
      config = conf("telescope"),
      requires = {
        "nvim-lua/popup.nvim",
        "nvim-telescope/telescope-fzf-writer.nvim",
        {"nvim-telescope/telescope-fzf-native.nvim", run = "make"},
        {
          "nvim-telescope/telescope-frecency.nvim",
          requires = "tami5/sql.nvim",
          after = "telescope.nvim"
        },
        {
          "nvim-telescope/telescope-arecibo.nvim",
          rocks = {{"openssl", env = {OPENSSL_DIR = openssl_dir}}, "lua-http-parser"}
        }
      }
    }
    use {
      "dhruvasagar/vim-dotoo",
      config = function()
        vim.g["dotoo#agenda#warning_days"] = "30d"
        vim.g["dotoo#agenda#files"] = {"~/Dropbox/todos/*.dotoo", "~/Documents/dotoo-files/*.dotoo"}
        vim.g["dotoo#capture#refile"] = vim.fn.expand("~/Documents/dotoo-files/refile.dotoo")
        vim.g["dotoo#capture#templates"] = {
          t = {target = "todo"}
        }
        require("which-key").register(
          {
            g = {
              A = "dotoo agenda",
              C = "dotoo capture"
            }
          }
        )
      end
    }
    use {
      "christoomey/vim-tmux-navigator",
      config = function()
        vim.g.tmux_navigator_no_mappings = 1
        as.nnoremap("<C-H>", "<cmd>TmuxNavigateLeft<cr>")
        as.nnoremap("<C-J>", "<cmd>TmuxNavigateDown<cr>")
        as.nnoremap("<C-K>", "<cmd>TmuxNavigateUp<cr>")
        as.nnoremap("<C-L>", "<cmd>TmuxNavigateRight<cr>")
        -- Disable tmux navigator when zooming the Vim pane
        vim.g.tmux_navigator_disable_when_zoomed = 1
        vim.g.tmux_navigator_save_on_switch = 2
      end
    }
    use {
      "nvim-lua/plenary.nvim",
      config = function()
        as.augroup(
          "PlenaryTests",
          {
            {
              events = {"BufEnter"},
              targets = {"*/personal/*/tests/*_spec.lua"},
              command = function()
                require("which-key").register(
                  {
                    t = {
                      name = "+plenary",
                      f = {"<Plug>PlenaryTestFile", "test file"},
                      d = {
                        "<cmd>PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal.vim'}<CR>",
                        "test directory"
                      }
                    }
                  },
                  {prefix = "<localleader>", buffer = 0}
                )
              end
            }
          }
        )
      end
    }
    -- }}}
    -----------------------------------------------------------------------------//
    -- LSP,Completion & Debugger {{{
    -----------------------------------------------------------------------------//
    use {"mfussenegger/nvim-dap", config = conf("dap"), module = "dap", keys = {"<localleader>dtc"}}
    use {
      "rcarriga/nvim-dap-ui",
      requires = "nvim-dap",
      after = "nvim-dap",
      config = function()
        require("dapui").setup()
      end
    }
    use {"jbyuki/step-for-vimkind", requires = "nvim-dap", ft = "lua", disable = is_work}

    use "folke/lua-dev.nvim"
    use {
      "neovim/nvim-lspconfig",
      config = conf("lspconfig"),
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
        -- TODO re-add lspsaga's lightbulb once lspsaga #161 is resolved
        {
          "kosayoda/nvim-lightbulb",
          config = function()
            as.augroup(
              "NvimLightbulb",
              {
                {
                  events = {"CursorHold", "CursorHoldI"},
                  targets = {"*"},
                  command = function()
                    require("nvim-lightbulb").update_lightbulb {
                      sign = {enabled = false},
                      virtual_text = {enabled = true}
                    }
                  end
                }
              }
            )
          end
        },
        {"glepnir/lspsaga.nvim", opt = true, config = conf("lspsaga")},
        {
          "kabouzeid/nvim-lspinstall",
          opt = true,
          config = function()
            require("lspinstall").post_install_hook = function()
              as.lsp.setup_servers()
              vim.cmd("bufdo e")
            end
          end
        }
      }
    }

    use "ray-x/lsp_signature.nvim"

    use_local {
      "akinsho/flutter-tools.nvim",
      ft = "dart",
      config = function()
        local ok, lsp_status = pcall(require, "lsp-status")
        local capabilities = ok and lsp_status.capabilities or nil
        require("flutter-tools").setup {
          debugger = {
            enabled = true
          },
          widget_guides = {
            enabled = true,
            debug = true
          },
          dev_log = {open_cmd = "tabedit"},
          lsp = {
            on_attach = as.lsp and as.lsp.on_attach or nil,
            --- This is necessary to prevent lsp-status' capabilities being
            --- given priority over that of the default config
            capabilities = function(defaults)
              return vim.tbl_deep_extend("keep", defaults, capabilities)
            end
          }
        }
      end,
      requires = {"nvim-dap", "plenary.nvim"},
      local_path = "personal"
    }

    use {"hrsh7th/nvim-compe", config = conf("compe"), event = "InsertEnter"}

    use {
      "hrsh7th/vim-vsnip",
      event = "InsertEnter",
      requires = {"rafamadriz/friendly-snippets", "hrsh7th/nvim-compe"},
      config = function()
        vim.g.vsnip_snippet_dir = vim.g.vim_dir .. "/snippets/textmate"
        local opts = {expr = true}
        as.imap("<c-l>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<c-l>'", opts)
        as.smap("<c-l>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<c-l>'", opts)
        as.imap("<c-h>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<c-h>'", opts)
        as.smap("<c-h>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<c-h>'", opts)
        as.xmap("<c-j>", [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>']], opts)
        as.imap("<c-j>", [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>']], opts)
        as.smap("<c-j>", [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>']], opts)
      end
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Utilities {{{
    ---------------------------------------------------------------------------------
    use "nanotee/luv-vimdocs"
    use "milisims/nvim-luaref"

    use "kevinhwang91/nvim-bqf"
    use {
      "arecarn/vim-fold-cycle",
      config = function()
        vim.g.fold_cycle_default_mapping = 0
        as.nmap("<BS>", "<Plug>(fold-cycle-close)")
      end
    }
    use {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup {
          close_triple_quotes = true,
          check_ts = false
        }
      end
    }
    use {
      "karb94/neoscroll.nvim",
      config = function()
        require("neoscroll").setup {
          mappings = {"<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "zt", "zz", "zb"}
        }
      end
    }
    --- Highlight commandline ranges e.g. :10,20m.
    use {
      "winston0410/range-highlight.nvim",
      opt = true,
      requires = {"winston0410/cmd-parser.nvim"},
      config = function()
        require("range-highlight").setup()
      end
    }
    use {
      "mg979/vim-visual-multi",
      config = function()
        vim.g.VM_highlight_matches = "underline"
        vim.g.VM_maps = {
          ["Find Under"] = "<C-e>",
          ["Find Subword Under"] = "<C-e>",
          ["Select Cursor Down"] = [[\j]],
          ["Select Cursor Up"] = [[\k]]
        }
      end
    }
    use {
      "itchyny/vim-highlighturl",
      config = function()
        vim.g.highlighturl_guifg = require("as.highlights").hl_value("Directory", "fg")
      end
    }
    -- NOTE: marks are currently broken in neovim i.e. deleted marks are resurrected on restarting nvim
    use {"kshenoy/vim-signature", disable = true}
    use {
      "mbbill/undotree",
      cmd = "UndotreeToggle",
      keys = "<leader>u",
      config = function()
        vim.g.undotree_TreeNodeShape = "◦" -- Alternative: '◉'
        vim.g.undotree_SetFocusWhenToggle = 1
        require("which-key").register(
          {["<leader>u"] = {"<cmd>UndotreeToggle<CR>", "toggle undotree"}}
        )
      end
    }
    use {
      "vim-test/vim-test",
      cmd = {"TestFile", "TestNearest", "TestSuite"},
      keys = {"<localleader>tf", "<localleader>tn", "<localleader>ts"},
      config = function()
        vim.cmd [[
          let test#strategy = "neovim"
          let test#neovim#term_position = "vert botright"
        ]]
        require("which-key").register(
          {
            t = {
              name = "+vim-test",
              f = {"<cmd>TestFile<CR>", "test: file"},
              n = {"<cmd>TestNearest<CR>", "test: nearest"},
              s = {"<cmd>TestSuite<CR>", "test: suite"}
            }
          },
          {prefix = "<localleader>"}
        )
      end
    }
    use {"folke/which-key.nvim", config = conf("whichkey")}
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
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup(
          {"*"},
          {
            RGB = false,
            mode = "background"
          }
        )
      end
    }
    use {
      "lukas-reineke/indent-blankline.nvim",
      branch = "lua",
      config = conf("indentline")
    }
    use "kyazdani42/nvim-web-devicons"

    --- TODO use_local does not work for this plugin, find out why
    use {
      "kyazdani42/nvim-tree.lua",
      config = conf("nvim-tree"),
      local_path = "contributing",
      requires = "nvim-web-devicons"
    }

    -- FIXME: If nvim-web-devicons is specified before
    -- it is used this errors that it is used twice
    use {
      "folke/trouble.nvim",
      keys = {"<leader>ld"},
      cmd = {"TroubleToggle"},
      requires = "nvim-web-devicons",
      config = function()
        require("which-key").register(
          {
            ["<leader>ld"] = {"<cmd>TroubleToggle lsp_workspace_diagnostics<CR>", "trouble: toggle"},
            ["<leader>lr"] = {"<cmd>TroubleToggle lsp_references<cr>", "trouble: lsp references"}
          }
        )
        require("as.highlights").all {
          {"TroubleNormal", {link = "PanelBackground"}},
          {"TroubleText", {link = "PanelBackground"}},
          {"TroubleIndent", {link = "PanelVertSplit"}},
          {"TroubleFoldIcon", {guifg = "yellow", gui = "bold"}}
        }
        require("trouble").setup {auto_close = true, auto_preview = false}
      end
    }
    -- TODO: this breaks when used with sessions but keep an eye on it
    use {
      "sunjon/shade.nvim",
      opt = true,
      config = function()
        require("shade").setup()
      end
    }
    --}}}
    ---------------------------------------------------------------------------------
    -- Knowledge and task management {{{
    ---------------------------------------------------------------------------------
    use {
      "soywod/himalaya", --- Email in nvim
      rtp = "vim",
      run = "curl -sSL https://raw.githubusercontent.com/soywod/himalaya/master/install.sh | PREFIX=~/.local sh",
      config = function()
        require("which-key").register(
          {
            e = {
              name = "+email",
              l = {"<Cmd>Himalaya<CR>", "list"}
            }
          },
          {prefix = "<localleader>"}
        )
      end
    }
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
    use {
      "dstein64/vim-startuptime",
      opt = true,
      config = function()
        vim.g.startuptime_exe_args = {"+let g:auto_session_enabled = 0"}
      end
    }
    use {"tweekmonster/startuptime.vim", cmd = "StartupTime"}
    -- }}}
    --------------------------------------------------------------------------------
    -- TPOPE {{{
    --------------------------------------------------------------------------------
    use "tpope/vim-eunuch"
    use "tpope/vim-repeat"
    use {
      "tpope/vim-abolish",
      config = function()
        local opts = {silent = false}
        as.nnoremap("<localleader>[", ":S/<C-R><C-W>//<LEFT>", opts)
        as.nnoremap("<localleader>]", ":%S/<C-r><C-w>//c<left><left>", opts)
        as.vnoremap("<localleader>[", [["zy:%S/<C-r><C-o>"//c<left><left>]], opts)
      end
    }
    -- sets searchable path for filetypes like go so 'gf' works
    use {"tpope/vim-apathy", ft = {"go", "python", "javascript", "typescript"}}
    use {"tpope/vim-projectionist", config = conf("vim-projectionist")}
    use {
      "tpope/vim-surround",
      config = function()
        as.vmap("s", "<Plug>VSurround")
        as.vmap("s", "<Plug>VSurround")
      end
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Syntax {{{
    --------------------------------------------------------------------------------
    use_local {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = conf("treesitter"),
      local_path = "contributing",
      requires = {
        {
          "nvim-treesitter/playground",
          cmd = "TSPlaygroundToggle",
          module = "nvim-treesitter-playground",
          disable = is_work
        }
      }
    }
    use {
      "nvim-treesitter/nvim-treesitter-textobjects",
      requires = "nvim-treesitter"
    }
    use {
      "p00f/nvim-ts-rainbow",
      requires = "nvim-treesitter"
    }
    use {
      "mizlan/iswap.nvim",
      cmd = "ISwap",
      requires = "nvim-treesitter",
      config = function()
        require("iswap").setup {}
      end
    }
    use {
      "lewis6991/spellsitter.nvim",
      opt = true,
      config = function()
        require("spellsitter").setup {hl = "SpellBad", captures = {"comment"}}
      end
    }
    use "dart-lang/dart-vim-plugin"
    use "plasticboy/vim-markdown"
    use "mtdl9/vim-log-highlighting"
    ---}}}
    --------------------------------------------------------------------------------
    -- Git {{{
    --------------------------------------------------------------------------------
    use {
      "ruifm/gitlinker.nvim",
      requires = "plenary.nvim",
      keys = {"<localleader>gu"},
      config = function()
        require("which-key").register({["<localleader>gu"] = "gitlinker: get line url"})
        require("gitlinker").setup {opts = {mappings = "<localleader>gu"}}
      end
    }
    use {"lewis6991/gitsigns.nvim", config = conf("gitsigns"), event = "BufRead"}
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
      keys = {"<localleader>gs", "<localleader>gl", "<localleader>gp"},
      requires = "plenary.nvim",
      config = conf("neogit")
    }
    use {
      "sindrets/diffview.nvim",
      cmd = "DiffviewOpen",
      module = "diffview",
      keys = "<localleader>gd",
      config = function()
        local cb = require("diffview.config").diffview_callback
        require("which-key").register(
          {gd = {"<Cmd>DiffviewOpen<CR>", "diff ref"}},
          {prefix = "<localleader>"}
        )
        require("diffview").setup(
          {
            key_bindings = {
              file_panel = {
                ["q"] = "<Cmd>DiffviewClose<CR>",
                ["j"] = cb("next_entry"), -- Bring the cursor to the next file entry
                ["<down>"] = cb("next_entry"),
                ["k"] = cb("prev_entry"), -- Bring the cursor to the previous file entry.
                ["<up>"] = cb("prev_entry"),
                ["<cr>"] = cb("select_entry"), -- Open the diff for the selected entry.
                ["o"] = cb("select_entry"),
                ["-"] = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
                ["S"] = cb("stage_all"), -- Stage all entries.
                ["U"] = cb("unstage_all"), -- Unstage all entries.
                ["R"] = cb("refresh_files"), -- Update stats and entries in the file list.
                ["<tab>"] = cb("select_next_entry"),
                ["<s-tab>"] = cb("select_prev_entry"),
                ["<leader>e"] = cb("focus_files"),
                ["<leader>b"] = cb("toggle_files")
              },
              view = {
                ["q"] = "<Cmd>DiffviewClose<CR>",
                ["<tab>"] = cb("select_next_entry"), -- Open the diff for the next file
                ["<s-tab>"] = cb("select_prev_entry"), -- Open the diff for the previous file
                ["<leader>e"] = cb("focus_files"), -- Bring focus to the files panel
                ["<leader>b"] = cb("toggle_files") -- Toggle the files panel.
              }
            }
          }
        )
      end
    }

    use {
      "pwntester/octo.nvim",
      cmd = "Octo",
      keys = {"<localleader>opl"},
      config = function()
        require("octo").setup()
        require("which-key").register(
          {
            o = {name = "+octo", p = {l = {"<cmd>Octo pr list<CR>", "PR List"}}}
          },
          {prefix = "<localleader>"}
        )
      end
    }
    ---}}}
    -----------------------------------------------------------------------------//
    -- UI {{{
    -----------------------------------------------------------------------------//
    use {
      "folke/zen-mode.nvim",
      cmd = {"ZenMode"},
      config = function()
        require("zen-mode").setup {
          window = {
            backdrop = 1,
            options = {
              number = false,
              relativenumber = false
            }
          },
          plugins = {
            gitsigns = {enabled = true},
            tmux = {enabled = true}
          }
        }
      end
    }
    ---}}}
    --------------------------------------------------------------------------------
    -- Text Objects {{{
    --------------------------------------------------------------------------------
    use "AndrewRadev/splitjoin.vim"
    use {
      "AndrewRadev/dsf.vim",
      config = function()
        vim.g.dsf_no_mappings = 1
        require("which-key").register(
          {
            d = {
              name = "+dsf: function text object",
              s = {
                f = {"<Plug>DsfDelete", "delete surrounding function"},
                nf = {"<Plug>DsfNextDelete", "delete next surrounding function"}
              }
            },
            c = {
              name = "+dsf: function text object",
              s = {
                f = {"<Plug>DsfChange", "change surrounding function"},
                nf = {"<Plug>DsfNextChange", "change next surrounding function"}
              }
            }
          }
        )
      end
    }
    use {
      "AndrewRadev/sideways.vim",
      config = function()
        vim.g.sideways_add_item_cursor_restore = 1
        require("which-key").register(
          {
            ["]w"] = {"<cmd>SidewaysLeft<cr>", "move argument left"},
            ["[w"] = {"<cmd>SidewaysRight<cr>", "move argument right"},
            ["<localleader>s"] = {
              name = "+sideways",
              i = {"<Plug>SidewaysArgumentInsertBefore", "insert argument before"},
              a = {"<Plug>SidewaysArgumentAppendAfter", "insert argument after"},
              I = {"<Plug>SidewaysArgumentInsertFirst", "insert argument first"},
              A = {"<Plug>SidewaysArgumentAppendLast", "insert argument last"}
            }
          }
        )
      end
    }
    use {
      "chaoren/vim-wordmotion",
      config = function()
        -- Restore Vim's special case behavior with dw and cw:
        as.nmap("dw", "de")
        as.nmap("cw", "ce")
        as.nmap("dW", "dE")
        as.nmap("cW", "cE")
      end
    }
    use {
      "b3nj5m1n/kommentary",
      config = function()
        require("kommentary.config").configure_language("lua", {prefer_single_line_comments = true})
      end
    }
    use {
      "tommcdo/vim-exchange",
      config = function()
        vim.g.exchange_no_mappings = 1
        as.xmap("X", "<Plug>(Exchange)")
        as.nmap("X", "<Plug>(Exchange)")
        as.nmap("Xc", "<Plug>(ExchangeClear)")
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
            as.xmap("ax", "<Plug>(textobj-comment-a)")
            as.omap("ax", "<Plug>(textobj-comment-a)")
            as.xmap("ix", "<Plug>(textobj-comment-i)")
            as.omap("ix", "<Plug>(textobj-comment-i)")
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
        local hop = require("hop")
        -- remove h,j,k,l from hops list of keys
        hop.setup {keys = "etovxqpdygfbzcisuran"}
        as.nnoremap("s", hop.hint_char1)
      end
    }
    -- }}}
    ---------------------------------------------------------------------------------
    -- Themes  {{{
    ----------------------------------------------------------------------------------
    use "romgrk/doom-one.vim"
    use {"monsonjeremy/onedark.nvim", opt = true}
    use {"Th3Whit3Wolf/one-nvim", opt = true}
    -- }}}
    ---------------------------------------------------------------------------------
    -- Dev plugins  {{{
    ---------------------------------------------------------------------------------
    use {
      "norcalli/nvim-terminal.lua",
      event = "BufEnter *_spec.lua",
      disable = is_work,
      config = function()
        require("terminal").setup()
      end
    }
    use {"rafcamlet/nvim-luapad", cmd = "Luapad", disable = is_work}
    -----------------------------------------------------------------------------//
    -- Personal plugins
    -----------------------------------------------------------------------------//
    use_local {
      "akinsho/dependency-assist.nvim",
      local_path = "personal",
      branch = "feature/delay-loading-modules",
      config = function()
        return require("dependency_assist").setup()
      end
    }

    use_local {
      "akinsho/nvim-toggleterm.lua",
      local_path = "personal",
      config = function()
        require("toggleterm").setup {
          persist_size = false,
          open_mapping = [[<c-\>]],
          shade_filetypes = {"none"},
          direction = "vertical",
          float_opts = {border = "curved"},
          size = function(term)
            if term.direction == "horizontal" then
              return 15
            elseif term.direction == "vertical" then
              return vim.o.columns * 0.4
            end
          end
        }

        local lazygit =
          require("toggleterm.terminal").Terminal:new {
          cmd = "lazygit",
          dir = "git_dir",
          hidden = true,
          direction = "float",
          on_open = function(term)
            vim.cmd("startinsert!")
            if vim.fn.mapcheck("jk", "t") ~= "" then
              vim.api.nvim_buf_del_keymap(term.bufnr, "t", "jk")
              vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
            end
          end
        }

        local function toggle()
          lazygit:toggle()
        end
        require("which-key").register({["<leader>lg"] = {toggle, "toggleterm: toggle lazygit"}})
      end
    }
    use_local {
      "akinsho/nvim-bufferline.lua",
      config = conf("nvim-bufferline"),
      local_path = "personal",
      requires = "nvim-web-devicons"
    }
    -- }}}
    ---------------------------------------------------------------------------------
  end,
  config = {
    compile_path = PACKER_COMPILED_PATH,
    display = {
      open_cmd = "silent topleft 65vnew Packer"
    },
    profile = {
      enable = true,
      threshold = 1
    }
  }
}

if not vim.g.packer_compiled_loaded and vim.loop.fs_stat(PACKER_COMPILED_PATH) then
  vim.cmd(fmt("source %s", PACKER_COMPILED_PATH))
  vim.g.packer_compiled_loaded = true
end
-- }}}

-- vim:foldmethod=marker
