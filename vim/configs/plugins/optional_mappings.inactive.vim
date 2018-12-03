"---------------------------------------------------------------------------//
" Auto Closing Pairs
"---------------------------------------------------------------------------//
inoremap ( ()<left>
inoremap { {}<left>
inoremap ` ``<left>
inoremap ```<CR> ```<CR>```<Esc>O<Tab>
inoremap (<CR> (<CR>)<Esc>O<Tab>
inoremap {<CR> {<CR>}<Esc>O<Tab>
inoremap {; {<CR>};<Esc>O<Tab>
inoremap {, {<CR>},<Esc>O<Tab>
inoremap [<CR> [<CR>]<Esc>O<Tab>
inoremap ([ ([<CR>])<Esc>O<Tab>
inoremap [; [<CR>];<Esc>O<Tab>
inoremap [, [<CR>],<Esc>O<Tab>
