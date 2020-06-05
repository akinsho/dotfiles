local fn = _G.vim.fn
local api = _G.vim.api

-----------------------------------------------------------------------------//
-- Helpers
-----------------------------------------------------------------------------//
local function is_plugin_loaded(plugin)
  local plugin_config = vim.g.plugs[plugin]
  local is_in_runtime = plugin_config  and fn.stridx(vim.o.runtimepath, plugin_config.dir) > 0
  local is_loaded = fn.has_key(vim.g.plugs, plugin) > 0
  return is_loaded and is_in_runtime
end

local function is_executable(name)
  if fn.executable(name) > 0 then
    return true
  else
    return false
  end
end


-----------------------------------------------------------------------------//
-- Init
-----------------------------------------------------------------------------//
local lsp_configs_loaded = is_plugin_loaded('nvim-lsp')

-- NOTE: Don't load this file if we aren't using "nvim-lsp"
if not lsp_configs_loaded then
  return
end

local lsp = require'nvim_lsp'

-----------------------------------------------------------------------------//
-- Setup plugins
-----------------------------------------------------------------------------//
local function echo_msg(message)
  api.nvim_command('echohl String')
  api.nvim_command(string.format('echom "%s"', message))
  api.nvim_command('echohl clear')
end

local function on_attach()
  if is_plugin_loaded('completion-nvim') then
    require'completion'.on_attach()
    echo_msg("Loaded completion-nvim")

    api.nvim_set_var('completion_enable_fuzzy_match', 1)
    api.nvim_set_var('completion_enable_snippet', 'UltiSnips')

    api.nvim_set_keymap('n', '[c', '<cmd>NextDiagnostic<cr>', {
        silent = true, nowait = true, noremap = true
      })
    api.nvim_set_keymap('n', ']c', '<cmd>PrevDiagnostic<cr>', {
        silent = true, nowait = true, noremap = true
      })
  end
  if is_plugin_loaded('diagnostic-nvim') then
    require'diagnostic'.on_attach()
    echo_msg("Loaded diagnostic-nvim")
    api.nvim_set_var('diagnostic_enable_virtual_text', 1)
  end
end

fn.sign_define("LspDiagnosticsErrorSign", {text = "✗", texthl = "LspDiagnosticsErrorSign"})
fn.sign_define("LspDiagnosticsWarningSign", {text = "", texthl = "LspDiagnosticsWarningSign"})
fn.sign_define("LspDiagnosticInformationSign", {text = "", texthl = "LspDiagnosticsInformationSign"})
fn.sign_define("LspDiagnosticHintSign", {text = "ﯦ", texthl = "LspDiagnosticsHintSign"})
-----------------------------------------------------------------------------//
-- Highlights
-----------------------------------------------------------------------------//
api.nvim_command("highlight! LspDiagnosticsError ctermfg=Red guifg=#E06C75 gui=undercurl,bold") -- used for "Error" diagnostic virtual text
api.nvim_command("highlight! LspDiagnosticsErrorSign guifg=#E06C75") -- used for "Error" diagnostic signs in sign column
api.nvim_command("highlight! LspDiagnosticsWarning  guifg=#ff922b  gui=undercurl") -- used for "Warning" diagnostic virtual text
api.nvim_command("highlight! LspDiagnosticsWarningSign guifg=#ff922b") -- used for "Warning" diagnostic signs in sign column
api.nvim_command("highlight! LspDiagnosticInformation guifg=#fab005") -- used for "Information" diagnostic virtual text
api.nvim_command("highlight! LspDiagnosticInformationSign guifg=#fab005") -- used for "Information" signs in sign column
api.nvim_command("highlight! LspDiagnosticHint guifg=#fab005 gui=bold") -- used for "Hint" diagnostic virtual text
api.nvim_command("highlight! LspDiagnosticHintSign guifg=#fab005") -- used for "Hint" diagnostic signs in sign column
api.nvim_command("highlight! LspReferenceText gui=undercurl,bold") -- used for highlighting "text" references
api.nvim_command("highlight! LspReferenceRead gui=undercurl,bold") -- used for highlighting "read" references
-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//
-- TODO combine all mappings into this table
local mappings = {
  ['gd'] =    '<cmd>lua vim.lsp.buf.declaration()<CR>';
  ['<c-]>'] =  '<cmd>lua vim.lsp.buf.definition()<CR>';
  ['K']    = '<cmd>lua vim.lsp.buf.hover()<CR>';
  ['gD'] =    '<cmd>lua vim.lsp.buf.implementation()<CR>';
  ['<c-k>'] =  '<cmd>lua vim.lsp.buf.signature_help()<CR>';
  ['1gD'] =   '<cmd>lua vim.lsp.buf.type_definition()<CR>';
  ['gr'] =    '<cmd>lua vim.lsp.buf.references()<CR>';
  ['g0'] =    '<cmd>lua vim.lsp.buf.document_symbol()<CR>';
  ['gW'] =    '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>';
  ['ff'] =    '<cmd>lua vim.lsp.buf.formatting()<CR>';
}

for key, mapping in pairs(mappings) do
    api.nvim_set_keymap('n', key, mapping, {
        nowait = true, noremap = true, silent = true
    })
end

api.nvim_set_keymap('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], {
    silent = true, nowait = true, noremap = true, expr = true
})

api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], {
    silent = true, nowait = true, noremap = true, expr = true
})

-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//
if is_executable('gopls') then
  lsp.gopls.setup{on_attach = on_attach}
end

if is_executable('vim-language-server') then
  lsp.vimls.setup{on_attach = on_attach}
end

if is_executable('flow') then
  lsp.flow.setup{on_attach = on_attach}
end

if is_executable('vscode-html-languageserver') then
  lsp.html.setup{on_attach = on_attach}
end

if is_executable('vscode-json-languageserver') then
  lsp.jsonls.setup{on_attach = on_attach}
end

if is_executable('typescript-language-server') then
  lsp.tsserver.setup{on_attach = on_attach}
end

lsp.sumneko_lua.setup{on_attach = on_attach}

lsp.rust_analyzer.setup{on_attach = on_attach}
