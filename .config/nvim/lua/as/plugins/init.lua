local fn = vim.fn
local has = as.has
local is_work = has 'mac'
local is_home = not is_work
local fmt = string.format

local PACKER_COMPILED_PATH = fn.stdpath 'cache' .. '/packer/packer_compiled.lua'

-----------------------------------------------------------------------------//
-- Bootstrap Packer {{{4
-----------------------------------------------------------------------------//
-- Make sure packer is installed on the current machine and load
-- the dev or upstream version depending on if we are at work or not
-- NOTE: install packer as an opt plugin since it's loaded conditionally on my local machine
-- it needs to be installed as optional so the install dir is consistent across machines
local install_path = fmt('%s/site/pack/packer/opt/packer.nvim', fn.stdpath 'data')
if fn.empty(fn.glob(install_path)) > 0 then
  vim.notify 'Downloading packer.nvim...'
  vim.notify(
    fn.system { 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path }
  )
  vim.cmd 'packadd! packer.nvim'
  require('packer').sync()
else
  local name = vim.env.DEVELOPING and 'local-packer.nvim' or 'packer.nvim'
  vim.cmd(fmt('packadd! %s', name))
end
-----------------------------------------------------------------------------//}}}3

-- cfilter plugin allows filter down an existing quickfix list
vim.cmd 'packadd! cfilter'

as.augroup('PackerSetupInit', {
  {
    events = { 'BufWritePost' },
    targets = { '*/as/plugins/*.lua' },
    command = function()
      as.invalidate('as.plugins', true)
      require('packer').compile()
      vim.notify 'packer compiled...'
    end,
  },
})
as.nnoremap('<leader>ps', [[<Cmd>PackerSync<CR>]])
as.nnoremap('<leader>pc', [[<Cmd>PackerClean<CR>]])

---@param path string
local function dev(path)
  return os.getenv 'HOME' .. '/projects/' .. path
end

local function developing()
  return vim.env.DEVELOPING ~= nil
end

local function not_developing()
  return not vim.env.DEVELOPING
end

--- Automagically register local and remote plugins as well as managing when they are enabled or disabled
--- 1. Local plugins that I created should be used but specified with their git URLs so they are
--- installed from git on other machines
--- 2. If DEVELOPING is set to true then local plugins I contribute to should be loaded vs their
--- remote counterparts
---@param spec table
local function with_local(spec)
  assert(type(spec) == 'table', fmt('spec must be a table', spec[1]))
  assert(spec.local_path, fmt('%s has no specified local path', spec[1]))

  local name = vim.split(spec[1], '/')[2]
  local path = dev(fmt('%s/%s', spec.local_path, name))
  if fn.isdirectory(fn.expand(path)) < 1 then
    return spec, nil
  end
  local is_contributing = spec.local_path:match 'contributing' ~= nil

  local local_spec = {
    path,
    config = spec.config,
    setup = spec.setup,
    rocks = spec.rocks,
    as = fmt('local-%s', name),
    cond = is_contributing and developing or spec.local_cond,
    disable = is_work or spec.local_disable,
  }

  spec.disable = not is_contributing and is_home or false
  spec.cond = is_contributing and not_developing or nil

  --- swap the keys and event if we are currently developing
  if is_contributing and developing() and spec.keys or spec.event then
    local_spec.keys, local_spec.event, spec.keys, spec.event = spec.keys, spec.event, nil, nil
  end

  spec.event = not developing() and spec.event or nil
  spec.local_path = nil
  spec.local_cond = nil
  spec.local_disable = nil

  return spec, local_spec
end

---local variant of packer's use function that specifies both a local and
---upstream version of a plugin
---@param original table
local function use_local(original)
  local use = require('packer').use
  local spec, local_spec = with_local(original)
  if local_spec then
    use(local_spec)
  end
  use(spec)
end

---Require a plugin config
---@param name string
---@return any
local function conf(name)
  return require(fmt('as.plugins.%s', name))
end

--[[
  NOTE "use" functions cannot call *upvalues* i.e. the functions
  passed to setup or config etc. cannot reference aliased functions
  or local variables
--]]
require('packer').startup {
  function(use, use_rocks)
    use_local { 'wbthomason/packer.nvim', local_path = 'contributing', opt = true }
    -----------------------------------------------------------------------------//
    -- Core {{{3
    -----------------------------------------------------------------------------//
    use_rocks 'penlight'

    use {
      'airblade/vim-rooter',
      config = function()
        vim.g.rooter_silent_chdir = 1
        vim.g.rooter_resolve_links = 1
      end,
    }

    use_local {
      'camspiers/snap',
      rocks = { 'fzy' },
      event = 'CursorHold',
      keys = { '<c-p>', '<leader>fo' },
      local_path = 'contributing',
      setup = function()
        require('which-key').register({
          f = {
            o = 'snap: buffers',
            s = 'snap: grep',
            c = 'snap: cursor word',
            d = 'snap: dotfiles',
            O = 'snap: org files',
          },
        }, {
          prefix = '<leader>',
        })
      end,
      config = function()
        --- FIXME: remove this when/if snap changes default highlights
        require('as.highlights').plugin(
          'snap',
          { 'SnapSelect', { link = 'TextInfoBold', force = true } },
          { 'SnapPosition', { link = 'Keyword', force = true } },
          { 'SnapBorder', { guifg = 'Gray' } }
        )
        local snap = require 'snap'
        local config = require 'snap.config'
        local file = config.file:with { suffix = ' »', consumer = 'fzy' }
        local vimgrep = config.vimgrep:with { limit = 50000 }
        snap.maps {
          {
            '<c-p>',
            file { prompt = 'Project files', try = { 'git.file', 'ripgrep.file' } },
            { command = 'project-files' },
          },
          {
            '<leader>fd',
            file {
              prompt = 'Dotfiles',
              producer = 'ripgrep.file',
              args = { vim.env.DOTFILES },
            },
            { command = 'dots' },
          },
          {
            '<leader>fO',
            file {
              prompt = 'Org',
              producer = 'ripgrep.file',
              args = { vim.fn.expand '~/Dropbox/org/' },
            },
            { command = 'org' },
          },
          { '<leader>fs', vimgrep { limit = 50000 }, { command = 'grep' } },
          { '<leader>fc', vimgrep { prompt = 'Find word', filter_with = 'cword' } },
          { '<leader>fo', file { producer = 'vim.buffer' }, { command = 'buffers' } },

          --- TODO: this producer hasn't been added yet
          -- { "<leader>fl", file { producer = "vim.help" }, "Help docs" },
        }
      end,
    }

    use {
      'nvim-telescope/telescope.nvim',
      event = 'CursorHold',
      config = conf 'telescope',
      requires = {
        'nvim-lua/popup.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        {
          'nvim-telescope/telescope-frecency.nvim',
          requires = 'tami5/sql.nvim',
          after = 'telescope.nvim',
        },
        { 'camgraff/telescope-tmux.nvim' },
        { 'nvim-telescope/telescope-smart-history.nvim' },
      },
    }

    use 'kyazdani42/nvim-web-devicons'

    use { 'folke/which-key.nvim', config = conf 'whichkey' }

    use {
      'folke/trouble.nvim',
      keys = { '<leader>ld' },
      cmd = { 'TroubleToggle' },
      setup = function()
        require('which-key').register {
          ['<leader>l'] = {
            d = 'trouble: toggle',
            r = 'trouble: lsp references',
          },
        }
      end,
      requires = 'nvim-web-devicons',
      config = function()
        local H = require 'as.highlights'
        H.plugin(
          'trouble',
          { 'TroubleNormal', { link = 'PanelBackground' } },
          { 'TroubleText', { link = 'PanelBackground' } },
          { 'TroubleIndent', { link = 'PanelVertSplit' } },
          { 'TroubleFoldIcon', { guifg = 'yellow', gui = 'bold' } },
          { 'TroubleLocation', { guifg = H.get_hl('Comment', 'fg') } }
        )
        as.nnoremap('<leader>ld', '<cmd>TroubleToggle lsp_workspace_diagnostics<CR>')
        as.nnoremap('<leader>lr', '<cmd>TroubleToggle lsp_references<CR>')
        require('trouble').setup { auto_close = true, auto_preview = false }
      end,
    }

    use {
      'rmagatti/auto-session',
      config = function()
        require('auto-session').setup {
          auto_session_root_dir = vim.fn.stdpath 'data' .. '/session/auto/',
        }
      end,
    }

    use {
      'christoomey/vim-tmux-navigator',
      config = function()
        vim.g.tmux_navigator_no_mappings = 1
        as.nnoremap('<C-H>', '<cmd>TmuxNavigateLeft<cr>')
        as.nnoremap('<C-J>', '<cmd>TmuxNavigateDown<cr>')
        as.nnoremap('<C-K>', '<cmd>TmuxNavigateUp<cr>')
        as.nnoremap('<C-L>', '<cmd>TmuxNavigateRight<cr>')
        -- Disable tmux navigator when zooming the Vim pane
        vim.g.tmux_navigator_disable_when_zoomed = 1
        vim.g.tmux_navigator_save_on_switch = 2
      end,
    }

    use {
      'nvim-lua/plenary.nvim',
      config = function()
        as.augroup('PlenaryTests', {
          {
            events = { 'BufEnter' },
            targets = { '*/personal/*/tests/*_spec.lua' },
            command = function()
              require('which-key').register({
                t = {
                  name = '+plenary',
                  f = { '<Plug>PlenaryTestFile', 'test file' },
                  d = {
                    "<cmd>PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal.vim'}<CR>",
                    'test directory',
                  },
                },
              }, {
                prefix = '<localleader>',
                buffer = 0,
              })
            end,
          },
        })
      end,
    }

    use { 'lukas-reineke/indent-blankline.nvim', config = conf 'indentline' }

    use {
      'kyazdani42/nvim-tree.lua',
      config = conf 'nvim-tree',
      requires = 'nvim-web-devicons',
    }
    -- }}}
    -----------------------------------------------------------------------------//
    -- LSP,Completion & Debugger {{{4
    -----------------------------------------------------------------------------//
    use {
      'mfussenegger/nvim-dap',
      module = 'dap',
      keys = { '<localleader>dc' },
      setup = conf('dap').setup,
      config = conf('dap').config,
      requires = {
        {
          'rcarriga/nvim-dap-ui',
          requires = 'nvim-dap',
          after = 'nvim-dap',
          config = function()
            require('dapui').setup()
          end,
        },
      },
    }

    -- NOTE: curiosity rather than necessity
    use { 'Pocco81/DAPInstall.nvim', opt = true }
    use { 'jbyuki/step-for-vimkind', opt = true }

    use 'folke/lua-dev.nvim'
    use {
      'folke/todo-comments.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('todo-comments').setup {
          highlight = {
            exclude = { 'org', 'orgagenda', 'vimwiki', 'markdown' },
          },
        }
        require('which-key').register { ['<leader>lt'] = { '<Cmd>TodoTrouble<CR>', 'trouble: todos' } }
      end,
    }

    use {
      'kabouzeid/nvim-lspinstall',
      module = 'lspinstall',
      config = function()
        require('lspinstall').post_install_hook = function()
          as.lsp.setup_servers()
          vim.cmd 'bufdo e'
        end
      end,
    }

    use {
      'neovim/nvim-lspconfig',
      event = 'BufReadPre',
      config = conf 'lspconfig',
      requires = {
        {
          'nvim-lua/lsp-status.nvim',
          config = function()
            local status = require 'lsp-status'
            status.config {
              indicator_hint = '',
              indicator_info = '',
              indicator_errors = '✗',
              indicator_warnings = '',
              status_symbol = ' ',
            }
            status.register_progress()
          end,
        },
        {
          'kosayoda/nvim-lightbulb',
          config = function()
            as.augroup('NvimLightbulb', {
              {
                events = { 'CursorHold', 'CursorHoldI' },
                targets = { '*' },
                command = function()
                  require('nvim-lightbulb').update_lightbulb {
                    sign = { enabled = false },
                    virtual_text = { enabled = true },
                  }
                end,
              },
            })
          end,
        },
      },
    }

    use_local {
      'windwp/lsp-fastaction.nvim',
      local_path = 'contributing',
      config = function()
        local fastaction = require 'lsp-fastaction'
        fastaction.setup {
          action_data = {
            ['dart'] = {
              { pattern = 'import library', key = 'i', order = 1 },
              { pattern = 'wrap with widget', key = 'w', order = 2 },
              { pattern = 'column', key = 'c', order = 3 },
              { pattern = 'row', key = 'r', order = 3 },
              { pattern = 'container', key = 'C', order = 4 },
              { pattern = 'center', key = 'E', order = 4 },
              { pattern = 'padding', key = 'p', order = 4 },
              { pattern = 'remove', key = 'r', order = 5 },

              -- range code action
              { pattern = "surround with %'if'", key = 'i', order = 2 },
              { pattern = 'try%-catch', key = 't', order = 2 },
              { pattern = 'for%-in', key = 'f', order = 2 },
              { pattern = 'setstate', key = 's', order = 2 },
            },
          },
        }
        as.xnoremap('<leader>ca', "<esc><Cmd>lua require('lsp-fastaction').range_code_action()<CR>")
        require('which-key').register {
          ['<leader>ca'] = { fastaction.code_action, 'lsp: code action' },
        }
      end,
    }

    use {
      'ray-x/lsp_signature.nvim',
      config = function()
        require('lsp_signature').setup {
          bind = true,
          fix_pos = false,
          hint_enable = false,
          handler_opts = {
            border = 'rounded',
          },
        }
      end,
    }

    use_local {
      'akinsho/flutter-tools.nvim',
      config = function()
        --- TODO: this causes lsp-status to be loaded early, increasing it's startup time
        local ok, lsp_status = pcall(require, 'lsp-status')
        local capabilities = ok and lsp_status.capabilities or nil
        require('flutter-tools').setup {
          ui = {
            border = 'rounded',
          },
          debugger = {
            enabled = true,
          },
          widget_guides = {
            enabled = true,
            debug = true,
          },
          dev_log = { open_cmd = 'tabedit' },
          lsp = {
            settings = {
              showTodos = false,
            },
            on_attach = as.lsp and as.lsp.on_attach or nil,
            --- This is necessary to prevent lsp-status' capabilities being
            --- given priority over that of the default config
            capabilities = function(defaults)
              return vim.tbl_deep_extend('keep', defaults, capabilities)
            end,
          },
        }
      end,
      requires = { 'nvim-dap', 'plenary.nvim' },
      local_path = 'personal',
    }

    -- The module key is so plugins like orgmode which register a source are able to do so
    use { 'hrsh7th/nvim-compe', module = 'compe', config = conf 'compe', event = 'InsertEnter' }

    use {
      'hrsh7th/vim-vsnip',
      event = 'InsertEnter',
      requires = { 'rafamadriz/friendly-snippets', 'hrsh7th/nvim-compe' },
      config = function()
        vim.g.vsnip_snippet_dir = vim.g.vim_dir .. '/snippets/textmate'
        local opts = { expr = true }
        as.imap('<c-l>', "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<c-l>'", opts)
        as.smap('<c-l>', "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<c-l>'", opts)
        as.imap('<c-h>', "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<c-h>'", opts)
        as.smap('<c-h>', "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<c-h>'", opts)
        as.xmap('<c-j>', "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'", opts)
        as.imap('<c-j>', "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'", opts)
        as.smap('<c-j>', "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'", opts)
      end,
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Utilities {{{4
    ---------------------------------------------------------------------------------
    use 'nanotee/luv-vimdocs'
    use 'milisims/nvim-luaref'
    use {
      'kevinhwang91/nvim-bqf',
      config = function()
        require('as.highlights').plugin('bqf', { 'BqfPreviewBorder', { guifg = 'Gray' } })
      end,
    }

    use {
      'arecarn/vim-fold-cycle',
      config = function()
        vim.g.fold_cycle_default_mapping = 0
        as.nmap('<BS>', '<Plug>(fold-cycle-close)')
      end,
    }
    use {
      'windwp/nvim-autopairs',
      after = 'nvim-compe',
      config = function()
        require('nvim-autopairs').setup {
          close_triple_quotes = true,
          check_ts = false,
        }

        require('nvim-autopairs.completion.compe').setup {
          map_cr = true,
          map_complete = true,
        }
      end,
    }
    use {
      'karb94/neoscroll.nvim',
      config = function()
        require('neoscroll').setup {
          mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', 'zt', 'zz', 'zb' },
          stop_eof = false,
        }
      end,
    }
    use {
      'mg979/vim-visual-multi',
      config = function()
        vim.g.VM_highlight_matches = 'underline'
        vim.g.VM_maps = {
          ['Find Under'] = '<C-e>',
          ['Find Subword Under'] = '<C-e>',
          ['Select Cursor Down'] = [[\j]],
          ['Select Cursor Up'] = [[\k]],
        }
      end,
    }
    use {
      'itchyny/vim-highlighturl',
      config = function()
        vim.g.highlighturl_guifg = require('as.highlights').get_hl('Keyword', 'fg')
      end,
    }
    -- NOTE: marks are currently broken in neovim i.e. deleted marks are resurrected on restarting nvim
    use 'kshenoy/vim-signature'

    use {
      'mbbill/undotree',
      cmd = 'UndotreeToggle',
      keys = '<leader>u',
      setup = function()
        require('which-key').register {
          ['<leader>u'] = 'undotree: toggle',
        }
      end,
      config = function()
        vim.g.undotree_TreeNodeShape = '◉' -- Alternative: '◦'
        vim.g.undotree_SetFocusWhenToggle = 1
        as.nnoremap('<leader>u', '<cmd>UndotreeToggle<CR>')
      end,
    }
    use {
      'vim-test/vim-test',
      cmd = { 'TestFile', 'TestNearest', 'TestSuite' },
      keys = { '<localleader>tf', '<localleader>tn', '<localleader>ts' },
      setup = function()
        require('which-key').register({
          t = {
            name = '+vim-test',
            f = 'test: file',
            n = 'test: nearest',
            s = 'test: suite',
          },
        }, {
          prefix = '<localleader>',
        })
      end,
      config = function()
        vim.cmd [[
          let test#strategy = "neovim"
          let test#neovim#term_position = "vert botright"
        ]]
        as.nnoremap('<localleader>tf', '<cmd>TestFile<CR>')
        as.nnoremap('<localleader>tn', '<cmd>TestNearest<CR>')
        as.nnoremap('<localleader>ts', '<cmd>TestSuite<CR>')
      end,
    }
    use {
      'iamcco/markdown-preview.nvim',
      run = function()
        vim.fn['mkdp#util#install']()
      end,
      ft = { 'markdown' },
      config = function()
        vim.g.mkdp_auto_start = 0
        vim.g.mkdp_auto_close = 1
      end,
    }
    use {
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup({ '*' }, {
          RGB = false,
          mode = 'background',
        })
      end,
    }
    --}}}
    ---------------------------------------------------------------------------------
    -- Knowledge and task management {{{4
    ---------------------------------------------------------------------------------
    use {
      'soywod/himalaya', --- Email in nvim
      rtp = 'vim',
      run = 'curl -sSL https://raw.githubusercontent.com/soywod/himalaya/master/install.sh | PREFIX=~/.local sh',
      config = function()
        require('which-key').register({
          e = {
            name = '+email',
            l = { '<Cmd>Himalaya<CR>', 'list' },
          },
        }, {
          prefix = '<localleader>',
        })
      end,
    }

    use {
      'vimwiki/vimwiki',
      branch = 'dev',
      keys = { '<leader>ww', '<leader>wt', '<leader>wi' },
      event = { 'BufEnter *.wiki' },
      setup = conf('vimwiki').setup,
      config = conf('vimwiki').config,
    }

    use {
      'vhyrro/neorg',
      config = function()
        require('neorg').setup {
          load = {
            ['core.defaults'] = {},
            ['core.norg.concealer'] = {},
          },
        }
      end,
    }

    use { 'kristijanhusak/orgmode.nvim', config = conf 'orgmode' }

    use_local {
      'akinsho/org-bullets.nvim',
      local_path = 'personal',
      config = function()
        require('org-bullets').setup()
      end,
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Profiling {{{4
    --------------------------------------------------------------------------------
    use {
      'dstein64/vim-startuptime',
      opt = true,
      config = function()
        vim.g.startuptime_exe_args = { '+let g:auto_session_enabled = 0' }
      end,
    }
    use { 'tweekmonster/startuptime.vim', cmd = 'StartupTime' }
    -- }}}
    --------------------------------------------------------------------------------
    -- TPOPE {{{4
    --------------------------------------------------------------------------------
    use 'tpope/vim-eunuch'
    use 'tpope/vim-sleuth'
    use 'tpope/vim-repeat'
    use {
      'tpope/vim-abolish',
      config = function()
        local opts = { silent = false }
        as.nnoremap('<localleader>[', ':S/<C-R><C-W>//<LEFT>', opts)
        as.nnoremap('<localleader>]', ':%S/<C-r><C-w>//c<left><left>', opts)
        as.xnoremap('<localleader>[', [["zy:%S/<C-r><C-o>"//c<left><left>]], opts)
      end,
    }
    -- sets searchable path for filetypes like go so 'gf' works
    use { 'tpope/vim-apathy', ft = { 'go', 'python', 'javascript', 'typescript' } }
    use { 'tpope/vim-projectionist', config = conf 'vim-projectionist' }
    use {
      'tpope/vim-surround',
      config = function()
        as.xmap('s', '<Plug>VSurround')
        as.xmap('s', '<Plug>VSurround')
      end,
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Syntax {{{4
    --------------------------------------------------------------------------------
    -- TODO: converting a plugin from disabled to enabled inside a require doesn't work
    use_local {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = conf 'treesitter',
      local_path = 'contributing',
      requires = { 'nvim-treesitter/nvim-treesitter-textobjects', 'p00f/nvim-ts-rainbow' },
    }
    use {
      'nvim-treesitter/playground',
      keys = '<leader>E',
      cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
      setup = function()
        require('which-key').register {
          ['<leader>E'] = 'treesitter: highlight cursor group',
        }
      end,
      config = function()
        as.nnoremap('<leader>E', '<Cmd>TSHighlightCapturesUnderCursor<CR>')
      end,
    }

    -- BUG: This needs to load after nvim-treesitter but the "after" key in packer is broken till #272 is fixed
    use {
      'mizlan/iswap.nvim',
      cmd = { 'ISwap', 'ISwapWith' },
      keys = '<localleader>sw',
      setup = function()
        require('which-key').register {
          ['<localleader>s'] = { name = '+swap', w = 'swap arguments,parameters etc.' },
        }
      end,
      config = function()
        require('iswap').setup {}
        as.nnoremap('<localleader>sw', '<Cmd>ISwapWith<CR>')
      end,
    }
    use {
      'lewis6991/spellsitter.nvim',
      opt = true,
      config = function()
        require('spellsitter').setup {}
      end,
    }
    use 'dart-lang/dart-vim-plugin'
    use 'plasticboy/vim-markdown'
    use 'mtdl9/vim-log-highlighting'
    ---}}}
    --------------------------------------------------------------------------------
    -- Git {{{4
    --------------------------------------------------------------------------------
    use {
      'ruifm/gitlinker.nvim',
      requires = 'plenary.nvim',
      keys = { '<localleader>gu', '<localleader>go' },
      setup = function()
        require('which-key').register(
          { gu = 'gitlinker: get line url', go = 'gitlinker: open repo url' },
          { prefix = '<localleader>' }
        )
      end,
      config = function()
        local linker = require 'gitlinker'
        linker.setup { mappings = '<localleader>gu' }
        as.nnoremap('<localleader>go', function()
          linker.get_repo_url { action_callback = require('gitlinker.actions').open_in_browser }
        end)
      end,
    }
    use { 'lewis6991/gitsigns.nvim', config = conf 'gitsigns', event = 'BufRead' }
    use {
      'rhysd/conflict-marker.vim',
      config = function()
        require('as.highlights').plugin(
          'conflictMarker',
          { 'ConflictMarkerBegin', { guibg = '#2f7366' } },
          { 'ConflictMarkerOurs', { guibg = '#2e5049' } },
          { 'ConflictMarkerTheirs', { guibg = '#344f69' } },
          { 'ConflictMarkerEnd', { guibg = '#2f628e' } },
          { 'ConflictMarkerCommonAncestorsHunk', { guibg = '#754a81' } }
        )
        -- disable the default highlight group
        vim.g.conflict_marker_highlight_group = ''
        -- Include text after begin and end markers
        vim.g.conflict_marker_begin = '^<<<<<<< .*$'
        vim.g.conflict_marker_end = '^>>>>>>> .*$'
      end,
    }
    use {
      'TimUntersberger/neogit',
      cmd = 'Neogit',
      keys = { '<localleader>gs', '<localleader>gl', '<localleader>gp' },
      requires = 'plenary.nvim',
      setup = conf('neogit').setup,
      config = conf('neogit').config,
    }
    use {
      'sindrets/diffview.nvim',
      cmd = 'DiffviewOpen',
      module = 'diffview',
      keys = '<localleader>gd',
      setup = function()
        require('which-key').register { ['<localleader>gd'] = 'diffview: diff HEAD' }
      end,
      config = function()
        as.nnoremap('<localleader>gd', '<Cmd>DiffviewOpen<CR>')
        require('diffview').setup {
          key_bindings = {
            file_panel = { q = '<Cmd>DiffviewClose<CR>' },
            view = { q = '<Cmd>DiffviewClose<CR>' },
          },
        }
      end,
    }

    use {
      'pwntester/octo.nvim',
      cmd = 'Octo',
      keys = { '<localleader>opl' },
      config = function()
        require('octo').setup()
        require('which-key').register({
          o = { name = '+octo', p = { l = { '<cmd>Octo pr list<CR>', 'PR List' } } },
        }, {
          prefix = '<localleader>',
        })
      end,
    }
    ---}}}
    --------------------------------------------------------------------------------
    -- Text Objects {{{4
    --------------------------------------------------------------------------------
    use 'AndrewRadev/splitjoin.vim'
    use {
      'AndrewRadev/dsf.vim',
      config = function()
        vim.g.dsf_no_mappings = 1
        require('which-key').register {
          d = {
            name = '+dsf: function text object',
            s = {
              f = { '<Plug>DsfDelete', 'delete surrounding function' },
              nf = { '<Plug>DsfNextDelete', 'delete next surrounding function' },
            },
          },
          c = {
            name = '+dsf: function text object',
            s = {
              f = { '<Plug>DsfChange', 'change surrounding function' },
              nf = { '<Plug>DsfNextChange', 'change next surrounding function' },
            },
          },
        }
      end,
    }
    use {
      'chaoren/vim-wordmotion',
      config = function()
        -- Restore Vim's special case behavior with dw and cw:
        as.nmap('dw', 'de')
        as.nmap('cw', 'ce')
        as.nmap('dW', 'dE')
        as.nmap('cW', 'cE')
      end,
    }
    use {
      'b3nj5m1n/kommentary',
      config = function()
        require('kommentary.config').configure_language(
          'lua',
          { prefer_single_line_comments = true }
        )
      end,
    }
    use {
      'tommcdo/vim-exchange',
      config = function()
        require('as.highlights').plugin('exchange', { 'ExchangeRegion', { link = 'Search' } })
        vim.g.exchange_no_mappings = 1
        as.xmap('X', '<Plug>(Exchange)')
        as.nmap('X', '<Plug>(Exchange)')
        as.nmap('Xc', '<Plug>(ExchangeClear)')
      end,
    }
    use 'wellle/targets.vim'
    use {
      'kana/vim-textobj-user',
      requires = {
        'kana/vim-operator-user',
        {
          'glts/vim-textobj-comment',
          config = function()
            vim.g.textobj_comment_no_default_key_mappings = 1
            as.xmap('ax', '<Plug>(textobj-comment-a)')
            as.omap('ax', '<Plug>(textobj-comment-a)')
            as.xmap('ix', '<Plug>(textobj-comment-i)')
            as.omap('ix', '<Plug>(textobj-comment-i)')
          end,
        },
      },
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Search Tools {{{4
    --------------------------------------------------------------------------------
    use {
      'phaazon/hop.nvim',
      keys = { { 'n', 's' } },
      config = function()
        local hop = require 'hop'
        -- remove h,j,k,l from hops list of keys
        hop.setup { keys = 'etovxqpdygfbzcisuran' }
        as.nnoremap('s', hop.hint_char1)
      end,
    }
    -- }}}
    ---------------------------------------------------------------------------------
    -- Themes  {{{4
    ----------------------------------------------------------------------------------
    use 'NTBBloodbath/doom-one.nvim'
    use 'monsonjeremy/onedark.nvim'
    use 'marko-cerovac/material.nvim'
    use {
      'projekt0n/github-nvim-theme',
      event = 'ColorScheme github',
      config = function()
        require('github-theme').setup()
      end,
    }
    use { 'Th3Whit3Wolf/one-nvim', opt = true }
    -- }}}
    ---------------------------------------------------------------------------------
    -- Dev plugins  {{{4
    ---------------------------------------------------------------------------------
    use {
      'norcalli/nvim-terminal.lua',
      config = function()
        require('terminal').setup()
      end,
    }
    use { 'rafcamlet/nvim-luapad', cmd = 'Luapad', disable = is_work }
    -- }}}
    -----------------------------------------------------------------------------//
    -- Personal plugins {{{4
    -----------------------------------------------------------------------------//
    use_local {
      'akinsho/dependency-assist.nvim',
      local_path = 'personal',
      config = function()
        return require('dependency_assist').setup()
      end,
    }

    use_local {
      'akinsho/nvim-toggleterm.lua',
      local_path = 'personal',
      config = function()
        require('toggleterm').setup {
          persist_size = false,
          open_mapping = [[<c-\>]],
          shade_filetypes = { 'none' },
          direction = 'vertical',
          float_opts = { border = 'curved' },
          size = function(term)
            if term.direction == 'horizontal' then
              return 15
            elseif term.direction == 'vertical' then
              return vim.o.columns * 0.4
            end
          end,
        }

        local float_handler = function(term)
          vim.cmd 'startinsert!'
          if vim.fn.mapcheck('jk', 't') ~= '' then
            vim.api.nvim_buf_del_keymap(term.bufnr, 't', 'jk')
            vim.api.nvim_buf_del_keymap(term.bufnr, 't', '<esc>')
          end
        end

        local Terminal = require('toggleterm.terminal').Terminal

        local lazygit = Terminal:new {
          cmd = 'lazygit',
          dir = 'git_dir',
          hidden = true,
          direction = 'float',
          on_open = float_handler,
        }

        local htop = Terminal:new {
          cmd = 'htop',
          hidden = 'true',
          direction = 'float',
          on_open = float_handler,
        }

        as.command {
          'Htop',
          function()
            htop:toggle()
          end,
        }

        require('which-key').register {
          ['<leader>lg'] = {
            function()
              lazygit:toggle()
            end,
            'toggleterm: toggle lazygit',
          },
        }
      end,
    }
    use_local {
      'akinsho/nvim-bufferline.lua',
      config = conf 'nvim-bufferline',
      local_path = 'personal',
      requires = 'nvim-web-devicons',
    }
    --}}}
    ---------------------------------------------------------------------------------
  end,
  config = {
    compile_path = PACKER_COMPILED_PATH,
    display = {
      prompt_border = 'rounded',
      open_cmd = 'silent topleft 65vnew',
    },
    profile = {
      enable = true,
      threshold = 1,
    },
  },
}

as.command {
  'PackerCompiledEdit',
  function()
    vim.cmd(fmt('edit %s', PACKER_COMPILED_PATH))
  end,
}

as.command {
  'PackerCompiledDelete',
  function()
    vim.fn.delete(PACKER_COMPILED_PATH)
    vim.notify(fmt('Deleted %s', PACKER_COMPILED_PATH))
  end,
}

if not vim.g.packer_compiled_loaded and vim.loop.fs_stat(PACKER_COMPILED_PATH) then
  vim.cmd(fmt('source %s', PACKER_COMPILED_PATH))
  vim.g.packer_compiled_loaded = true
end

-- vim:foldmethod=marker
