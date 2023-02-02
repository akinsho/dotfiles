if not as then return end

local api, fn = vim.api, vim.fn

as.qf = {}

-- NOTE: we define this outside of our ftplugin/qf.vim
-- since that is loaded on each run of our qf window
-- this means that it would be recreated each time if
-- not defined separately, so on replacing the quickfix
-- we would recreate this function during it's execution
-- source: https://vi.stackexchange.com/a/21255
-- using range-aware function
function as.qf.delete(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  local qfl = fn.getqflist()
  local line = unpack(api.nvim_win_get_cursor(0))
  -- FIXME: get visual selection so this functionality can work in visual mode
  if api.nvim_get_mode().mode == 'v' then
    local firstline = unpack(api.nvim_buf_get_mark(0, '<'))
    local lastline = unpack(api.nvim_buf_get_mark(0, '>'))
    local result = {}
    for i, item in ipairs(qfl) do
      if i < firstline or i > lastline then table.insert(result, item) end
    end
    qfl = result
  else
    table.remove(qfl, line)
  end
  -- replace items in the current list, do not make a new copy of it;
  -- this also preserves the list title
  fn.setqflist({}, 'r', { items = qfl })
  -- restore current line
  fn.setpos('.', { bufnr, line, 1, 0 })
end
