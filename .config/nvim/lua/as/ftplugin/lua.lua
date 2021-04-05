--- Stolen from nlua.nvim this function attempts to open
--- vim help docs if an api or vim.fn function otherwise it
--- shows the lsp hover doc
---@param word string
local function keyword(word, callback)
  local original_iskeyword = vim.bo.iskeyword

  vim.bo.iskeyword = vim.bo.iskeyword .. ",."
  word = word or vim.fn.expand("<cword>")

  vim.bo.iskeyword = original_iskeyword

  -- TODO: This is kind of a lame hack... since you could rename `vim.api` -> `a` or similar
  if string.find(word, "vim.api") then
    local _, finish = string.find(word, "vim.api.")
    local api_function = string.sub(word, finish + 1)

    vim.cmd(string.format("help %s", api_function))
    return
  elseif string.find(word, "vim.fn") then
    local _, finish = string.find(word, "vim.fn.")
    local api_function = string.sub(word, finish + 1) .. "()"

    vim.cmd(string.format("help %s", api_function))
    return
  elseif callback then
    callback()
  else
    vim.lsp.buf.hover()
  end
end

local loaded, hover

local function hover_doc()
  loaded, hover = pcall(require, "lspsaga.hover")
  local cb = loaded and hover.render_hover_doc or nil
  keyword(nil, cb)
end

as_utils.nnoremap("K", hover_doc, {buffer = 0})
