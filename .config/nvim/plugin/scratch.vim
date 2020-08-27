function! ScratchLine() abort
  return "%#Comment#%t\ Quit\ with\ Q,\ close\ window\ with\ q"
endfunction

let s:supported_types = {
      \ 'javascript': 'js',
      \ 'typescript': 'ts',
      \ 'typescriptreact': 'tsx',
      \ 'javascriptreact': 'jsx',
      \ 'config': 'conf'
      \}

function! s:scratch(...) abort
  let ft = get(a:, '1', '')
  if strlen(ft) > 0
    let ft_to_use = get(s:supported_types, ft, ft)
    " set the window's filename so that the filetype can
    " be picked up by the tabline
    execute "vnew Scratch.".ft_to_use
    execute "setfiletype ".ft
  else
    vnew Scratch
  endif
  setlocal buftype=nofile bufhidden=hide noswapfile
  setlocal statusline=%!ScratchLine()
  nnoremap <nowait><silent><buffer> Q :confirm bd!<CR>
  nnoremap <nowait><silent><buffer> q :close<CR>
  autocmd! BufEnter <buffer> setlocal statusline=%!ScratchLine()
endfunction

command! -complete=filetype -nargs=? ScratchBuffer call s:scratch(<f-args>)
