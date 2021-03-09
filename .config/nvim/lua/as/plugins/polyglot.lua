local M = {}

function M.setup()
  vim.g.polyglot_disabled = {"sensible"}
end

function M.config()
  -----------------------------------------------------------------------------//
  -- Polyglot
  -----------------------------------------------------------------------------//
  vim.g.vim_json_syntax_conceal = 1
  vim.g.vue_disable_pre_processors = 1

  -----------------------------------------------------------------------------//
  -- CSV
  -----------------------------------------------------------------------------//
  vim.g.csv_autocmd_arrange = 1
  vim.g.csv_autocmd_arrange_size = 1024 * 1024
  vim.g.csv_strict_columns = 1
  vim.g.csv_highlight_column = "y"
  vim.g.csv_hiGroup = ""

  -----------------------------------------------------------------------------//
  -- MARKDOWN {{{
  -----------------------------------------------------------------------------//
  vim.g.vim_markdown_strikethrough = 1
  vim.g.vim_markdown_fenced_languages = {
    "css",
    "sh=bash",
    "js=javascript",
    "json",
    "xml",
    "html=html",
    "py=python",
    "sql",
    "go",
    "elm",
    "vim",
    "lua"
  }
  vim.g.vim_markdown_autowrite = 1
  vim.g.vim_markdown_json_frontmatter = 1
  vim.g.vim_markdown_frontmatter = 1
  vim.g.vim_markdown_toml_frontmatter = 1
  vim.g.vim_markdown_conceal = 1
  vim.g.vim_markdown_conceal_code_blocks = 1
  vim.g.vim_markdown_folding_disabled = 0
  --}}}
  -----------------------------------------------------------------------------//
  -- DART
  -----------------------------------------------------------------------------//
  vim.g.dart_html_in_string = true
  vim.g.dart_style_guide = 2

  -----------------------------------------------------------------------------//
  -- JSX
  -----------------------------------------------------------------------------//
  vim.g.jsx_ext_required = 0 -- "Allow jsx in .js files REQUIRED

  -----------------------------------------------------------------------------//
  -- VIM-JAVASCRIPT
  -----------------------------------------------------------------------------//
  vim.g.javascript_plugin_flow = 1
  vim.g.javascript_plugin_jsdoc = 1
end

return M
