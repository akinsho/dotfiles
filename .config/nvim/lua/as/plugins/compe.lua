local fn = vim.fn

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s" ~= nil
end

--- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.__tab_complete = function()
  local luasnip = require "luasnip"
  if fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif luasnip and luasnip.expand_or_jumpable() then
    return t "<Plug>luasnip-expand-or-jump"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return fn["compe#complete"]()
  end
end
_G.__s_tab_complete = function()
  local luasnip = require "luasnip"
  if fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif luasnip and luasnip.jumpable(-1) then
    return t "<Plug>luasnip-jump-prev"
  else
    return t "<S-Tab>"
  end
end

return function()
  require("compe").setup {
    source = {
      path = true,
      buffer = { kind = " " },
      luasnip = { kind = " " },
      spell = true,
      emoji = { kind = "ﲃ", filetypes = { "markdown", "gitcommit" } },
      nvim_lsp = { priority = 101 },
      nvim_lua = true,
      orgmode = true,
    },
    documentation = {
      border = "rounded",
      winhighlight = table.concat({
        "NormalFloat:CompeDocumentation",
        "Normal:CompeDocumentation",
        "FloatBorder:CompeDocumentationBorder",
      }, ","),
    },
  }

  local imap = as.imap
  local smap = as.smap
  local inoremap = as.inoremap
  local opts = { expr = true, silent = true }

  inoremap("<C-e>", "compe#complete()", opts)
  imap("<Tab>", "v:lua.__tab_complete()", opts)
  smap("<Tab>", "v:lua.__tab_complete()", opts)
  imap("<S-Tab>", "v:lua.__s_tab_complete()", opts)
  smap("<S-Tab>", "v:lua.__s_tab_complete()", opts)
  inoremap("<C-f>", "compe#scroll({ 'delta': +4 })", opts)
  inoremap("<C-d>", "compe#scroll({ 'delta': -4 })", opts)
end
