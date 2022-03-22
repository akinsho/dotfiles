---@diagnostic disable: undefined-global
-- FIXME: it doesn't recognise that the "l" global is passed in by the snip_env?
local extras = require 'luasnip.extras'
local l = extras.lambda

return {
  snippet(
    {
      trig = 'pr',
      name = 'print',
      dscr = 'print a variable optionally wrapping it with braces',
    },
    fmt([[print('{}: ${}');]], {
      i(1, { 'label' }),
      m(1, '%.', '{' .. l._1 .. '}', l._1),
    })
  ),
}
