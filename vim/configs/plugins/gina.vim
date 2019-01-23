" Plugin Mappings
call gina#custom#mapping#nmap('/.*', '<Tab>', '<Plug>(gina-builtin-choice)')
call gina#custom#mapping#vmap('/.*', '<Tab>', '<Plug>(gina-builtin-choice)')
call gina#custom#execute('/.*', 'silent! nunmap <buffer> <c-j>')
call gina#custom#execute('/.*', 'silent! nunmap <buffer> <c-k>')
" TODO: prevent this command from closing vim
call gina#custom#execute('/.*', 'silent! nnoremap <buffer> q :q<cr>')
call gina#custom#execute('/.*', 'silent! nnoremap <buffer> Q :q!<cr>')

" Aliases
call gina#custom#command#alias('branch', 'br')
call gina#custom#command#option('br', '-v', 'v')
call gina#custom#command#alias('status', 'st')

" Options
call gina#custom#command#option(
      \ 'commit', '-v|--verbose'
      \)

" Echo chunk info with j/k
call gina#custom#mapping#nmap(
      \ 'blame', 'j',
      \ 'j<Plug>(gina-blame-echo)'
      \)

call gina#custom#mapping#nmap(
      \ 'blame', 'k',
      \ 'k<Plug>(gina-blame-echo)'
      \)

call gina#custom#execute(
      \ '/\%(status\|branch\|ls\|grep\|changes\|tag\)',
      \ 'setlocal winfixheight',
      \)

call gina#custom#command#option(
      \ '/\%(log\|reflog\)',
      \ '--opener', 'vsplit'
      \)

" Open these window types as small re-usable splits
"NOTE: This and the command below should be specified separately
" call gina#custom#command#option(
"       \ '/\%(status\|commit\|branch\)',
"       \ '--opener', &previewheight . 'split',
"       \)

" Open diffs in a vsplit but group all diff splits i.e. reopen new splits in the same window
" call gina#custom#command#option('diff', '--opener', 'vsplit')
" call gina#custom#command#option('diff', '--group', 'diffs')

call gina#custom#mapping#nmap(
      \ 'diff', 'cc',
      \ ':<C-u>Gina status<CR>',
      \ {'noremap': 1, 'silent': 1},
      \)

call gina#custom#command#option(
      \ '/\%(status\|commit\|branch\|diff\)',
      \ '--opener', 'vsplit',
      \)

call gina#custom#command#option(
      \ '/\%(status\|commit\|branch\|diff\)',
      \ '--group', 'sidepanel'
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

" General Mappings
nnoremap <silent><nowait> <localleader>gs :Gina status<cr>
nnoremap <silent><localleader>gb :Gina branch<cr>
nnoremap <silent><localleader>gbl :Gina blame<cr>
nnoremap <silent><nowait> <localleader>gc :Gina commit<cr>
nnoremap <silent><nowait> <localleader>gp :Gina push<cr>
nnoremap <silent><nowait> <localleader>gl :Gina pull<cr>

augroup GinaCmds
  au!
  autocmd BufLeave *
        \ if &ft ==# 'gina-branch'
        \ |   execute('CleanBufferList')
        \ | endif
augroup END
