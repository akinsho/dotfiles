return {
  'anuvyklack/hydra.nvim',
  event = 'CursorHold',
  config = function()
    local Hydra = require('hydra')
    local pcmd = require('hydra.keymap-util').pcmd
    local hint_opts = { position = 'bottom', border = as.ui.current.border, type = 'window' }

    local splits = as.reqcall('smart-splits')
    local fold_cycle = as.reqcall('fold-cycle')

    local base_config = function(opts)
      return vim.tbl_extend('force', {
        invoke_on_body = true,
        hint = hint_opts,
        on_enter = function() vim.cmd('silent! BeaconOff') end,
        on_exit = function() vim.cmd('silent! BeaconOn') end,
      }, opts or {})
    end

    Hydra({
      name = 'Folds',
      mode = 'n',
      body = '<leader>z',
      color = 'teal',
      config = base_config(),
      heads = {
        { 'j', 'zj', { desc = 'next fold' } },
        { 'k', 'zk', { desc = 'previous fold' } },
        { 'l', fold_cycle.open_all, { desc = 'open folds underneath' } },
        { 'h', fold_cycle.close_all, { desc = 'close folds underneath' } },
        { '<Esc>', nil, { exit = true, desc = 'Quit' } },
      },
    })

    Hydra({
      name = 'Buffer management',
      mode = 'n',
      body = '<leader>b',
      color = 'teal',
      config = base_config(),
      heads = {
        { 'l', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' } },
        { 'h', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Prev buffer' } },
        { 'p', '<Cmd>BufferLineTogglePin<CR>', { desc = 'Pin buffer' } },
        { 'c', '<Cmd>BufferLinePick<CR>', { desc = 'Pin buffer' } },
        { 'd', '<Cmd>BDelete this<CR>', { desc = 'delete buffer' } },
        { 'D', '<Cmd>BufferLinePickClose<CR>', { desc = 'Pick buffer to close', exit = true } },
        { '<Esc>', nil, { exit = true, desc = 'Quit' } },
      },
    })

    Hydra({
      name = 'Side scroll',
      mode = 'n',
      body = 'z',
      config = base_config({ invoke_on_body = false }),
      heads = {
        { 'h', '5zh' },
        { 'l', '5zl', { desc = '←/→' } },
        { 'H', 'zH' },
        { 'L', 'zL', { desc = 'half screen ←/→' } },
      },
    })

    local window_hint = [[
 ^^^^^^^^^^^^     Move      ^^    Size   ^^   ^^     Split
 ^^^^^^^^^^^^-------------  ^^-----------^^   ^^---------------
 ^ ^ _k_ ^ ^  ^ ^ _K_ ^ ^   ^   _<C-k>_   ^   _s_: horizontally 
 _h_ ^ ^ _l_  _H_ ^ ^ _L_   _<C-h>_ _<C-l>_   _v_: vertically
 ^ ^ _j_ ^ ^  ^ ^ _J_ ^ ^   ^   _<C-j>_   ^   _q_, _c_: close
 focus^^^^^^  window^^^^^^  ^_=_: equalize^   _o_: remain only
 ^ ^ ^ ^ ^ ^  ^ ^ ^ ^ ^ ^   ^^ ^          ^
]]

    Hydra({
      name = 'Windows',
      hint = window_hint,
      config = base_config({ invoke_on_body = false }),
      mode = 'n',
      body = '<C-w>',
      heads = {
        --- Move
        { 'h', '<C-w>h' },
        { 'j', '<C-w>j' },
        { 'k', pcmd('wincmd k', 'E11', 'close') },
        { 'l', '<C-w>l' },

        { 'o', '<C-w>o', { exit = true, desc = 'remain only' } },
        { '<C-o>', '<C-w>o', { exit = true, desc = false } },
        -- Resize
        { '<C-h>', function() splits.resize_left(2) end },
        { '<C-j>', function() splits.resize_down(2) end },
        { '<C-k>', function() splits.resize_up(2) end },
        { '<C-l>', function() splits.resize_right(2) end },
        { '=', '<C-w>=', { desc = 'equalize' } },
        -- Split
        { 's', pcmd('split', 'E36') },
        { '<C-s>', pcmd('split', 'E36'), { desc = false } },
        { 'v', pcmd('vsplit', 'E36') },
        { '<C-v>', pcmd('vsplit', 'E36'), { desc = false } },
        -- Size
        { 'H', function() splits.swap_buf_left() end },
        { 'J', function() splits.swap_buf_down() end },
        { 'K', function() splits.swap_buf_up() end },
        { 'L', function() splits.swap_buf_right() end },

        { 'c', pcmd('close', 'E444') },
        { 'q', pcmd('close', 'E444'), { desc = 'close window' } },
        { '<C-c>', pcmd('close', 'E444'), { desc = false } },
        { '<C-q>', pcmd('close', 'E444'), { desc = false } },
        { '<Esc>', nil, { exit = true } },
      },
    })
  end,
}
