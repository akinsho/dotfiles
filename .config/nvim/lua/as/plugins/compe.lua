local fn = vim.fn

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

--- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.__tab_complete = function()
  if fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif fn["vsnip#available"](1) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return fn["compe#complete"]()
  end
end
_G.__s_tab_complete = function()
  if fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif fn["vsnip#jumpable"](-1) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

return function()
  require("compe").setup {
    source = {
      path = true,
      buffer = {kind = " [Buffer]"},
      vsnip = {kind = " [Vsnip]"},
      spell = true,
      nvim_lsp = true,
      nvim_lua = true,
      treesitter = true,
      tabnine = true
    }
  }

  local map = as_utils.map
  local opts = {noremap = true, silent = true, expr = true}
  map("i", "<C-Space>", "compe#complete()", opts)
  map("i", "<C-e>", "compe#close('<C-e>')", opts)
  map("i", "<Tab>", "v:lua.__tab_complete()", {expr = true})
  map("s", "<Tab>", "v:lua.__tab_complete()", {expr = true})
  map("i", "<S-Tab>", "v:lua.__s_tab_complete()", {expr = true})
  map("s", "<S-Tab>", "v:lua.__s_tab_complete()", {expr = true})
  map("i", "<C-f>", "compe#scroll({ 'delta': +4 }", opts)
  map("i", "<C-d>", "compe#scroll({ 'delta': -4 }", opts)

  local npairs = require("nvim-autopairs")

  as_utils.completion_confirm = function()
    if vim.fn.pumvisible() ~= 0 then
      if vim.fn.complete_info()["selected"] ~= -1 then
        return vim.fn["compe#confirm"]()
      end
      vim.fn.nvim_select_popupmenu_item(0, false, false, {})
      vim.fn["compe#confirm"]()
      return vim.fn["compe#confirm"]()
    end

    return npairs.check_break_line_char()
  end
  as_utils.map("i", "<CR>", "v:lua.as_utils.completion_confirm()", {expr = true, noremap = true})
end
