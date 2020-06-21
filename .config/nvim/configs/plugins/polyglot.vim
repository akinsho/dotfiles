""---------------------------------------------------------------------------//
" Polyglot
""---------------------------------------------------------------------------//
let g:polyglot_disabled           = []
let g:vim_json_syntax_conceal     = 1
let g:vue_disable_pre_processors  = 1


""---------------------------------------------------------------------------//
" CSV
""---------------------------------------------------------------------------//
let g:csv_autocmd_arrange      = 1
let g:csv_autocmd_arrange_size = 1024*1024
let g:csv_strict_columns       = 1
let g:csv_highlight_column     = 'y'
let g:csv_hiGroup = ""

""---------------------------------------------------------------------------//
" MARKDOWN {{{
""---------------------------------------------------------------------------//
let g:vim_markdown_strikethrough       = 1
let g:vim_markdown_fenced_languages    = [
      \'css',
      \'sh=bash',
      \'js=javascript',
      \'json',
      \'xml',
      \'html=html',
      \'py=python',
      \'sql',
      \'go',
      \'elm',
      \'vim',
      \'lua'
      \]
let g:vim_markdown_autowrite           = 1
let g:vim_markdown_json_frontmatter    = 1
let g:vim_markdown_frontmatter         = 1
let g:vim_markdown_toml_frontmatter    = 1
let g:vim_markdown_conceal             = 1
let g:vim_markdown_folding_disabled    = 0
let g:vim_markdown_conceal_code_blocks = 0
"}}}
