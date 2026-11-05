#!/bin/sh
# Claude Code status line: a git line for the session's directory, then the
# output of the command given as arguments, if any, fed the same JSON on stdin.
#
#   "statusLine": { "type": "command", "command": "~/.claude/hooks/statusline.sh [command...]" }

input=$(cat)
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')

git_line() {
  rev=$(git -C "$1" rev-parse --show-toplevel --git-dir --git-common-dir 2>/dev/null) || return
  top=$(printf '%s\n' "$rev" | sed -n 1p)
  dir=$(cd "$1" && cd "$(printf '%s\n' "$rev" | sed -n 2p)" && pwd -P)
  common=$(cd "$1" && cd "$(printf '%s\n' "$rev" | sed -n 3p)" && pwd -P)

  git -C "$1" --no-optional-locks status --porcelain=v2 --branch 2>/dev/null |
    awk -v top="$top" -v dir="$dir" -v common="$common" '
      function base(p) { sub(/\/+$/, "", p); n = split(p, a, "/"); return a[n] }
      /^# branch.oid / { oid = substr($3, 1, 7) }
      /^# branch.head / { head = $3 }
      /^# branch.ab / { ahead = substr($3, 2) + 0; behind = substr($4, 2) + 0 }
      !/^#/ { changed++ }
      END {
        repo = base(top); worktree = ""
        if (dir != common) {
          parent = common; sub(/\/[^\/]+\/?$/, "", parent)
          repo = base(parent); worktree = base(top)
        }
        if (head == "(detached)") head = oid
        line = "\033[2m\xef\x90\x81\033[22m " repo "  \033[35m\xef\x90\x98 " head "\033[39m"
        if (worktree != "") line = line "  \033[2m\xef\x90\x94 " worktree "\033[22m"
        if (changed) line = line "  \033[33m±" changed "\033[39m"
        if (ahead) line = line "  \033[32m\xef\x90\xb1" ahead "\033[39m"
        if (behind) line = line "  \033[31m\xef\x90\xb3" behind "\033[39m"
        print line
      }'
}

[ -n "$cwd" ] && git_line "$cwd"
[ $# -gt 0 ] && printf '%s' "$input" | "$@"
exit 0
