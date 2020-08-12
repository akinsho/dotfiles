if !PluginLoaded('vim-projectionist')
  finish
endif

let g:projectionist_heuristics = {
      \ "*.go": {
      \   "*.go": { "alternate": "{}_test.go", "type": "source" },
      \   "*_test.go": { "alternate": "{}.go", "type": "test" },
      \},
      \ "lib/*.dart": {
      \   "lib/screens/*.dart": {
      \     "alternate": "lib/screens/view_models/{}_view_model.dart",
      \     "type": "source",
      \   },
      \   "lib/screens/view_models/*_view_model.dart": {
      \     "alternate": "lib/screens/{}.dart",
      \     "type": "source",
      \   }
      \  }
      \}

nnoremap <silent><leader>av :AV<CR>
nnoremap <silent><leader>A :A<CR>
