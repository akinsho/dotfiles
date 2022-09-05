-- no distractions in markdown files
vim.opt_local.number = false
vim.opt_local.relativenumber = false

local args = { buffer = 0 }

if not as then return end
as.onoremap('ih', [[:<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>]], args)
as.onoremap('ah', [[:<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rg_vk0"<cr>]], args)
as.onoremap('aa', [[:<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rg_vk0"<cr>]], args)
as.onoremap('ia', [[:<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rkvg_"<cr>]], args)

if as.plugin_loaded('markdown-preview.nvim') then
  as.nmap('<localleader>p', '<Plug>MarkdownPreviewToggle', args)
end

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
