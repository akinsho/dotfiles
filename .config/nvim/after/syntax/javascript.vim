if hlexists('jsComment')
  syntax match NoSpellUri '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell containedin=jsComment
  syntax match NoSpellAcronym '\<\(\u\|\d\)\{3,}s\?\>' transparent contains=@NoSpell containedin=jsComment,js.*String
  highlight def link NoSpellUri URIHighlight
endif
