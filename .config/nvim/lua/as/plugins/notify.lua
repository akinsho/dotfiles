return function()
  local api = vim.api
  -- this plugin is not safe to reload
  if vim.g.packer_compiled_loaded then
    return
  end
  require('as.highlights').plugin('notify', {
    NotifyERRORBody = { link = 'NormalFloat' },
    NotifyWARNBody = { link = 'NormalFloat' },
    NotifyINFOBody = { link = 'NormalFloat' },
    NotifyDEBUGBody = { link = 'NormalFloat' },
    NotifyTRACEBody = { link = 'NormalFloat' },
  })
  local notify = require('notify')
  ---@type table<string, fun(bufnr: number, notif: table, highlights: table)>
  local renderer = require('notify.render')
  notify.setup({
    max_width = function()
      return math.floor(vim.o.columns * 0.8)
    end,
    max_height = function()
      return math.floor(vim.o.lines * 0.8)
    end,
    background_colour = 'NormalFloat',
    stages = 'fade_in_slide_out',
    on_open = function(win)
      if api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_config(win, { border = as.style.current.border })
      end
    end,
    timeout = 3000,
    render = function(bufnr, notif, highlights)
      local style = notif.title[1] == '' and 'minimal' or 'default'
      renderer[style](bufnr, notif, highlights)
    end,
  })
  vim.notify = notify
  require('telescope').load_extension('notify')
  as.nnoremap('<leader>nd', notify.dismiss, { label = 'dismiss notifications' })
end
