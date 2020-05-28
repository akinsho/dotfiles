" Error format from help docs possibly matching esy's output
setlocal errorformat+=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

if executable('esy')
  set makeprg=esy
endif

if exists("g:lexima#default_rules") 
  call lexima#add_rule({'char': "'", 'filetype': ['reason']})
  call lexima#add_rule({'char': '`', 'filetype': ['reason']})
endif
