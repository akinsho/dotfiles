-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//
-- Each entry is merged over the server's default definition, which nvim-lspconfig
-- ships as `lsp/<name>.lua` on the runtimepath. Only the deltas belong here.
-- A `false` value means the server is defined but should not be enabled.
-- A function value is called lazily, for config that must not run at require time.
--
-- svelte requires the additional installation of the typescript-svelte-plugin, per project
-- https://github.com/sveltejs/language-tools/tree/master/packages/typescript-plugin#usage

---@type table<string, vim.lsp.Config | false | fun(): vim.lsp.Config>
local servers = {
  sqlls = false,
  eslint = {},
  ccls = {},
  jsonls = function()
    return {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    }
  end,
  bashls = {},
  vimls = {},
  terraformls = {},
  marksman = {},
  pyright = {},
  buf_ls = {},
  prosemd_lsp = {},
  docker_compose_language_service = {
    root_markers = { 'docker-compose.yml' },
    filetypes = { 'yaml', 'dockerfile' },
  },
  graphql = {
    on_attach = function(client)
      -- Disable workspaceSymbolProvider because this prevents
      -- searching for symbols in typescript files which this server
      -- is also enabled for.
      -- @see: https://github.com/nvim-telescope/telescope.nvim/issues/964
      client.server_capabilities.workspaceSymbolProvider = false
    end,
  },
  --- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        codelenses = {
          generate = true,
          gc_details = false,
          test = true,
          tidy = true,
        },
        hints = {
          assignVariableTypes = false,
          compositeLiteralFields = true,
          constantValues = true,
          parameterNames = true,
          functionTypeParameters = false,
          rangeVariableTypes = false,
        },
        analyses = {
          unusedparams = true,
        },
        semanticTokens = true,
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { '-node_modules', '-vendor' },
      },
    },
  },
  jdtls = {},
  yamlls = {
    settings = {
      yaml = {
        customTags = {
          '!reference sequence', -- necessary for gitlab-ci.yaml files
        },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        codeLens = { enable = true },
        hint = { enable = true, arrayIndex = 'Disable', setType = false, paramName = 'Disable', paramType = true },
        format = { enable = false },
        diagnostics = {
          globals = { 'vim', 'P', 'describe', 'it', 'before_each', 'after_each', 'pending' },
        },
        completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
}

--- Register every server's settings with `vim.lsp.config` and enable the ones
--- that are not explicitly disabled.
return function()
  -- Applied to every server, so completion capabilities are declared in one place.
  vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(nil, true),
  })

  local enabled = {}
  for name, config in pairs(servers) do
    if config then
      if type(config) == 'function' then config = config() end
      vim.lsp.config(name, config)
      table.insert(enabled, name)
    end
  end
  vim.lsp.enable(enabled)
end
