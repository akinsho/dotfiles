return function()
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
      custom_filter = custom_filter,
      panels = {
        {filetype = "NvimTree", text = "File Explorer", highlight = "Directory"},
        {filetype = "flutterToolsOutline", text = "Flutter Outline", highlight = "Directory"}
      }
    }
  }

  require("which-key").register(
    {
      ["gb"] = {"<cmd>BufferLinePick<CR>", "bufferline: pick buffer"},
      ["<leader><tab>"] = {"<cmd>BufferLineCycleNext<CR>", "bufferline: next"},
      ["<S-tab>"] = {"<cmd>BufferLineCyclePrev<CR>", "bufferline: prev"},
      ["[b"] = {"<cmd>BufferLineMoveNext<CR>", "bufferline: move next"},
      ["]b"] = {"<cmd>BufferLineMovePrev<CR>", "bufferline: move prev"}
    }
  )
end
