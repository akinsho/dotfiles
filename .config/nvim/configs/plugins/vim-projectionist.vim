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
      \     "alternate": "lib/view_models/{}_view_model.dart",
      \     "type": "source",
      \   },
      \   "lib/view_models/*_view_model.dart": {
      \     "alternate": ["lib/screens/{}.dart", "lib/widgets/{}.dart"],
      \     "type": "source",
      \   },
      \   "test/view_models/*_view_model_test.dart": {
      \     "alternate": "lib/view_models/{}_view_model.dart",
      \     "type": "test",
      \   }
      \  }
      \}

nnoremap <silent><leader>av :AV<CR>
nnoremap <silent><leader>at :Vtest<CR>
nnoremap <silent><leader>A :A<CR>
