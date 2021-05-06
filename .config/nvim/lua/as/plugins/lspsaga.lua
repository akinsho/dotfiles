return function()
  local saga = require("lspsaga")

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

  as.vnoremap("<leader>ca", ":<c-u>lua require('lspsaga.codeaction').range_code_action()<CR>")
  as.inoremap("<c-k>", "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>")
  as.nnoremap("K", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>")
  -- scroll down hover doc
  as.nnoremap("<C-f>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>")
  -- scroll up hover doc
  as.nnoremap("<C-b>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>")

  require("which-key").register(
    {
      ["<leader>rn"] = {require("lspsaga.rename").rename, "lsp: rename"},
      ["<leader>ca"] = {require("lspsaga.codeaction").code_action, "lsp: code action"},
      ["gp"] = {require("lspsaga.provider").preview_definition, "lsp: preview definition"},
      ["gh"] = {require("lspsaga.provider").lsp_finder, "lsp: finder"},
      -- jump diagnostic
      ["]c"] = {require("lspsaga.diagnostic").lsp_jump_diagnostic_prev, "lsp: previous diagnostic"},
      ["[c"] = {require("lspsaga.diagnostic").lsp_jump_diagnostic_next, "lsp: next diagnostic"}
    }
  )

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
