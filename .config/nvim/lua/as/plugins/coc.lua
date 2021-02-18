-----------------------------------------------------------------------------//
-- Coc Highlights
-----------------------------------------------------------------------------//
function _G.__coc_apply_highlights()
  local highlight = require("as.highlights").all
  highlight {
    {"CocErrorHighlight", {guisp = "#E06C75", gui = "undercurl"}},
    {"CocWarningHighlight", {guisp = "orange", gui = "undercurl"}},
    {"CocInfoHighlight", {guisp = "orange", gui = "undercurl"}},
    {"CocHighlightText", {gui = "underline"}},
    {"CocHintHighlight", {guisp = "#15aabf", gui = "undercurl"}},
    {"CocOutlineIndentLine", {link = "LineNr"}},
    -- By default this links to CocHintSign but that keeps getting cleared mysteriously
    {"CocRustChainingHint", {guifg = "#15aabf"}}
  }
end

function _G.__coc_init()
  local languageservers = {}

  if vim.fn.executable("ccls") then
    languageservers.ccls = {
      command = "ccls",
      filetypes = {"c", "cpp", "objc", "objcpp"},
      rootPatterns = {".ccls", "compile_commands.json", ".vim/", ".git/", ".hg/"},
      initializationOptions = {
        cacheDirectory = "/tmp/ccls"
      }
    }
  end

  if vim.fn.executable("ocaml-language-server") then
    languageservers.ocaml = {
      command = "ocaml-language-server",
      args = {"--stdio"},
      ["trace.server"] = "verbose",
      filetypes = {"ocaml"}
    }
  end

  -- manually compiled and installed
  -- using https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
  -- https://github.com/sumneko/lua-language-server/wiki/Setting-without-VSCode
  local sumneko_root = os.getenv("HOME") .. "/lua-language-server"
  local sumneko_binary = sumneko_root .. "/bin/" .. vim.g.system_name .. "/lua-language-server"
  if vim.fn.executable(sumneko_root .. "/bin/Linux/lua-language-server") then
    languageservers.lua = {
      command = sumneko_binary,
      args = {"-E", sumneko_root .. "/main.lua"},
      filetypes = {"lua"},
      rootPatterns = {".git/"},
      settings = {
        Lua = {
          awakened = {cat = true},
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
            }
          },
          runtime = {version = "LuaJIT"},
          diagnostics = {
            globals = {"vim"}
          },
          completion = {
            keywordSnippet = "Both"
          }
        }
      }
    }
  end

  if vim.fn.executable("elm-language-server") then
    languageservers["elmLS"] = {
      command = "elm-language-server",
      filetypes = {"elm"},
      rootPatterns = {"elm.json"}
    }
  end

  if not vim.tbl_isempty(languageservers) then
    vim.fn["coc#config"]("languageserver", languageservers)
  end
end

