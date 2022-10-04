return function()
  local map = vim.keymap.set
  local utils = require('yanky.utils')
  local mapping = require('yanky.telescope.mapping')

  require('yanky').setup({
    ring = { storage = 'sqlite' },
    preserve_cursor_position = { enabled = true },
    picker = {
      telescope = {
        mappings = {
          default = mapping.put('p'),
          i = {
            ['<c-p>'] = mapping.put('p'),
            ['<c-k>'] = mapping.put('P'),
            ['<c-x>'] = mapping.delete(),
            ['<c-r>'] = mapping.set_register(utils.get_default_register()),
          },
          n = {
            p = mapping.put('p'),
            P = mapping.put('P'),
            d = mapping.delete(),
            r = mapping.set_register(utils.get_default_register()),
          },
        },
      },
    },
  })

  map({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
  map({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
  map({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
  map({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')

  as.nnoremap('<m-n>', '<Plug>(YankyCycleForward)')
  as.nnoremap('<m-p>', '<Plug>(YankyCycleBackward)')
  as.nnoremap(
    '<localleader>p',
    function() require('telescope').extensions.yank_history.yank_history(as.telescope.dropdown()) end,
    'yanky: open yank history'
  )
end
