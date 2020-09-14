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
-- Autocommands
-----------------------------------------------------------------------------//
local function setup_autocommands()
  vim.cmd [[autocmd CursorHold  <buffer> lua vim.lsp.util.show_line_diagnostics()]]
  vim.cmd [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
  vim.cmd [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.signature_help()]]
  vim.cmd [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
end
-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//
local function mapper(key, mode, mapping, expr)
  expr = not expr and false or expr
  api.nvim_buf_set_keymap(0, mode, key, mapping, {
      nowait = true, noremap = true, silent = true, expr = expr
    })
end

local mappings = {
  ['gd']       = {mode = 'n', mapping = '<cmd>lua vim.lsp.buf.definition()<CR>'};
  ['<c-]>']    = {mode = 'n', mapping = '<cmd>lua vim.lsp.buf.definition()<CR>'};
  ['K']        = {mode = 'n', mapping = '<cmd>lua vim.lsp.buf.hover()<CR>'};
  ['gD']       = {mode = 'n', mapping = '<cmd>lua vim.lsp.buf.implementation()<CR>'};
  ['<c-k>']    = {mode = 'i', mapping = '<cmd>lua vim.lsp.buf.signature_help()<CR>'};
  ['1gD']      = {mode = 'n', mapping = '<cmd>lua vim.lsp.buf.type_definition()<CR>'};
  ['gr']       = {mode = 'n', mapping = '<cmd>lua vim.lsp.buf.references()<CR>'};
  ['g0']       = {mode = 'n', mapping = '<cmd>lua vim.lsp.buf.document_symbol()<CR>'};
  ['gW']       = {mode = 'n', mapping = '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>'};
  ['ff']       = {mode = 'n', mapping = '<cmd>lua vim.lsp.buf.formatting()<CR>'};
  ['rn']       = {mode = 'n', mapping = '<cmd>lua vim.lsp.buf.rename()<CR>'};
  ['<tab>']    = {mode = 'i', mapping = [[pumvisible() ? "\<C-n>" : "\<Tab>"]], expr = true};
  ['<s-tab>']  = {mode = 'i', mapping = [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], expr = true};
  ['<c-j>']    = {mode = {'i', 's'}, mapping = [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>']], expr = true};
}

local function setup_mappings()
  for key, entry in pairs(mappings) do
    if type(entry.mode) == 'table' then
      for _, mode in ipairs(entry.mode) do
          mapper(key, mode, entry.mapping, entry.expr)
      end
    else
      mapper(key, entry.mode, entry.mapping, entry.expr)
    end
  end
end

-----------------------------------------------------------------------------//
-- Setup plugins
-----------------------------------------------------------------------------//
local function on_attach()
  setup_autocommands()
  setup_mappings()


  local completion_loaded, completion = is_plugin_loaded('completion')
  if completion_loaded then
    completion.on_attach()
    vim.g.completion_enable_fuzzy_match = true
    vim.g.completion_enable_snippet =  'vim-vsnip'
    vim.g.completion_matching_strategy_list = {'substring', 'fuzzy', 'exact', 'all'}
    mapper('[c', 'n', '<cmd>NextDiagnostic<cr>')
    mapper(']c', 'n', '<cmd>PrevDiagnostic<cr>')
  end

  local diagnostics_loaded, diagnostic = is_plugin_loaded('diagnostic')
  if diagnostics_loaded then
    vim.g.diagnostic_enable_virtual_text = true
    fn.sign_define("LspDiagnosticsErrorSign", {text = "✗", texthl = "LspDiagnosticsErrorSign"})
    fn.sign_define("LspDiagnosticsWarningSign", {text = "", texthl = "LspDiagnosticsWarningSign"})
    fn.sign_define("LspDiagnosticsInformationSign", {text = "", texthl = "LspDiagnosticsInformationSign"})
    fn.sign_define("LspDiagnosticsHintSign", {text = "ﯦ", texthl = "LspDiagnosticsHintSign"})
    diagnostic.on_attach()
  end
end
-----------------------------------------------------------------------------//
-- Highlights
-----------------------------------------------------------------------------//
function _G.__apply_lsp_highlights()
  vim.cmd("highlight! LspDiagnosticsError ctermfg=Red guifg=#E06C75 gui=undercurl,bold") -- used for "Error" diagnostic virtual text
  vim.cmd("highlight! LspDiagnosticsErrorSign guifg=#E06C75") -- used for "Error" diagnostic signs in sign column
  vim.cmd("highlight! LspDiagnosticsWarning  guifg=#ff922b  gui=undercurl") -- used for "Warning" diagnostic virtual text
  vim.cmd("highlight! LspDiagnosticsWarningSign guifg=#ff922b") -- used for "Warning" diagnostic signs in sign column
  vim.cmd("highlight! LspDiagnosticsInformation guifg=#fab005") -- used for "Information" diagnostic virtual text
  vim.cmd("highlight! LspDiagnosticsInformationSign guifg=#fab005") -- used for "Information" signs in sign column
  vim.cmd("highlight! LspDiagnosticsHint guifg=#fab005 gui=bold") -- used for "Hint" diagnostic virtual text
  vim.cmd("highlight! LspDiagnosticsHintSign guifg=#fab005") -- used for "Hint" diagnostic signs in sign column
  vim.cmd("highlight! LspReferenceText gui=undercurl,bold") -- used for highlighting "text" references
  vim.cmd("highlight! LspReferenceRead gui=undercurl,bold") -- used for highlighting "read" references
  vim.cmd('highlight! LspDiagnosticsUnderlineError gui=undercurl guisp=red')
  vim.cmd('highlight! LspDiagnosticsUnderlineHint gui=undercurl guisp=purple')
  vim.cmd('highlight! LspDiagnosticsUnderlineInfo gui=undercurl guisp=blue')
  vim.cmd('highlight! LspDiagnosticsUnderlineWarning gui=undercurl guisp=orange')
end

_G.__apply_lsp_highlights()

vim.cmd('augroup LspHighlights')
vim.cmd('au!')
vim.cmd('autocmd ColorScheme * lua _G.__apply_lsp_highlights()')
vim.cmd('augroup END')

-- see https://github.com/nvim-lua/completion-nvim/wiki/Customizing-LSP-label
-- for how to do this without completion-nvim
vim.g.completion_customize_lsp_label = {
  Function = '',
  Method = '',
  Reference = '',
  Enum = '',
  Field = 'ﰠ',
  Keyword = '',
  Variable = '',
  Folder = '',
  Snippet = ' ',
  Operator = '',
  Module = '',
  Text = 'ﮜ',
  Buffers = '',
  Class = '',
  Interface = ''
}
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
  on_attach = on_attach,
  callbacks = {
    ["textDocument/codeAction"] = function (_, _, value)
      print('code actions'..vim.inspect(value))
    end,
    ["dart/textDocument/publishFlutterOutline"] = function (_, _, value)
        print(vim.inspect(value))
    end,
    ["dart/textDocument/publishClosingLabels"] = function(_, _, value)
      print('closing labels: '..value);
    end
  }
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

vim.cmd('command! ListEmulators lua require"flutter".flutter_emulators()')

vim.g.dotfiles_lsp_setup = true
