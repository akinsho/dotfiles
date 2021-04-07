local fn = vim.fn

function _G.__fugitive_create_new_branch()
  -- TODO: add a new line at the end of the input
  -- consider highlighting for bonus point
  local branch = fn.input("Enter new branch name: ")
  if branch and #branch > 0 then
    vim.cmd "redraw" -- clear the input message we just added
    vim.cmd(string.format([[execute 'Git checkout -b %s']], branch))
  end
end

return function()
  local nnoremap = as.nnoremap
  local vnoremap = as.vnoremap
  local command = as.command

  command {"Gcm", [[<cmd>G checkout master]], nargs = 0}
  command {"Gcb", [[<cmd>G checkout -b <q-args>]], nargs = 1}

  -- Fugitive bindings
  nnoremap("<localleader>gS", "<cmd>Git<CR>")
  -- Stages the current file
  nnoremap("<localleader>gw", "<cmd>Gwrite<CR>")
  -- Revert current file to last checked in version
  nnoremap("<localleader>gre", "<cmd>Gread<CR>")
  -- Remove the current file and the corresponding buffer
  nnoremap("<localleader>grm", "<cmd>GRemove<CR>")
  -- See in a side window who is responsible for lines of code
  -- can also set the date=relative but this breaks rendering
  -- and shortcuts
  nnoremap("<localleader>gbl", "<cmd>Git blame --date=short<CR>")
  -- Blame specific visual range
  vnoremap("<localleader>gbl", ":Gblame --date=short<CR>")
  nnoremap("<localleader>gd", "<cmd>Gdiffsplit<CR>")
  nnoremap("<localleader>gdc", "<cmd>call fugitive#DiffClose()<CR>")
  nnoremap("<localleader>gdt", "<cmd>G difftool<CR>")
  nnoremap("<localleader>gda", "<cmd>G difftool -y<CR>")
  nnoremap("<localleader>gc", "<cmd>Git commit<CR>")
  nnoremap("<localleader>gcl", "<cmd>Gclog!<CR>")
  nnoremap("<localleader>gcm", "<cmd>Gcm<CR>")
  nnoremap("<localleader>gn", "<cmd>lua __fugitive_create_new_branch()<CR>")
  nnoremap("<localleader>gm", "<cmd>Git mergetool<CR>")
  -- command is not silent as this obscures the preceding command
  -- also not the use of <c-z> the wildcharm character to trigger completion
  nnoremap("<localleader>go", ":Git checkout<space><C-Z>")
end
