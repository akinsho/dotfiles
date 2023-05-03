return {
  { 'akinsho/horizon.nvim', dev = true, lazy = false, priority = 1000 },
  { 'igorgue/danger', lazy = false },
  {
    'NTBBloodbath/doom-one.nvim',
    lazy = false,
    config = function()
      vim.g.doom_one_pumblend_enable = true
      vim.g.doom_one_pumblend_transparency = 3
    end,
  },
}
