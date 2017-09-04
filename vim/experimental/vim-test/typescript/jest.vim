if !exists('g:test#typescript#jest#file_pattern')
  let g:test#typescript#jest#file_pattern = '\v(__tests__/.*|(spec|test))\.(ts|tsx)$'
endif

function! test#typescript#jest#test_file(file) abort
  return a:file =~# g:test#typescript#jest#file_pattern
	  \ && (test#typescript#has_package('jest') || !empty(test#typescript#jest#executable()))
endfunction

function! test#typescript#jest#build_position(type, position) abort
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '-t '.shellescape(name, 1)
    endif
    return [a:position['file'], name]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#typescript#jest#build_args(args) abort
  return a:args
endfunction

function! test#typescript#jest#executable() abort
  if filereadable('node_modules/.bin/jest')
    return 'node_modules/.bin/jest'
  else
    return 'jest'
  endif
endfunction

function! s:nearest_test(position)
  let name = test#base#nearest_test(a:position, g:test#typescript#patterns)
  return (len(name['namespace']) ? '^' : '') .
       \ test#base#escape_regex(join(name['namespace'] + name['test'])) .
       \ (len(name['test']) ? '$' : '')
endfunction
