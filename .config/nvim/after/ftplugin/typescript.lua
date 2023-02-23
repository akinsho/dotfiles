if pcall(require, 'typescript') then
  map('n', 'gd', 'TypescriptGoToSourceDefinition', { desc = 'typescript: go to source definition' })
end
