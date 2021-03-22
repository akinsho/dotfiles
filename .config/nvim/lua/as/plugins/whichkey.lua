return function()
  vim.g.which_leader_key_map = {
    name = "leader",
    ["0"] = "which_key_ignore",
    ["1"] = "which_key_ignore",
    ["2"] = "which_key_ignore",
    ["3"] = "which_key_ignore",
    ["4"] = "which_key_ignore",
    ["5"] = "which_key_ignore",
    ["6"] = "which_key_ignore",
    ["7"] = "which_key_ignore",
    ["8"] = "which_key_ignore",
    ["9"] = "which_key_ignore",
    A = "projectionist: edit alternate",
    av = "projectionist: vsplit alternate",
    at = "projectionist: vsplit test",
    h = {
      name = "+git-hunk",
      s = "stage",
      u = "undo"
    },
    n = {
      name = "+new",
      f = "create a new file",
      s = "create new file in a split"
    },
    E = "show token under the cursor",
    p = {
      name = "+vim-plug",
      u = "update",
      c = "clean",
      s = "status",
      i = "install"
    },
    q = {
      name = "+quit",
      w = "sayonara: close window (and buffer)",
      q = "sayonara: delete buffer"
    },
    f = {
      name = "+telescope",
      b = "branches",
      c = "commits",
      f = "files",
      ["?"] = "help",
      d = "dotfiles",
      o = "buffers",
      h = "history",
      r = "module reloader",
      s = "rg",
      w = "rg: <cursor word>"
    },
    g = "grep word under the cursor",
    l = {
      name = "+list",
      i = "toggle location list",
      s = "toggle quickfix"
    },
    e = {
      name = "+edit",
      v = "open vimrc in a new buffer",
      z = "open zshrc in a new buffer",
      t = "open tmux config in a new buffer"
    },
    o = {
      name = "+only",
      n = "close all other buffers"
    },
    t = {
      name = "+tab",
      c = "tab close",
      n = "tab edit current buffer"
    },
    u = "toggle undo tree",
    [",s"] = "subversive: range",
    s = "subversive: current word",
    ss = "subversive: entire line",
    S = "subversive: till end of line",
    v = "vista: toggle",
    w = {
      name = "+wiki",
      [","] = {
        name = "+diary",
        i = "generate diary links",
        m = "edit tomorrow's diary entry",
        t = "edit diary entry (tab)",
        y = "edit yesterday's diary entry",
        w = "edit today's diary entry"
      },
      q = "close all wikis",
      w = "open vimwiki index",
      s = "vimwiki UI select",
      t = "open vimwiki index in a tab",
      i = "open vimwiki diary"
    },
    z = {
      name = "+zoom/zen",
      t = "zoom in current buffer",
      g = "goyo: toggle"
    },
    sw = "swap buffers horizontally",
    so = "source current buffer",
    sv = "source init.vim",
    U = "uppercase all word",
    ["<CR>"] = "repeat previous macro",
    [","] = "go to previous buffer",
    ["="] = "make windows equal size",
    [")"] = "wrap with parens",
    ["}"] = "wrap with braces",
    ['"'] = "wrap with double quotes",
    ["'"] = "wrap with single quotes",
    ["`"] = "wrap with back ticks",
    ["["] = "replace cursor word in file",
    ["]"] = "replace cursor word in line",
    ["<Tab>"] = {"bnext", "Go to next buffer"}
  }

  vim.g.which_localleader_key_map = {
    name = "local leader",
    d = {
      name = "+debugger",
      ["?"] = "hover: variables scopes",
      b = "toggle breakpoint",
      B = "set breakpoint",
      c = "continue or start debugging",
      e = "step out",
      i = "step into",
      o = "step over",
      l = "REPL: run last",
      r = "REPL: open",
      t = {
        name = "+treesitter",
        e = "treesitter: enable highlight (buffer)",
        d = "treesitter: disable highlight (buffer)",
        p = "treesitter: toggle playground"
      }
    },
    g = {
      name = "+git-commands",
      b = {
        name = "+git-information",
        o = "coc: git open in browser",
        l = "git blame"
      },
      c = "git commit",
      cm = "checkout master",
      cl = "commit log",
      d = "git diff (split)",
      dt = "git difftool (against HEAD)",
      da = "git difftool -y (against HEAD)",
      dc = "git diff close all",
      l = "git pull (non-async)",
      o = "git checkout <branchname>",
      v = "coc: view commit",
      m = "git list merge conflicts",
      n = "git checkout new branch",
      r = {
        name = "+git-remove",
        e = "git read (remove changes)",
        m = "git remove"
      },
      s = "git status",
      S = "fzf: git status",
      u = "coc: copy git url",
      p = "git push (async)",
      pf = "git push --force (async)",
      pt = "git push (terminal)",
      ["*"] = "git grep current word"
    },
    w = {
      name = "+window",
      h = "change two vertically split windows to horizontal splits",
      v = "change two horizontally split windows to vertical splits",
      x = "swap current window with the next",
      j = "resize: downwards",
      k = "resize: upwards"
    },
    l = "redraw window",
    z = "center view port",
    t = {
      name = "+vim-test",
      n = "test nearest",
      f = "test file",
      s = "test suite"
    },
    s = {
      name = "+sideways",
      i = "insert argument before",
      a = "insert argument after",
      I = "insert argument first",
      A = "insert argument last"
    },
    [","] = "add comma to end of line",
    [";"] = "add semicolon to end of line",
    ["?"] = "search for word under cursor in google",
    ["!"] = "search for word under cursor in google",
    ["<Tab>"] = {"bnext", "open vim bufferlist"},
    ["["] = "abolish = subsitute cursor word in file",
    ["]"] = "abolish = substitute cursor word on line",
    ["/"] = "find matching word in buffer",
    ["<space>"] = "Toggle current fold"
  }

  vim.g.which_key_centered = 0
  vim.g.which_key_use_floating_win = 0
  vim.g.which_key_disable_default_offset = 1
  vim.g.which_key_display_names = {[" "] = "Space", ["<CR>"] = "↵", ["<TAB>"] = "⇆"}

  if vim.g.which_key_use_floating_win == 0 then
    require("as.autocommands").augroup(
      "which_key",
      {
        {
          events = {"FileType"},
          targets = {"which_key"},
          command = [[setlocal laststatus=0 | autocmd BufLeave <buffer> set laststatus=2]]
        }
      }
    )
  end

  vim.fn["which_key#register"](",", "g:which_leader_key_map")
  vim.fn["which_key#register"]("<Space>", "g:which_localleader_key_map")
  as_utils.map("n", "<localleader>", [[<cmd>WhichKey '<Space>'<CR>]])
  as_utils.map("n", "<leader>", [[<cmd>WhichKey  ','<CR>]])
end
