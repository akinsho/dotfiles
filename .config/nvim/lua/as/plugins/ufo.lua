return function()
  local ufo = require('ufo')
  local hl = require('as.highlights')
  local opt, fn, api = vim.opt, vim.fn, vim.api

  local function handler(virt_text, lnum, end_lnum, width, truncate)
    local result = {}
    local _end = end_lnum - 1
    local final_text = vim.trim(api.nvim_buf_get_text(0, _end, 0, _end, -1, {})[1])
    local suffix = final_text:format(end_lnum - lnum)
    local suffix_width = fn.strdisplaywidth(suffix)
    local target_width = width - suffix_width
    local cur_width = 0
    for _, chunk in ipairs(virt_text) do
      local chunk_text = chunk[1]
      local chunk_width = fn.strdisplaywidth(chunk_text)
      if target_width > cur_width + chunk_width then
        table.insert(result, chunk)
      else
        chunk_text = truncate(chunk_text, target_width - cur_width)
        local hl_group = chunk[2]
        table.insert(result, { chunk_text, hl_group })
        chunk_width = fn.strdisplaywidth(chunk_text)
        -- str width returned from truncate() may less than 2nd argument, need padding
        if cur_width + chunk_width < target_width then
          suffix = suffix .. (' '):rep(target_width - cur_width - chunk_width)
        end
        break
      end
      cur_width = cur_width + chunk_width
    end
    table.insert(result, { ' ⋯ ', 'NonText' })
    table.insert(result, { suffix, 'TSPunctBracket' })
    return result
  end

  opt.foldlevelstart = 99
  opt.sessionoptions:append('folds')

  local bg = hl.alter_color(hl.get('Normal', 'bg'), -7)
  hl.plugin('ufo', { Folded = { bold = false, italic = false, bg = bg } })

  local ft_map = {}
  ufo.setup({
    open_fold_hl_timeout = 0,
    fold_virt_text_handler = handler,
    provider_selector = function(_, filetype)
      return ft_map[filetype] or { 'treesitter', 'indent' }
    end,
  })
  as.nnoremap('zR', ufo.openAllFolds, 'open all folds')
  as.nnoremap('zM', ufo.closeAllFolds, 'close all folds')
end
