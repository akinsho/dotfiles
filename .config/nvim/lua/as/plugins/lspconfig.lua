as.lsp = {}

-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//
--- LSP server configs are setup dynamically as they need to be generated during
--- startup so things like the runtimepath for lua is correctly populated
as.lsp.servers = {
  ccls = true,
  tsserver = true,
  graphql = true,
  jsonls = true,
  bashls = true,
  vimls = true,
  terraformls = true,
  rust_analyzer = true,
  gopls = false,
  sourcekit = {
    filetypes = { 'swift', 'objective-c', 'objective-cpp' },
  },
  yamlls = {
    settings = {
      yaml = {
        customTags = {
          '!reference sequence', -- necessary for gitlab-ci.yaml files
        },
      },
    },
  },
  sqls = function()
    return {
      root_dir = require('lspconfig').util.root_pattern('.git'),
      single_file_support = false,
      on_new_config = function(new_config, new_rootdir)
        table.insert(new_config.cmd, '-config')
        table.insert(new_config.cmd, new_rootdir .. '/.config.yaml')
      end,
    }
  end,
  --- @see https://gist.github.com/folke/fe5d28423ea5380929c3f7ce674c41d8
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
    ui = { border = as.style.current.border },
  })
  for name, config in pairs(as.lsp.servers) do
    if type(config) == 'boolean' then
      config = {}
    elseif config and type(config) == 'function' then
      config = config()
    end
    if config then
      config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_nvim_lsp = as.safe_require('cmp_nvim_lsp')
      if ok then
        cmp_nvim_lsp.update_capabilities(config.capabilities)
      end
      require('lspconfig')[name].setup(config)
    end
  end
end
