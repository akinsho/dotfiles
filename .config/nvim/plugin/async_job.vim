command! -nargs=+ -complete=shellcmd Exec lua require'async_job'.exec(<q-args>)
command! GitPush lua require'async_job'.exec('git push')
command! GitStatus lua require'async_job'.exec('git status')
command! GitPushF lua require'async_job'.exec('git push -f')
