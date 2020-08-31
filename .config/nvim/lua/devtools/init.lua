local M = {}

function M.reset_package(regex)
  for k in pairs(package.loaded) do
   if k:match(regex) then
      vim.cmd(string.format("echom 'Removing %s from loaded packages'", k))
      package.loaded[k] = nil
   end
  end
end

return M
