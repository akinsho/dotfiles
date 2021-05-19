if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" Enable automatic indentation (2 spaces) if variable g:dart_style_guide is set 
setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2

setlocal formatoptions-=t

" Set 'comments' to format dashed lists in comments.
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,:///,://

setlocal commentstring=//%s
let s:win_sep = (has('win32') || has('win64')) ? '/' : ''
let &l:errorformat =
  \ join([
  \   ' %#''file://' . s:win_sep . '%f'': %s: line %l pos %c:%m',
  \   '%m'
  \ ], ',')

setlocal includeexpr=dart#resolveUri(v:fname)
setlocal isfname+=:
setlocal iskeyword+=$

lua << EOF
-- Open flutter only commands in dart files
local success, wk = pcall(require, 'which-key')
if not success then return end
wk.register({
  cc = {"<Cmd>Telescope flutter commands<CR>", "flutter: commands"},
  d = {
    name = "+flutter",
    d = {"<Cmd>FlutterDevices<CR>", "flutter: devices"},
    b = {
        "<cmd>TermExec cmd='flutter pub run build_runner build --delete-conflicting-outputs'<CR>",
        "flutter: run code generation"
    },
    e = {"<Cmd>FlutterEmulators<CR>", "flutter: emulators"},
    o = {"<Cmd>FlutterOutline<CR>", "flutter: outline"},
    q = {"<Cmd>FlutterQuit<CR>", "flutter: quit"},
    r = {
      name = "+dev-server",
      n = {"<Cmd>FlutterRun<CR>", "run"},
      s = {"<Cmd>FlutterRestart<CR>", "restart"}
      }
    }
}, {prefix = "<leader>"})
EOF

let b:undo_ftplugin = 'setl et< fo< sw< sts< com< cms< inex< isf<'
