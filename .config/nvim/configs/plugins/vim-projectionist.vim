if !PluginLoaded('vim-projectionist')
  finish
endif

let g:projectionist_heuristics = get(g:, 'projectionist_heuristics', {})

let g:projectionist_heuristics['*.go'] = {
      \ '*.go': { 'alternate': '{}_test.go', 'type': 'source' },
      \ '*_test.go': { 'alternate': '{}.go', 'type': 'test' }
      \ }

nnoremap <silent><leader>av :AV<CR>
nnoremap <silent><leader>A :A<CR>
