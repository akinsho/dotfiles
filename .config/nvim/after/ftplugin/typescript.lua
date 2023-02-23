local opt = vim.opt_local

opt.textwidth = 100

if pcall(require, 'typescript') then
  map('n', 'gd', 'TypescriptGoToSourceDefinition', { desc = 'typescript: go to source definition' })
end
