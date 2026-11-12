#!/usr/bin/env bash
# Links the shared Obsidian config in this folder into a vault's .obsidian/.
#
# app.json and workspace*.json stay per vault: workspace holds each vault's open
# files and layout, and app.json carries settings that differ between vaults,
# such as opening to the daily note.
#
# Obsidian can replace a linked file with a real one when it saves it. Re-run
# this to relink; a replaced file that differs from the shared copy is kept as
# <name>.local-<timestamp> so nothing is lost.
#
# Usage: link-vault.sh <vault> [<vault> ...]
#        link-vault.sh --check <vault> [<vault> ...]
set -euo pipefail

shared="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
items=(
  appearance.json
  community-plugins.json
  core-plugins.json
  daily-notes.json
  graph.json
  types.json
  plugins
  snippets
  themes
)

check=false
if [ "${1:-}" = "--check" ]; then
  check=true
  shift
fi
[ $# -gt 0 ] || { echo "usage: $(basename "$0") [--check] <vault>..." >&2; exit 2; }

status=0
for vault in "$@"; do
  config="$vault/.obsidian"
  [ -d "$vault" ] || { echo "skip: $vault does not exist" >&2; status=1; continue; }
  mkdir -p "$config"

  for item in "${items[@]}"; do
    target="$config/$item"
    source="$shared/$item"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
      continue
    fi

    if $check; then
      echo "not linked: $target"
      status=1
      continue
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
      if diff -rq "$target" "$source" >/dev/null 2>&1; then
        rm -rf "$target"
      else
        backup="$target.local-$(date +%Y%m%d%H%M%S)"
        mv "$target" "$backup"
        echo "kept: $backup"
      fi
    fi

    ln -s "$source" "$target"
    echo "linked: $target"
  done
done
exit $status
