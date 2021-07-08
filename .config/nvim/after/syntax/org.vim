" Things to note:
" 1. containedin and contained prevent the parent highlight from being wiped
" 2. Concealed characters have to use the Conceal highlight group
syntax match OrgHeadlineStar1 /^\*\s/me=e-1 conceal cchar=◉ containedin=OrgHeadlineLevel1 contained
syntax match OrgHeadlineStar2 /^\*\{2}\s/me=e-1 conceal cchar=○ containedin=OrgHeadlineLevel2 contained
syntax match OrgHeadlineStar3 /^\*\{3}\s/me=e-1 conceal cchar=✸ containedin=OrgHeadlineLevel3 contained
syntax match OrgHeadlineStar4 /^\*{4}s/me=e-1 conceal cchar=✿ containedin=OrgHeadlineLevel4 contained
