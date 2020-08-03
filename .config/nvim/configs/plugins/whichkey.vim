if !PluginLoaded("vim-which-key")
  finish
endif

" Define prefix dictionary
let g:which_leader_key_map = {
      \ '0':      'go to buffer 0',
      \ '1':      'go to buffer 1',
      \ '2':      'go to buffer 2',
      \ '3':      'go to buffer 3',
      \ '4':      'go to buffer 4',
      \ '5':      'go to buffer 5',
      \ '6':      'go to buffer 6',
      \ '7':      'go to buffer 7',
      \ '8':      'go to buffer 8',
      \ '9':      'go to buffer 9',
      \ '10':     'which_key_ignore',
      \ 'A':      'projectionist: edit alternate',
      \ 'av':     'projectionist: vsplit alternate',
      \ 'a':      'coc codeaction (for text object)',
      \ 'c':      {
      \   'name': '+coc command',
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
      \ 'h':      {
      \   'name': '+git hunk',
      \   's':    'stage',
      \   'u':    'undo',
      \},
      \ 'r':      {
      \ 'name':   '+coc edit',
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
      \   'name': '+vim plug',
      \   'u':    'update',
      \   'c':    'clean',
      \   's':    'status',
      \   'i':    'install'
      \ },
      \ 'q':      'sayonara: close buffer (keep window)',
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
      \ "[":      'open space above',
      \ "]":      'insert space below',
      \ "<Tab>":  ['bnext', 'Go to next buffer'],
      \}

let g:which_localleader_key_map = {
      \ 'g':         {
      \   'name':    '+git commands',
      \   'b':       {
      \      'name': '+git information',
      \      'o':    'coc: git open in browser',
      \      'l':    'git blame',
      \    },
      \   'c':       'git commit',
      \   'cm':      'checkout master',
      \   'd':       'git diff (split)',
      \   'l':       'git pull (non-async)',
      \   'o':       'fzf: buffers',
      \   'v':       'coc: view commit',
      \   'm':       'git move file',
      \   'n':       'git checkout new branch',
      \   'r':       {
      \      'name': '+git remove',
      \      'e':    'git read (remove changes)',
      \      'm':    'git remove',
      \},
      \   's':       'git status',
      \   'S':       'fzf: git status',
      \   'u':       'coc: copy git url',
      \   'p':       'git push (terminal)',
      \   'pf':      'git push --force (terminal)',
      \},
      \   'w':       {
      \     'name':  '+window',
      \     'h':     'change two vertically split windows to horizontal splits',
      \     'v':     'change two horizontally split windows to vertical splits',
      \},
      \ 'l':         'redraw window',
      \ 'q':         'close buffer (kill window)',
      \ 'z':         'center view port',
      \ 't':         {
      \   'name':    '+vim test',
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
