" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

lua << END
local plugins = {
  ["goyo.vim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/goyo.vim"
  },
  ["lazygit.nvim"] = {
    commands = { "LazyGit" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/lazygit.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim"
  },
  ["nvim-luapad"] = {
    commands = { "Luapad" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/nvim-luapad"
  },
  ["nvim-tree.lua"] = {
    commands = { "NvimTreeOpen" },
    config = { "\27LJ\2\n¢\a\0\0\5\0\"\0E6\0\0\0009\0\1\0005\1\3\0005\2\4\0=\2\5\1=\1\2\0006\0\0\0009\0\1\0005\1\b\0005\2\a\0=\2\t\1=\1\6\0006\0\n\0009\0\v\0'\2\f\0'\3\r\0'\4\14\0B\0\4\0016\0\0\0009\0\1\0)\1\1\0=\1\15\0006\0\0\0009\0\1\0)\1\1\0=\1\16\0006\0\0\0009\0\1\0)\1\0\0=\1\17\0006\0\0\0009\0\1\0)\1\1\0=\1\18\0006\0\0\0009\0\1\0)\1\30\0=\1\19\0006\0\0\0009\0\1\0)\1\1\0=\1\20\0006\0\0\0009\0\1\0'\1\22\0=\1\21\0006\0\0\0009\0\1\0005\1\24\0=\1\23\0006\0\0\0009\0\25\0'\2\26\0B\0\2\0016\0\0\0009\0\25\0'\2\27\0B\0\2\0016\0\28\0'\2\29\0B\0\2\0029\0\30\0005\2 \0004\3\3\0005\4\31\0>\4\1\3=\3!\2B\0\2\1K\0\1\0\22NvimTreeOverrides\1\0\0\1\4\0\0\16ColorScheme\6*Dhighlight NvimTreeRootFolder gui=bold,italic guifg=LightMagenta\vcreate\20as.autocommands\frequireDhighlight NvimTreeRootFolder gui=bold,italic guifg=LightMagenta0highlight link NvimTreeIndentMarker Comment\bcmd\1\4\0\0\14.DS_Store\14fugitive:\t.git\21nvim_tree_ignore\a:t#nvim_tree_root_folder_modifier!nvim_tree_width_allow_resize\20nvim_tree_width\21nvim_tree_follow\25nvim_tree_auto_close\21nvim_tree_git_hl\29nvim_tree_indent_markers\28<cmd>NvimTreeToggle<CR>\n<c-n>\6n\bmap\ras_utils\acd\1\0\0\1\2\0\0\acd\23nvim_tree_bindings\bgit\1\0\6\14untracked\bÔÑ®\runstaged\bÔëó\fdeleted\bÔëò\frenamed\bÔëö\runmerged\bÓúß\vstaged\bÔëô\1\0\1\fdefault\bÓòí\20nvim_tree_icons\6g\bvim\0" },
    keys = { { "", "<c-n>" } },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua"
  },
  ["packer.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  playground = {
    commands = { "TSPlaygroundToggle" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/playground"
  },
  ["startuptime.vim"] = {
    commands = { "StartupTime" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/startuptime.vim"
  },
  ["tagalong.vim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/tagalong.vim"
  },
  undotree = {
    commands = { "UndotreeToggle" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/undotree"
  },
  ["vim-fat-finger"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/vim-fat-finger"
  },
  ["vim-polyglot"] = {
    loaded = false,
    only_sequence = true,
    only_setup = true,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/vim-polyglot"
  },
  ["vim-sayonara"] = {
    commands = { "Sayonara" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/vim-sayonara"
  },
  ["vim-test"] = {
    commands = { "TestFile", "TestNearest", "TestSuite" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/vim-test"
  },
  ["vim-tmux-navigator"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/vim-tmux-navigator"
  },
  vimwiki = {
    keys = { { "", ",ww" }, { "", ",wt" }, { "", ",wi" } },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/akin/.local/share/nvim/site/pack/packer/opt/vimwiki"
  }
}

local function handle_bufread(names)
  for _, name in ipairs(names) do
    local path = plugins[name].path
    for _, dir in ipairs({ 'ftdetect', 'ftplugin', 'after/ftdetect', 'after/ftplugin' }) do
      if #vim.fn.finddir(dir, path) > 0 then
        vim.cmd('doautocmd BufRead')
        return
      end
    end
  end
end

_packer_load = nil

local function handle_after(name, before)
  local plugin = plugins[name]
  plugin.load_after[before] = nil
  if next(plugin.load_after) == nil then
    _packer_load({name}, {})
  end
end

_packer_load = function(names, cause)
  local some_unloaded = false
  for _, name in ipairs(names) do
    if not plugins[name].loaded then
      some_unloaded = true
      break
    end
  end

  if not some_unloaded then return end

  local fmt = string.format
  local del_cmds = {}
  local del_maps = {}
  for _, name in ipairs(names) do
    if plugins[name].commands then
      for _, cmd in ipairs(plugins[name].commands) do
        del_cmds[cmd] = true
      end
    end

    if plugins[name].keys then
      for _, key in ipairs(plugins[name].keys) do
        del_maps[key] = true
      end
    end
  end

  for cmd, _ in pairs(del_cmds) do
    vim.cmd('silent! delcommand ' .. cmd)
  end

  for key, _ in pairs(del_maps) do
    vim.cmd(fmt('silent! %sunmap %s', key[1], key[2]))
  end

  for _, name in ipairs(names) do
    if not plugins[name].loaded then
      vim.cmd('packadd ' .. name)
      if plugins[name].config then
        for _i, config_line in ipairs(plugins[name].config) do
          loadstring(config_line)()
        end
      end

      if plugins[name].after then
        for _, after_name in ipairs(plugins[name].after) do
          handle_after(after_name, name)
          vim.cmd('redraw')
        end
      end

      plugins[name].loaded = true
    end
  end

  handle_bufread(names)

  if cause.cmd then
    local lines = cause.l1 == cause.l2 and '' or (cause.l1 .. ',' .. cause.l2)
    vim.cmd(fmt('%s%s%s %s', lines, cause.cmd, cause.bang, cause.args))
  elseif cause.keys then
    local keys = cause.keys
    local extra = ''
    while true do
      local c = vim.fn.getchar(0)
      if c == 0 then break end
      extra = extra .. vim.fn.nr2char(c)
    end

    if cause.prefix then
      local prefix = vim.v.count and vim.v.count or ''
      prefix = prefix .. '"' .. vim.v.register .. cause.prefix
      if vim.fn.mode('full') == 'no' then
        if vim.v.operator == 'c' then
          prefix = '' .. prefix
        end

        prefix = prefix .. vim.v.operator
      end

      vim.fn.feedkeys(prefix, 'n')
    end

    -- NOTE: I'm not sure if the below substitution is correct; it might correspond to the literal
    -- characters \<Plug> rather than the special <Plug> key.
    vim.fn.feedkeys(string.gsub(string.gsub(cause.keys, '^<Plug>', '\\<Plug>') .. extra, '<[cC][rR]>', '\r'))
  elseif cause.event then
    vim.cmd(fmt('doautocmd <nomodeline> %s', cause.event))
  elseif cause.ft then
    vim.cmd(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeplugin', cause.ft))
    vim.cmd(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeindent', cause.ft))
  end
end

-- Runtimepath customization

-- Pre-load configuration
-- Setup for: vim-polyglot
loadstring("\27LJ\2\n@\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\2\0\0\rsensible\22polyglot_disabled\6g\bvim\0")()
vim.cmd("packadd vim-polyglot")
-- Post-load configuration
-- Config for: completion-nvim
loadstring("\27LJ\2\n•\n\0\0\5\0'\0S6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0004\3\3\0005\4\3\0>\4\1\3=\3\5\2B\0\2\0016\0\6\0009\0\a\0006\1\6\0009\1\a\0019\1\t\1'\2\n\0&\1\2\1=\1\b\0006\0\6\0009\0\a\0)\1\0\0=\1\v\0006\0\6\0009\0\a\0'\1\r\0=\1\f\0006\0\6\0009\0\a\0)\1\1\0=\1\14\0006\0\6\0009\0\a\0005\1\16\0=\1\15\0006\0\6\0009\0\a\0)\1\1\0=\1\17\0006\0\6\0009\0\a\0)\1-\0=\1\18\0006\0\6\0009\0\a\0'\1\20\0=\1\19\0006\0\6\0009\0\a\0005\1\22\0=\1\21\0006\0\6\0009\0\a\0)\1\1\0=\1\23\0006\0\6\0009\0\a\0005\1 \0004\2\5\0005\3\26\0005\4\25\0=\4\27\3>\3\1\0025\3\29\0005\4\28\0=\4\27\3>\3\2\0025\3\30\0>\3\3\0025\3\31\0>\3\4\2=\2!\0014\2\3\0005\3#\0005\4\"\0=\4\27\3>\3\1\2=\2$\1=\1\24\0006\0\6\0009\0\a\0005\1&\0=\1%\0K\0\1\0\1\0\27\rProperty\bÓò§\fKeyword\bÔáû\nField\bÔ¶æ\nColor\bÓà´\tUnit\bÔëµ\vModule\bÔêç\nEvent\bÔ´ç\15EnumMember\bÔÄ´\tFile\bÔú£\tEnum\bÔêµ\vFolder\bÔÑî\tText\bÓòí\18TypeParameter\bÔú®\14Interface\bÔêó\fDefault\bÔäú\nClass\bÔÉ®\fBuffers\bÔôç\vStruct\bÔ≠Ñ\fSnippet\bÔÉê\vMethod\bÔÇö\14vim-vsnip\bÔÉê\rConstant\bÔ£æ\14Reference\bÔ©Ü\rFunction\a∆í\rOperator\aŒ®\nValue\bÔ¢ü\rVariable\bÓûõ#completion_customize_lsp_label\vstring\1\0\0\1\5\0\0\tpath\blsp\ftabnine\fsnippet\fdefault\1\0\0\1\0\1\tmode\n<c-n>\1\0\1\tmode\n<c-p>\1\0\0\1\4\0\0\blsp\fsnippet\ftabnine\19complete_items\1\0\0\1\4\0\0\blsp\fsnippet\ftabnine#completion_chain_complete_list'completion_tabnine_sort_by_details\1\3\0\0\nexact\14substring&completion_matching_strategy_list\tnone\23completion_sorting\27completion_menu_length#completion_matching_smart_case\1\0\1\14vim-vsnip\3\0\30completion_items_priority!completion_enable_auto_paren\14vim-vsnip\30completion_enable_snippet\"completion_auto_change_source\23/snippets/textmate\fvim_dir\22vsnip_snippet_dir\6g\bvim\15Completion\1\0\0\1\4\0\0\rBufEnter\6*(lua require'completion'.on_attach()\vcreate\20as.autocommands\frequire\0")()
-- Config for: nvim-dap
loadstring("\27LJ\2\nø\t\0\0\b\0%\0M6\0\0\0009\0\1\0'\2\2\0B\0\2\0026\1\3\0009\1\4\0016\2\5\0'\4\6\0B\2\2\0029\3\a\0025\4\t\0005\5\v\0\18\6\0\0'\a\n\0&\6\a\6>\6\1\5=\5\f\4=\4\b\0039\3\r\0024\4\3\0005\5\14\0\18\6\0\0'\a\15\0&\6\a\6=\6\16\5\18\6\0\0'\a\17\0&\6\a\6=\6\18\5>\5\1\4=\4\b\3\18\3\1\0'\5\19\0'\6\20\0'\a\21\0B\3\4\1\18\3\1\0'\5\19\0'\6\22\0'\a\23\0B\3\4\1\18\3\1\0'\5\19\0'\6\24\0'\a\25\0B\3\4\1\18\3\1\0'\5\19\0'\6\26\0'\a\27\0B\3\4\1\18\3\1\0'\5\19\0'\6\28\0'\a\29\0B\3\4\1\18\3\1\0'\5\19\0'\6\30\0'\a\31\0B\3\4\1\18\3\1\0'\5\19\0'\6 \0'\a!\0B\3\4\1\18\3\1\0'\5\19\0'\6\"\0'\a#\0B\3\4\1\18\3\1\0'\5\19\0'\6 \0'\a$\0B\3\4\1K\0\1\0.<cmd>lua require'dap'.repl.run_last()<CR>*<cmd>lua require'dap'.repl.open()<CR>\20<localleader>dr\\<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>\20<localleader>dlU<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>\20<localleader>dB2<cmd>lua require'dap'.toggle_breakpoint()<CR>\20<localleader>db)<cmd>lua require'dap'.step_out()<CR>\20<localleader>de*<cmd>lua require'dap'.step_into()<CR>\20<localleader>di*<cmd>lua require'dap'.step_over()<CR>\20<localleader>do)<cmd>lua require'dap'.continue()<CR>\20<localleader>dc\6n\19flutterSdkPath\r/flutter\16dartSdkPath!/flutter/bin/cache/dart-sdk/\1\0\5\bcwd\23${workspaceFolder}\frequest\vlaunch\fprogram%${workspaceFolder}/lib/main.dart\tname\19Launch flutter\ttype\tdart\19configurations\targs\1\3\0\0\0\fflutter!/dart-code/out/dist/debug.js\1\0\2\ttype\15executable\fcommand\tnode\tdart\radapters\bdap\frequire\bmap\ras_utils\tHOME\vgetenv\aos\0")()
-- Config for: nvim-treesitter
loadstring("\27LJ\2\n.\0\1\2\1\1\0\a-\1\0\0008\1\0\0019\1\0\1\14\0\1\0X\2\1Ä\18\1\0\0L\1\2\0\3¿\rfiletype¢\6\1\0\v\0\"\0@6\0\0\0009\0\1\0009\0\2\0006\1\0\0009\1\3\1'\3\4\0B\1\2\0016\1\0\0009\1\3\1'\3\5\0B\1\2\0015\1\6\0\18\2\0\0'\4\a\0B\2\2\2)\3\0\0\1\3\2\0X\2\5Ä6\2\b\0009\2\t\2\18\4\1\0'\5\n\0B\2\3\0016\2\v\0'\4\f\0B\2\2\0029\2\r\0025\4\14\0005\5\15\0=\1\16\5=\5\17\0045\5\18\0005\6\19\0=\6\20\5=\5\21\0045\5\22\0005\6\23\0=\6\16\5=\5\24\4B\2\2\0016\2\v\0'\4\25\0B\2\2\0029\3\26\2B\3\1\0026\4\b\0009\4\27\0046\6\0\0009\6\28\0063\b\29\0009\t\30\2B\t\1\0A\6\1\2'\a\31\0B\4\3\0026\5\0\0009\5\3\5'\a \0\18\b\4\0'\t!\0&\a\t\aB\5\2\0012\0\0ÄK\0\1\0B setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()\23autocmd! Filetype \6,\22available_parsers\0\ftbl_map\vconcat\23get_parser_configs\28nvim-treesitter.parsers\frainbow\1\2\0\0\blua\1\0\1\venable\1\26incremental_selection\fkeymaps\1\0\4\19init_selection\f<enter>\22scope_incremental\bgrc\21node_incremental\f<enter>\21node_decremental\bgrm\1\0\1\venable\2\14highlight\fdisable\1\0\1\venable\2\1\0\1\21ensure_installed\15maintained\nsetup\28nvim-treesitter.configs\frequire\tdart\vinsert\ntable\bmac\1\2\0\0\tjson*highlight TSParameter gui=italic,bold'highlight link TSKeyword Statement\bcmd\bhas\afn\bvim\0")()
-- Config for: nvim-dap-virtual-text
loadstring("\27LJ\2\n2\0\0\2\0\3\0\0056\0\0\0009\0\1\0+\1\2\0=\1\2\0K\0\1\0\21dap_virtual_text\6g\bvim\0")()
-- Config for: vim-vsnip
loadstring("\27LJ\2\nŒ\3\0\0\a\0\18\0-6\0\0\0009\0\1\0\18\1\0\0'\3\2\0'\4\3\0'\5\4\0005\6\5\0B\1\5\1\18\1\0\0'\3\6\0'\4\3\0'\5\4\0005\6\a\0B\1\5\1\18\1\0\0'\3\2\0'\4\b\0'\5\t\0005\6\n\0B\1\5\1\18\1\0\0'\3\6\0'\4\b\0'\5\t\0005\6\v\0B\1\5\1\18\1\0\0'\3\f\0'\4\r\0'\5\14\0005\6\15\0B\1\5\1\18\1\0\0'\3\2\0'\4\r\0'\5\14\0005\6\16\0B\1\5\1\18\1\0\0'\3\6\0'\4\r\0'\5\14\0005\6\17\0B\1\5\1K\0\1\0\1\0\1\texpr\2\1\0\1\texpr\2\1\0\1\texpr\2Cvsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'\n<c-j>\6x\1\0\1\texpr\2\1\0\1\texpr\2<vsnip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<c-h>'\n<c-h>\1\0\1\texpr\2\6s\1\0\1\texpr\2<vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<c-l>'\n<c-l>\6i\bmap\ras_utils\0")()
-- Config for: vim-hexokinase
loadstring("\27LJ\2\nC\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\2\0\0\fvimwiki\26Hexokinase_ftDisabled\6g\bvim\0")()
-- Config for: gitsigns.nvim
loadstring("\27LJ\2\nÀ\1\0\1\t\0\t\0%9\1\0\0)\2\0\0\1\2\1\0X\1\5Ä'\1\1\0009\2\0\0&\1\2\1\14\0\1\0X\2\1Ä'\1\2\0009\2\3\0)\3\0\0\1\3\2\0X\2\5Ä'\2\4\0009\3\3\0&\2\3\2\14\0\2\0X\3\1Ä'\2\2\0009\3\5\0)\4\0\0\1\4\3\0X\3\5Ä'\3\6\0009\4\5\0&\3\4\3\14\0\3\0X\4\1Ä'\3\2\0009\4\a\0\18\5\1\0\18\6\2\0\18\a\3\0'\b\b\0&\4\b\4L\4\2\0\6 \thead\n Ôëò \fremoved\n Ôëô \fchanged\5\n Ôëó \nadded∆\6\1\0\5\0\24\0\0276\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\14\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\3=\3\15\0025\3\16\0005\4\17\0=\4\18\0035\4\19\0=\4\20\3=\3\21\0023\3\22\0=\3\23\2B\0\2\1K\0\1\0\21status_formatter\0\fkeymaps\tn ]h\1\2\1\0@&diff ? '[h' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'\texpr\2\tn [h\1\2\1\0@&diff ? ']h' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'\texpr\2\1\0\a\vbuffer\2\fnoremap\2\17n <leader>hb0<cmd>lua require\"gitsigns\".blame_line()<CR>\17n <leader>hp2<cmd>lua require\"gitsigns\".preview_hunk()<CR>\17n <leader>hr0<cmd>lua require\"gitsigns\".reset_hunk()<CR>\17n <leader>hu5<cmd>lua require\"gitsigns\".undo_stage_hunk()<CR>\17n <leader>hs0<cmd>lua require\"gitsigns\".stage_hunk()<CR>\nsigns\1\0\1\nnumhl\1\17changedelete\1\0\2\ahl\20GitGutterChange\ttext\b‚ñå\14topdelete\1\0\2\ahl\20GitGutterDelete\ttext\b‚ñå\vdelete\1\0\2\ahl\20GitGutterDelete\ttext\b‚ñå\vchange\1\0\2\ahl\20GitGutterChange\ttext\b‚ñå\badd\1\0\0\1\0\2\ahl\17GitGutterAdd\ttext\b‚ñå\nsetup\rgitsigns\frequire\0")()
-- Config for: nvim-lspconfig
require("as.lsp")
-- Config for: nvim-bufferline.lua
loadstring("\27LJ\2\nµ\3\0\0\5\0\19\0'6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\0016\0\6\0009\0\a\0'\2\b\0'\3\t\0'\4\n\0B\0\4\0016\0\6\0009\0\a\0'\2\b\0'\3\v\0'\4\f\0B\0\4\0016\0\6\0009\0\a\0'\2\b\0'\3\r\0'\4\14\0B\0\4\0016\0\6\0009\0\a\0'\2\b\0'\3\15\0'\4\16\0B\0\4\0016\0\6\0009\0\a\0'\2\b\0'\3\17\0'\4\18\0B\0\4\1K\0\1\0 <cmd>BufferLineMovePrev<CR>\a]b <cmd>BufferLineMoveNext<CR>\a[b!<cmd>BufferLineCyclePrev<CR>\f<S-tab>!<cmd>BufferLineCycleNext<CR>\19<leader><tab> \28<cmd>BufferLinePick<CR>\agb\6n\bmap\ras_utils\foptions\1\0\0\1\0\3\rmappings\2\20separator_style\nslant\fsort_by\14extension\nsetup\15bufferline\frequire\0")()
-- Conditional loads
if
  loadstring("\27LJ\2\n8\0\0\1\0\3\0\t6\0\0\0009\0\1\0009\0\2\0\v\0\0\0X\0\2Ä+\0\1\0X\1\1Ä+\0\2\0L\0\2\0\tTMUX\benv\bvim\0")()
then
	vim.cmd("packadd vim-tmux-navigator")
end

if
  loadstring("\27LJ\2\nC\0\0\3\0\4\1\v6\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\2\b\0\0\0X\0\2Ä+\0\1\0X\1\1Ä+\0\2\0L\0\2\0\bmac\bhas\afn\bvim\0\0")()
then
	vim.cmd("packadd playground")
end

-- Load plugins in order defined by `after`
END

function! s:load(names, cause) abort
call luaeval('_packer_load(_A[1], _A[2])', [a:names, a:cause])
endfunction


" Command lazy-loads
command! -nargs=* -range -bang -complete=file StartupTime call s:load(['startuptime.vim'], { "cmd": "StartupTime", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file TSPlaygroundToggle call s:load(['playground'], { "cmd": "TSPlaygroundToggle", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Luapad call s:load(['nvim-luapad'], { "cmd": "Luapad", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file UndotreeToggle call s:load(['undotree'], { "cmd": "UndotreeToggle", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file LazyGit call s:load(['lazygit.nvim'], { "cmd": "LazyGit", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Sayonara call s:load(['vim-sayonara'], { "cmd": "Sayonara", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file TestNearest call s:load(['vim-test'], { "cmd": "TestNearest", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file TestFile call s:load(['vim-test'], { "cmd": "TestFile", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file NvimTreeOpen call s:load(['nvim-tree.lua'], { "cmd": "NvimTreeOpen", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file TestSuite call s:load(['vim-test'], { "cmd": "TestSuite", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })

" Keymap lazy-loads
noremap <silent> <c-n> <cmd>call <SID>load(['nvim-tree.lua'], { "keys": "<c-n>", "prefix": "" })<cr>
noremap <silent> ,wi <cmd>call <SID>load(['vimwiki'], { "keys": ",wi", "prefix": "" })<cr>
noremap <silent> ,ww <cmd>call <SID>load(['vimwiki'], { "keys": ",ww", "prefix": "" })<cr>
noremap <silent> ,wt <cmd>call <SID>load(['vimwiki'], { "keys": ",wt", "prefix": "" })<cr>

augroup packer_load_aucmds
  au!
  " Filetype lazy-loads
  au FileType html ++once call s:load(['tagalong.vim'], { "ft": "html" })
  au FileType markdown ++once call s:load(['markdown-preview.nvim', 'goyo.vim'], { "ft": "markdown" })
  au FileType vimwiki ++once call s:load(['goyo.vim'], { "ft": "vimwiki" })
  au FileType typescriptreact ++once call s:load(['tagalong.vim'], { "ft": "typescriptreact" })
  au FileType javascriptreact ++once call s:load(['tagalong.vim'], { "ft": "javascriptreact" })
  " Event lazy-loads
  au CursorHoldI *  ++once call s:load(['vim-fat-finger'], { "event": "CursorHoldI * " })
  au BufEnter *.wiki ++once call s:load(['vimwiki'], { "event": "BufEnter *.wiki" })
augroup END
