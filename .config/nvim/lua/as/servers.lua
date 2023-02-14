-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//
local fn, fmt = vim.fn, string.format

-- This function allows reading a per project "settings.json" file in the `.vim` directory of the project.
---@param client table<string, any>
---@return boolean
local function on_init(client)
  local settings = client.workspace_folders[1].name .. '/.vim/settings.json'

  if fn.filereadable(settings) == 0 then return true end
  local ok, json = pcall(fn.readfile, settings)
  if not ok then return true end

  local overrides = vim.json.decode(table.concat(json, '\n'))

  for name, config in pairs(overrides) do
    if name == client.name then
      client.config = vim.tbl_deep_extend('force', client.config, config)
      client.notify('workspace/didChangeConfiguration')

      vim.schedule(function()
        local path = fn.fnamemodify(settings, ':~:.')
        local msg = fmt('loaded local settings for %s from %s', client.name, path)
        vim.notify_once(msg, 'info', { title = 'LSP Settings' })
      end)
    end
  end
  return true
end

local servers = {
  ccls = {},
  graphql = {},
  jsonls = {},
  bashls = {},
  vimls = {},
  terraformls = {},
  rust_analyzer = {},
  marksman = {},
  pyright = {},
  bufls = {},
  prosemd_lsp = {},
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
          assignVariableTypes = true,
          compositeLiteralFields = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        analyses = {
          unusedparams = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { '-node_modules' },
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
  lua_ls = function()
    local path = vim.split(package.path, ';')
    table.insert(path, 'lua/?.lua')
    table.insert(path, 'lua/?/init.lua')

    local plugins = ('%s/site/pack/packer'):format(fn.stdpath('data'))
    local emmy = ('%s/start/emmylua-nvim'):format(plugins)
    local plenary = ('%s/start/plenary.nvim'):format(plugins)
    local packer = ('%s/opt/packer.nvim'):format(plugins)
    local neotest = ('%s/opt/neotest'):format(plugins)

    return {
      settings = {
        Lua = {
          runtime = {
            path = path,
            version = 'LuaJIT',
          },
          hint = { enable = true, arrayIndex = 'Disable', setType = true },
          format = { enable = false },
          diagnostics = {
            globals = {
              'vim',
              'P',
              'describe',
              'it',
              'before_each',
              'after_each',
              'packer_plugins',
            },
          },
          completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
          workspace = {
            library = { fn.expand('$VIMRUNTIME/lua'), emmy, packer, plenary, neotest },
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    }
  end,
}

---Get the configuration for a specific language server
---@param name string
---@return table<string, any>?
return function(name)
  local config = servers[name]
  if not config then return end
  if type(config) == 'function' then config = config() end
  config.on_init = on_init
  local ok, cmp_nvim_lsp = as.require('cmp_nvim_lsp')
  if ok then config.capabilities = cmp_nvim_lsp.default_capabilities() end
  config.capabilities = vim.tbl_extend('keep', config.capabilities or {}, {
    textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } },
  })
  return config
end
