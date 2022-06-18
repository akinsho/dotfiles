if not vim.filetype then
  return
end

vim.g.do_filetype_lua = 1

vim.filetype.add({
  extension = {
    lock = 'yaml',
  },
  filename = {
    ['.psqlrc'] = 'conf', -- TODO: find a better filetype
    ['go.mod'] = 'gomod',
    ['.gitignore'] = 'conf',
    ['launch.json'] = 'jsonc',
    Podfile = 'ruby',
    Brewfile = 'ruby',
  },
  pattern = {
    ['.*%.conf'] = 'conf',
    ['.*%.theme'] = 'conf',
    ['.*%.gradle'] = 'groovy',
    ['.*%.env%..*'] = 'env',
  },
})
