local ok, wk = pcall(require, 'which-key')
if not ok then
  return
end

wk.register {
  ['<localleader>n'] = {
    name = '+neorg',
    n = {
      name = '+directory',
    },
    t = {
      name = '+todo',
      c = 'capture',
      e = 'edit',
      v = 'views',
    },
  },
}
