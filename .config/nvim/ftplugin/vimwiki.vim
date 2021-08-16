" Vimwiki mappings should all go here
"
" Restore overridden mappings by remapping the keys
" NOTE: this works because vimwiki checks that we haven't already created
" a mapping for these commands before it uses it's default
"
" you can do let g:vimwiki_mappings = { 'links': 0 }
" but this would involve having to manually map about 12 keys
nmap <buffer> ] <Plug>VimwikiPrevLink
nmap <buffer> [ <Plug>VimwikiNextLink
nmap <buffer> <Leader>tt <Plug>VimwikiToggleListItem
