setlocal foldtext=utils#braces_fold_text()
" Error format from help docs possibly matching esy's output
setlocal errorformat+=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

if executable('esy')
  set makeprg=esy
endif
