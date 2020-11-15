if hlexists('jsComment')
  syntax match NoSpellAcronym '\<\(\u\|\d\)\{3,}s\?\>' transparent contains=@NoSpell containedin=jsComment,js.*String
endif
