if hlexists('luaComment')
  syntax match NoSpellAcronym '\<\(\u\|\d\)\{3,}s\?\>' transparent contains=@NoSpell containedin=lua.*Comment,lua.*String
endif
