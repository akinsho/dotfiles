local ok, wk = pcall(require, 'which-key')
if not ok then
  return
end

wk.register({
  g = {
    name = '+todos',
    t = {
      name = '+status',
      u = 'task undone',
      p = 'task pending',
      d = 'task done',
      h = 'task on_hold',
      c = 'task cancelled',
      r = 'task recurring',
      i = 'task important',
    },
  },
  ['<localleader>t'] = {
    name = '+gtd',
    c = 'capture',
    v = 'views',
    e = 'edit',
  },
})
