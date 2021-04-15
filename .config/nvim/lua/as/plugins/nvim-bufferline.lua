return function()
  local nnoremap = as.nnoremap

  local function is_ft(b, ft)
    return vim.bo[b].filetype == ft
  end

  local function diagnostics_indicator(_, _, diagnostics)
    local result = {}
    local symbols = {error = " ", warning = " ", info = ""}
    for name, count in pairs(diagnostics) do
      if symbols[name] and count > 0 then
        table.insert(result, symbols[name] .. count)
      end
    end
    result = table.concat(result, " ")
    return #result > 0 and " " .. result or ""
  end

  local function custom_filter(buf, buf_nums)
    local logs =
      vim.tbl_filter(
      function(b)
        return is_ft(b, "log")
      end,
      buf_nums
    )
    if vim.tbl_isempty(logs) then
      return true
    end
    local tab_num = vim.fn.tabpagenr()
    local last_tab = vim.fn.tabpagenr("$")
    local is_log = is_ft(buf, "log")
    if last_tab == 1 then
      return true
    end
    -- only show log buffers in secondary tabs
    return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
  end

  require("bufferline").setup {
    options = {
      mappings = false,
      sort_by = "extension",
      show_close_icon = false,
      separator_style = "slant",
      diagnostics = "nvim_lsp",
      diagnostics_indicator = diagnostics_indicator,
      custom_filter = custom_filter
    }
  }

  nnoremap("gb", [[<cmd>BufferLinePick<CR>]])
  nnoremap("<leader><tab>", [[<cmd>BufferLineCycleNext<CR>]])
  nnoremap("<S-tab>", [[<cmd>BufferLineCyclePrev<CR>]])
  nnoremap("[b", [[<cmd>BufferLineMoveNext<CR>]])
  nnoremap("]b", [[<cmd>BufferLineMovePrev<CR>]])
end
