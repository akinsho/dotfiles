call wilder#enable_cmdline_enter()
cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"
call wilder#set_option('modes', ['/', '?', ':'])

call wilder#set_option('pipeline', [
    \ wilder#branch(
    \   wilder#python_file_finder_pipeline(#{
    \     file_command: ['rg', '--files'],
    \     filters: ['fuzzy_filter', 'difflib_sorter'],
    \   }),
    \   wilder#cmdline_pipeline(#{
    \     fuzzy: 1,
    \     sorter: wilder#python_difflib_sorter(),
    \     fuzzy_filter: wilder#lua_fzy_filter(),
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

let s:menu_accent = wilder#make_hl(
    \ 'WilderAccent',
    \ 'Pmenu',
    \ [{}, {}, #{foreground: '#f4468f'}]
    \)

call wilder#set_option('renderer', wilder#renderer_mux({
    \ ':': wilder#popupmenu_renderer(
    \        wilder#popupmenu_border_theme(#{
    \          winblend: 3,
    \          empty_message: wilder#popupmenu_empty_message_with_spinner(),
    \          highlights: #{
    \           default: 'Pmenu',
    \           border: 'FloatBorder',
    \           accent: s:menu_accent,
    \         },
    \         border: 'rounded',
    \         highlighter: s:highlighters,
    \         left: [
    \          wilder#popupmenu_devicons(),
    \          wilder#popupmenu_buffer_flags({
    \            'flags': ' a + ',
    \            'icons': {'+': '', 'a': '', 'h': ''},
    \          }),
    \         ],
    \         right: [' ', wilder#popupmenu_scrollbar()],
    \        })
    \     ),
    \ '/': wilder#wildmenu_renderer(#{
    \   highlighter: s:highlighters,
    \   separator: ' · ',
    \ }),
    \})
    \)
