---@diagnostic disable: undefined-global
local fn = vim.fn

return {
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
      i(1),
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
    fmt([[use {{"{}"{}}}]], {
      d(1, function()
        -- Get the author and URL in the clipboard and auto populate the author and project
        local default = snippet('', { i(1, 'author'), t '/', i(2, 'plugin') })
        local clip = fn.getreg '*'
        if not vim.startswith(clip, 'https://github.com/') then
          return default
        end
        local parts = vim.split(clip, '/')
        if #parts < 2 then
          return default
        end
        local author, project = parts[#parts - 1], parts[#parts]
        return snippet('', { t(author .. '/' .. project) })
      end),
      c(2, {
        fmt(
          [[
              , config = function()
                require("{}").setup()
              end
          ]],
          { i(1, 'module') }
        ),
        t '',
      }),
    })
  ),
}
