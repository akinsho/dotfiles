return function()
  local function render(props)
    local fmt, icons = string.format, as.style.icons.misc
    local bufname = vim.api.nvim_buf_get_name(props.buf)
    if bufname == '' then
      return '[No name]'
    end
    local directory_color = require('as.highlights').get_hl('Directory', 'fg')
    local parts = vim.split(vim.fn.fnamemodify(bufname, ':.'), '/')
    local result = {}
    for idx, part in ipairs(parts) do
      if next(parts, idx) then
        vim.list_extend(result, {
          { as.truncate(part, 20) },
          { fmt(' %s ', icons.chevron_right), guifg = directory_color },
        })
      else
        table.insert(result, { part, gui = 'underline,bold' })
      end
    end
    local icon, color = require('nvim-web-devicons').get_icon_color(bufname, nil, {
      default = true,
    })
    if icon then
      table.insert(result, #result, { icon .. ' ', guifg = color })
    end
    return result
  end

  require('incline').setup({
    hide = { focused_win = true },
    render = render,
  })
end
