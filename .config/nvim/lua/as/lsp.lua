local M = {}

local command = as_utils.command
-- -----------------------------------------------------------------------------//
-- -- Highlights
-- -----------------------------------------------------------------------------//
function M.highlight()
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

-----------------------------------------------------------------------------//
-- Helpers
-----------------------------------------------------------------------------//
function _G.reload_lsp()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
  vim.cmd [[edit]]
end

function _G.open_lsp_log()
  local path = vim.lsp.get_log_path()
  vim.cmd("edit " .. path)
end

command {
  "Format",
  function()
    vim.lsp.buf.formatting_sync(nil, 1000)
  end
}

command {
  "ReloadLSP",
  function()
    reload_lsp()
  end
}

command {
  "DebugLSP",
  function()
    print(vim.inspect(vim.lsp.get_active_clients()))
  end
}

command {
  "LogLSP",
  function()
    open_lsp_log()
  end
}

function M.tagfunc(pattern, flags)
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
-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//
function M.setup_autocommands(client)
  local autocommands = require "as.autocommands"
  autocommands.augroup(
    "LspHighlights",
    {
      {
        events = {"VimEnter", "ColorScheme"},
        targets = {"*"},
        command = [[lua require('as.lsp').highlight()]]
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
function M.setup_mappings(client)
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
-----------------------------------------------------------------------------//
-- Signs
-----------------------------------------------------------------------------//
M.signs = {
  {"LspDiagnosticsSignError", {text = "✗", texthl = "LspDiagnosticsSignError"}},
  {"LspDiagnosticsSignWarning", {text = "", texthl = "LspDiagnosticsSignWarning"}},
  {"LspDiagnosticsSignInformation", {text = "", texthl = "LspDiagnosticsSignInformation"}},
  {"LspDiagnosticsSignHint", {text = "", texthl = "LspDiagnosticsSignHint"}}
}

-----------------------------------------------------------------------------//
-- Buffer attach
-----------------------------------------------------------------------------//
function M.on_attach(client, bufnr)
  M.setup_autocommands(client)
  M.setup_mappings(client)

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
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.require('as.lsp').tagfunc")
  end
  require("lsp-status").on_attach(client)
end

return M
