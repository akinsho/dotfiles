-----------------------------------------------------------------------------//
-- Fold Text
-----------------------------------------------------------------------------//
local fn = vim.fn
local api = vim.api

-- List of file types to use default fold text for
local fold_exclusions = { 'vim', 'norg' }

---@param str string
---@param pattern string
---@return boolean
local function contains(str, pattern)
  assert(str and pattern)
  return fn.match(str, pattern) >= 0
end

---format the fold text e.g. replace tabs with spaces
---@param value string
---@return string
local function format_section(value)
  -- 1. Replace tabs
  local str = fn.substitute(value, '\t', string.rep(' ', vim.bo.tabstop), 'g')
  -- 2. getline returns the line leading white space so we remove it
  -- CREDIT: https://stackoverflow.com/questions/5992336/indenting-fold-text
  return fn.substitute(str, [[^\s*]], '', 'g')
end

local function is_ignored()
  if vim.wo.diff then
    return vim.wo.diff
  end
  return vim.tbl_contains(fold_exclusions, vim.bo.filetype)
end

---@param item string
---@return boolean
local function is_import(item)
  return contains(item, '^import')
end

--[[
  Naive regex to match closing delimiters (undoubtedly there are edge cases)
  if the fold text doesn't include delimiter characters just append an
  empty string. This avoids folds that look like function … end or
  import 'package'…import 'second-package'
  this fold text should handle cases like

  value.Member{
    Field : String
  }.Method()
  turns into

  value.Member{…}.Method()
--]]
local function contains_delimiter(value)
  return contains(value, [[}\|)\|]\|`\|>\|<]])
end

--[[
  We initially check if the fold start text is an import by looking for the
  'import' keyword at the Start of a line. If it is we replace the line with
  import … although if the fold end text contains a delimiter
  e.g.
  import {
    thing
  } from 'apple'
  '}' being a delimiter we instead allow normal folding to happen
  i.e.
  import {…} from 'apple'
--]]
local function get_fold_start(start_text, end_text, foldsymbol)
  if is_import(start_text) and not contains_delimiter(end_text) then
    --- This regex matches anything after an import followed by a space
    --- this might not hold true for all languages but think it does
    --- for all the ones I use
    return fn.substitute(start_text, [[^import .\+]], 'import ' .. foldsymbol, '')
  end
  return format_section(start_text) .. foldsymbol
end

local function get_fold_end(item)
  if not contains_delimiter(item) or is_import(item) then
    return ''
  end
  return format_section(item)
end

function as.folds()
  if is_ignored() then
    return fn.foldtext()
  end
  local end_text = fn.getline(vim.v.foldend)
  local start_text = fn.getline(vim.v.foldstart)
  local line_end = get_fold_end(end_text)
  local line_start = get_fold_start(start_text, end_text, '…')
  local line = line_start .. line_end
  local lines_count = vim.v.foldend - vim.v.foldstart + 1
  local count_text = '(' .. lines_count .. ' lines)'
  local indentation = fn.indent(vim.v.foldstart)
  local fold_start = string.rep(' ', indentation) .. line
  local fold_end = count_text .. string.rep(' ', 2)
  --NOTE: foldcolumn can now be set to a value of auto:Count e.g auto:5
  --so we split off the auto portion so we can still get the line count
  local parts = vim.split(vim.wo.foldcolumn, ':')
  local column_size = parts[#parts]
  local text_length = #fn.substitute(fold_start .. fold_end, '.', 'x', 'g') + column_size
  return fold_start .. string.rep(' ', api.nvim_win_get_width(0) - text_length - 7) .. fold_end
end

-- CREDIT: https://coderwall.com/p/usd_cw/a-pretty-vim-foldtext-function
