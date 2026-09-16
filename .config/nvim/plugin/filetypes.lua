if not as then return end
local settings = as.filetype_settings
local cmd = vim.cmd

settings({
  checkhealth = {
    opt = { spell = false },
  },
  ['dap-repl'] = {
    opt = {
      buflisted = false,
      winfixheight = true,
      signcolumn = 'yes:2',
    },
    function() as.adjust_split_height(12, math.floor(vim.o.lines * 0.3)) end,
  },
  fzf = {
    function(args)
      -- remove the default terminal mappings
      vim.keymap.del('t', '<esc>', { buffer = args.buf })
      -- TODO: figure out if  this is still needed then
      -- vim.keymap.del('t', 'jk', { buffer = args.buf })
    end,
  },
  [{ 'gitcommit', 'gitrebase' }] = {
    bo = { bufhidden = 'delete' },
    opt = {
      list = false,
      spell = true,
      spelllang = 'en_gb',
    },
  },
  go = {
    bo = {
      expandtab = false,
      softtabstop = 0,
      tabstop = 4,
      shiftwidth = 4,
      textwidth = 120,
    },
    opt = { spell = true },
    mappings = {
      { 'n', '<leader>gb', '<Cmd>GoBuild<CR>', desc = 'build' },
      { 'n', '<leader>gfs', '<Cmd>GoFillStruct<CR>', desc = 'fill struct' },
      { 'n', '<leader>gfp', '<Cmd>GoFixPlurals<CR>', desc = 'fix plurals' },
      { 'n', '<leader>gie', '<Cmd>GoIfErr<CR>', desc = 'if err' },
    },
  },
  [{ 'javascript', 'javascriptreact' }] = {
    bo = { textwidth = 100 },
    opt = { spell = true },
  },
  startuptime = {
    function() cmd.wincmd('H') end, -- open startup time to the left
  },
  [{ 'typescript', 'typescriptreact' }] = {
    bo = { textwidth = 100 },
    opt = { spell = true },
  },
  [{ 'lua', 'python', 'rust' }] = { opt = { spell = true } },
})
