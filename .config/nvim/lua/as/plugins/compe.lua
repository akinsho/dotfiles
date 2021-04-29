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
      vsnip = {priority = 1500, kind = " [Vsnip]"},
      spell = true,
      nvim_lsp = true,
      nvim_lua = true,
      emoji = false,
      tabnine = as.has("mac") and {priority = 1200} or false
    }
  }

  local imap = as.imap
  local smap = as.smap
  local inoremap = as.inoremap
  local opts = {expr = true}

  inoremap("<C-Space>", "compe#complete()", opts)
  inoremap("<C-e>", "compe#close('<C-e>')", opts)
  imap("<Tab>", "v:lua.__tab_complete()", opts)
  smap("<Tab>", "v:lua.__tab_complete()", opts)
  imap("<S-Tab>", "v:lua.__s_tab_complete()", opts)
  smap("<S-Tab>", "v:lua.__s_tab_complete()", opts)
  inoremap("<C-f>", "compe#scroll({ 'delta': +4 })", opts)
  inoremap("<C-d>", "compe#scroll({ 'delta': -4 })", opts)

  as.completion_confirm = function()
    local npairs = require("nvim-autopairs")

    if vim.fn.pumvisible() ~= 0 then
      if vim.fn.complete_info()["selected"] ~= -1 then
        return vim.fn["compe#confirm"](npairs.esc("<cr>"))
      else
        return npairs.esc("<cr>")
      end
    else
      return npairs.autopairs_cr()
    end
  end
  inoremap("<CR>", "v:lua.as.completion_confirm()", opts)
end
