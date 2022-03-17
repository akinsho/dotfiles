return function()
  local fn = vim.fn

  local ls = require 'luasnip'
  local extras = require 'luasnip.extras'
  local types = require 'luasnip.util.types'
  local fmt = require('luasnip.extras.fmt').fmt

  local f = ls.function_node
  local c = ls.choice_node
  local l = extras.lambda
  local snippet = ls.snippet
  local text = ls.text_node
  local match = extras.match
  local insert = ls.insert_node

  ls.config.set_config {
    history = false,
    -- if you have dynamic snippets, it updates as you type
    updateevents = 'TextChangedI',
    region_check_events = 'CursorMoved,CursorHold,InsertEnter',
    delete_check_events = 'InsertLeave',
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { '●', 'Operator' } },
        },
      },
      [types.insertNode] = {
        active = {
          virt_text = { { '●', 'Type' } },
        },
      },
    },
    enable_autosnippets = true,
  }

  -- <c-l> is selecting within a list of options.
  vim.keymap.set('i', '<c-l>', function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end)

  vim.keymap.set({ 's', 'i' }, '<c-j>', function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end)

  vim.keymap.set({ 's', 'i' }, '<c-k>', function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end)

  ls.snippets = {
    all = {
      snippet({ trig = 'td', name = 'TODO' }, {
        c(1, {
          text 'TODO: ',
          text 'FIXME: ',
          text 'HACK: ',
          text 'BUG: ',
        }),
        insert(0),
      }),
      snippet(
        { trig = 'hr', name = 'Header' },
        fmt(
          [[
            {1}
            {2} {3}
            {1}
            {4}
          ]],
          {
            f(function()
              local comment = string.format(vim.bo.commentstring:gsub(' ', '') or '#%s', '-')
              local col = vim.bo.textwidth or 80
              return comment .. string.rep('-', col - #comment)
            end),
            f(function()
              return vim.bo.commentstring:gsub('%%s', '')
            end),
            insert(1, 'HEADER'),
            insert(0),
          }
        )
      ),
    },
    lua = {
      snippet(
        {
          trig = 'req',
          name = 'require module',
          dscr = 'Require a module and set the import to the last word',
        },
        fmt([[local {} = require("{}")]], {
          f(function(import_name)
            local parts = vim.split(import_name[1][1], '.', true)
            return parts[#parts] or ''
          end, { 1 }),
          insert(1),
        })
      ),
      snippet(
        {
          trig = 'use',
          name = 'packer use',
          dscr = {
            'packer use plugin block',
            'e.g.',
            "use {'author/plugin'}",
          },
        },
        fmt(
          [[
          use {{"{}", config = function()
            {}
          end}}
          ]],
          {
            f(function()
              -- Get the author and URL in the clipboard and auto populate the author and project
              local default = 'author/plugin'
              local clip = fn.getreg '*'
              if not vim.startswith(clip, 'https://github.com/') then
                return default
              end
              local parts = vim.split(clip, '/')
              if #parts < 2 then
                return default
              end
              local author, project = parts[#parts - 1], parts[#parts]
              return author .. '/' .. project
            end),
            insert(0),
          }
        )
      ),
    },
    dart = {
      snippet(
        {
          trig = 'pr',
          name = 'print',
          dscr = 'print a variable optionally wrapping it with braces',
        },
        fmt([[print('{}: ${}')]], {
          insert(1, { 'label' }),
          match(1, '%.', '{' .. l._1 .. '}', l._1),
        })
      ),
    },
  }

  -- NOTE: load external snippets last so they are not overruled by ls.snippets
  require('luasnip.loaders.from_vscode').lazy_load { paths = './snippets/textmate' }
end
