local fn = vim.fn

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
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
  elseif fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return fn['compe#complete']()
  end
end
_G.__s_tab_complete = function()
  if fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif fn.call("vsnip#jumpable", {-1}) == 1 then
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
      vsnip = {priority = 1500, kind = " [Vsnip]"},
      spell = true,
      nvim_lsp = true,
      nvim_lua = true,
      treesitter = true,
      tabnine = true
    }
  }

  local map = as_utils.map
  local opts = {noremap = true, silent = true, expr = true}
  vim.g.lexima_no_default_rules = true
  vim.fn["lexima#set_default_rules"]()
  map("i", "<C-Space>", "compe#complete()", opts)
  map("i", "<CR>", [[compe#confirm(lexima#expand('<LT>CR>', 'i'))]], opts)
  map("i", "<C-e>", "compe#close('<C-e>')", opts)
  map("i", "<Tab>", "v:lua.__tab_complete()", opts)
  map("s", "<Tab>", "v:lua.__tab_complete()", opts)
  map("i", "<S-Tab>", "v:lua.__s_tab_complete()", opts)
  map("s", "<S-Tab>", "v:lua.__s_tab_complete()", opts)
end
