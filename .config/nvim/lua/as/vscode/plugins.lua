return {
  {
    'chaoren/vim-wordmotion',
    lazy = false,
    init = function() vim.g.wordmotion_spaces = { '-', '_', '\\/', '\\.' } end,
  },
  {
    'kylechui/nvim-surround',
    version = '*',
    keys = { { 's', mode = 'v' }, '<C-g>s', '<C-g>S', 'ys', 'yss', 'yS', 'cs', 'ds' },
    opts = { move_cursor = true, keymaps = { visual = 's' } },
  },
}
