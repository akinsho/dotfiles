local M = {}

function M.setup()
  require('as.highlights').plugin('Headlines', {
    theme = {
      ['*'] = {
        { Headline1 = { background = '#003c30', foreground = 'White' } },
        { Headline2 = { background = '#00441b', foreground = 'White' } },
        { Headline3 = { background = '#084081', foreground = 'White' } },
        { Dash = { background = '#0b60a1', bold = true } },
      },
      ['horizon'] = {
        { Headline = { background = { from = 'Normal', alter = 20 } } },
      },
    },
  })
end

function M.config()
  require('headlines').setup({
    markdown = {
      headline_highlights = { 'Headline1', 'Headline2', 'Headline3' },
    },
    org = { headline_highlights = false },
    norg = {
      headline_highlights = { 'Headline1', 'Headline2', 'Headline3' },
      codeblock_highlight = false,
    },
  })
end

return M
