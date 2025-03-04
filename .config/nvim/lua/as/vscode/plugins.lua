return {
  {
    'vscode-neovim/vscode-multi-cursor.nvim',
    event = 'VeryLazy',
    opts = {},
  },
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
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup({
        close_triple_quotes = true,
        disable_filetype = { 'neo-tree-popup' },
        check_ts = true,
        fast_wrap = { map = '<c-e>' },
        ts_config = {
          lua = { 'string' },
          dart = { 'string' },
          javascript = { 'template_string' },
        },
      })
    end,
  },
  --------------------------------------------------------------------------------
  -- TPOPE {{{1
  --------------------------------------------------------------------------------
  { 'tpope/vim-repeat', event = 'VeryLazy' },
  {
    'tpope/vim-abolish',
    keys = {
      {
        '<localleader>[',
        ':S/<C-R><C-W>//<LEFT>',
        mode = 'n',
        silent = false,
        desc = 'abolish: replace word under the cursor (line)',
      },
      {
        '<localleader>]',
        ':%S/<C-r><C-w>//c<left><left>',
        mode = 'n',
        silent = false,
        desc = 'abolish: replace word under the cursor (file)',
      },
      {
        '<localleader>[',
        [["zy:'<'>S/<C-r><C-o>"//c<left><left>]],
        mode = 'x',
        silent = false,
        desc = 'abolish: replace word under the cursor (visual)',
      },
    },
  },
  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    config = function() require('mini.ai').setup({ mappings = { around_last = '', inside_last = '' } }) end,
  },
  {
    'glts/vim-textobj-comment',
    dependencies = { { 'kana/vim-textobj-user', dependencies = { 'kana/vim-operator-user' } } },
    init = function() vim.g.textobj_comment_no_default_key_mappings = 1 end,
    keys = {
      { 'ax', '<Plug>(textobj-comment-a)', mode = { 'x', 'o' } },
      { 'ix', '<Plug>(textobj-comment-i)', mode = { 'x', 'o' } },
    },
  },
}
