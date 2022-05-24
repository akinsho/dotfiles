return function()
  local api = vim.api

  require('as.highlights').plugin('notify', {
    NotifyERRORBorder = { bg = { from = 'NormalFloat' } },
    NotifyWARNBorder = { bg = { from = 'NormalFloat' } },
    NotifyINFOBorder = { bg = { from = 'NormalFloat' } },
    NotifyDEBUGBorder = { bg = { from = 'NormalFloat' } },
    NotifyTRACEBorder = { bg = { from = 'NormalFloat' } },
    NotifyERRORBody = { link = 'NormalFloat' },
    NotifyWARNBody = { link = 'NormalFloat' },
    NotifyINFOBody = { link = 'NormalFloat' },
    NotifyDEBUGBody = { link = 'NormalFloat' },
    NotifyTRACEBody = { link = 'NormalFloat' },
  })

  local percent = function()
    return math.floor(vim.o.lines * 0.8)
  end

  local notify = require('notify')
  notify.setup({
    timeout = 3000,
    max_width = percent,
    max_height = percent,
    stages = 'fade_in_slide_out',
    background_colour = 'NormalFloat',
    on_open = function(win)
      if api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_config(win, { border = as.style.current.border })
      end
    end,
    render = function(bufnr, notif, highlights)
      local style = notif.title[1] == '' and 'minimal' or 'default'
      require('notify.render')[style](bufnr, notif, highlights)
    end,
  })
  vim.notify = notify
  as.nnoremap('<leader>nd', notify.dismiss, { desc = 'dismiss notifications' })
end
