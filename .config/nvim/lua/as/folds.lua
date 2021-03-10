-----------------------------------------------------------------------------//
-- Fold Text
-----------------------------------------------------------------------------//
-- Previous profile:
-- using profile func utils#fold_text
-- viml
--0.022417s i.e. 22ms
-----------------------------------------------------------------------------//
local fn = vim.fn
local api = vim.api

-- List of file types to use default fold text for
local fold_exclusions = {"vim"}

local function replace_tabs(value)
  return fn.substitute(value, "\t", string.rep(" ", vim.bo.tabstop), "g")
end

--[[
  CREDIT:
  getline returns the line leading whitespace so we remove it
  https://stackoverflow.com/questions/5992336/indenting-fold-text
--]]
local function strip_whitespace(value)
  return fn.substitute(value, [[^\s*]], "", "g")
end

local function prepare_fold_section(value)
  return strip_whitespace(replace_tabs(value))
end

local function is_ignored()
  if vim.wo.diff then
    return vim.wo.diff
  end
  for _, exclusion in ipairs(fold_exclusions) do
    if exclusion == vim.bo.filetype then
      return true
    end
  end
end

local function is_import(item)
  return #fn.matchstr(item, "^import") > 0
end

--- This regex matches anything after an import followed by a space
--- this might not hold true for all languages but think it does
--- for all the ones I use
local function transform_import(item, foldsymbol)
  return fn.substitute(item, [[^import .\+]], "import " .. foldsymbol, "")
end

--[[
  Naive regex to match closing delimiters (undoubtedly there are edge cases)
  if the fold text doesn't include delimiter characters just append an
  empty string. This avoids folds that look like func…end or
  import 'pkg'…import 'second-pkg'
  this fold text should handle cases like

  value.Member{
    Field : String
  }.Method()
  turns into

  value.Member{…}.Method()
--]]
local function contains_delimiter(value)
  return #fn.matchstr(value, [[}\|)\|]\|`\|>\]], "g") > 0
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
local function handle_fold_start(start_text, end_text, foldsymbol)
  if is_import(start_text) and not contains_delimiter(end_text) then
    return transform_import(start_text, foldsymbol)
  end
  return prepare_fold_section(start_text) .. foldsymbol
end

local function handle_fold_end(item)
  if not contains_delimiter(item) or is_import(item) then
    return ""
  end
  return prepare_fold_section(item)
end

--[[
  CREDIT:
  1. https://coderwall.com/p/usd_cw/a-pretty-vim-foldtext-function
--]]
function _G.folds()
  if is_ignored() then
    return fn.foldtext()
  end
  local end_text = fn.getline(vim.v.foldend)
  local start_text = fn.getline(vim.v.foldstart)
  local line_end = handle_fold_end(end_text)
  local line_start = handle_fold_start(start_text, end_text, "…")
  local line = line_start .. line_end
  local lines_count = vim.v.foldend - vim.v.foldstart + 1
  local count_text = "(" .. lines_count .. " lines)"
  local indentation = fn.indent(vim.v.foldstart)
  local fold_start = string.rep(" ", indentation) .. line
  local fold_end = count_text .. string.rep(" ", 2)
  --NOTE: foldcolumn can now be set to a value of auto:Count e.g auto:5
  --so we split off the auto portion so we can still get the line count
  local parts = vim.split(vim.wo.foldcolumn, ":")
  local column_size = parts[#parts]
  local text_length = #fn.substitute(fold_start .. fold_end, ".", "x", "g") + column_size
  return fold_start .. string.rep(" ", api.nvim_win_get_width(0) - text_length - 7) .. fold_end
end
