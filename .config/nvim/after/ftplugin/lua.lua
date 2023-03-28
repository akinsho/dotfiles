if not as then return end

local fn, opt = vim.fn, vim.opt_local
local fmt = string.format

opt.textwidth = 120
opt.formatoptions:remove('o')

local function find(word, ...)
  for _, str in ipairs({ ... }) do
    local match_start, match_end = string.find(word, str)
    if match_start then return str, match_start, match_end end
  end
end

local function open_help(tag) as.pcall(vim.cmd.help, tag) end

--- Stolen from nlua.nvim this function attempts to open
--- vim help docs if an api or vim.fn function otherwise it
--- shows the lsp hover doc
--- @param word string
--- @param callback function
local function keyword(word, callback)
  local original_iskeyword = vim.bo.iskeyword

  vim.bo.iskeyword = vim.bo.iskeyword .. ',.'
  word = word or fn.expand('<cword>')

  vim.bo.iskeyword = original_iskeyword

  local match, _, end_idx = find(word, 'api.', 'vim.api.')
  if match and end_idx then return open_help(word:sub(end_idx + 1)) end

  match, _, end_idx = find(word, 'fn.', 'vim.fn.')
  if match and end_idx then return open_help(word:sub(end_idx + 1) .. '()') end

  match, _, end_idx = find(word, '^vim.(%w+)')
  if match and end_idx then return open_help(word:sub(1, end_idx)) end

  if callback then return callback() end

  vim.lsp.buf.hover()
end

map('n', 'gK', keyword, { buffer = 0 })
map('n', '<leader>so', function()
  vim.cmd.luafile('%')
  vim.notify('Sourced ' .. fn.expand('%'))
end)

as.ftplugin_conf({
  ['nvim-surround'] = function(surround)
    local get_input = function(prompt)
      local ok, input = pcall(vim.fn.input, fmt('%s: ', prompt))
      if not ok then return end
      return input
    end
    surround.buffer_setup({
      surrounds = {
        s = {
          add = { "['", "']" },
        },
        l = { add = { 'function () ', ' end' } },
        F = {
          add = function()
            return {
              { fmt('local function %s() ', get_input('Enter a function name')) },
              { ' end' },
            }
          end,
        },
        i = {
          add = function()
            return {
              { fmt('if %s then ', get_input('Enter a condition')) },
              { ' end' },
            }
          end,
        },
        t = {
          add = function()
            return {
              { fmt('{ %s = { ', get_input('Enter a field name')) },
              { ' }}' },
            }
          end,
        },
      },
    })
  end,
})
