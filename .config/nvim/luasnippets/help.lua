---@diagnostic disable: undefined-global

return {
  snippet({ trig = 'con', wordTrig = true }, {
    i(1),
    f(function(args) return { ' ' .. string.rep('.', 80 - (#args[1][1] + #args[2][1] + 2 + 2)) .. ' ' } end, { 1, 2 }),
    t({ '|' }),
    i(2),
    t({ '|' }),
    i(0),
  }),
}
