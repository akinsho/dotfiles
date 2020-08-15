" Generic command with shell program autocompletion to execute any command
command! -count -nargs=+ -complete=shellcmd Exec lua require'async_job'.exec(<q-args>, <count>)

" Git commands
command! -count GitPush lua require'async_job'.exec('git push --porcelain', <count>)
command! -count GitStatus lua require'async_job'.exec('git status', <count>)
command! -count GitPushF lua require'async_job'.exec('git push --porcelain -f', <count>)
