if !exists('g:test#dart#cargotest#file_pattern')
  let g:test#dart#flutter#file_pattern = '\v_test\.dart$'
endif

function test#dart#flutter#test_file(file) abort
  return a:file =~# g:test#dart#flutter#file_pattern
endfunction


function test#dart#flutter#build_position(type, position) abort
  if a:type ==# 'suite'
    return []
  else
    let path = './'.fnamemodify(a:position['file'], ':h')

    if a:type ==# 'file' || a:type ==# 'nearest'
      return [path]
    endif
  endif
endfunction


function test#dart#flutter#build_args(args) abort
  return a:args
endfunction

function test#dart#flutter#executable() abort
  if executable('flutter')
    return 'flutter test'
  endif
endfunction
