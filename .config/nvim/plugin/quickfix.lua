local fn = vim.fn
local api = vim.api

as.qf = {}

function as.qf.textfunc(info)
  local items
  local ret = {}
  if info.quickfix == 1 then
    items = fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local limit = 25
  local fname_fmt1, fname_fmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
  local valid_fmt, invalid_fmt = '%s |%5d:%-3d|%s %s', '%s'
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = api.nvim_buf_get_name(e.bufnr)
        if fname == '' then
          fname = '[No Name]'
        else
          fname = fname:gsub('^' .. vim.env.HOME, '~')
        end
        if fn.strwidth(fname) <= limit then
          fname = fname_fmt1:format(fname)
        else
          fname = fname_fmt2:format(fname:sub(1 - limit, -1))
        end
      end
      local lnum = e.lnum > 99999 and 'inf' or e.lnum
      local col = e.col > 999 and 'inf' or e.col
      local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      str = valid_fmt:format(fname, lnum, col, qtype, e.text)
    else
      str = invalid_fmt:format(e.text)
    end
    table.insert(ret, str)
  end
  return ret
end

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
  if api.nvim_get_mode().mode == 'v' then
    -- no need for filter() and such; just drop the items in range
    local firstline = unpack(api.nvim_buf_get_mark(0, '<'))
    local lastline = unpack(api.nvim_buf_get_mark(0, '>'))
    fn.remove(qfl, firstline - 1, lastline - 1)
  else
    table.remove(qfl, line)
  end
  -- replace items in the current list, do not make a new copy of it;
  -- this also preserves the list title
  fn.setqflist({}, 'r', { items = qfl })
  -- restore current line
  fn.setpos('.', { bufnr, line, 1, 0 })
end
