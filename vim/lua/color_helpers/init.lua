local M = {}

local success, bufferline = pcall(require, 'bufferline')
local shade_color = (success and bufferline) and bufferline.shade_color or nil


function M.darken_explorer(amount)
  if not success or not shade_color then return end
  local id = vim.fn.hlID('Normal')
  local bg_color = vim.fn.synIDattr(id, 'bg')
  local darkened_bg = shade_color(bg_color, amount)
  vim.cmd('highlight DarkenedPanel guibg='..darkened_bg)
  vim.cmd('highlight DarkenedClear guifg='..darkened_bg..' guibg='..darkened_bg)
  vim.cmd('setlocal winhighlight=Normal:DarkenedPanel,VertSplit:DarkenedClear')
end

function M.darken_terminal(amount)
  if not success or not shade_color then return end
  local id = vim.fn.hlID('Normal')
  local bg_color = vim.fn.synIDattr(id, 'bg')
  local darkened_bg = shade_color(bg_color, amount)
  vim.cmd('highlight DarkenedPanel guibg='..darkened_bg)
  vim.cmd('highlight DarkenendStatusline gui=NONE guibg='..darkened_bg)
  -- setting ctermbg to black is a hack to prevent the statusline caret issue
  vim.cmd('highlight DarkenendStatuslineNC ctermbg=black gui=NONE guibg='..darkened_bg)
  vim.cmd('setlocal winhighlight=Normal:DarkenedPanel,StatusLine:DarkenendStatusline,StatusLineNC:DarkenendStatuslineNC')
end

return M
