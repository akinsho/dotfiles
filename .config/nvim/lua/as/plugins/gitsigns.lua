return function()
  require('gitsigns').setup({
    signs = {
      add = { hl = 'GitSignsAdd', text = '▌' },
      change = { hl = 'GitSignsChange', text = '▌' },
      delete = { hl = 'GitSignsDelete', text = '▌' },
      topdelete = { hl = 'GitSignsDelete', text = '▌' },
      changedelete = { hl = 'GitSignsChange', text = '▌' },
    },
    _threaded_diff = true, -- NOTE: experimental but I'm curious
    word_diff = false,
    numhl = false,
    preview_config = {
      border = as.style.current.border,
    },
    on_attach = function()
      local gs = package.loaded.gitsigns

      local function qf_list_modified()
        gs.setqflist('all')
      end

      require('which-key').register({
        ['<leader>h'] = {
          name = '+gitsigns hunk',
          u = { gs.undo_stage_hunk, 'undo stage' },
          p = { gs.preview_hunk, 'preview current hunk' },
          s = { gs.stage_hunk, 'stage current hunk' },
          r = { gs.reset_hunk, 'reset current hunk' },
          b = { gs.toggle_current_line_blame, 'toggle current line blame' },
          d = { gs.toggle_deleted, 'show deleted lines' },
        },
        ['<localleader>g'] = {
          name = '+git',
          w = { gs.stage_buffer, 'gitsigns: stage entire buffer' },
          r = {
            name = '+reset',
            e = { gs.reset_buffer, 'gitsigns: reset entire buffer' },
          },
          b = {
            name = '+blame',
            l = { gs.blame_line, 'gitsigns: blame current line' },
            d = { gs.toggle_word_diff, 'gitsigns: toggle word diff' },
          },
        },
        ['<leader>lm'] = { qf_list_modified, 'gitsigns: list modified in quickfix' },
      })

      -- Navigation
      as.nnoremap('[h', function()
        vim.schedule(function()
          gs.next_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, desc = 'go to next git hunk' })

      as.nnoremap(']h', function()
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, desc = 'go to previous git hunk' })

      vim.keymap.set('v', '<leader>hs', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end)
      vim.keymap.set('v', '<leader>hr', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end)

      vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
  })
end
