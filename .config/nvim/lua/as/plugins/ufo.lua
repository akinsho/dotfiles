return function()
  local ufo = require('ufo')
  local hl = require('as.highlights')
  local opt, get_width = vim.opt, vim.api.nvim_strwidth

  local function handler(virt_text, _, _, width, truncate, end_text)
    local result = {}
    local padding = ''
    local cur_width = 0
    local suffix_width = get_width(end_text.text)
    local target_width = width - suffix_width

    for _, chunk in ipairs(virt_text) do
      local chunk_text = chunk[1]
      local chunk_width = get_width(chunk_text)
      if target_width > cur_width + chunk_width then
        table.insert(result, chunk)
      else
        chunk_text = truncate(chunk_text, target_width - cur_width)
        local hl_group = chunk[2]
        table.insert(result, { chunk_text, hl_group })
        chunk_width = get_width(chunk_text)
        if cur_width + chunk_width < target_width then
          padding = padding .. (' '):rep(target_width - cur_width - chunk_width)
        end
        break
      end
      cur_width = cur_width + chunk_width
    end

    -- reformat the end text to trim excess whitespace from indentation
    local end_virt_text = vim.tbl_map(function(item)
      item[1] = item[1]:gsub('%s+', function(m)
        return #m > 1 and '' or ' '
      end)
      return item
    end, end_text.end_virt_text)

    table.insert(result, { ' ⋯ ', 'NonText' })
    vim.list_extend(result, end_virt_text)
    table.insert(result, { padding, '' })
    return result
  end

  opt.foldlevelstart = 99
  opt.sessionoptions:append('folds')

  hl.plugin('ufo', {
    Folded = {
      bold = false,
      italic = false,
      bg = hl.alter_color(hl.get('Normal', 'bg'), -7),
    },
  })

  as.augroup('UfoSettings', {
    {
      event = 'FileType',
      pattern = { 'org' },
      command = function()
        ufo.detach()
      end,
    },
  })

  ufo.setup({
    open_fold_hl_timeout = 0,
    fold_virt_text_handler = handler,
    enable_fold_end_virt_text = true,
    preview = { win_config = { winhighlight = 'Normal:Normal,FloatBorder:Normal' } },
    provider_selector = function()
      return { 'treesitter', 'indent' }
    end,
  })
  as.nnoremap('zR', ufo.openAllFolds, 'open all folds')
  as.nnoremap('zM', ufo.closeAllFolds, 'close all folds')
  as.nnoremap('zP', ufo.peekFoldedLinesUnderCursor, 'preview fold')
end
