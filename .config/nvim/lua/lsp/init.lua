local fn = vim.fn
local api = vim.api
local H = require("highlights")
local autocommands = require("autocommands")
-----------------------------------------------------------------------------//
-- Helpers
-----------------------------------------------------------------------------//
local function is_plugin_loaded(plugin)
  local success, plug = pcall(require, plugin)
  return success, plug
end

local function is_executable(name)
  return fn.executable(name) > 0
end

function _G.reload_lsp()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
  vim.cmd [[edit]]
end

vim.cmd [[command! ReloadLSP lua reload_lsp()]]
-----------------------------------------------------------------------------//
-- Init
-----------------------------------------------------------------------------//
local lsp_configs_loaded, lsp = is_plugin_loaded("lspconfig")
-- NOTE: Don't load this file if we aren't using "nvim-lsp"
if not lsp_configs_loaded then
  return
end

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//

local function setup_autocommands()
  autocommands.create(
    {
      LspCursorCommands = {
        {
          "CursorHold",
          "<buffer>",
          "lua vim.lsp.diagnostic.show_line_diagnostics()"
        },
        {"CursorHold", "<buffer>", "lua vim.lsp.buf.document_highlight()"},
        {"CursorHoldI", "<buffer>", "lua vim.lsp.buf.document_highlight()"},
        {"CursorHoldI", "<buffer>", "lua vim.lsp.buf.signature_help()"},
        {"CursorMoved", "<buffer>", "lua vim.lsp.buf.clear_references()"}
      },
      LspHighlights = {
        {"ColorScheme", "*", "lua _G.__apply_lsp_highlights()"}
      }
    }
  )
end
-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//
local function mapper(key, mode, mapping, expr)
  expr = not expr and false or expr
  api.nvim_buf_set_keymap(
    0,
    mode,
    key,
    mapping,
    {
      nowait = true,
      noremap = true,
      silent = true,
      expr = expr
    }
  )
end

local mappings = {
  ["[c"] = {mode = "n", mapping = "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>"},
  ["]c"] = {mode = "n", mapping = "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>"},
  ["gd"] = {mode = "n", mapping = "<cmd>lua vim.lsp.buf.definition()<CR>"},
  ["<c-]>"] = {mode = "n", mapping = "<cmd>lua vim.lsp.buf.definition()<CR>"},
  ["K"] = {mode = "n", mapping = "<cmd>lua vim.lsp.buf.hover()<CR>"},
  ["gi"] = {mode = "n", mapping = "<cmd>lua vim.lsp.buf.implementation()<CR>"},
  ["<c-k>"] = {
    mode = "i",
    mapping = "<cmd>lua vim.lsp.buf.signature_help()<CR>"
  },
  ["<leader>gd"] = {
    mode = "n",
    mapping = "<cmd>lua vim.lsp.buf.type_definition()<CR>"
  },
  ["<leader>gi"] = {
    mode = "n",
    mapping = "<cmd>vim.lsp.buf.incoming_calls()<CR>"
  },
  ["gr"] = {mode = "n", mapping = "<cmd>lua vim.lsp.buf.references()<CR>"},
  ["g0"] = {mode = "n", mapping = "<cmd>lua vim.lsp.buf.document_symbol()<CR>"},
  ["gW"] = {mode = "n", mapping = "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>"},
  ["ff"] = {mode = "n", mapping = "<cmd>lua vim.lsp.buf.formatting()<CR>"},
  ["rn"] = {mode = "n", mapping = "<cmd>lua vim.lsp.buf.rename()<CR>"},
  ["<tab>"] = {
    mode = "i",
    mapping = [[pumvisible() ? "\<C-n>" : "\<Tab>"]],
    expr = true
  },
  ["<s-tab>"] = {
    mode = "i",
    mapping = [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]],
    expr = true
  },
  ["<c-j>"] = {
    mode = {"i", "s"},
    mapping = [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>']],
    expr = true
  },
  ["<leader>ca"] = {
    mode = "n",
    mapping = "<cmd>lua vim.lsp.buf.code_action()<CR>"
  },
  ["ca"] = {
    mode = "x",
    mapping = "<cmd>'<'>lua vim.lsp.buf.range_code_action()<CR>"
  }
}

local function setup_mappings()
  for key, entry in pairs(mappings) do
    if type(entry.mode) == "table" then
      for _, mode in ipairs(entry.mode) do
        mapper(key, mode, entry.mapping, entry.expr)
      end
    else
      mapper(key, entry.mode, entry.mapping, entry.expr)
    end
  end
end
-----------------------------------------------------------------------------//
-- Signs
-----------------------------------------------------------------------------//
local signs = {
  {
    "LspDiagnosticsSignError",
    {text = "✗", texthl = "LspDiagnosticsSignError"}
  },
  {
    "LspDiagnosticsSignWarning",
    {text = "", texthl = "LspDiagnosticsSignWarning"}
  },
  {
    "LspDiagnosticsSignInformation",
    {text = "", texthl = "LspDiagnosticsSignInformation"}
  },
  {
    "LspDiagnosticsHintSign",
    {text = "ﯦ", texthl = "LspDiagnosticsSignHint"}
  }
}

for _, sign in pairs(signs) do
  fn.sign_define(unpack(sign))
end

-----------------------------------------------------------------------------//
-- Setup plugins
-----------------------------------------------------------------------------//
vim.g.completion_matching_strategy_list = {
  "exact",
  "substring",
  "fuzzy",
  "all"
}

