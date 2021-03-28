local has = as_utils.has
local fn = vim.fn
-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//
local function setup_autocommands(client)
  local autocommands = require("as.autocommands")

  autocommands.augroup(
    "LspLocationList",
    {
      {
        events = {"InsertLeave", "BufWrite", "BufEnter"},
        targets = {"<buffer>"},
        command = [[lua vim.lsp.diagnostic.set_loclist({open_loclist = false})]]
      }
    }
  )
  autocommands.augroup(
    "LspHighlights",
    {
      {
        events = {"VimEnter", "ColorScheme"},
        targets = {"*"},
        command = [[lua as_utils.lsp.highlight()]]
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
  local nnoremap, opts = as_utils.nnoremap, {buffer = 0}
  nnoremap("<c-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  nnoremap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  if client.resolved_capabilities.implementation then
    nnoremap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  end
  nnoremap("<leader>gd", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  nnoremap("gI", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
  nnoremap("gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  nnoremap("<leader>cs", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
  nnoremap("<leader>cw", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
  nnoremap("<leader>rf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

function as_utils.lsp.highlight()
  -----------------------------------------------------------------------------//
  -- Highlights
  -----------------------------------------------------------------------------//
  local highlight = require("as.highlights")
  local cursor_line_bg = highlight.hl_value("CursorLine", "bg")
  highlight.all {
    {"LspReferenceText", {guibg = cursor_line_bg, gui = "none"}},
    {"LspReferenceRead", {guibg = cursor_line_bg, gui = "none"}},
    {"LspDiagnosticsSignHint", {guifg = "#fab005"}},
    {"LspDiagnosticsDefaultHint", {guifg = "#fab005"}},
    {"LspDiagnosticsDefaultError", {guifg = "#E06C75"}},
    {"LspDiagnosticsDefaultWarning", {guifg = "#ff922b"}},
    {"LspDiagnosticsDefaultInformation", {guifg = "#15aabf"}},
    {"LspDiagnosticsUnderlineError", {gui = "undercurl", guisp = "#E06C75", guifg = "none"}},
    {"LspDiagnosticsUnderlineHint", {gui = "undercurl", guisp = "#fab005", guifg = "none"}},
    {"LspDiagnosticsUnderlineWarning", {gui = "undercurl", guisp = "orange", guifg = "none"}},
    {"LspDiagnosticsUnderlineInformation", {gui = "undercurl", guisp = "#15aabf", guifg = "none"}},
    {"LspDiagnosticsFloatingWarning", {guibg = "NONE"}},
    {"LspDiagnosticsFloatingError", {guibg = "NONE"}},
    {"LspDiagnosticsFloatingHint", {guibg = "NONE"}},
    {"LspDiagnosticsFloatingInformation", {guibg = "NONE"}}
  }
end

function as_utils.lsp.tagfunc(pattern, flags)
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

function as_utils.lsp.on_attach(client, bufnr)
  setup_autocommands(client)
  setup_mappings(client)

  if client.resolved_capabilities.goto_definition then
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.as_utils.lsp.tagfunc")
  end
  require("lsp-status").on_attach(client)
end

-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//
local prettier = {formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true}

local local_path = has("mac") and os.getenv("HOME") or fn.stdpath("data") .. "/lspinstall"
local sumneko_path = string.format("%s/lua-language-server", local_path)
local sumneko_binary = sumneko_path .. "/bin/" .. vim.g.system_name .. "/lua-language-server"

as_utils.lsp.servers = {
  lua = {
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

function as_utils.lsp.setup_servers()
  vim.cmd "packadd nvim-lspinstall" -- Important!
  local lspinstall = require("lspinstall")
  local lspconfig = require("lspconfig")

  lspinstall.setup()
  local installed = lspinstall.installed_servers()
  local status_capabilities = require("lsp-status").capabilities
  for _, server in pairs(installed) do
    local config = as_utils.lsp.servers[server] or {}
    config.on_attach = as_utils.lsp.on_attach
    if not config.capabilities then
      config.capabilities = vim.lsp.protocol.make_client_capabilities()
    end
    config.capabilities.textDocument.completion.completionItem.snippetSupport = true
    config.capabilities = vim.tbl_deep_extend("force", config.capabilities, status_capabilities)
    lspconfig[server].setup(config)
  end
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
  "Format",
  function()
    vim.lsp.buf.formatting_sync(nil, 1000)
  end
}

return function()
  if as_utils.lsp.has_setup then
    return
  end
  as_utils.lsp.has_setup = true

  as_utils.lsp.highlight()
  -----------------------------------------------------------------------------//
  -- Signs
  -----------------------------------------------------------------------------//
  vim.fn.sign_define("LspDiagnosticsSignError", {text = "✗", texthl = "LspDiagnosticsSignError"})
  vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", texthl = "LspDiagnosticsSignHint"})
  vim.fn.sign_define(
    "LspDiagnosticsSignWarning",
    {text = "", texthl = "LspDiagnosticsSignWarning"}
  )
  vim.fn.sign_define(
    "LspDiagnosticsSignInformation",
    {text = "", texthl = "LspDiagnosticsSignInformation"}
  )

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

  as_utils.lsp.setup_servers()
end
