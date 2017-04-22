#!/bin/sh
# Setting ag as the default source for fzf
# sets ag as default source for fzf allow .gitignore to be respected this
# breaks the tabbing function : (

# FZF_DEFAULT_COMMAND='ag -g ""'
# export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
# I might need to escape the "!" character
# --no-ignore = this flag shows node modules etc
export FZF_DEFAULT_COMMAND='rg --files  --hidden --follow --glob "!.git/*"'

# export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
# export FZF_DEFAULT_COMMAND='ag --nobreak --nonumbers --noheading . | fzf'

# Changed FZF trigger to ; from **
# export FZF_COMPLETION_TRIGGER=';'

#Options to fzf command
# export FZF_COMPLETION_OPTS='+c -x'

# To apply to the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_TMUX=1

# Similar ish functionality with find as with ag??
# export FZF_DEFAULT_COMMAND="find . -type f -print -o -type l -print 2>
# /dev/null | sed s/^..//"


#=============================================================================================================
#                           FUNCTIONS
#=============================================================================================================

# fshow - git commit browser
fshow() {
  git log --graph --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
    --bind "ctrl-m:execute:
  (grep -o '[a-f0-9]\{7\}' | head -1 |
  xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
  {}
  FZF-EOF"
}

# Use ag instead of the default find command for listing candidates.
# - The first argument to the function is the base path to start traversal
# - Note that ag only lists files not directories
# - See the source code (completion.{bash,zsh}) for the details.
# _fzf_compgen_path() {
#   ag -g "" "$1"
# }


# Another function which is not based on grep or locate
cdf() {
  local file
  local dir
  file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# fbr - checkout git branch
fbr() {
  local branches branch
  branches=$(git branch) &&
    branch=$(echo "$branches" | fzf +s +m) &&
    git checkout $(echo "$branch" | sed "s/.* //")
}

# cf - fuzzy cd from anywhere
# ex: cf word1 word2 ... (even part of a file name)
# zsh autoload function


# cf() {
#   local file
#
#   # file="$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1)"
#   file="$(fzf --read0 -0 -1)"
#
#   if [[ -n $file ]]
#   then
#      if [[ -d $file ]]
#      then
#         cd -- $file
#      else
#         cd -- ${file:h}
#      fi
#   fi
# }

# fs [FUZZY PATTERN] - Select selected tmux session
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
    tmux switch-client -t "$session"
}

# unalias z
# z() {
#   if [[ -z "$*" ]]; then
#       cd "$(_z -l 2>&1 | fzf +s --tac | sed 's/^[0-9,.]* *//')"
#       else
#           _last_z_args="$@"
#             _z "$@"
#             fi
#           }
#
#           zz() {
#             cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf -q $_last_z_args)"
#           }

# Works with fasd to move dir with fuzzy searching
# z() {
#   local dir
#   dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
# }





# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}


