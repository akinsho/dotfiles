return function()
  local cwd = vim.fn.getcwd()
  require('gitsigns').setup({
    signs = {
      add = { hl = 'GitSignsAdd', text = '▌' },
      change = { hl = 'GitSignsChange', text = '▌' },
      delete = { hl = 'GitSignsDelete', text = '▌' },
      topdelete = { hl = 'GitSignsDelete', text = '▌' },
      changedelete = { hl = 'GitSignsChange', text = '▌' },
    },
    _threaded_diff = true,
    _extmark_signs = false,
    _signs_staged_enable = true,
    word_diff = false,
    current_line_blame = not cwd:match('personal') and not cwd:match('dotfiles'),
    current_line_blame_formatter = ' <author>, <author_time> · <summary>',
    numhl = false,
    preview_config = { border = as.style.current.border },
    on_attach = function()
      local gs = package.loaded.gitsigns

      local function qf_list_modified() gs.setqflist('all') end

      as.nnoremap('<leader>hu', gs.undo_stage_hunk, 'undo stage')
      as.nnoremap('<leader>hp', gs.preview_hunk_inline, 'preview current hunk')
      as.nnoremap('<leader>hs', gs.stage_hunk, 'stage current hunk')
      as.nnoremap('<leader>hr', gs.reset_hunk, 'reset current hunk')
      as.nnoremap('<leader>hb', gs.toggle_current_line_blame, 'toggle current line blame')
      as.nnoremap('<leader>hd', gs.toggle_deleted, 'show deleted lines')
      as.nnoremap('<leader>hw', gs.toggle_word_diff, 'gitsigns: toggle word diff')
      as.nnoremap('<localleader>gw', gs.stage_buffer, 'gitsigns: stage entire buffer')
      as.nnoremap('<localleader>gre', gs.reset_buffer, 'gitsigns: reset entire buffer')
      as.nnoremap('<localleader>gbl', gs.blame_line, 'gitsigns: blame current line')
      as.nnoremap('<leader>lm', qf_list_modified, 'gitsigns: list modified in quickfix')

      -- Navigation
      as.nnoremap('[h', function()
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true, desc = 'go to next git hunk' })

      as.nnoremap(']h', function()
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true, desc = 'go to previous git hunk' })

      as.vnoremap(
        '<leader>hs',
        function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end
      )
      as.vnoremap(
        '<leader>hr',
        function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end
      )

      vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
  })
end
