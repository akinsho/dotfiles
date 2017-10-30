augroup TsuSetup
au User CmSetup call cm#register_source({'name' : 'cm-css',
      \ 'priority': 1,
      \ 'scoping': 3,
      \ 'scopes': ['tsx','typescript', 'typescript.tsx'],
      \ 'abbreviation': 'TS',
      \ 'word_pattern': '[\w\-]+',
      \ 'cm_refresh_patterns':['[\w\-]+\s*:\s+'],
      \ 'cm_refresh': {'omnifunc': 'tsuquyomi#complete'},
      \ })
augroup END

let g:cm_sources_override = {
                  \ 'cm-tags': {'enable':0}
                  \ }
