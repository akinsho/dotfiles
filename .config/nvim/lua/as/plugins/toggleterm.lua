return function()
  local api, fn = vim.api, vim.fn
  require('toggleterm').setup({
    open_mapping = [[<c-\>]],
    shade_filetypes = { 'none' },
    direction = 'horizontal',
    insert_mappings = false,
    start_in_insert = true,
    winbar = {
      enabled = true,
    },
    highlights = {
      FloatBorder = { link = 'FloatBorder' },
      NormalFloat = { link = 'NormalFloat' },
    },
    float_opts = {
      border = as.style.current.border,
      winblend = 3,
    },
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
  })

  local float_handler = function(term)
    if fn.mapcheck('jk', 't') ~= '' then
      api.nvim_buf_del_keymap(term.bufnr, 't', 'jk')
      api.nvim_buf_del_keymap(term.bufnr, 't', '<esc>')
    end
  end

  local Terminal = require('toggleterm.terminal').Terminal

  local lazygit = Terminal:new({
    cmd = 'lazygit',
    dir = 'git_dir',
    hidden = true,
    direction = 'float',
    on_open = float_handler,
  })

  local btop = Terminal:new({
    cmd = 'btop',
    hidden = true,
    direction = 'float',
    on_open = float_handler,
    highlights = {
      FloatBorder = { guibg = 'Black', guifg = 'DarkGray' },
      NormalFloat = { guibg = 'Black' },
    },
  })

  local gh_dash = Terminal:new({
    cmd = 'gh dash',
    hidden = true,
    direction = 'float',
    on_open = float_handler,
    float_opts = {
      height = function() return math.floor(vim.o.lines * 0.8) end,
      width = function() return math.floor(vim.o.columns * 0.95) end,
    },
  })

  as.nnoremap('<leader>ld', function() gh_dash:toggle() end, 'toggleterm: toggle github dashboard')

  as.command('Btop', function() btop:toggle() end)

  as.nnoremap('<leader>lg', function() lazygit:toggle() end, 'toggleterm: toggle lazygit')
end
