as.lsp = {}

-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//

--- This is a product of over-engineering dear reader. The LSP servers table
--- can contain a server specified in a bunch of different ways, which is arguably
--- barely more convenient. This function is a helper than then marshals things
--- into the correct shape. All this is more for fun and experimentation with lua
--- than because it's remotely necessary.
---@param name string | number
---@param config table<string, any> | function | string
---@return table<string, any>
function as.lsp.convert_config(name, config)
  if type(name) == 'number' then
    name = config
  end
  local config_type = type(config)
  local data = ({
    ['string'] = function()
      return {}
    end,
    ['boolean'] = function()
      return {}
    end,
    ['table'] = function()
      return config
    end,
    ['function'] = function()
      return config()
    end,
  })[config_type]()
  return name, data
end

---Logic to (re)start installed language servers for use initialising lsps
---and restarting them on installing new ones
---@param config table<string, any>
---@return string, table<string, any>
function as.lsp.get_server_config(config)
  config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
  local nvim_lsp_ok, cmp_nvim_lsp = as.safe_require('cmp_nvim_lsp')
  if nvim_lsp_ok then
    cmp_nvim_lsp.update_capabilities(config.capabilities)
  end
  return config
end

--- LSP server configs are setup dynamically as they need to be generated during
--- startup so things like the runtimepath for lua is correctly populated
as.lsp.servers = {
  'sourcekit',
  'sqls',
  'tsserver',
  'graphql',
  'jsonls',
  'bashls',
  'vimls',
  'yamlls',
  'terraformls',
  gopls = false, -- NOTE: this is loaded by it's own plugin
  ---  NOTE: This is the secret sauce that allows reading requires and variables
  --- between different modules in the nvim lua context
  --- @see https://gist.github.com/folke/fe5d28423ea5380929c3f7ce674c41d8
  --- if I ever decide to move away from lua dev then use the above
  sumneko_lua = function()
    local settings = {
      settings = {
        Lua = {
          format = { enable = false },
          diagnostics = {
            globals = { 'vim', 'describe', 'it', 'before_each', 'after_each', 'packer_plugins' },
          },
          completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
        },
      },
    }
    local ok, lua_dev = as.safe_require('lua-dev')
    if not ok then
      return settings
    end
    return lua_dev.setup({
      library = { plugins = { 'plenary.nvim' } },
      lspconfig = settings,
    })
  end,
}

return function()
  require('nvim-lsp-installer').setup({
    automatic_installation = true,
  })
  if vim.v.vim_did_enter == 1 then
    return
  end
  for name, config in pairs(as.lsp.servers) do
    name, config = as.lsp.convert_config(name, config)
    if config then
      require('lspconfig')[name].setup(as.lsp.get_server_config(config))
    end
  end
end
