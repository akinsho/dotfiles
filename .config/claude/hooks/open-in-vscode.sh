#!/usr/bin/env bash
# Passing the enclosing .code-workspace alongside the file is what picks the
# window: the file alone goes to whichever window was focused last, which may
# belong to an unrelated checkout.
set -u

file=$(jq -r '.tool_response.filePath // .tool_input.file_path // empty')
[ -n "$file" ] || exit 0
[ -f "$file" ] || exit 0

case "$(dirname "$(readlink -f "$file" 2>/dev/null || echo "$file")")/" in
  */dotfiles/* | */dotfiles.*/*) exit 0 ;;
esac

code_bin="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
command -v code >/dev/null 2>&1 && code_bin=code

dir=$(dirname "$file")
workspace=""
while [ "$dir" != "/" ]; do
  for candidate in "$dir"/*.code-workspace; do
    if [ -f "$candidate" ]; then
      workspace="$candidate"
      break 2
    fi
  done
  dir=$(dirname "$dir")
done

if [ -n "$workspace" ]; then
  "$code_bin" "$workspace" "$file"
else
  "$code_bin" --reuse-window "$file"
fi
