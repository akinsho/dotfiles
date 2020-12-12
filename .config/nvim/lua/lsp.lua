-----------------------------------------------------------------------------//
-- Init
-----------------------------------------------------------------------------//
local success, lspconfig = pcall(require, "lspconfig")
-- NOTE: Don't load this file if we aren't using "nvim-lsp"
if not success then
  return
end
-----------------------------------------------------------------------------//

local fn = vim.fn
local api = vim.api

local M = {}

local H = require "highlights"
local autocommands = require "autocommands"
local lsp_status = require "lsp-status"
local completion = require "completion"
-----------------------------------------------------------------------------//
-- Helpers
-----------------------------------------------------------------------------//
function _G.reload_lsp()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
  vim.cmd [[edit]]
end

vim.cmd [[command! ReloadLSP lua reload_lsp()]]
vim.cmd [[command! DebugLSP lua print(vim.inspect(vim.lsp.get_active_clients()))]]

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
        {"ColorScheme", "*", "lua require('lsp').setup_lsp_highlights()"}
      }
    }
  )
end
-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//
local function map(...)
  api.nvim_buf_set_keymap(0, ...)
end

local function setup_mappings()
  local opts = {nowait = true, noremap = true, silent = true}
  map("n", "[c", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  map("n", "]c", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  map("n", "<c-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  map("i", "<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  map("n", "<leader>gd", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  map("n", "gI", "<cmd>vim.lsp.buf.incoming_calls()<CR>", opts)
  map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  map("n", "<leader>gd", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
  map("n", "<leader>gs", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
  map("n", "<leader>ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  map("i", "<tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], {expr = true})
  map("i", "<s-tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], {expr = true})
  map(
    "x",
    "<c-j>",
    [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>']],
    {expr = true}
  )
  map(
    "i",
    "<c-j>",
    [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>']],
    {expr = true}
  )
  map(
    "s",
    "<c-j>",
    [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>']],
    {expr = true}
  )
  map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  map(
    "x",
    "<leader>a",
    "<cmd>'<'>lua vim.lsp.buf.range_code_action()<CR>",
    opts
  )
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
    {text = "", texthl = "LspDiagnosticsSignInformation"}
  },
  {
    "LspDiagnosticsSignHint",
    {text = "", texthl = "LspDiagnosticsSignHint"}
  }
}

for _, sign in pairs(signs) do
  fn.sign_define(unpack(sign))
end

-----------------------------------------------------------------------------//
-- Setup plugins
-----------------------------------------------------------------------------//
vim.g.vsnip_snippet_dir = vim.g.vim_dir .. "/snippets/textmate"

vim.g.completion_enable_snippet = "vim-vsnip"
vim.g.completion_enable_auto_paren = 1
vim.g.completion_items_priority = {
  ["vim-vsnip"] = 0
}
vim.g.completion_enable_fuzzy_match = true
vim.g.completion_matching_smart_case = 1
vim.g.completion_menu_length = 25
vim.g.completion_sorting = "none"
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
  Snippet = "",
  ["vim-vsnip"] = ""
}

local function on_attach(client)
  setup_autocommands()
  setup_mappings()

  completion.on_attach()
  lsp_status.on_attach(client)
end

lsp_status.config {
  kind_labels = vim.g.completion_customize_lsp_label
}
lsp_status.register_progress()
-----------------------------------------------------------------------------//
-- Highlights
-----------------------------------------------------------------------------//
function M.setup_lsp_highlights()
  local highlights = {
    {"LspReferenceText", {gui = "underline"}},
    {"LspReferenceRead", {gui = "underline"}},
    {"LspDiagnosticsDefaultHint", {guifg = "#fab005"}},
    {"LspDiagnosticsDefaultError", {guifg = "#E06C75"}},
    {"LspDiagnosticsDefaultWarning", {guifg = "#ff922b"}},
    {"LspDiagnosticsDefaultInformation", {guifg = "#15aabf"}},
    {"LspDiagnosticsUnderlineError", {gui = "undercurl", guisp = "#E06C75"}},
    {"LspDiagnosticsUnderlineHint", {gui = "undercurl", guisp = "#fab005"}},
    {"LspDiagnosticsUnderlineWarning", {gui = "undercurl", guisp = "orange"}},
    {
      "LspDiagnosticsUnderlineInformation",
      {gui = "undercurl", guisp = "#15aabf"}
    }
  }
  for _, hl in pairs(highlights) do
    H.highlight(unpack(hl))
  end
end

M.setup_lsp_highlights()

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
local closing_labels_namespace =
  api.nvim_create_namespace("flutter_lsp_closing_labels")

local function flutter_closing_tags(err, _, response)
  if err then
    return
  end
  local uri = response.uri
  -- This check is meant to prevent stray events from over-writing labels that
  -- don't match the current buffer.
  if uri ~= vim.uri_from_bufnr(0) then
    return
  end
  vim.api.nvim_buf_clear_namespace(0, closing_labels_namespace, 0, -1)

  for _, item in ipairs(response.labels) do
    local line = item.range["end"].line
    api.nvim_buf_set_virtual_text(
      0,
      closing_labels_namespace,
      tonumber(line),
      {
        {"//" .. item.label, "Comment"}
      },
      {}
    )
  end
end

local servers = {
  rust_analyzer = {},
  vimls = {},
  gopls = {},
  flow = {},
  jsonls = {},
  html = {},
  tsserver = {},
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = {
          globals = {"vim"}
        },
        runtime = {version = "LuaJIT", path = vim.split(package.path, ";")},
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
          }
        }
      }
    }
  },
  dartls = {
    flags = {allow_incremental_sync = true},
    init_options = {
      closingLabels = true,
      outline = true,
      flutterOutline = true
    },
    on_attach = on_attach,
    handlers = {
      ["dart/textDocument/publishClosingLabels"] = flutter_closing_tags,
      ["dart/textDocument/publishFlutterOutline"] = function(_, _, _)
      end
    }
  }
}

for server, config in pairs(servers) do
  config.on_attach = on_attach
  config.capabilities =
    vim.tbl_deep_extend(
    "keep",
    config.capabilities or {},
    lsp_status.capabilities
  )
  lspconfig[server].setup(config)
end

return M
