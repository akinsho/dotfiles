return function()
  local Hydra = require('hydra')
  local border = as.style.current.border

  Hydra({
    name = 'Folds',
    mode = 'n',
    body = '<leader>z',
    color = 'teal',
    config = {
      invoke_on_body = true,
      hint = { border = border },
      on_enter = function()
        vim.cmd('BeaconOff')
      end,
      on_exit = function()
        vim.cmd('BeaconOn')
      end,
    },
    heads = {
      { 'j', 'zj', { desc = 'next fold' } },
      { 'k', 'zk', { desc = 'previous fold' } },
      { 'l', require('fold-cycle').open_all, { desc = 'open folds underneath' } },
      { 'h', require('fold-cycle').close_all, { desc = 'close folds underneath' } },
      { '<Esc>', nil, { exit = true, desc = 'Quit' } },
    },
  })

  Hydra({
    name = 'Buffer management',
    mode = 'n',
    body = '<leader>b',
    color = 'teal',
    config = {
      hint = { border = border },
      invoke_on_body = true,
      on_enter = function()
        vim.cmd('BeaconOff')
      end,
      on_exit = function()
        vim.cmd('BeaconOn')
      end,
    },
    heads = {
      { 'l', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' } },
      { 'h', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Prev buffer' } },
      { 'p', '<Cmd>BufferLineTogglePin<CR>', { desc = 'Pin buffer' } },
      { 'c', '<Cmd>BufferLinePick<CR>', { desc = 'Pin buffer' } },
      { 'd', '<Cmd>Bwipeout<CR>', { desc = 'delete buffer' } },
      { 'D', '<Cmd>BufferLinePickClose<CR>', { desc = 'Pick buffer to close', exit = true } },
      { '<Esc>', nil, { exit = true, desc = 'Quit' } },
    },
  })

  Hydra({
    name = 'Side scroll',
    mode = 'n',
    body = 'z',
    heads = {
      { 'h', '5zh' },
      { 'l', '5zl', { desc = '←/→' } },
      { 'H', 'zH' },
      { 'L', 'zL', { desc = 'half screen ←/→' } },
    },
  })

  Hydra({
    name = 'Window management',
    config = {
      invoke_on_body = true,
      hint = {
        border = border,
      },
    },
    mode = 'n',
    body = '<C-w>',
    heads = {
      -- Split
      { 's', '<C-w>s', { desc = 'split horizontally' } },
      { 'v', '<C-w>v', { desc = 'split vertically' } },
      { 'q', '<Cmd>Bwipeout<CR>', { desc = 'close window' } },
      -- Size
      { 'j', '2<C-w>+', { desc = 'increase height' } },
      { 'k', '2<C-w>-', { desc = 'decrease height' } },
      { 'h', '5<C-w>>', { desc = 'increase width' } },
      { 'l', '5<C-w><', { desc = 'decrease width' } },
      { '=', '<C-w>=', { desc = 'equalize' } },
      --
      { '<Esc>', nil, { exit = true } },
    },
  })

  local ok, gitsigns = pcall(require, 'gitsigns')
  if ok then
    local hint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo stage hunk   _p_: preview hunk   _B_: blame show full 
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _<Enter>_: Neogit              _q_: exit
]]

    Hydra({
      name = 'Git Mode',
      hint = hint,
      config = {
        color = 'pink',
        invoke_on_body = true,
        hint = {
          position = 'bottom',
          border = border,
        },
        on_enter = function()
          gitsigns.toggle_linehl(true)
          gitsigns.toggle_deleted(true)
        end,
        on_exit = function()
          gitsigns.toggle_linehl(false)
          gitsigns.toggle_deleted(false)
        end,
      },
      mode = { 'n', 'x' },
      body = '<localleader>G',
      heads = {
        {
          'J',
          function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gitsigns.next_hunk()
            end)
            return '<Ignore>'
          end,
          { expr = true },
        },
        {
          'K',
          function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gitsigns.prev_hunk()
            end)
            return '<Ignore>'
          end,
          { expr = true },
        },
        { 's', ':Gitsigns stage_hunk<CR>', { silent = true } },
        { 'u', gitsigns.undo_stage_hunk },
        { 'S', gitsigns.stage_buffer },
        { 'p', gitsigns.preview_hunk },
        { 'd', gitsigns.toggle_deleted, { nowait = true } },
        { 'b', gitsigns.blame_line },
        {
          'B',
          function()
            gitsigns.blame_line({ full = true })
          end,
        },
        { '/', gitsigns.show, { exit = true } }, -- show the base of the file
        { '<Enter>', '<cmd>Neogit<CR>', { exit = true } },
        { 'q', nil, { exit = true, nowait = true } },
      },
    })
  end

  local function run(method, args)
    return function()
      local dap = require('dap')
      if dap[method] then
        dap[method](args)
      end
    end
  end

  local hint = [[
 _n_: step over   _s_: Continue/Start   _b_: Breakpoint     _K_: Eval
 _i_: step into   _x_: Quit             ^ ^                 ^ ^
 _o_: step out    _X_: Stop             ^ ^
 _c_: to cursor   _C_: Close UI
 ^
 ^ ^              _q_: exit
]]

  local dap_hydra = Hydra({
    hint = hint,
    config = {
      color = 'pink',
      invoke_on_body = true,
      hint = {
        position = 'bottom',
        border = 'rounded',
      },
    },
    name = 'dap',
    mode = { 'n', 'x' },
    body = '<leader>dh',
    heads = {
      { 'n', run('step_over'), { silent = true } },
      { 'i', run('step_into'), { silent = true } },
      { 'o', run('step_out'), { silent = true } },
      { 'c', run('run_to_cursor'), { silent = true } },
      { 's', run('continue'), { silent = true } },
      { 'x', run('disconnect', { terminateDebuggee = false }), { exit = true, silent = true } },
      { 'X', run('close'), { silent = true } },
      {
        'C',
        ":lua require('dapui').close()<cr>:DapVirtualTextForceRefresh<CR>",
        { silent = true },
      },
      { 'b', run('toggle_breakpoint'), { silent = true } },
      { 'K', ":lua require('dap.ui.widgets').hover()<CR>", { silent = true } },
      { 'q', nil, { exit = true, nowait = true } },
    },
  })

  as.augroup('HydraDap', {
    event = 'User',
    user = 'DapStarted',
    command = function()
      vim.schedule(function()
        dap_hydra:activate()
      end)
    end,
  })
end
