return function()
  local map = as_utils.map
  local has = as_utils.has

  local function is_ft(b, ft)
    return vim.bo[b].filetype == ft
  end

  require("bufferline").setup {
    options = {
      mappings = false,
      sort_by = "extension",
      show_close_icon = false,
      separator_style = "slant",
      diagnostics = not has("mac") and "nvim_lsp" or false,
      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,
      custom_filter = function(buf, buf_nums)
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
        local is_log = is_ft(buf, "log")
        -- only show log buffers in secondary tabs
        return (tab_num == 2 and is_log) or (tab_num ~= 2 and not is_log)
      end
    }
  }

  map("n", "gb", [[<cmd>BufferLinePick<CR>]])
  map("n", "<leader><tab>", [[<cmd>BufferLineCycleNext<CR>]])
  map("n", "<S-tab>", [[<cmd>BufferLineCyclePrev<CR>]])
  map("n", "[b", [[<cmd>BufferLineMoveNext<CR>]])
  map("n", "]b", [[<cmd>BufferLineMovePrev<CR>]])
end
