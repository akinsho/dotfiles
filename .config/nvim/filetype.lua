if not vim.filetype then
  return
end

vim.g.do_filetype_lua = 1

vim.filetype.add {
  filename = {
    ['.gitignore'] = 'conf',
    ['Podfile'] = 'ruby',
    ['Podfile.lock'] = 'yaml',
  },
  pattern = {
    ['*.gradle'] = 'groovy',
    ['*.env.*'] = 'env',
  },
}
