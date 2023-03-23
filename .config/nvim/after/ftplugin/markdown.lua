if not as then return end
local fn, env = vim.fn, vim.env

local args = { buffer = 0, silent = true }
map('o', 'ih', [[:<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>]], args)
map('o', 'ah', [[:<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rg_vk0"<cr>]], args)
map('o', 'aa', [[:<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rg_vk0"<cr>]], args)
map('o', 'ia', [[:<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rkvg_"<cr>]], args)

map('n', '<localleader>p', '<Plug>MarkdownPreviewToggle', args)

vim.b.formatting_disabled = not vim.startswith(fn.expand('%'), env.PROJECTS_DIR .. '/personal')

as.ftplugin_conf({
  cmp = function(cmp)
    cmp.setup.filetype('markdown', {
      sources = cmp.config.sources({
        { name = 'dictionary' },
        { name = 'spell' },
        { name = 'emoji' },
      }, {
        { name = 'buffer' },
      }),
    })
  end,
  ['nvim-surround'] = function(surround)
    surround.buffer_setup({
      surrounds = {
        l = {
          add = function()
            return {
              { '[' },
              { '](' .. vim.fn.getreg('*') .. ')' },
            }
          end,
        },
      },
    })
  end,
})
