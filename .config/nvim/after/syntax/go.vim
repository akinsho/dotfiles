if hlexists('goComment')
  syntax match NoSpellUri '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell containedin=goComment,go.*String
  syntax match NoSpellAcronym '\<\(\u\|\d\)\{3,}s\?\>' transparent contains=@NoSpell containedin=goComment,go.*String
  highlight def link NoSpellUri URIHighlight
endif
