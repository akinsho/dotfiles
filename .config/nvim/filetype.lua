if not vim.filetype then
  return
end

vim.g.do_filetype_lua = 1

vim.filetype.add {
  filename = {
    ['.gitignore'] = 'conf',
    ['*.gradle'] = 'groovy',
    ['Podfile'] = 'ruby',
    ['*.env.*'] = 'sh'
  },
}