return function()
  local map = as_utils.map
  local command = as_utils.command
  -----------------------------------------------------------------------------//
  -- Extensions
  -----------------------------------------------------------------------------//
  vim.g.coc_global_extensions = {
    "coc-java",
    "coc-marketplace",
    "coc-json",
    "coc-vimlsp",
    "coc-rls",
    "coc-python",
    "coc-html",
    "coc-snippets",
    "coc-highlight",
    "coc-css",
    "coc-prettier",
    "coc-emoji",
    "coc-yank",
    "coc-eslint",
    "coc-go",
    "coc-word",
    "coc-tabnine",
    "coc-flutter-tools",
    "coc-xml",
    "coc-tsserver",
    "coc-graphql",
    "coc-spell-checker"
  }

  -----------------------------------------------------------------------------//
  -- Coc Autocommands
  -----------------------------------------------------------------------------//

  require("as.autocommands").create(
    {
      coc_commands = {
        {"VimEnter", "*", "lua __coc_init()"},
        {"CursorHold", "*", "silent call CocActionAsync('highlight')"},
        -- Update signature help on jump placeholder.
        {"User CocJumpPlaceholder", "call CocActionAsync('showSignatureHelp')"},
        {"CompleteDone", "*", "if pumvisible() == 0 | pclose | endif"},
        -- Suggestions don't work and are not needed in the command line window
        {"CmdwinEnter", "*", "let b:coc_suggest_disable = 1"},
        {"User CocOpenFloat", "setlocal foldlevel=20 foldcolumn=0"},
        {"VimEnter,ColorScheme", "*", "lua __coc_apply_highlights()"}
      }
    }
  )

  -----------------------------------------------------------------------------//
  -- CoC Mappings
  -----------------------------------------------------------------------------//
  -- Use tab for trigger completion with characters ahead and navigate.
  -- Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  map(
    "i",
    "<TAB>",
    [[pumvisible() ? "\<C-n>" : v:lua.__coc_check_back_space() ? "\<TAB>" : coc#refresh()]],
    {expr = true, silent = true}
  )
  map("i", "<S-TAB>", [[pumvisible() ? "\<C-p>" : "\<C-h>"]], {expr = true, silent = true})

  function _G.__coc_check_back_space()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    return (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match("%s")) and true
  end

  local expr = {expr = true, silent = true}
  local recursive = {noremap = false, silent = true}
  -- Use <C-l> for trigger snippet expand.
  map("i", "<C-l>", [[<Plug>(coc-snippets-expand)]], recursive)

  -- Use <C-j> for select text for visual placeholder of snippet.
  map("v", "<C-j>", [[<Plug>(coc-snippets-select]], recursive)

  -- Use <C-j> for both expand and jump (make expand higher priority.)
  map("i", "<C-j>", [[<Plug>(coc-snippets-expand-jump)]], recursive)

  -- Use <c-space> for trigger completion.
  map("i", "<c-space>", [[coc#refresh()]], expr)
  -- Make <CR> auto-select the first completion item and notify coc.nvim to
  -- format on enter, <cr> could be remapped by other vim plugin
  map(
    "i",
    "<cr>",
    [[pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
    expr
  )

  -- Use `[c` and `]c` for navigate diagnostics
  map(
    "n",
    "]c",
    [[&diff ? ']c' : "\<Plug>(coc-diagnostic-prev)"]],
    {expr = true, noremap = false, silent = true}
  )
  map(
    "n",
    "[c",
    [[&diff ? '[c' : "\<Plug>(coc-diagnostic-next)"]],
    {expr = true, noremap = false, silent = true}
  )

  map("n", "gd", [[<Plug>(coc-definition)]], recursive)
  map("n", "gy", [[<Plug>(coc-type-definition)]], recursive)
  map("n", "gi", [[<Plug>(coc-implementation)]], recursive)
  map("n", "gr", [[<Plug>(coc-references)]], recursive)
  -- Use K for show documentation in preview window
  map("n", "K", [[<cmd>lua __coc_show_documentation()<CR>]])

  function _G.__coc_show_documentation()
    if vim.tbl_contains({"vim", "help"}, vim.bo.filetype) then
      vim.cmd("h " .. vim.fn.expand("<cword>"))
    elseif (vim.fn["coc#rpc#ready"]()) then
      vim.fn["CocActionAsync"]("doHover")
    else
      vim.cmd("!" .. vim.bo.keywordprg .. " " .. vim.fn.expand("<cword>"))
    end
  end

  map("x", "if", [[<Plug>(coc-funcobj-i)]], recursive)
  map("x", "af", [[<Plug>(coc-funcobj-a)]], recursive)
  map("o", "if", [[<Plug>(coc-funcobj-i)]], recursive)
  map("o", "af", [[<Plug>(coc-funcobj-a)]], recursive)
  map("x", "im", [[<Plug>(coc-classobj-i)]], recursive)
  map("o", "im", [[<Plug>(coc-classobj-i)]], recursive)
  map("x", "am", [[<Plug>(coc-classobj-a)]], recursive)
  map("o", "am", [[<Plug>(coc-classobj-a)]], recursive)
  -----------------------------------------------------------------------------//
  -- Code Actions
  -----------------------------------------------------------------------------//
  map("n", "<leader>ca", [[<Plug>(coc-codelens-action)]], recursive)
  -- Applying codeAction to the selected region.
  -- Example: `<leader>aap` for current paragraph
  map("x", "<leader>a", [[<Plug>(coc-codeaction-selected)]], recursive)
  map("n", "<leader>a", [[<Plug>(coc-codeaction-selected)]], recursive)
  -- Fix autofix problem of current line
  map("n", "<leader>rf", [[<Plug>(coc-fix-current)]], recursive)
  map("n", "<leader>rr", [[<Plug>(coc-refactor)]], recursive)
  -- Remap for rename current word
  map("n", "<leader>rn", [[<Plug>(coc-rename)]], recursive)
  -- source: https://www.youtube.com/watch?v=q7gr6s8skt0
  -- add --hidden flag so dotfiles are always searched
  map("n", "<leader>cf", [[:CocSearch --hidden <C-R>=expand("<cword>")<CR><CR>]])
  -- Scroll the floating window if open
  -- FIXME this breaks smooth scrolling
  -- Remap <C-f> and <C-b> for scroll float windows/popups.
  local nowait = {silent = true, nowait = true, expr = true}
  map("n", "<C-f>", [[coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"]], nowait)
  map("n", "<C-b>", [[coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"]], nowait)
  map(
    "i",
    "<C-f>",
    [[coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"]],
    nowait
  )
  map(
    "i",
    "<C-b>",
    [[coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"]],
    nowait
  )
  map("v", "<C-f>", [[coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"]], nowait)
  map("v", "<C-b>", [[coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"]], nowait)
  -----------------------------------------------------------------------------//
  -- Coc Statusline
  -----------------------------------------------------------------------------//
  vim.g.coc_status_error_sign = "✗ "
  vim.g.coc_status_warning_sign = " "
  -----------------------------------------------------------------------------//
  -- Using CocList
  -----------------------------------------------------------------------------//
  map("n", "<leader>cy", [[<cmd>CocList -A --normal yank<cr>]])
  -- Show all diagnostics
  map(
    "n",
    "<leader>cd",
    [[<cmd>CocList diagnostics<cr>]],
    {nowait = true, noremap = true, silent = true}
  )
  -- Show commands
  map("n", "<leader>cc", [[<cmd>CocList commands<cr>]])
  -- Manage extensions
  map("n", "<leader>ce", [[<cmd>CocList extensions<cr>]])
  -- Find symbol of current document
  map("n", "<leader>co", [[<cmd>CocList outline<cr>]])
  -- Search workspace symbols
  map("n", "<leader>cs", [[<cmd>CocList symbols<cr>]])
  -- Search marketplace for coc symbols
  map("n", "<leader>cm", [[<cmd>CocList marketplace<cr>]])
  -- Search snippets
  map("n", "<leader>cn", [[<cmd>CocList snippets <CR>]])
  -- Resume latest coc list
  map("n", "<leader>cr", [[<cmd>CocListResume<CR>]])

  local mappings = vim.g.which_leader_key_map or {}
  mappings.a = "coc codeaction (for text object)"
  mappings.c = {
    name = "+coc-command",
    f = "search = cursor word",
    y = "list: yank",
    b = "list: branches",
    d = "list: diagnostic",
    c = "list: command",
    e = "list: extension",
    o = "list: outline",
    s = "list: symbol",
    m = "list: marketplace",
    r = "list: resume",
    a = "codelens: action"
  }
  mappings.g = {
    name = "+coc-edit",
    a = "codeaction: entire file",
    r = "refactor",
    f = "fix current line",
    n = "rename cursor word"
  }

  vim.g.which_leader_key_map = mappings

  -----------------------------------------------------------------------------//
  -- Formatting
  -----------------------------------------------------------------------------//
  -- Use `:Format` for format current buffer
  command {"CocFormat", [[:call CocActionAsync('format')]], nargs = 0}

  -- Add `:OR` command for organize imports of the current buffer.
  command {"OR", [[:call CocAction('runCommand', 'editor.action.organizeImport')]], nargs = 0}
  -----------------------------------------------------------------------------//
  -- Tags
  -----------------------------------------------------------------------------//
  vim.cmd "set tagfunc=CocTagFunc"
end
