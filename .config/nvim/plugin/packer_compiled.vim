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
    keys = { { "", ",ww" }, { "", ",wi" } },
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
-- Conditional loads
if
  loadstring("\27LJ\2\n8\0\0\1\0\3\0\t6\0\0\0009\0\1\0009\0\2\0\v\0\0\0X\0\2€+\0\1\0X\1\1€+\0\2\0L\0\2\0\tTMUX\benv\bvim\0")()
then
	vim.cmd("packadd vim-tmux-navigator")
end

-- Load plugins in order defined by `after`
END

function! s:load(names, cause) abort
call luaeval('_packer_load(_A[1], _A[2])', [a:names, a:cause])
endfunction


" Command lazy-loads
command! -nargs=* -range -bang -complete=file UndotreeToggle call s:load(['undotree'], { "cmd": "UndotreeToggle", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Sayonara call s:load(['vim-sayonara'], { "cmd": "Sayonara", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file TestFile call s:load(['vim-test'], { "cmd": "TestFile", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file TestNearest call s:load(['vim-test'], { "cmd": "TestNearest", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file TestSuite call s:load(['vim-test'], { "cmd": "TestSuite", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file StartupTime call s:load(['startuptime.vim'], { "cmd": "StartupTime", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file TSPlaygroundToggle call s:load(['playground'], { "cmd": "TSPlaygroundToggle", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file LazyGit call s:load(['lazygit.nvim'], { "cmd": "LazyGit", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Luapad call s:load(['nvim-luapad'], { "cmd": "Luapad", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })

" Keymap lazy-loads
noremap <silent> ,ww <cmd>call <SID>load(['vimwiki'], { "keys": ",ww", "prefix": "" })<cr>
noremap <silent> ,wi <cmd>call <SID>load(['vimwiki'], { "keys": ",wi", "prefix": "" })<cr>

augroup packer_load_aucmds
  au!
  " Filetype lazy-loads
  au FileType markdown ++once call s:load(['goyo.vim', 'markdown-preview.nvim'], { "ft": "markdown" })
  au FileType vimwiki ++once call s:load(['goyo.vim'], { "ft": "vimwiki" })
  au FileType html ++once call s:load(['tagalong.vim'], { "ft": "html" })
  au FileType typescriptreact ++once call s:load(['tagalong.vim'], { "ft": "typescriptreact" })
  au FileType javascriptreact ++once call s:load(['tagalong.vim'], { "ft": "javascriptreact" })
  " Event lazy-loads
  au BufEnter *.wiki ++once call s:load(['vimwiki'], { "event": "BufEnter *.wiki" })
  au CursorHoldI *  ++once call s:load(['vim-fat-finger'], { "event": "CursorHoldI * " })
augroup END
