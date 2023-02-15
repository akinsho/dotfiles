local strwidth = vim.api.nvim_strwidth

local function fold_renderer(virt_text, _, end_lnum, width, truncate, ctx)
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

local ufo_ft_map = { dart = { 'lsp', 'treesitter' } }

return {
  {
    'kevinhwang91/nvim-ufo',
    event = 'VeryLazy',
    dependencies = { 'kevinhwang91/promise-async' },
    keys = {
      { 'zR', function() require('ufo').openAllFolds() end, 'open all folds' },
      { 'zM', function() require('ufo').closeAllFolds() end, 'close all folds' },
      { 'zP', function() require('ufo').peekFoldedLinesUnderCursor() end, 'preview fold' },
    },
    opts = {
      open_fold_hl_timeout = 0,
      enable_get_fold_virt_text = true,
      fold_virt_text_handler = fold_renderer,
      preview = { win_config = { winhighlight = 'Normal:Normal,FloatBorder:Normal' } },
      provider_selector = function(_, filetype)
        return ufo_ft_map[filetype] or { 'treesitter', 'indent' }
      end,
    },
    config = function(_, opts)
      as.augroup('UfoSettings', {
        {
          event = 'FileType',
          pattern = { 'org' },
          command = function() require('ufo').detach() end,
        },
      })
      require('ufo').setup(opts)
    end,
  },
}
