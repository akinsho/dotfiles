return {
  {
    'gbprod/yanky.nvim',
    keys = {
      { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' } },
      { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' } },
      { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' } },
      { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' } },
      { '<m-n>', '<Plug>(YankyCycleForward)' },
      { '<m-p>', '<Plug>(YankyCycleBackward)' },
      {
        '<localleader>p',
        function()
          require('telescope').extensions.yank_history.yank_history(as.telescope.dropdown())
        end,
        desc = 'yanky: open yank history',
      },
    },
    config = function()
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
                ['<CR>'] = mapping.put('p'),
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
    end,
  },
  {
    'gbprod/substitute.nvim',
    dependencies = { 'gbprod/yanky.nvim' },
    keys = {
      { 'S', function() require('substitute').visual() end, mode = 'x' },
      { 'S', function() require('substitute').operator() end, mode = 'n' },
      { 'X', function() require('substitute.exchange').operator() end, mode = 'n' },
      { 'X', function() require('substitute.exchange').visual() end, mode = 'x' },
      { 'Xc', function() require('substitute.exchange').cancel() end, mode = { 'n', 'x' } },
    },
    config = function()
      require('substitute').setup({
        on_substitute = require('yanky.integration').substitute(),
      })
    end,
  },
  {
    'monaqa/dial.nvim',
    keys = {
      { '<C-a>', '<Plug>(dial-increment)', mode = 'n' },
      { '<C-x>', '<Plug>(dial-decrement)', mode = 'n' },
      { '<C-a>', '<Plug>(dial-increment)', mode = 'v' },
      { '<C-x>', '<Plug>(dial-decrement)', mode = 'v' },
      { 'g<C-a>', 'g<Plug>(dial-increment)', mode = 'v' },
      { 'g<C-x>', 'g<Plug>(dial-decrement)', mode = 'v' },
    },
    config = function()
      local augend = require('dial.augend')
      local config = require('dial.config')

      local operators = augend.constant.new({
        elements = { '&&', '||' },
        word = false,
        cyclic = true,
      })

      local casing = augend.case.new({
        types = { 'camelCase', 'snake_case', 'PascalCase', 'SCREAMING_SNAKE_CASE' },
        cyclic = true,
      })

      config.augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.bool,
          casing,
        },
      })

      config.augends:on_filetype({
        go = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.alias.bool,
          operators,
        },
        typescript = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.alias.bool,
          augend.constant.new({ elements = { 'let', 'const' } }),
          casing,
        },
        markdown = {
          augend.integer.alias.decimal,
          augend.misc.alias.markdown_header,
        },
        yaml = {
          augend.semver.alias.semver,
        },
        toml = {
          augend.semver.alias.semver,
        },
      })
    end,
  },
}
