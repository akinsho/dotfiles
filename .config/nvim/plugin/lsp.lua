-- TODO: Convert to use vim.diagnostic when 0.6 is stable
-- [ ] use DiagnosticSign* and remove LspDiagnosticSign*
-- [ ] use vim.diagnostic.config not handler overwrite

local lsp = vim.lsp
local fn = vim.fn

if vim.env.DEVELOPING then
  vim.lsp.set_log_level(vim.lsp.log_levels.DEBUG)
end

-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
local command = as.command

command {
  'LspLog',
  function()
    local path = vim.lsp.get_log_path()
    vim.cmd('edit ' .. path)
  end,
}

command {
  'Format',
  function()
    vim.lsp.buf.formatting_sync(nil, 1000)
  end,
}

if not as.nightly then
  -- Capture real implementation of function that sets signs
  local orig_set_signs = vim.lsp.diagnostic.set_signs
  local diagnostic_cache = {}

  ---Override diagnostics signs helper to only show the single most relevant sign
  ---@see: http://reddit.com/r/neovim/comments/mvhfw7/can_built_in_lsp_diagnostics_be_limited_to_show_a
  ---@param diagnostics table
  ---@param bufnr number
  ---@param client_id number
  ---@param sign_ns number
  ---@param opts table
  local function set_highest_signs(diagnostics, bufnr, client_id, sign_ns, opts)
    -- original func runs some checks, which I think is worth doing but maybe overkill
    if not diagnostics then
      diagnostics = diagnostic_cache[bufnr][client_id]
    end

    -- early escape
    if not diagnostics then
      return
    end

    -- Work out max severity diagnostic per line
    local max_severity_per_line = {}
    for _, d in pairs(diagnostics) do
      if max_severity_per_line[d.range.start.line] then
        local current_d = max_severity_per_line[d.range.start.line]
        if d.severity < current_d.severity then
          max_severity_per_line[d.range.start.line] = d
        end
      else
        max_severity_per_line[d.range.start.line] = d
      end
    end

    -- map to list
    local filtered_diagnostics = {}
    for _, v in pairs(max_severity_per_line) do
      table.insert(filtered_diagnostics, v)
    end

    -- call original function
    orig_set_signs(filtered_diagnostics, bufnr, client_id, sign_ns, opts)
  end

  vim.lsp.diagnostic.set_signs = set_highest_signs
end
-----------------------------------------------------------------------------//
-- Signs
-----------------------------------------------------------------------------//

local prefix = as.nightly and 'DiagnosticSign' or 'LspDiagnosticsSign'

local diagnostic_types = {
  { 'Hint', icon = as.style.icons.hint },
  { 'Error', icon = as.style.icons.error },
  { as.nightly and 'Warn' or 'Warning', icon = as.style.icons.warn },
  { as.nightly and 'Info' or 'Information', icon = as.style.icons.info },
}

fn.sign_define(vim.tbl_map(function(t)
  local hl = prefix .. t[1]
  return {
    name = hl,
    text = t.icon,
    texthl = hl,
    linehl = hl .. 'Line',
  }
end, diagnostic_types))

-----------------------------------------------------------------------------//
-- Handler overrides
-----------------------------------------------------------------------------//
if as.nightly then
  vim.diagnostic.config {
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
else
  lsp.handlers['textDocument/publishDiagnostics'] =
    lsp.with(lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = false,
      signs = true,
      update_in_insert = false,
    })
end

local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

-- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
lsp.handlers['textDocument/hover'] = lsp.with(
  lsp.handlers.hover,
  { border = 'rounded', max_width = max_width, max_height = max_height }
)
