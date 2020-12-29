return function()
  vim.lsp.handlers["textDocument/codeAction"] = require "lsputil.codeAction".code_action_handler
  vim.lsp.handlers["textDocument/references"] = require "lsputil.locations".references_handler
  vim.lsp.handlers["textDocument/definition"] = require "lsputil.locations".definition_handler
  vim.lsp.handlers["textDocument/declaration"] = require "lsputil.locations".declaration_handler
  vim.lsp.handlers["textDocument/documentSymbol"] = require "lsputil.symbols".document_handler
  vim.lsp.handlers["workspace/symbol"] = require "lsputil.symbols".workspace_handler
  vim.lsp.handlers["textDocument/typeDefinition"] =
    require "lsputil.locations".typeDefinition_handler
  vim.lsp.handlers["textDocument/implementation"] =
    require "lsputil.locations".implementation_handler
end
