local fn = _G.vim.fn
local api = _G.vim.api

-- This plugin might not be installed so check it's there first
local load_lsp = function ()
  require'nvim_lsp'
end

local nvim_lsp_loaded, lsp = pcall(load_lsp)

if not nvim_lsp_loaded then
  return
end


local function is_executable(name)
  if fn.executable(name) > 0 then
    return true
  else
    return false
  end
end

function _G.attach_lsp()
  require'completion'.on_attach()
  require'diagnostic'.on_attach()
end

if is_executable('gopls') then
  lsp.gopls.setup{}
end

if is_executable('vim-language-server') then
  lsp.vimls.setup{}
end

lsp.rust_analyzer.setup{}

api.nvim_command("augroup LuaInit")
api.nvim_command("autocmd!")
api.nvim_command("autocmd BufEnter * lua attach_lsp()")
api.nvim_command("augroup END")

fn.sign_define("LspDiagnosticsErrorSign", {text = "✗", texthl = "LspDiagnosticsError"})
fn.sign_define("LspDiagnosticsWarningSign", {text = "", texthl = "LspDiagnosticsWarning"})
fn.sign_define("LspDiagnosticInformationSign", {text = "", texthl = "LspDiagnosticsInformation"})
fn.sign_define("LspDiagnosticHintSign", {text = "ﯦ", texthl = "LspDiagnosticsHint"})
