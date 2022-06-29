-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//
--- LSP server configs are setup dynamically as they need to be generated during
--- startup so things like the runtimepath for lua is correctly populated
as.lsp = {}

local fn = vim.fn

-- This function allows reading a per project "settings.json" file in the `.vim` directory of the project.
---@param client table<string, any>
---@return boolean
function as.lsp.on_init(client)
  local path = client.workspace_folders[1].name
  local config_path = path .. '/.vim/settings.json'
  if fn.filereadable(config_path) == 0 then
    return true
  end
  local ok, json = pcall(fn.readfile, config_path)
  if not ok then
    return
  end
  local overrides = vim.json.decode(table.concat(json, '\n'))
  for name, config in pairs(overrides) do
    if name == client.name then
      local original = client.config
      client.config = vim.tbl_deep_extend('force', original, config)
      client.notify('workspace/didChangeConfiguration')
    end
  end
  return true
end

return function()
  -- FIXME: prevent language servers from being reset because this causes errors
  -- with in flight requests. Eventually this should be improved or allowed and so
  -- this won't be necessary
  if vim.g.lsp_config_complete then
    return
  end
  vim.g.lsp_config_complete = true

  local servers = {
    ccls = true,
    tsserver = true,
    graphql = true,
    jsonls = true,
    bashls = true,
    vimls = true,
    terraformls = true,
    rust_analyzer = true,
    marksman = true,
    gopls = {
      settings = {
        gopls = {
          codelenses = {
            generate = true,
            gc_details = false,
            test = true,
            tidy = true,
          },
          analyses = {
            unusedparams = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          -- hints = {
          --   assignVariableTypes = true,
          --   constantValues = true,
          --   functionTypeParameters = true,
          -- },
        },
      },
    },
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
        library = { plugins = { 'plenary.nvim', 'neotest' } },
        lspconfig = settings,
      })
    end,
  }

  for name, config in pairs(servers) do
    if config and type(config) == 'boolean' then
      config = {}
    elseif config and type(config) == 'function' then
      config = config()
    end
    if config then
      config.on_init = as.lsp.on_init
      config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
      config.capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local ok, cmp_nvim_lsp = as.safe_require('cmp_nvim_lsp')
      if ok then
        cmp_nvim_lsp.update_capabilities(config.capabilities)
      end
      require('lspconfig')[name].setup(config)
    end
  end
end
