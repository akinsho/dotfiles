local highlight = as.highlight

--- Parsers to keep installed. Neovim bundles only c, lua, markdown,
--- markdown_inline, query, vim and vimdoc, so everything else this config edits
--- has to be listed here. There is no `auto_install` on the main branch; use
--- `:TSInstall <lang>` for anything one-off. Names must exist upstream, and a
--- single unknown name aborts the whole batch, so jsonc is absent: it has no
--- parser of its own and is covered by json.
-- stylua: ignore
local parsers = {
  'bash', 'c', 'css', 'diff', 'dockerfile', 'git_config', 'git_rebase', 'gitcommit',
  'go', 'gomod', 'gosum', 'gowork', 'graphql', 'html', 'java', 'javascript', 'json',
  'lua', 'luadoc', 'luap', 'markdown', 'markdown_inline', 'python', 'query',
  'regex', 'rust', 'sql', 'svelte', 'terraform', 'toml', 'tsx', 'typescript', 'vim',
  'vimdoc', 'yaml',
}

--- Treesitter indentation is flagged experimental upstream and misindents these.
local no_indent = { yaml = true }

--- Parsers are built with the tree-sitter CLI rather than shipped, so without it
--- most of them fail to compile. Called from `build`, i.e. when a new machine
--- first clones the plugin.
local function ensure_tree_sitter_cli()
  if vim.fn.executable('tree-sitter') == 1 then return end
  if vim.fn.executable('brew') == 0 then
    return vim.notify('Install tree-sitter-cli (not via npm), then :TSUpdate', vim.log.levels.WARN)
  end
  local res = vim.system({ 'brew', 'install', 'tree-sitter-cli' }, { text = true }):wait()
  if res.code ~= 0 then vim.notify('tree-sitter-cli: ' .. res.stderr, vim.log.levels.ERROR) end
end

--- Filetypes where the regex syntax highlighting is worth keeping alongside
--- treesitter, because the queries alone lose too much.
local keep_syntax = { sql = true }

return {
  {
    'nvim-treesitter/nvim-treesitter',
    -- Pinned explicitly: upstream moved the default branch from `master` to
    -- `main`, so an unpinned spec resolves differently depending on when the
    -- machine first cloned it.
    branch = 'main',
    -- The main branch does not support lazy-loading.
    lazy = false,
    build = function()
      ensure_tree_sitter_cli()
      pcall(vim.cmd, 'TSUpdate')
    end,
    -- Kept for the `textobjects` queries it ships, which mini.ai reads via
    -- `vim.treesitter.query.get()`. Neovim ships none of its own.
    dependencies = { { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' } },
    config = function()
      require('nvim-treesitter').install(parsers)

      -- The main branch has no module system. Highlighting comes from Neovim
      -- itself and only the indent expression comes from the plugin, so both are
      -- enabled per buffer rather than configured once.
      as.augroup('Treesitter', {
        event = 'FileType',
        desc = 'Enable treesitter highlighting and indentation when a parser exists',
        command = function(args)
          local buf, ft = args.buf, vim.bo[args.buf].filetype
          if not pcall(vim.treesitter.start, buf) then return end
          if keep_syntax[ft] then vim.bo[buf].syntax = 'on' end
          if not no_indent[ft] then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    init = function()
      highlight.plugin('treesitter-context', {
        { TreesitterContextSeparator = { link = 'Dim' } },
        { TreesitterContext = { inherit = 'Normal' } },
        { TreesitterContextLineNumber = { inherit = 'LineNr' } },
      })
    end,
    opts = {
      multiline_threshold = 4,
      separator = '─', -- alternatives: ▁ ─ ▄
      mode = 'cursor',
    },
  },
}
