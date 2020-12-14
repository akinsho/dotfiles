" Generic command with shell program autocompletion to execute any command
command! -count -nargs=+ -complete=shellcmd Exec lua require'async_job'.exec(<q-args>, <count>)

" Git commands
command! -count GitPush lua require'akinsho.async_job'.exec('git push', <count>)
command! -count GitPull lua require'akinsho.async_job'.exec('git pull', <count>)
command! -count GitStatus lua require'akinsho.async_job'.exec('git status', <count>)
command! -count GitPushF lua require'akinsho.async_job'.exec('git push -f', <count>)
