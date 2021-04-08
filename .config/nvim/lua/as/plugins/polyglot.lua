local M = {}

function M.setup()
  vim.g.polyglot_disabled = {"sensible", "autoindent"}
end

function M.config()
  -----------------------------------------------------------------------------//
  -- Polyglot
  -----------------------------------------------------------------------------//
  vim.g.vim_json_syntax_conceal = 1
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
end

return M
