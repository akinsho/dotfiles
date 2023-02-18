-- no distractions in markdown files
vim.opt_local.number = false
vim.opt_local.relativenumber = false

local args = { buffer = 0 }

if not as then return end
map('o', 'ih', [[:<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>]], args)
map('o', 'ah', [[:<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rg_vk0"<cr>]], args)
map('o', 'aa', [[:<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rg_vk0"<cr>]], args)
map('o', 'ia', [[:<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rkvg_"<cr>]], args)

as.nmap('<localleader>p', '<Plug>MarkdownPreviewToggle', args)

as.ftplugin_conf(
  'cmp',
  function(cmp)
    cmp.setup.filetype('markdown', {
      sources = cmp.config.sources({
        { name = 'dictionary' },
        { name = 'spell' },
        { name = 'emoji' },
      }, {
        { name = 'buffer' },
      }),
    })
  end
)

as.ftplugin_conf('nvim-surround', function(surround)
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
end)
