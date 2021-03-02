LspConfig = {}

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//
local function setup_autocommands(client)
  local autocommands = require "as.autocommands"
  autocommands.augroup(
    "LspHighlights",
    {
      {
        events = {"VimEnter", "ColorScheme"},
        targets = {"*"},
        command = [[lua LspFunctions.highlight()]]
      }
    }
  )
  if client and client.resolved_capabilities.document_highlight then
    autocommands.augroup(
      "LspCursorCommands",
      {
        {
          events = {"CursorHold"},
          targets = {"<buffer>"},
          command = "lua vim.lsp.buf.document_highlight()"
        },
        {
          events = {"CursorHoldI"},
          targets = {"<buffer>"},
          command = "lua vim.lsp.buf.document_highlight()"
        },
        {
          events = {"CursorMoved"},
          targets = {"<buffer>"},
          command = "lua vim.lsp.buf.clear_references()"
        }
      }
    )
  end
  if client and client.resolved_capabilities.document_formatting then
    -- format on save
    autocommands.augroup(
      "LspFormat",
      {
        {
          events = {"BufWritePre"},
          targets = {"<buffer>"},
          command = "lua vim.lsp.buf.formatting_sync(nil, 1000)"
        }
      }
    )
  end
end
-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//
local function setup_mappings(client)
  local buf_map = as_utils.buf_map
  buf_map(0, "n", "<c-]>", "<cmd>lua vim.lsp.buf.definition()<CR>")
  buf_map(0, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  if client.resolved_capabilities.implementation then
    buf_map(0, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  end
  buf_map(0, "n", "<leader>gd", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  buf_map(0, "n", "gI", "<cmd>vim.lsp.buf.incoming_calls()<CR>")
  buf_map(0, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  buf_map(0, "n", "<leader>cs", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
  buf_map(0, "n", "<leader>cw", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
  buf_map(0, "n", "<leader>rf", "<cmd>lua vim.lsp.buf.formatting()<CR>")
end

function LspConfig.highlight()
  -----------------------------------------------------------------------------//
  -- Highlights
  -----------------------------------------------------------------------------//
  require("as.highlights").all {
    {"LspReferenceText", {link = "CursorLine"}},
    {"LspReferenceRead", {link = "CursorLine"}},
    {"LspDiagnosticsDefaultHint", {guifg = "#fab005"}},
    {"LspDiagnosticsDefaultError", {guifg = "#E06C75"}},
    {"LspDiagnosticsDefaultWarning", {guifg = "#ff922b"}},
    {"LspDiagnosticsDefaultInformation", {guifg = "#15aabf"}},
    {"LspDiagnosticsUnderlineError", {gui = "undercurl", guisp = "#E06C75"}},
    {"LspDiagnosticsUnderlineHint", {gui = "undercurl", guisp = "#fab005"}},
    {"LspDiagnosticsUnderlineWarning", {gui = "undercurl", guisp = "orange"}},
    {"LspDiagnosticsUnderlineInformation", {gui = "undercurl", guisp = "#15aabf"}}
  }
end

function LspConfig.tagfunc(pattern, flags)
  if flags ~= "c" then
    return vim.NIL
  end
  local params = vim.lsp.util.make_position_params()
  local client_id_to_results, err =
    vim.lsp.buf_request_sync(0, "textDocument/definition", params, 500)
  assert(not err, vim.inspect(err))

  local results = {}
  for _, lsp_results in ipairs(client_id_to_results) do
    for _, location in ipairs(lsp_results.result or {}) do
      local start = location.range.start
      table.insert(
        results,
        {
          name = pattern,
          filename = vim.uri_to_fname(location.uri),
          cmd = string.format("call cursor(%d, %d)", start.line + 1, start.character + 1)
        }
      )
    end
  end
  return results
end

function LspConfig.on_attach(client, bufnr)
  setup_autocommands(client)
  setup_mappings(client)

  require("vim.lsp.protocol").CompletionItemKind = {
    " [Text]", -- Text
    " [Method]", -- Method
    "ƒ [Function]", -- Function
    " [Constructor]", -- Constructor
    "識 [Field]", -- Field
    " [Variable]", -- Variable
    "\u{f0e8} [Class]", -- Class
    "ﰮ [Interface]", -- Interface
    " [Module]", -- Module
    " [Property]", -- Property
    " [Unit]", -- Unit
    " [Value]", -- Value
    "了 [Enum]", -- Enum
    " [Keyword]", -- Keyword
    " [Snippet]", -- Snippet
    " [Color]", -- Color
    " [File]", -- File
    "渚 [Reference]", -- Reference
    " [Folder]", -- Folder
    " [Enum]", -- Enum
    " [Constant]", -- Constant
    " [Struct]", -- Struct
    "鬒 [Event]", -- Event
    "\u{03a8} [Operator]", -- Operator
    " [Type Parameter]" -- TypeParameter
  }

  if client.resolved_capabilities.goto_definition then
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.LspFunctions.tagfunc")
  end
  require("lsp-status").on_attach(client)
end

-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
local command = as_utils.command

command {
  "ReloadLSP",
  function()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    vim.cmd [[edit]]
  end
}
command {
  "LogLSP",
  function()
    local path = vim.lsp.get_log_path()
    vim.cmd("edit " .. path)
  end
}
command {
  "DebugLSP",
  function()
    print(vim.inspect(vim.lsp.get_active_clients()))
  end
}
command {
  "Format",
  function()
    vim.lsp.buf.formatting_sync(nil, 1000)
  end
}

return function()
  local has = as_utils.has
  local fn = vim.fn

  local lspconfig = require "lspconfig"
  local lsp_status = require "lsp-status"
  local flutter = require "flutter-tools"

  LspConfig.highlight()
  -----------------------------------------------------------------------------//
  -- Signs
  -----------------------------------------------------------------------------//
  fn.sign_define("LspDiagnosticsSignError", {text = "✗", texthl = "LspDiagnosticsSignError"})
  fn.sign_define("LspDiagnosticsSignHint", {text = "", texthl = "LspDiagnosticsSignHint"})
  fn.sign_define("LspDiagnosticsSignWarning", {text = "", texthl = "LspDiagnosticsSignWarning"})
  fn.sign_define(
    "LspDiagnosticsSignInformation",
    {text = "", texthl = "LspDiagnosticsSignInformation"}
  )

  -----------------------------------------------------------------------------//
  -- Setup plugins
  -----------------------------------------------------------------------------//
  lsp_status.config {
    indicator_hint = "",
    indicator_info = "",
    indicator_errors = "✗",
    indicator_warnings = "",
    status_symbol = ""
  }
  lsp_status.register_progress()

  -----------------------------------------------------------------------------//
  -- Handler overrides
  -----------------------------------------------------------------------------//
  vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      underline = true,
      virtual_text = false,
      signs = true,
      update_in_insert = false
    }
  )
  -----------------------------------------------------------------------------//
  -- Language servers
  -----------------------------------------------------------------------------//
  local prettier = {formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true}

  local local_path = has("mac") and os.getenv("HOME") or fn.stdpath("data") .. "/lspinstall"
  local sumneko_path = string.format("%s/lua-language-server", local_path)
  local sumneko_binary = sumneko_path .. "/bin/" .. vim.g.system_name .. "/lua-language-server"

  local servers = {
    rust_analyzer = {},
    vimls = {},
    gopls = {},
    flow = {},
    jsonls = {},
    html = {},
    tsserver = {},
    sumneko_lua = {
      cmd = {sumneko_binary, "-E", sumneko_path .. "/main.lua"},
      settings = {
        Lua = {
          diagnostics = {globals = {"vim"}},
          completion = {keywordSnippet = "Both"},
          runtime = {
            version = "LuaJIT",
            path = vim.split(package.path, ";")
          },
          workspace = {
            library = {
              [fn.expand("$VIMRUNTIME/lua")] = true,
              [fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
            }
          }
        }
      }
    },
    efm = {
      init_options = {documentFormatting = true},
      filetypes = {"yaml", "json", "html", "css", "markdown", "lua"},
      settings = {
        -- add ".lua-format" to root if using lua-format
        rootMarkers = {".git/"},
        languages = {
          json = {prettier},
          html = {prettier},
          css = {prettier},
          yaml = {prettier},
          markdown = {prettier},
          -- npm i -g lua-fmt
          -- 'lua-format -i -c {config_dir}'
          lua = {
            {
              formatCommand = "luafmt --indent-count 2 --line-width 100 --stdin",
              formatStdin = true
            }
          }
        }
      }
    }
  }

  local status_capabilities = lsp_status.capabilities

  flutter.setup {
    flutter_outline = {
      enabled = true
    },
    dev_log = {open_cmd = "tabedit"},
    lsp = {
      on_attach = LspConfig.on_attach,
      capabilities = status_capabilities
    }
  }

  for server, config in pairs(servers) do
    config.on_attach = LspConfig.on_attach
    if not config.capabilities then
      config.capabilities = vim.lsp.protocol.make_client_capabilities()
    end
    config.capabilities.textDocument.completion.completionItem.snippetSupport = true
    config.capabilities =
      require("as.utils").deep_merge(config.capabilities or {}, status_capabilities)
    lspconfig[server].setup(config)
  end
end
