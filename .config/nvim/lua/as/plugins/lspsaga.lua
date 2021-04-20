return function()
  local saga = require("lspsaga")
  local nnoremap = as.nnoremap
  local inoremap = as.inoremap
  local vnoremap = as.vnoremap

  saga.init_lsp_saga {
    use_saga_diagnostic_sign = false,
    finder_action_keys = {
      vsplit = "v",
      split = "s",
      quit = {"q", "<ESC>"}
    },
    code_action_icon = "💡",
    code_action_prompt = {
      enable = false,
      sign = false,
      virtual_text = false
    }
  }

  require("as.highlights").highlight("LspSagaLightbulb", {guifg = "NONE", guibg = "NONE"})

  nnoremap("gp", "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>")
  nnoremap("gh", [[<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>]])

  -- jump diagnostic
  nnoremap("]c", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>")
  nnoremap("[c", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>")
  inoremap("<c-k>", "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>")
  nnoremap("<leader>rn", "<cmd>lua require('lspsaga.rename').rename()<CR>")
  nnoremap("<leader>ca", "<cmd>lua require('lspsaga.codeaction').code_action()<CR>")
  vnoremap("<leader>ca", ":<c-u>lua require('lspsaga.codeaction').range_code_action()<CR>")
  nnoremap("K", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>")

  -- scroll down hover doc
  nnoremap("<C-f>", [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>]])
  -- scroll up hover doc
  nnoremap("<C-b>", [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>]])

  as.augroup(
    "LspSagaCursorCommands",
    {
      {
        events = {"CursorHold"},
        targets = {"*"},
        command = "lua require('lspsaga.diagnostic').show_cursor_diagnostics()"
      }
    }
  )
end
