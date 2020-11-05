if !PluginLoaded('format.nvim')
  finish
endif

augroup LuaFormat
  autocmd!
  autocmd BufWritePost *lua,*.vim FormatWrite
augroup END

lua << EOF
require "format".setup {
    lua = {
        {
            cmd = {
                function(file)
                    return string.format(
                        "luafmt --indent-count 2 --line-width %s -w replace %s",
                        vim.bo.textwidth,
                        file
                    )
                end
            }
        }
    },
    vim = {
        {
            cmd = {"luafmt -w replace"},
            start_pattern = "^lua << EOF$",
            end_pattern = "^EOF$"
        }
    }
}
EOF
