local fn = vim.fn
local api = vim.api

function as.qftf(info)
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
