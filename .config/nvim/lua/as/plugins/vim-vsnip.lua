return function()
  vim.g.vsnip_snippet_dir = vim.g.vim_dir .. "/snippets/textmate"

  local map = as_utils.map
  map("i", "<c-l>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<c-l>'", {expr = true})
  map("s", "<c-l>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<c-l>'", {expr = true})
  map("i", "<c-h>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<c-h>'", {expr = true})
  map("s", "<c-h>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<c-h>'", {expr = true})
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
end
