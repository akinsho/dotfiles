return {
  -- The active colorscheme, so it has to load before anything is drawn.
  -- Light vs dark is chosen by 'background', which init.lua sets before this loads.
  {
    'maxmx03/solarized.nvim',
    lazy = false,
    priority = 1000,
    ---@type solarized.config
    opts = {
      palette = 'solarized',
      styles = {
        comments = { italic = true },
        types = { italic = true, bold = true },
      },
    },
  },
  -- Kept for `:colorscheme github_dark_default`; loaded on demand.
  { 'projekt0n/github-nvim-theme', lazy = true },
}
