call gina#custom#mapping#nmap('/.*', '<Tab>', '<Plug>(gina-builtin-choice)')
call gina#custom#mapping#vmap('/.*', '<Tab>', '<Plug>(gina-builtin-choice)')
call gina#custom#execute('/.*', 'silent! nunmap <buffer> a')
call gina#custom#execute('/.*', 'silent! vunmap <buffer> a')
call gina#custom#execute('/.*', 'silent! nunmap <buffer> <c-j>')
call gina#custom#execute('/.*', 'silent! vunmap <buffer> <c-k>')

call gina#custom#command#alias('branch', 'br')
call gina#custom#command#option('br', '-v', 'v')
call gina#custom#command#alias('status', 'st')

call gina#custom#command#option(
      \ 'commit', '-v|--verbose'
      \)

call gina#custom#execute(
      \ '/\%(status\|branch\|ls\|grep\|changes\|tag\)',
      \ 'setlocal winfixheight',
      \)

call gina#custom#command#option(
      \ '/\%(log\|reflog\)',
      \ '--opener', 'vsplit'
      \)

" Add "--opener=split" to branch/changes/grep/log
call gina#custom#command#option(
      \ '/\%(branch\|changes\|grep\|status\|commit\|log\)',
      \ '--group', 'short'
      \)

" Execute :Gina commit with cc on "gina-status" buffer
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

nnoremap <silent><nowait> <localleader>gs :Gina status<cr>
