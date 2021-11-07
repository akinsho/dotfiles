as.lsp = {}

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//
local function setup_autocommands(client, _)
  if client and client.resolved_capabilities.code_lens then
    as.augroup('LspCodeLens', {
      {
        events = { 'BufEnter', 'CursorHold', 'InsertLeave' },
        targets = { '<buffer>' },
        command = vim.lsp.codelens.refresh,
      },
    })
  end
  if client and client.resolved_capabilities.document_highlight then
    as.augroup('LspCursorCommands', {
      {
        events = { 'CursorHold' },
        targets = { '<buffer>' },
        command = vim.lsp.buf.document_highlight,
      },
      {
        events = { 'CursorHoldI' },
        targets = { '<buffer>' },
        command = vim.lsp.buf.document_highlight,
      },
      {
        events = { 'CursorMoved' },
        targets = { '<buffer>' },
        command = vim.lsp.buf.clear_references,
      },
    })
  end
  if client and client.resolved_capabilities.document_formatting then
    -- format on save
    as.augroup('LspFormat', {
      {
        events = { 'BufWritePre' },
        targets = { '<buffer>' },
        command = function()
          -- BUG: folds are are removed when formatting is done, so we save the current state of the
          -- view and re-apply it manually after formatting the buffer
          -- @see: https://github.com/nvim-treesitter/nvim-treesitter/issues/1424#issuecomment-909181939
          vim.cmd 'mkview!'
          vim.lsp.buf.formatting_sync()
          vim.cmd 'loadview'
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
---@param bufnr integer?
local function setup_mappings(client, bufnr)
  local maps = {
    ['<leader>rf'] = { vim.lsp.buf.formatting, 'lsp: format buffer' },
    ['gi'] = 'lsp: implementation',
    ['gd'] = { vim.lsp.buf.definition, 'lsp: definition' },
    ['gr'] = { vim.lsp.buf.references, 'lsp: references' },
    ['gI'] = { vim.lsp.buf.incoming_calls, 'lsp: incoming calls' },
    ['K'] = { vim.lsp.buf.hover, 'lsp: hover' },
  }

  -- FIXME: remove when 0.6 is released
  local goto_key = as.nightly and 'float' or 'popup_opts'
  local diagnostics = as.nightly and vim.diagnostic or vim.lsp.diagnostic

  maps[']c'] = {
    function()
      diagnostics.goto_prev {
        [goto_key] = {
          border = 'rounded',
          focusable = false,
          source = 'always',
        },
      }
    end,
    'lsp: go to prev diagnostic',
  }
  maps['[c'] = {
    function()
      diagnostics.goto_next {
        [goto_key] = {
          border = 'rounded',
          focusable = false,
          source = 'always',
        },
      }
    end,
    'lsp: go to next diagnostic',
  }

  if client.resolved_capabilities.implementation then
    maps['gi'] = { vim.lsp.buf.implementation, 'lsp: impementation' }
  end

  if client.resolved_capabilities.type_definition then
    maps['<leader>gd'] = { vim.lsp.buf.type_definition, 'lsp: go to type definition' }
  end

  if not as.has_map('<leader>ca', 'n') then
    maps['<leader>ca'] = { vim.lsp.buf.code_action, 'lsp: code action' }
    -- TODO: not sure that this works, since these keys likely override each other in which key
    maps['<leader>ca'] = { vim.lsp.buf.range_code_action, 'lsp: code action', mode = 'x' }
  end

  if client.supports_method 'textDocument/rename' then
    local renamer = require('renamer').rename or vim.lsp.buf.rename
    maps['<leader>rn'] = { renamer, 'lsp: rename' }
  end

  require('which-key').register(maps, { buffer = 0 })
end

function as.lsp.tagfunc(pattern, flags)
  if flags ~= 'c' then
    return vim.NIL
  end
  local params = vim.lsp.util.make_position_params()
  local client_id_to_results, err = vim.lsp.buf_request_sync(
    0,
    'textDocument/definition',
    params,
    500
  )
  assert(not err, vim.inspect(err))

  local results = {}
  for _, lsp_results in ipairs(client_id_to_results) do
    for _, location in ipairs(lsp_results.result or {}) do
      local start = location.range.start
      table.insert(results, {
        name = pattern,
        filename = vim.uri_to_fname(location.uri),
        cmd = string.format('call cursor(%d, %d)', start.line + 1, start.character + 1),
      })
    end
  end
  return results
end

function as.lsp.on_attach(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client, bufnr)

  if client.resolved_capabilities.goto_definition then
    vim.bo[bufnr].tagfunc = 'v:lua.as.lsp.tagfunc'
  end

  require('lsp-status').on_attach(client)
end

-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//

--- LSP server configs are setup dynamically as they need to be generated during
--- startup so things like runtimepath for lua is correctly populated
as.lsp.servers = {
  gopls = true,
  bashls = true,
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
function as.lsp.get_server_config(server)
  local nvim_lsp_ok, cmp_nvim_lsp = as.safe_require 'cmp_nvim_lsp'
  local status_capabilities = require('lsp-status').capabilities
  local conf = as.lsp.servers[server.name]
  local conf_type = type(conf)
  local config = conf_type == 'table' and conf or conf_type == 'function' and conf() or {}
  config.flags = { debounce_text_changes = 500 }
  config.on_attach = as.lsp.on_attach
  config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
  if nvim_lsp_ok then
    cmp_nvim_lsp.update_capabilities(config.capabilities)
  end
  config.capabilities = as.deep_merge(status_capabilities, config.capabilities)
  return config
end

return function()
  local lsp_installer = require 'nvim-lsp-installer'
  lsp_installer.on_server_ready(function(server)
    server:setup(as.lsp.get_server_config(server))
    vim.cmd [[ do User LspAttachBuffers ]]
  end)
end
