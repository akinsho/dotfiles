if !exists('g:test#typescript#mocha#file_pattern')
  let g:test#typescript#mocha#file_pattern = '\vspec?/.*\.(js|jsx|tsx|ts)$'
endif

function! test#typescript#mocha#test_file(file) abort
  return a:file =~# g:test#typescript#mocha#file_pattern
    \ && (test#typescript#has_package('mocha') || !empty(test#typescript#mocha#executable()))
endfunction

function! test#typescript#mocha#build_position(type, position) abort
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '--grep '.shellescape(name, 1)
    endif
    return [a:position['file'], name]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#typescript#mocha#build_args(args) abort
  let args = a:args

  if test#base#no_colors()
    let args = ['--no-colors'] + args
    let args = args + ['|', 'sed -e "s///g"']
  endif

  return args
endfunction

function! test#typescript#mocha#executable() abort
  if filereadable('node_modules/.bin/mocha')
    return 'node_modules/.bin/mocha'
  else
    return 'mocha'
  endif
endfunction

function! s:nearest_test(position)
  let name = test#base#nearest_test(a:position, g:test#typescript#patterns)
  return (len(name['namespace']) ? '^' : '') .
       \ test#base#escape_regex(join(name['namespace'] + name['test'])) .
       \ (len(name['test']) ? '$' : '')
endfunction
