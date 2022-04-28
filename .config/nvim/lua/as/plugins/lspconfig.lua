as.lsp = {}

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//

--- Add lsp autocommands
---@param client table<string, any>
---@param bufnr number
local function setup_autocommands(client, bufnr)
  if client and client.resolved_capabilities.code_lens then
    as.augroup('LspCodeLens', {
      {
        event = { 'BufEnter', 'CursorHold', 'InsertLeave' },
        buffer = bufnr,
        command = function()
          vim.lsp.codelens.refresh()
        end,
      },
    })
  end
  if client and client.resolved_capabilities.document_highlight then
    as.augroup('LspCursorCommands', {
      {
        event = { 'CursorHold' },
        buffer = bufnr,
        command = function()
          vim.diagnostic.open_float(nil, { focus = false })
        end,
      },
      {
        event = { 'CursorHold', 'CursorHoldI' },
        buffer = bufnr,
        description = 'LSP: Document Highlight',
        command = function()
          vim.lsp.buf.document_highlight()
        end,
      },
      {
        event = 'CursorMoved',
        description = 'LSP: Document Highlight (Clear)',
        buffer = bufnr,
        command = function()
          vim.lsp.buf.clear_references()
        end,
      },
    })
  end
end

-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//

---Setup mapping when an lsp attaches to a buffer
---@param client table lsp client
local function setup_mappings(client)
  local ok = pcall(require, 'lsp-format')
  local format = ok and '<Cmd>Format<CR>' or vim.lsp.buf.formatting
  local maps = {
    n = {
      ['<leader>rf'] = { format, 'lsp: format buffer' },
      gi = 'lsp: implementation',
      gd = { vim.lsp.buf.definition, 'lsp: definition' },
      gr = { vim.lsp.buf.references, 'lsp: references' },
      gI = { vim.lsp.buf.incoming_calls, 'lsp: incoming calls' },
      K = { vim.lsp.buf.hover, 'lsp: hover' },
    },
    x = {},
  }

  maps.n[']c'] = {
    function()
      vim.diagnostic.goto_prev()
    end,
    'lsp: go to prev diagnostic',
  }
  maps.n['[c'] = {
    function()
      vim.diagnostic.goto_next()
    end,
    'lsp: go to next diagnostic',
  }

  if client.resolved_capabilities.implementation then
    maps.n['gi'] = { vim.lsp.buf.implementation, 'lsp: implementation' }
  end

  if client.resolved_capabilities.type_definition then
    maps.n['<leader>gd'] = { vim.lsp.buf.type_definition, 'lsp: go to type definition' }
  end

  maps.n['<leader>cl'] = { vim.lsp.codelens.run, 'lsp: run code lens' }
  maps.n['<leader>ca'] = { vim.lsp.buf.code_action, 'lsp: code action' }
  maps.x['<leader>ca'] = { '<esc><Cmd>lua vim.lsp.buf.range_code_action()<CR>', 'lsp: code action' }

  if client.supports_method 'textDocument/rename' then
    maps.n['<leader>rn'] = { vim.lsp.buf.rename, 'lsp: rename' }
  end

  for mode, value in pairs(maps) do
    require('which-key').register(value, { buffer = 0, mode = mode })
  end
end

function as.lsp.on_attach(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client)
  local format_ok, lsp_format = pcall(require, 'lsp-format')
  if format_ok then
    lsp_format.on_attach(client)
  end

  if client.resolved_capabilities.goto_definition == true then
    vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
  end

  if client.resolved_capabilities.document_formatting == true then
    vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
  end
end

-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//

--- LSP server configs are setup dynamically as they need to be generated during
--- startup so things like runtimepath for lua is correctly populated
as.lsp.servers = {
  gopls = false, -- NOTE: this is loaded by it's own plugin
  golangci_lint_ls = true,
  tsserver = true,
  graphql = true,
  jsonls = true,
  bashls = true,
  vimls = true,
  terraformls = true,
  ---  NOTE: This is the secret sauce that allows reading requires and variables
  --- between different modules in the nvim lua context
  --- @see https://gist.github.com/folke/fe5d28423ea5380929c3f7ce674c41d8
  --- if I ever decide to move away from lua dev then use the above
  ---  NOTE: we return a function here so that the lua dev dependency is not
  --- required till the setup function is called.
  sumneko_lua = function()
    local ok, lua_dev = as.safe_require 'lua-dev'
    if not ok then
      return {}
    end
    return lua_dev.setup {
      library = {
        plugins = { 'plenary.nvim' },
      },
      lspconfig = {
        settings = {
          Lua = {
            diagnostics = {
              globals = {
                'vim',
                'describe',
                'it',
                'before_each',
                'after_each',
                'pending',
                'teardown',
                'packer_plugins',
              },
            },
            completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
          },
        },
      },
    }
  end,
}

---Logic to (re)start installed language servers for use initialising lsps
---and restarting them on installing new ones
---@param conf table<string, any>
---@return table<string, any>
function as.lsp.get_server_config(conf)
  local nvim_lsp_ok, cmp_nvim_lsp = as.safe_require 'cmp_nvim_lsp'
  local conf_type = type(conf)
  local config = conf_type == 'table' and conf or conf_type == 'function' and conf() or {}
  config.flags = { debounce_text_changes = 500 }
  config.on_attach = config.on_attach or as.lsp.on_attach
  config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
  if nvim_lsp_ok then
    cmp_nvim_lsp.update_capabilities(config.capabilities)
  end
  return config
end

return function()
  require('nvim-lsp-installer').setup {
    ensure_installed = vim.tbl_keys(as.lsp.servers),
  }
  if vim.v.vim_did_enter == 1 then
    return
  end
  for name, config in pairs(as.lsp.servers) do
    if config then
      require('lspconfig')[name].setup(as.lsp.get_server_config(config))
    end
  end
end
