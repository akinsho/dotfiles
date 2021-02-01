return function ()
   -- s for substitute
  local map = as_utils.map
  local opts = {silent = true}
  map("n", "<leader>s", "<plug>(SubversiveSubstitute)", opts)
  map("n", "<leader>ss", "<plug>(SubversiveSubstituteLine)", opts)
  map("n", "<leader>S", "<plug>(SubversiveSubstituteToEndOfLine)", opts)
  map("n", "<leader><leader>s", "<plug>(SubversiveSubstituteRange)", opts)
  map("x", "<leader><leader>s", "<plug>(SubversiveSubstituteRange)", opts)
end
