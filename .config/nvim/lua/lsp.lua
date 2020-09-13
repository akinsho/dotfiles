local fn = _G.vim.fn
local api = _G.vim.api

if vim.g.dotfiles_lsp_setup then return end
-----------------------------------------------------------------------------//
-- Helpers
-----------------------------------------------------------------------------//
local function is_plugin_loaded(plugin)
  local success, plug = pcall(require, plugin)
  return success, plug
end

local function is_executable(name)
  return fn.executable(name) > 0
end

-----------------------------------------------------------------------------//
-- Init
-----------------------------------------------------------------------------//
local lsp_configs_loaded, lsp = is_plugin_loaded('nvim_lsp')
-- NOTE: Don't load this file if we aren't using "nvim-lsp"
if not lsp_configs_loaded then return end

-----------------------------------------------------------------------------//
-- Setup plugins
-----------------------------------------------------------------------------//
local function echo_msg(message)
  vim.cmd('echohl String')
  vim.cmd(string.format('echom "%s"', message))
  vim.cmd('echohl clear')
end

local function on_attach()
  local success, completion = is_plugin_loaded('completion')
  if success then
    completion.on_attach()
    echo_msg("Loaded completion-nvim")
    vim.g.completion_enable_fuzzy_match = true
    vim.g.completion_enable_snippet =  'UltiSnips'
    vim.g.completion_matching_strategy_list = {'substring', 'fuzzy', 'exact', 'all'}

    api.nvim_set_keymap('n', '[c', '<cmd>NextDiagnostic<cr>', {
        silent = true, nowait = true, noremap = true
      })
    api.nvim_set_keymap('n', ']c', '<cmd>PrevDiagnostic<cr>', {
        silent = true, nowait = true, noremap = true
      })
  end
  local d_success, diagnostic = is_plugin_loaded('diagnostic')
  if d_success then
    vim.g.diagnostic_enable_virtual_text = true
    fn.sign_define("LspDiagnosticsErrorSign", {text = "✗", texthl = "LspDiagnosticsErrorSign"})
    fn.sign_define("LspDiagnosticsWarningSign", {text = "", texthl = "LspDiagnosticsWarningSign"})
    fn.sign_define("LspDiagnosticInformationSign", {text = "", texthl = "LspDiagnosticsInformationSign"})
    fn.sign_define("LspDiagnosticHintSign", {text = "ﯦ", texthl = "LspDiagnosticsHintSign"})
    diagnostic.on_attach()
    echo_msg("Loaded diagnostic-nvim")
  end
end
-----------------------------------------------------------------------------//
-- Highlights
-----------------------------------------------------------------------------//
--
vim.cmd("highlight! LspDiagnosticsError ctermfg=Red guifg=#E06C75 gui=undercurl,bold") -- used for "Error" diagnostic virtual text
vim.cmd("highlight! LspDiagnosticsErrorSign guifg=#E06C75") -- used for "Error" diagnostic signs in sign column
vim.cmd("highlight! LspDiagnosticsWarning  guifg=#ff922b  gui=undercurl") -- used for "Warning" diagnostic virtual text
vim.cmd("highlight! LspDiagnosticsWarningSign guifg=#ff922b") -- used for "Warning" diagnostic signs in sign column
vim.cmd("highlight! LspDiagnosticInformation guifg=#fab005") -- used for "Information" diagnostic virtual text
vim.cmd("highlight! LspDiagnosticInformationSign guifg=#fab005") -- used for "Information" signs in sign column
vim.cmd("highlight! LspDiagnosticHint guifg=#fab005 gui=bold") -- used for "Hint" diagnostic virtual text
vim.cmd("highlight! LspDiagnosticHintSign guifg=#fab005") -- used for "Hint" diagnostic signs in sign column
vim.cmd("highlight! LspReferenceText gui=undercurl,bold") -- used for highlighting "text" references
vim.cmd("highlight! LspReferenceRead gui=undercurl,bold") -- used for highlighting "read" references
vim.cmd('highlight! LspDiagnosticsUnderlineError gui=undercurl guisp=red')
vim.cmd('highlight! LspDiagnosticsUnderlineHint gui=undercurl guisp=purple')
vim.cmd('highlight! LspDiagnosticsUnderlineInfo gui=undercurl guisp=blue')
vim.cmd('highlight! LspDiagnosticsUnderlineWarning gui=undercurl guisp=orange')
-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//
vim.cmd('autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()')
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

vim.cmd [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
vim.cmd [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
vim.cmd [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
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

lsp.dartls.setup{
  cmd = {
    "dart",
    "/usr/lib/dart/bin/snapshots/analysis_server.dart.snapshot",
    "--lsp",
  },
  on_attach = on_attach
}

lsp.sumneko_lua.setup{
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = {[vim.fn.expand("$VIMRUNTIME/lua")] = true}
      }
    }
  }
}

lsp.rust_analyzer.setup{on_attach = on_attach}

vim.g.dotfiles_lsp_setup = true
