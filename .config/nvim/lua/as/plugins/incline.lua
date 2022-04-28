return function()
  require('incline').setup {
    render = function(props)
      local fmt, icons = string.format, as.style.icons.misc
      local bufname = vim.api.nvim_buf_get_name(props.buf)
      if bufname == '' then
        return '[No name]'
      end
      local parts = vim.split(vim.fn.fnamemodify(bufname, ':.'), '/')
      local icon, _ = require('nvim-web-devicons').get_icon(bufname, nil, { default = true })
      parts[#parts] = fmt('%s %s', icon, parts[#parts])
      return table.concat(parts, fmt(' %s ', icons.chevron_right))
    end,
    hide = { focused_win = true },
  }
end
