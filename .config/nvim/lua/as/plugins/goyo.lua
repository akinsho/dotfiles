local fn = vim.fn

function _G.__goyo_enter()
  if fn.executable("tmux") > 0 and fn.strlen("$TMUX") then
    vim.cmd "silent !tmux set status off"
    vim.cmd [["silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z"]]
  end
  vim.cmd "set showtabline=0"
  vim.b.quitting = 0
  vim.b.quitting_bang = 0
  vim.cmd "autocmd QuitPre <buffer> let b:quitting = 1"
  vim.cmd "cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!"
end

function _G.__goyo_leave()
  if fn.exists("$TMUX") > 0 then
    vim.cmd "silent !tmux set status on"
    vim.cmd [["silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z"]]
  end
  vim.cmd "set showtabline=2"
  -- Quit Vim if this is the only remaining buffer
  if vim.b.quitting and #fn.getbufinfo {buflisted = true} == 1 then
    if vim.b.quitting_bang then
      vim.cmd "qa!"
    else
      vim.cmd "qa"
    end
  end
end

function _G.__auto_goyo()
  local fts = {"markdown", "vimwiki"}
  if fn.index(fts, vim.bo.ft) >= 0 then
    vim.cmd "Goyo 120"
  elseif fn.exists("#goyo") > 0 then
    local bufnr = fn.bufnr("%")
    vim.cmd "Goyo!"
    fn.execute("buffer " .. bufnr)
    vim.cmd "doautocmd ColorScheme,BufEnter,WinEnter"
  end
end

return function()
  -- augroup automatic_goyo
  -- autocmd!
  -- BUG:
  -- 1. s:auto_goyo cannot be called in a nested autocommand
  -- as this causes an infinite loop because of a FileType autocommand
  -- so the function manually triggers necessary autocommands
  -- 2. Floating windows cause this to break BADLY
  -- autocmd BufEnter * call s:auto_goyo()
  -- augroup END
  vim.g.goyo_margin_top = 2
  vim.g.goyo_margin_bottom = 2
  vim.g.goyo_width = "60%"

  as_utils.map("n", "<leader>zg", "<cmd>Goyo<CR>")

  vim.cmd "autocmd! User GoyoLeave nested lua __goyo_leave()"
  vim.cmd "autocmd! User GoyoEnter nested lua __goyo_enter()"
end
