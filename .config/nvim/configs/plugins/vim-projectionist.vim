if !v:lua.plugin_loaded('vim-projectionist')
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
      \     "type": "view",
      \   },
      \   "lib/view_models/*_view_model.dart": {
      \     "alternate": ["lib/screens/{}.dart", "lib/widgets/{}.dart"],
      \     "type": "model",
      \     "template": ["class {camelcase|capitalize}ViewModel extends BaseViewModel {", "}"]
      \   },
      \   "test/view_models/*_view_model_test.dart": {
      \     "alternate": "lib/view_models/{}_view_model.dart",
      \     "type": "test",
      \     "template": ["void main() async {", "  group('TODO', () {", "// TODO:", "})", "}"]
      \   }
      \  }
      \}

nnoremap <silent><leader>av :AV<CR>
nnoremap <silent><leader>at :Vtest<CR>
nnoremap <silent><leader>A :A<CR>
