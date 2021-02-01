local fn = vim.fn
local buf_map = as_utils.buf_map

function _G.__fugitive_create_new_branch()
  -- TODO add a new line at the end of the input
  -- consider highlighting for bonus point
  local branch = fn.input("Enter new branch name: ")
  if #branch > 0 then
    vim.cmd "redraw" -- clear the input message we just added
    vim.cmd([[execute 'Git checkout -b ']] .. branch)
  end
end

function _G.__fugitive_setup_commit_buffer()
  local expr = {expr = true, silent = true}
  buf_map(
    "n",
    "}",
    [[filter([search('\%(\_^#\?\s*\_$\)\\|\%$', 'W'), line('$')], 'v:val')[0].'G']],
    expr
  )
  buf_map("n", "{", [[max([1, search('\%(\_^#\?\s*\_$\)\\|\%^', 'bW')]).'G']], expr)

  if fn.expand("%"):match("COMMIT_EDITMSG") then
    vim.cmd [[setlocal spell]]
    -- delete the commit message storing it in "g, and go back to Gstatus
    buf_map(
      "n",
      "Q",
      [[gg0"gd/#<cr>:let @/=''<cr>:<c-u>wq<cr>:Gstatus<cr>:call histdel('search', -1)<cr>]],
      {silent = true}
    )
    -- Restore register "g
    buf_map("n", "<leader>u", [[gg"gP]], {silent = true})
  end
end
return function()
  local map = as_utils.map
  local cmd = as_utils.cmd

  cmd("Gcm", "Gcm", {"-nargs=0"}, [[<cmd>G checkout master]])
  cmd("Gcb", "Gcb", {"-nargs=1"}, [[<cmd>G checkout -b <q-args>]])

  -- Fugitive bindings
  map("n", "<localleader>gs", "<cmd>Git<CR>")
  -- Stages the current file
  map("n", "<localleader>gw", "<cmd>Gwrite<CR>")
  -- Revert current file to last checked in version
  map("n", "<localleader>gre", "<cmd>Gread<CR>")
  -- Remove the current file and the corresponding buffer
  map("n", "<localleader>grm", "<cmd>GRemove<CR>")
  -- See in a side window who is responsible for lines of code
  -- can also set the date=relative but this breaks rendering
  -- and shortcuts
  map("n", "<localleader>gbl", "<cmd>Git blame --date=short<CR>")
  -- Blame specific visual range
  map("v", "<localleader>gbl", ":Gblame --date=short<CR>")
  map("n", "<localleader>gd", "<cmd>Gdiffsplit<CR>")
  map("n", "<localleader>gdc", "<cmd>call fugitive#DiffClose()<CR>")
  map("n", "<localleader>gdt", "<cmd>G difftool<CR>")
  map("n", "<localleader>gda", "<cmd>G difftool -y<CR>")
  map("n", "<localleader>gc", "<cmd>Git commit<CR>")
  map("n", "<localleader>gcl", "<cmd>Gclog!<CR>")
  map("n", "<localleader>gcm", "<cmd>Gcm<CR>")
  map("n", "<localleader>gn", "<cmd>lua __fugitive_create_new_branch()<CR>")
  map("n", "<localleader>gm", "<cmd>Git mergetool<CR>")
  -- command is not silent as this obscures the preceding command
  -- also not the use of <c-z> the wildcharm character to trigger completion
  map("n", "<localleader>go", ":Git checkout<space><C-Z>")

  require("as.autocommands").create {
    vimrc_fugitive = {
      {
        "FileType",
        "gitcommit",
        "lua __fugitive_setup_commit_buffer()"
      }
    }
  }
end
