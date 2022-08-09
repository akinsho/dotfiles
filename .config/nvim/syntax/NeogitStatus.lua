local api = vim.api
api.nvim_set_hl(0, 'NeogitDiffAdd', { link = 'DiffAdd' })
api.nvim_set_hl(0, 'NeogitDiffDelete', { link = 'DiffDelete' })
api.nvim_set_hl(0, 'NeogitDiffAddHighlight', { link = 'DiffAdd' })
api.nvim_set_hl(0, 'NeogitDiffDeleteHighlight', { link = 'DiffDelete' })
api.nvim_set_hl(0, 'NeogitDiffContextHighlight', { link = 'NormalFloat' })
api.nvim_set_hl(0, 'NeogitHunkHeader', { link = 'TabLine' })
api.nvim_set_hl(0, 'NeogitHunkHeaderHighlight', { link = 'DiffText' })
