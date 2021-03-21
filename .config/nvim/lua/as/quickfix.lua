-- File: quickfix.lua
-- Author: Akin Sowemimo
-- Description: A copy/paste/edit of ronakg/quickr-preview.vim
-- Last Modified: October 11, 2020
local M = {}

local fn = vim.fn
local api = vim.api
local fmt = string.format

local state = {
  enabled = true,
  preview_height = nil
}

---Check if the preview window is open
---@return boolean
---@return integer
local function is_preview_open()
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if vim.wo[w].previewwindow then
      return true, w
    end
  end
  return false, nil
end

local function open_preview_window(entry)
  local original_height = vim.o.previewheight
  local preview_height = state.preview_height or original_height
  vim.o.previewheight = preview_height
  vim.cmd(fmt("pedit +%d %s", entry.lnum, fn.bufname(entry.bufnr)))
  vim.o.previewheight = original_height
end

---Match the quickfix entry and the containing line differently
---@param lnum number
local function highlight_match(lnum)
  if vim.w.qf_preview_line_id then
    fn.matchdelete(vim.w.qf_preview_line_id)
  end
  if vim.w.qf_preview_match_id then
    fn.matchdelete(vim.w.qf_preview_match_id)
  end
  vim.w.qf_preview_match_id, vim.w.qf_preview_line_id =
    fn.matchadd("Search", [[\%]] .. lnum .. [[l^\s*\zs.\{-}\ze\s*$]], 12),
    fn.matchadd("Visual", [[\%]] .. lnum .. "l", 10)
end

local function preview_matches(opts)
  local entry = opts.entry
  local is_listed = opts.buf_listed
  local preview_open = opts.preview_open

  if not preview_open then
    open_preview_window(entry)
  end

  vim.cmd "set eventignore+=all"
  -- Go to preview window
  vim.cmd "keepjumps wincmd P"

  -- If the window was already opened and we have jumped to it
  -- we should find the line in question
  if preview_open then
    -- Jump to the line of interest
    vim.cmd(fmt("silent! keepjumps %d | normal! zz", entry.lnum))
  end

  -- Setting for unlisted buffers
  if not is_listed then
    vim.bo.buflisted = false -- don't list this buffer
    vim.bo.swapfile = false -- don't create swap file for this buffer
    vim.bo.bufhidden = "delete" -- clear out settings when buffer is hidden
  end
  -- Open any folds we may be in
  vim.cmd "silent! foldopen!"
  vim.wo.number = true

  -- highlight the line
  highlight_match(entry.lnum)

  -- go back to the quickfix
  vim.cmd "keepjumps wincmd p"
  vim.cmd "keepjumps wincmd J"
  vim.cmd "set eventignore-=all"
end

function M.view_file(lnum)
  -- Close the preview window if the user has selected a same entry again
  if lnum == vim.b.previous_lnum then
    vim.cmd "pclose"
    vim.b.previous_lnum = 0
    return
  end
  -- get the qf entry for the current line which includes the line number
  -- and the buffer number. Using those open the preview window to the specific
  -- position
  local entry = fn.getqflist()[lnum] or {}
  if vim.tbl_isempty(entry) or not entry.lnum or entry.lnum < 0 then
    return
  end
  vim.b.previous_lnum = lnum

  local preview_open = is_preview_open() and entry.bufnr == vim.b.previous_bufnr

  -- Note if the buffer of interest is already listed
  local is_listed = fn.buflisted(entry.bufnr) > 0
  -- Setting for unlisted buffers
  preview_matches(
    {
      entry = entry,
      preview_open = preview_open,
      buf_listed = is_listed
    }
  )

  vim.b.previous_bufnr = entry.bufnr
end

function M.open(lnum)
  if not state.enabled then
    return
  end
  if lnum ~= vim.b.previous_lnum then
    if vim.b.qf_timer then
      fn.timer_stop(vim.b.qf_timer)
    end
    vim.b.qf_timer =
      fn.timer_start(
      300,
      function()
        if vim.b.qf_timer then
          vim.b.qf_timer = nil
        end
        M.view_file(fn.line("."))
      end
    )
  end
end

function M.enter()
  vim.cmd [[pclose!]]
  vim.cmd [[execute "normal! \<cr>"]]
end

function M.toggle()
  if state.enabled then
    local is_open = is_preview_open()
    if is_open then
      vim.cmd "pclose!"
    end
    state.enabled = false
  else
    M.open(fn.line("."))
    state.enabled = true
  end
end

function M.setup(opts)
  state.preview_height = opts.preview_height or 8
  vim.b.previous_lnum = 0
  vim.b.previous_bufnr = 0

  as_utils.nnoremap("<CR>", [[:lua require('as.quickfix').enter()<CR>]], {buffer = 0})
  api.nvim_exec(
    [[
      augroup QFMove
        au! * <buffer>
        " Auto close preview window when closing/deleting the qf/loc list
        autocmd WinClosed <buffer> pclose
        " we create a nested autocommand to ensure that when we open the preview buffer
        " things like syntax highlighting and statuslines get set correctly
        autocmd CursorMoved <buffer> nested lua require('as.quickfix').open(vim.fn.line('.'))
      augroup END
      ]],
    ""
  )
end
return M
