---@diagnostic disable: undefined-global

return {
  snippet({ trig = 'td', name = 'TODO' }, {
    c(1, {
      t 'TODO: ',
      t 'FIXME: ',
      t 'HACK: ',
      t 'BUG: ',
    }),
    i(0),
  }),
  snippet(
    { trig = 'hr', name = 'Header' },
    fmt(
      [[
            {1}
            {2} {3}
            {1}
            {4}
          ]],
      {
        f(function()
          local comment = string.format(vim.bo.commentstring:gsub(' ', '') or '#%s', '-')
          local col = vim.bo.textwidth or 80
          return comment .. string.rep('-', col - #comment)
        end),
        f(function()
          return vim.bo.commentstring:gsub('%%s', '')
        end),
        i(1, 'HEADER'),
        i(0),
      }
    )
  ),
}
