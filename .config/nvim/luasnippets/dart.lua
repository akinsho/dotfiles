---@diagnostic disable: undefined-global

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
