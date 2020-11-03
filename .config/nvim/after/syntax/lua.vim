if hlexists('luaComment')
  syntax match NoSpellUri '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell containedin=lua.*Comment
  syntax match NoSpellAcronym '\<\(\u\|\d\)\{3,}s\?\>' transparent contains=@NoSpell containedin=lua.*Comment,lua.*String
  highlight def link NoSpellUri URIHighlight
endif
