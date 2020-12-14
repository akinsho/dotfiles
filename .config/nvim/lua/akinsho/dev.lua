local M = {}

function M.reset_package(regex)
  for k in pairs(package.loaded) do
    if k:match(regex) then
      vim.cmd(string.format("echom 'Removing %s from loaded packages'", k))
      package.loaded[k] = nil
    end
  end
end

-- stolen from ThePrimegean's video
--  https://www.youtube.com/watch?v=9L4sW047oow
if vim.fn.has("nvim-0.5") then
  vim.cmd(
    'command! -nargs=? ResetLuaPlugin lua require"devtools".reset_package(<q-args>)'
  )
end

return M
