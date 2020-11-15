if hlexists('goComment')
  syntax match NoSpellAcronym '\<\(\u\|\d\)\{3,}s\?\>' transparent contains=@NoSpell containedin=goComment,go.*String
endif
