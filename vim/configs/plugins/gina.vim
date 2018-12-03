function! LightLineGinaStatus() abort
  let conflicted = gina#component#status#conflicted()
  let project = gina#component#repo#name()
  let conflicts = conflicted > 0 ? conflicted . ',❗: '.conflicted : ''
  let s:change_status =  printf(
        \ ' %s %s',
        \ project,
        \ conflicts,
        \) 
  return s:change_status . ' ' . gina#component#traffic#preset('fancy')
endfunction

call gina#custom#command#option('br', '-v', 'v')

call gina#custom#execute(
      \ '/\%(status\|branch\|ls\|grep\|changes\|tag\)',
      \ 'setlocal winfixheight',
      \)

" Execute :Gina commit with <C-^> on "gina-status" buffer
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
      \ 'status', '<C-^>',
      \ ':<C-u>Gina commit<CR>',
      \ {'noremap': 1, 'silent': 1},
      \)

" Execute :Gina status with <C-^> on "gina-commit" buffer
call gina#custom#mapping#nmap(
      \ 'commit', '<C-^>',
      \ ':<C-u>Gina status<CR>',
      \ {'noremap': 1, 'silent': 1},
      \)
