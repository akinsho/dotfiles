return function()
  local lsp = require("as.lsp")
  local has = as_utils.has
  local fn = vim.fn
  -- Deactivate for work machines
  if has("mac") then
    return
  end

  local lspconfig = require "lspconfig"
  local lsp_status = require "lsp-status"
  local flutter = require "flutter-tools"

  lsp.highlight()

  for _, sign in pairs(lsp.signs) do
    fn.sign_define(unpack(sign))
  end

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
  local prettier = {formatCommand = "prettier"}

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
    dev_log = {open_cmd = "tabedit"},
    lsp = {on_attach = lsp.on_attach, capabilities = status_capabilities}
  }

  for server, config in pairs(servers) do
    config.on_attach = lsp.on_attach
    if not config.capabilities then
      config.capabilities = vim.lsp.protocol.make_client_capabilities()
    end
    config.capabilities.textDocument.completion.completionItem.snippetSupport = true
    config.capabilities =
      require("as.utils").deep_merge(config.capabilities or {}, status_capabilities)
    lspconfig[server].setup(config)
  end
end
