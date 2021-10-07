return function()
  local wk = require 'which-key'
  wk.setup {
    plugins = {
      spelling = {
        enabled = true,
      },
    },
  }

  wk.register {
    [']'] = {
      name = '+next',
      ['<space>'] = 'add space below',
    },
    ['['] = {
      name = '+prev',
      ['<space>'] = 'add space above',
    },
    ['g>'] = 'show message history',
    ['<leader>'] = {
      d = {
        f = 'treesitter: peek function definition',
        F = 'treesitter: peek class definition',
      },
      n = {
        name = '+new',
        f = 'create a new file',
        s = 'create new file in a split',
      },
      E = 'show token under the cursor',
      p = {
        name = '+packer',
        c = 'clean',
        s = 'sync',
      },
      q = {
        name = '+quit',
        w = 'close window (and buffer)',
        q = 'delete buffer',
      },
      g = 'grep word under the cursor',
      l = {
        name = '+list',
        i = 'toggle location list',
        s = 'toggle quickfix',
      },
      e = {
        name = '+edit',
        v = 'open vimrc in a vertical split',
        p = 'open plugins file in a vertical split',
        z = 'open zshrc in a vertical split',
        t = 'open tmux config in a vertical split',
      },
      o = {
        name = '+only',
        n = 'close all other buffers',
      },
      t = {
        name = '+tab',
        c = 'tab close',
        n = 'tab edit current buffer',
      },
      sw = 'swap buffers horizontally',
      so = 'source current buffer',
      sv = 'source init.vim',
      U = 'uppercase all word',
      ['<CR>'] = 'repeat previous macro',
      [','] = 'go to previous buffer',
      ['='] = 'make windows equal size',
      [')'] = 'wrap with parens',
      ['}'] = 'wrap with braces',
      ['"'] = 'wrap with double quotes',
      ["'"] = 'wrap with single quotes',
      ['`'] = 'wrap with back ticks',
      ['['] = 'replace cursor word in file',
      [']'] = 'replace cursor word in line',
    },
    ['<localleader>'] = {
      name = 'local leader',
      w = {
        name = '+window',
        h = 'change two vertically split windows to horizontal splits',
        v = 'change two horizontally split windows to vertical splits',
        x = 'swap current window with the next',
        j = 'resize: downwards',
        k = 'resize: upwards',
      },
      l = 'redraw window',
      z = 'center view port',
      [','] = 'add comma to end of line',
      [';'] = 'add semicolon to end of line',
      ['?'] = 'search for word under cursor in google',
      ['!'] = 'search for word under cursor in google',
      ['['] = 'abolish = subsitute cursor word in file',
      [']'] = 'abolish = substitute cursor word on line',
      ['/'] = 'find matching word in buffer',
      ['<space>'] = 'Toggle current fold',
      ['<tab>'] = 'open commandline bufferlist',
    },
  }
end
