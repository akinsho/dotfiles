return function()
  local function render(props)
    local fmt, icons = string.format, as.style.icons.misc
    local devicons = require('nvim-web-devicons')
    local highlights = require('as.highlights')
    local bufname = vim.api.nvim_buf_get_name(props.buf)
    if bufname == '' then
      return '[No name]'
    end
    local directory_color = highlights.get_hl('Directory', 'fg')
    local parts = vim.split(vim.fn.fnamemodify(bufname, ':.'), '/')
    local result = {}
    for idx, part in ipairs(parts) do
      if next(parts, idx) then
        vim.list_extend(result, {
          { as.truncate(part, 20) },
          { fmt(' %s ', icons.chevron_right), guifg = directory_color },
        })
      else
        table.insert(result, { part, gui = 'underline,bold', guisp = directory_color })
      end
    end
    local icon, color = devicons.get_icon_color(bufname, nil, { default = true })
    table.insert(result, #result, { icon .. ' ', guifg = color })
    return result
  end

  require('incline').setup({
    window = {
      zindex = 49, -- Make zindex slightly lower than telescope
      winhighlight = {
        inactive = {
          Normal = 'Normal',
        },
      },
      width = 'fill',
      padding = { left = 2, right = 1 },
      margin = {
        horizontal = 0,
      },
    },
    hide = { focused_win = true },
    render = render,
  })
end
