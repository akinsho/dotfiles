local fn = _G.vim.fn
local api = _G.vim.api
local lsp = require'nvim_lsp'

local function is_executable(name)
  if fn.executable(name) > 0 then
    return true
  else
    return false
  end
end

-----------------------------------------------------------------------------//
-- Setup plugins
-----------------------------------------------------------------------------//
function _G.attach_lsp()
  require'completion'.on_attach()
  require'diagnostic'.on_attach()
end

api.nvim_set_var('completion_enable_snippet ', 'UltiSnips')
api.nvim_set_var('diagnostic_enable_virtual_text ', 1)

fn.sign_define("LspDiagnosticsErrorSign", {text = "✗", texthl = "LspDiagnosticsError"})
fn.sign_define("LspDiagnosticsWarningSign", {text = "", texthl = "LspDiagnosticsWarning"})
fn.sign_define("LspDiagnosticInformationSign", {text = "", texthl = "LspDiagnosticsInformation"})
fn.sign_define("LspDiagnosticHintSign", {text = "ﯦ", texthl = "LspDiagnosticsHint"})

-----------------------------------------------------------------------------//
-- Highlights
-----------------------------------------------------------------------------//
api.nvim_command("highlight! LspDiagnosticsError guifg=red gui=undercurl,bold") -- used for "Error" diagnostic virtual text
api.nvim_command("highlight! LspDiagnosticsErrorSign guifg=red") -- used for "Error" diagnostic signs in sign column
api.nvim_command("highlight! LspDiagnosticsWarning  guifg=yellow gui=undercurl") -- used for "Warning" diagnostic virtual text
api.nvim_command("highlight! LspDiagnosticsWarningSign guifg=yellow") -- used for "Warning" diagnostic signs in sign column
api.nvim_command("highlight! LspDiagnosticInformation guifg=blue") -- used for "Information" diagnostic virtual text
api.nvim_command("highlight! LspDiagnosticInformationSign guifg=blue") -- used for "Information" signs in sign column
api.nvim_command("highlight! LspDiagnosticHint guifg=yellow gui=bold") -- used for "Hint" diagnostic virtual text
api.nvim_command("highlight! LspDiagnosticHintSign guifg=yellow") -- used for "Hint" diagnostic signs in sign column
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
  lsp.gopls.setup{}
end

if is_executable('vim-language-server') then
  lsp.vimls.setup{}
end

lsp.rust_analyzer.setup{}

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//
api.nvim_command("augroup LuaInit")
api.nvim_command("autocmd!")
api.nvim_command("autocmd BufEnter * lua attach_lsp()")
api.nvim_command("augroup END")
