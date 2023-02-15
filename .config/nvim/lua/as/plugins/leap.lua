local api, fn = vim.api, vim.fn
local highlight = as.highlight

local function leap_keys()
  require('leap').leap({
    target_windows = vim.tbl_filter(
      function(win) return as.empty(fn.win_gettype(win)) end,
      api.nvim_tabpage_list_wins(0)
    ),
  })
end

--------------------------------------------------------------------------------
-- Search Tools {{{1
--------------------------------------------------------------------------------
return {
  {
    'ggandor/leap.nvim',
    keys = { { 's', leap_keys, mode = 'n' } },
    opts = { equivalence_classes = { ' \t\r\n', '([{', ')]}', '`"\'' } },
    config = function(_, opts)
      highlight.plugin('leap', {
        theme = {
          ['*'] = { { LeapBackdrop = { fg = '#707070' } } },
          horizon = {
            { LeapLabelPrimary = { bg = 'NONE', fg = '#ccff88', italic = true } },
            { LeapLabelSecondary = { bg = 'NONE', fg = '#99ccff' } },
            { LeapLabelSelected = { bg = 'NONE', fg = 'Magenta' } },
          },
        },
      })
      require('leap').setup(opts)
    end,
  },
  {
    'ggandor/flit.nvim',
    keys = { 'f' },
    dependencies = { 'ggandor/leap.nvim' },
    opts = { labeled_modes = 'nvo', multiline = false },
  },
}