-- see https://github.com/nvim-lua/completion-nvim/wiki/Customizing-LSP-label
-- for how to do this without completion-nvim
vim.g.completion_customize_lsp_label = {
  Keyword = "\u{f1de}",
  Variable = "\u{e79b}",
  Value = "\u{f89f}",
  Operator = "\u{03a8}",
  Function = "\u{0192}",
  Reference = "\u{fa46}",
  Constant = "\u{f8fe}",
  Method = "\u{f09a}",
  Struct = "\u{fb44}",
  Class = "\u{f0e8}",
  Interface = "\u{f417}",
  Text = "\u{e612}",
  Enum = "\u{f435}",
  EnumMember = "\u{f02b}",
  Module = "\u{f40d}",
  Color = "\u{e22b}",
  Property = "\u{e624}",
  Field = "\u{f9be}",
  Unit = "\u{f475}",
  Event = "\u{facd}",
  File = "\u{f723}",
  Folder = "\u{f114}",
  TypeParameter = "\u{f728}",
  Default = "\u{f29c}",
  Buffers = "",
  Snippet = " "
}

local function on_attach()
  setup_autocommands()
  setup_mappings()

  local completion_loaded, completion = is_plugin_loaded("completion")
  if completion_loaded then
    completion.on_attach()
    vim.g.completion_enable_snippet = "vim-vsnip"
    vim.g.completion_enable_fuzzy_match = true
  end
end
-----------------------------------------------------------------------------//
-- Highlights
-----------------------------------------------------------------------------//
function _G.__apply_lsp_highlights()
  local highlights = {
    {"LspDiagnosticsError", {guifg = "#E06C75", gui = "undercurl,bold"}},
    {"LspDiagnosticsSignError", {guifg = "#E06C75"}}, -- used for "Error" diagnostic signs in sign colum}n
    {"LspDiagnosticsWarning", {guifg = "#ff922b", gui = "undercurl"}}, -- used for "Warning" diagnostic virtual text
    {"LspDiagnosticsSignWarning", {guifg = "#ff922b"}}, -- used for "Warning" diagnostic signs in sign column
    {"LspDiagnosticsInformation", {guifg = "#fab005"}}, -- used for "Information" diagnostic virtual text
    {"LspDiagnosticsSignInformation", {guifg = "#fab005"}}, -- used for "Information" signs in sign column
    {"LspDiagnosticsHint", {guifg = "#fab005", gui = "bold"}}, -- used for "Hint" diagnostic virtual text
    {"LspDiagnosticsSignHint", {guifg = "#fab005"}}, -- used for "Hint" diagnostic signs in sign column
    {"LspReferenceText", {gui = "underline"}}, -- used for highlighting "text" references
    {"LspReferenceRead", {gui = "underline"}}, -- used for highlighting "read" references
    {"LspDiagnosticsUnderlineError", {gui = "undercurl", guisp = "red"}},
    {"LspDiagnosticsUnderlineHint", {gui = "undercurl", guisp = "purple"}},
    {"LspDiagnosticsUnderlineInfo", {gui = "undercurl", guisp = "blue"}},
    {"LspDiagnosticsUnderlineWarning", {gui = "undercurl", guisp = "orange"}}
  }
  for _, hl in pairs(highlights) do
    H.highlight(unpack(hl))
  end
end

__apply_lsp_highlights()

-----------------------------------------------------------------------------//
-- Handler overrides
-----------------------------------------------------------------------------//
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    underline = true,
    virtual_text = true,
    signs = true,
    update_in_insert = false
  }
)
-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//
if is_executable("gopls") then
  lsp.gopls.setup {on_attach = on_attach}
end

if is_executable("vim-language-server") then
  lsp.vimls.setup {on_attach = on_attach}
end

if is_executable("flow") then
  lsp.flow.setup {on_attach = on_attach}
end

if is_executable("vscode-html-languageserver") then
  lsp.html.setup {on_attach = on_attach}
end

if is_executable("vscode-json-languageserver") then
  lsp.jsonls.setup {on_attach = on_attach}
end

if is_executable("typescript-language-server") then
  lsp.tsserver.setup {on_attach = on_attach}
end

lsp.rust_analyzer.setup {on_attach = on_attach}

lsp.sumneko_lua.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = {"vim"}
      },
      workspace = {
        library = {[vim.fn.expand("$VIMRUNTIME/lua")] = true}
      }
    }
  }
}

local function flutter_closing_tags(err, _, response)
  if err then
    return
  end
  local namespace = api.nvim_create_namespace("flutter_lsp_closing_labels")

  for _, item in ipairs(response.labels) do
    local line = item.range["end"].line
    api.nvim_buf_set_virtual_text(
      0,
      namespace,
      tonumber(line),
      {
        {"//" .. item.label, "Comment"}
      },
      {}
    )
  end
end

local dart_capabilities = vim.lsp.protocol.make_client_capabilities()
dart_capabilities.textDocument.codeAction = {
  dynamicRegistration = false,
  codeActionLiteralSupport = {
    codeActionKind = {
      valueSet = {
        "",
        "quickfix",
        "refactor",
        "refactor.extract",
        "refactor.inline",
        "refactor.rewrite",
        "source",
        "source.organizeImports"
      }
    }
  }
}

lsp.dartls.setup {
  init_options = {
    onlyAnalyzeProjectsWithOpenFiles = false,
    suggestFromUnimportedLibraries = true,
    closingLabels = true,
    outline = true,
    flutterOutline = true
  },
  capabilities = dart_capabilities,
  cmd = {
    "dart",
    "/usr/lib/dart/bin/snapshots/analysis_server.dart.snapshot",
    "--lsp"
  },
  on_attach = on_attach,
  handlers = {
    ["dart/textDocument/publishClosingLabels"] = flutter_closing_tags,
    ["dart/textDocument/publishFlutterOutline"] = function(_, _, _)
    end
  }
}
