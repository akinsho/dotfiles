return function()
  -- Use completion-nvim in every buffer
  require("as.autocommands").create(
    {
      Completion = {
        {
          "BufEnter",
          "*",
          [[lua require'completion'.on_attach()]]
        }
      }
    }
  )

  local map = as_utils.map
  -- cycle the completion menu with <TAB>
  map("i", "<tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], {expr = true})
  map("i", "<s-tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], {expr = true})

  vim.g.vsnip_snippet_dir = vim.g.vim_dir .. "/snippets/textmate"

  vim.g.completion_auto_change_source = 0
  vim.g.completion_enable_snippet = "vim-vsnip"
  vim.g.completion_enable_auto_paren = 1
  vim.g.completion_items_priority = {
    ["vim-vsnip"] = 0
  }
  vim.g.completion_matching_smart_case = 1
  vim.g.completion_menu_length = 45
  vim.g.completion_sorting = "none"
  vim.g.completion_matching_strategy_list = {
    "exact",
    "substring"
  }

  vim.g.completion_tabnine_sort_by_details = 1

  vim.g.completion_chain_complete_list = {
    default = {
      {complete_items = {"lsp", "snippet", "ts", "tabnine"}},
      {mode = "<c-p>"},
      {mode = "<c-n>"}
    },
    string = {
      {complete_items = {"path", "lsp", "tabnine", "snippet"}}
    }
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
end
