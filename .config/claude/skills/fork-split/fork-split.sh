#!/usr/bin/env bash
# Opens a copy of the calling Claude conversation in a split beside it and
# hands the copy a task.
#
#   fork-split.sh [-n NAME] [-d right|left|above|below] TASK
#
# Uses tmux when running inside tmux, otherwise Rex.
set -euo pipefail

name="" direction=right
while getopts "n:d:" opt; do
	case "$opt" in
	n) name="$OPTARG" ;;
	d) direction="$OPTARG" ;;
	*) exit 2 ;;
	esac
done
shift $((OPTIND - 1))
task="${1:?usage: fork-split.sh [-n NAME] [-d DIRECTION] TASK}"

sid="${CLAUDE_CODE_SESSION_ID:?not running inside Claude Code}"

# --resume finds the transcript by project directory, so the fork must start
# in the directory the conversation was started in.
cwd=$(jq -r '.cwd' "$HOME/.claude/sessions/${CLAUDE_PID:?}.json")

if ! compgen -G "$HOME/.claude/projects/*/$sid.jsonl" >/dev/null; then
	echo "conversation has no transcript to fork yet" >&2
	exit 1
fi

# The copy inherits the request that asked for the fork, so it is told
# outright that it is the fork.
prompt="You are the forked session. Do this task directly in this session and do not fork again: $task"

cmd=(claude --resume "$sid" --fork-session)
[ -n "$name" ] && cmd+=(--name "$name")
cmd+=("$prompt")

if [ -n "${TMUX:-}" ]; then
	case "$direction" in
	right) flags=(-h) ;;
	left) flags=(-h -b) ;;
	below) flags=(-v) ;;
	above) flags=(-v -b) ;;
	*) echo "unknown direction: $direction" >&2; exit 2 ;;
	esac
	pane=$(tmux split-window "${flags[@]}" -t "${TMUX_PANE:?}" -c "$cwd" -P -F '#{pane_id}')
	tmux send-keys -t "$pane" -l "$(printf '%q ' "${cmd[@]}")"
	tmux send-keys -t "$pane" Enter
	echo "forked into tmux pane $pane"
elif [ -n "${REX_BLOCK:-}" ]; then
	rex run -b "$REX_BLOCK" --split="$direction" -c "$cwd" -- "${cmd[@]}"
else
	echo "not inside tmux or Rex" >&2
	exit 1
fi
