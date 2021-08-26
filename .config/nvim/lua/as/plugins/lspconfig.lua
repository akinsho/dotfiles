as.lsp = {}
-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//
local function setup_autocommands(client, _)
  as.augroup('LspLocationList', {
    {
      events = { 'User LspDiagnosticsChanged' },
      command = function()
        -- FIXME: this opens even when there is no content so this is closed by default
        -- argument has changed in nvim nightly
        local args = as.has 'nvim-0.6' and { open = false } or { open_loclist = false }
        vim.lsp.diagnostic.set_loclist(args)
      end,
    },
  })
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
        command = vim.lsp.buf.formatting_sync,
      },
    })
  end
end

-- Capture real implementation of function that sets signs
local orig_set_signs = vim.lsp.diagnostic.set_signs
local diagnostic_cache = {}

---Override diagnostics signs helper to only show the single most relevant sign
---@see: http://reddit.com/r/neovim/comments/mvhfw7/can_built_in_lsp_diagnostics_be_limited_to_show_a
---@param diagnostics table
---@param bufnr number
---@param client_id number
---@param sign_ns number
---@param opts table
local function set_highest_signs(diagnostics, bufnr, client_id, sign_ns, opts)
  -- original func runs some checks, which I think is worth doing but maybe overkill
  if not diagnostics then
    diagnostics = diagnostic_cache[bufnr][client_id]
  end

  -- early escape
  if not diagnostics then
    return
  end

  -- Work out max severity diagnostic per line
  local max_severity_per_line = {}
  for _, d in pairs(diagnostics) do
    if max_severity_per_line[d.range.start.line] then
      local current_d = max_severity_per_line[d.range.start.line]
      if d.severity < current_d.severity then
        max_severity_per_line[d.range.start.line] = d
      end
    else
      max_severity_per_line[d.range.start.line] = d
    end
  end

  -- map to list
  local filtered_diagnostics = {}
  for _, v in pairs(max_severity_per_line) do
    table.insert(filtered_diagnostics, v)
  end

  -- call original function
  orig_set_signs(filtered_diagnostics, bufnr, client_id, sign_ns, opts)
end

vim.lsp.diagnostic.set_signs = set_highest_signs
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

  maps[']c'] = {
    function()
      vim.lsp.diagnostic.goto_prev {
        popup_opts = { border = 'rounded', focusable = false },
      }
    end,
    'lsp: go to prev diagnostic',
  }
  maps['[c'] = {
    function()
      vim.lsp.diagnostic.goto_next {
        popup_opts = { border = 'rounded', focusable = false },
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
    maps['<leader>rn'] = { vim.lsp.buf.rename, 'lsp: rename' }
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
  lua = function()
    --- NOTE: This is the secret sauce that allows reading requires and variables
    --- between different modules in the nvim lua context
    --- @see https://gist.github.com/folke/fe5d28423ea5380929c3f7ce674c41d8
    --- if I ever decide to move away from lua dev then use the above
    return require('lua-dev').setup {
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

-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
local command = as.command

command {
  'LspLog',
  function()
    local path = vim.lsp.get_log_path()
    vim.cmd('edit ' .. path)
  end,
}

command {
  'Format',
  function()
    vim.lsp.buf.formatting_sync(nil, 1000)
  end,
}

---Logic to (re)start installed language servers for use initialising lsps
---and restarting them on installing new ones
function as.lsp.setup_servers()
  local lspconfig = require 'lspconfig'
  local install_ok, lspinstall = pcall(require, 'lspinstall')
  local nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  -- can't reasonably proceed if lspinstall isn't loaded
  if not install_ok then
    return vim.notify(lspinstall, vim.log.levels.ERROR)
  end

  lspinstall.setup()
  local installed = lspinstall.installed_servers()
  local status_capabilities = require('lsp-status').capabilities
  for _, server in pairs(installed) do
    local config = as.lsp.servers[server] and as.lsp.servers[server]() or {}
    config.flags = { debounce_text_changes = 500 }
    config.on_attach = as.lsp.on_attach
    config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
    if nvim_lsp_ok then
      cmp_nvim_lsp.update_capabilities(config.capabilities)
    end
    config.capabilities = as.deep_merge(status_capabilities, config.capabilities)
    lspconfig[server].setup(config)
  end
  vim.cmd 'doautocmd User LspServersStarted'
end

return function()
  if vim.g.lspconfig_has_setup then
    return
  end
  vim.g.lspconfig_has_setup = true

  if vim.env.DEVELOPING then
    vim.lsp.set_log_level(vim.lsp.log_levels.DEBUG)
  end

  -----------------------------------------------------------------------------//
  -- Signs
  -----------------------------------------------------------------------------//
  vim.fn.sign_define {
    {
      name = 'LspDiagnosticsSignError',
      text = as.style.icons.error,
      texthl = 'LspDiagnosticsSignError',
    },
    {
      name = 'LspDiagnosticsSignHint',
      text = as.style.icons.hint,
      texthl = 'LspDiagnosticsSignHint',
    },
    {
      name = 'LspDiagnosticsSignWarning',
      text = as.style.icons.warning,
      texthl = 'LspDiagnosticsSignWarning',
    },
    {
      name = 'LspDiagnosticsSignInformation',
      text = as.style.icons.info,
      texthl = 'LspDiagnosticsSignInformation',
    },
  }

  -----------------------------------------------------------------------------//
  -- Handler overrides
  -----------------------------------------------------------------------------//
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      underline = true,
      virtual_text = false,
      signs = true,
      update_in_insert = false,
    }
  )

  local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
  local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

  -- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = 'rounded', max_width = max_width, max_height = max_height }
  )
  as.lsp.setup_servers()
end
