call gina#custom#command#option('br', '-v', 'v')

call gina#custom#command#option(
      \ 'commit', '-v|--verbose'
      \)

call gina#custom#execute(
      \ '/\%(status\|branch\|ls\|grep\|changes\|tag\)',
      \ 'setlocal winfixheight',
      \)

" Execute :Gina commit with cc on "gina-status" buffer
call gina#custom#command#option(
      \ '/\%(log\|reflog\)',
      \ '--opener', 'vsplit'
      \)

" Add "--opener=split" to branch/changes/grep/log
call gina#custom#command#option(
      \ '/\%(branch\|changes\|grep\|status\|commit\|log\)',
      \ '--opener', 'sp'
      \)

call gina#custom#mapping#nmap(
      \ 'status', 'cc',
      \ ':<C-u>Gina commit<CR>',
      \ {'noremap': 1, 'silent': 1},
      \)

" Execute :Gina status with cc on "gina-commit" buffer
call gina#custom#mapping#nmap(
      \ 'commit', 'cc',
      \ ':<C-u>Gina status<CR>',
      \ {'noremap': 1, 'silent': 1},
      \)
