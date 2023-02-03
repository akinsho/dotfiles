return function()
  local ufo = require('ufo')
  local hl = require('as.highlights')
  local opt, strwidth = vim.opt, vim.api.nvim_strwidth

  local function handler(virt_text, _, end_lnum, width, truncate, ctx)
    local result = {}
    local padding = ''
    local cur_width = 0
    local suffix_width = strwidth(ctx.text)
    local target_width = width - suffix_width

    for _, chunk in ipairs(virt_text) do
      local chunk_text = chunk[1]
      local chunk_width = strwidth(chunk_text)
      if target_width > cur_width + chunk_width then
        table.insert(result, chunk)
      else
        chunk_text = truncate(chunk_text, target_width - cur_width)
        local hl_group = chunk[2]
        table.insert(result, { chunk_text, hl_group })
        chunk_width = strwidth(chunk_text)
        if cur_width + chunk_width < target_width then
          padding = padding .. (' '):rep(target_width - cur_width - chunk_width)
        end
        break
      end
      cur_width = cur_width + chunk_width
    end

    local end_text = ctx.get_fold_virt_text(end_lnum)
    -- reformat the end text to trim excess whitespace from indentation usually the first item is indentation
    if end_text[1] and end_text[1][1] then end_text[1][1] = end_text[1][1]:gsub('[%s\t]+', '') end

    table.insert(result, { ' ⋯ ', 'UfoFoldedEllipsis' })
    vim.list_extend(result, end_text)
    table.insert(result, { padding, '' })
    return result
  end

  opt.foldlevelstart = 2
  -- Don't add folds to sessions because they are added asynchronously and if the file does not
  -- exist on a git branch for which the folds where saved it will cause an error on startup
  -- opt.sessionoptions:append('folds')

  hl.plugin('ufo', {
    { Folded = { bold = false, italic = false, bg = { from = 'Normal', alter = -7 } } },
  })

  as.augroup('UfoSettings', {
    {
      event = 'FileType',
      pattern = { 'org' },
      command = function() ufo.detach() end,
    },
  })

  local ft_map = {
    dart = { 'lsp', 'treesitter' },
  }

  ufo.setup({
    open_fold_hl_timeout = 0,
    fold_virt_text_handler = handler,
    enable_get_fold_virt_text = true,
    preview = { win_config = { winhighlight = 'Normal:Normal,FloatBorder:Normal' } },
    provider_selector = function(_, filetype) return ft_map[filetype] or { 'treesitter', 'indent' } end,
  })
  as.nnoremap('zR', ufo.openAllFolds, 'open all folds')
  as.nnoremap('zM', ufo.closeAllFolds, 'close all folds')
  as.nnoremap('zP', ufo.peekFoldedLinesUnderCursor, 'preview fold')
end
