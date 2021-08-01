call wilder#enable_cmdline_enter()
cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"
call wilder#set_option('modes', ['/', '?', ':'])

call wilder#set_option('pipeline', [
    \ wilder#branch(
    \   wilder#python_file_finder_pipeline({
    \     'file_command': ['rg', '--files'],
    \     'filters': ['fuzzy_filter', 'difflib_sorter'],
    \   }),
    \   wilder#cmdline_pipeline(#{
    \     fuzzy: 1,
    \     sorter: wilder#python_difflib_sorter(),
    \   }),
    \   wilder#python_search_pipeline(#{
    \     pattern: 'fuzzy',
    \   }),
    \ ),
    \])

let s:highlighters = [
  \ wilder#lua_pcre2_highlighter(),
  \ wilder#lua_fzy_highlighter(),
  \]

call wilder#set_option('renderer', wilder#renderer_mux({
    \ ':': wilder#popupmenu_renderer(#{
    \   highlighter: s:highlighters,
    \   left: [
    \     wilder#popupmenu_devicons(),
    \   ],
    \   right: [
    \     ' ',
    \     wilder#popupmenu_scrollbar(),
    \   ],
    \ }),
    \ '/': wilder#wildmenu_renderer(#{
    \   highlighter: s:highlighters,
    \   separator: ' · ',
    \ }),
    \})
    \)
