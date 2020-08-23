if !PluginLoaded("vim-which-key")
  finish
endif

" remove link between diff added and vim which key
highlight WhichKeySeperator guifg=green guibg=background

let g:which_leader_key_map = {
      \ '0':      'which_key_ignore',
      \ '1':      'which_key_ignore',
      \ '2':      'which_key_ignore',
      \ '3':      'which_key_ignore',
      \ '4':      'which_key_ignore',
      \ '5':      'which_key_ignore',
      \ '6':      'which_key_ignore',
      \ '7':      'which_key_ignore',
      \ '8':      'which_key_ignore',
      \ '9':      'which_key_ignore',
      \ 'A':      'projectionist: edit alternate',
      \ 'av':     'projectionist: vsplit alternate',
      \ 'a':      'coc codeaction (for text object)',
      \ 'c':      {
      \   'name': '+coc-command',
      \   'f':    'search: cursor word',
      \   'y':    'list: yank',
      \   'b':    'list: branches',
      \   'd':    'list: diagnostic',
      \   'c':    'list: command',
      \   'e':    'list: extension',
      \   'o':    'list: outline',
      \   's':    'list: symbol',
      \   'm':    'list: marketplace',
      \   'r':    'list: resume',
      \   'a':    'codelens: action'
      \},
      \ 'd': {
      \ 'name': '+debug',
      \ 't': {
      \   'name': '+treesitter',
      \   'e': 'treesitter: enable highlight (buffer)',
      \   'd': 'treesitter: disable highlight (buffer)',
      \   'p': 'treesitter: toggle playground',
      \}
      \},
      \ 'h':      {
      \   'name': '+git-hunk',
      \   's':    'stage',
      \   'u':    'undo',
      \},
      \ 'r':      {
      \ 'name':   '+coc-edit',
      \   'a':    'codeaction: entire file',
      \   'r':    'refactor',
      \   'f':    'fix current line',
      \   'n':    'rename cursor word'
      \ },
      \ 'n':      {
      \  'name':  '+new',
      \  'f':     'create a new file',
      \  's':     'create new file in a split',
      \ },
      \ 'f':      'find cursor word (fzf)',
      \ 'F':      'find word (prompt)',
      \ 'E':      'show token under the cursor',
      \ 'p':      {
      \   'name': '+vim-plug',
      \   'u':    'update',
      \   'c':    'clean',
      \   's':    'status',
      \   'i':    'install'
      \ },
      \ 'q':       {
      \   'name':   '+quit',
      \   'w':      'sayonara: close window (and buffer)',
      \   'q':      'sayonara: delete buffer',
      \},
      \ 'g':      'grep word under the cursor',
      \ 'l':      {
      \   'name': '+list',
      \   'i':    'toggle location list',
      \   's':    'toggle quickfix'
      \ },
      \ 'e':      {
      \   'name': '+edit',
      \   'v':    'open vimrc in a new buffer',
      \   'z':    'open zshrc in a new buffer',
      \   't':    'open tmux config in a new buffer',
      \},
      \ 'o':      {
      \   'name': '+only',
      \   'n':    'close all other buffers',
      \ },
      \ 't':      {
      \   'name': '+tab',
      \   'c':    'tab close',
      \   'n':    'tab edit current buffer',
      \},
      \ 'u':      'toggle undo tree',
      \ ',s':     'subversive: range',
      \ 's':      'subversive: current word',
      \ 'ss':     'subversive: entire line',
      \ 'S':      'subversive: till end of line',
      \ 'v':      'vista: toggle',
      \ 'w':      'save',
      \ 'wt':     'open vimwiki index',
      \ 'ws':     'vimwiki UI select',
      \ 'z':      'zoom in current buffer',
      \ 'Z':      'zoom in with tab',
      \ 'sw':     'swap buffers horizontally',
      \ 'so':     'source current buffer',
      \ 'sv':     'source init.vim',
      \ 'U':      'uppercase all word',
      \ ",":      'go to previous buffer',
      \ "=":      'make windows equal size',
      \ ")":      'wrap with parens',
      \ "}":      'wrap with braces',
      \ "\"":     'wrap with double quotes',
      \ "'":      'wrap with single quotes',
      \ "`":      'wrap with back ticks',
      \ "[":      'replace cursor word in file',
      \ "]":      'replace cursor word in line',
      \ "<Tab>":  ['bnext', 'Go to next buffer'],
      \ "<F9>":   'vimspector: toggle breakpoint'
      \}

let g:which_localleader_key_map = {
      \ 'f':         {
      \   'name':    '+fzf',
      \   'c':       'commits',
      \   'f':       'files',
      \   '?':       'help',
      \   'd':       'dotfiles',
      \   'o':       'buffers',
      \   'h':       'history',
      \},
      \ 'g':         {
      \   'name':    '+git-commands',
      \   'b':       {
      \      'name': '+git-information',
      \      'o':    'coc: git open in browser',
      \      'l':    'git blame',
      \    },
      \   'c':       'git commit',
      \   'cm':      'checkout master',
      \   'd':       'git diff (split)',
      \   'l':       'git pull (non-async)',
      \   'o':       'git checkout <branchname>',
      \   'v':       'coc: view commit',
      \   'm':       'git move file',
      \   'n':       'git checkout new branch',
      \   'r':       {
      \      'name': '+git-remove',
      \      'e':    'git read (remove changes)',
      \      'm':    'git remove',
      \},
      \   's':       'git status',
      \   'S':       'fzf: git status',
      \   'u':       'coc: copy git url',
      \   'p':       'git push (async)',
      \   'pf':      'git push --force (async)',
      \   'pt':      'git push (terminal)',
      \   '*':       'git grep current word',
      \},
      \   'w':       {
      \     'name':  '+window',
      \     'h':     'change two vertically split windows to horizontal splits',
      \     'v':     'change two horizontally split windows to vertical splits',
      \     'x':     'swap current window with the next',
      \     'j':     'resize: downwards',
      \     'k':     'resize: upwards'
      \},
      \ 'l':         'redraw window',
      \ 'z':         'center view port',
      \ 't':         {
      \   'name':    '+vim-test',
      \   'n':       'test nearest',
      \   'f':       'test file',
      \   's':       'test suite',
      \},
      \ 's':         {
      \  'name':     '+session',
      \  's':        'save'
      \} ,
      \ ',':         'add comma to end of line',
      \ ';':         'add semicolon to end of line',
      \ '?':         'search for word under cursor in google',
      \ '!':         'search for word under cursor in google',
      \ '<Tab>':     ['bnext', 'open vim bufferlist'],
      \ "[":         'abolish: subsitute cursor word in file',
      \ "]":         'abolish: substitute cursor word on line',
      \}

let g:which_key_use_floating_win       = 0
let g:which_key_disable_default_offset = 1

if !g:which_key_use_floating_win
  autocmd! FileType which_key
  autocmd  FileType which_key set laststatus=0
        \| autocmd BufLeave <buffer> set laststatus=2
endif

call which_key#register(',', 'g:which_leader_key_map')
call which_key#register('<Space>', 'g:which_localleader_key_map')
nnoremap <silent> <localleader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <leader>           :<c-u>WhichKey  ','<CR>
