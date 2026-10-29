#!/usr/bin/env bash
# Records which coding-agent conversation runs in each tmux pane, and resumes
# them after tmux-resurrect rebuilds the panes.
#
# Each agent provides three functions:
#   <agent>_list            prints "pane_id<TAB>cwd<TAB>session_id" per live session
#   <agent>_resumable <id>  succeeds if the session can be resumed
#   <agent>_resume <id>     prints the command that resumes it
#   <agent>_fork <id>       prints the command that resumes a copy of it
set -euo pipefail

agents=(claude)
state="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect/agent-sessions.tsv"

# Claude writes ~/.claude/sessions/<pid>.json for each running instance, with
# the current sessionId and the tmux pane it runs in. The pid is the real
# Claude process, which sits below wrapper processes in the pane's tree.
claude_list() {
	local f pid pane cwd sid
	for f in "$HOME"/.claude/sessions/*.json; do
		[ -e "$f" ] || continue
		IFS=$'\t' read -r pid pane cwd sid < <(
			jq -r 'select(.kind == "interactive" and (.tmux // "") != "")
				| [.pid, (.tmux | sub(".*\\."; "")), .cwd, .sessionId] | @tsv' "$f" 2>/dev/null
		) || continue
		kill -0 "$pid" 2>/dev/null || continue
		printf '%s\t%s\t%s\n' "$pane" "$cwd" "$sid"
	done
}

# Conversations with no messages have no transcript and cannot be resumed.
claude_resumable() {
	compgen -G "$HOME/.claude/projects/*/$1.jsonl" >/dev/null
}

claude_resume() {
	printf 'claude --resume %s' "$1"
}

claude_fork() {
	printf 'claude --resume %s --fork-session' "$1"
}

save() {
	local agent pane cwd sid target tmp
	tmp=$(mktemp "$state.XXXXXX")
	for agent in "${agents[@]}"; do
		"${agent}_list" | while IFS=$'\t' read -r pane cwd sid; do
			target=$(tmux display -p -t "$pane" '#{session_name}:#{window_index}.#{pane_index}' 2>/dev/null) || continue
			printf '%s\t%s\t%s\t%s\n' "$target" "$agent" "$cwd" "$sid"
		done
	done | sort -u -t $'\t' -k1,1 >"$tmp"
	mv "$tmp" "$state"
}

restore() {
	[ -f "$state" ] || return 0
	local target agent cwd sid shell
	while IFS=$'\t' read -r target agent cwd sid; do
		[[ " ${agents[*]} " == *" $agent "* ]] || continue
		[[ "$sid" =~ ^[0-9A-Za-z_-]+$ ]] || continue
		"${agent}_resumable" "$sid" || continue
		shell=$(tmux display -p -t "$target" '#{pane_current_command}' 2>/dev/null) || continue
		case "$shell" in
		bash | zsh | fish | sh) ;;
		*) continue ;;
		esac
		tmux send-keys -t "$target" "cd $(printf '%q' "$cwd") && $("${agent}_resume" "$sid")" Enter
	done <"$state"
}

# Opens the conversation running in <pane_id> as a copy in a split of <target>.
fork() {
	local source="$1" target="$2" agent pane cwd sid new
	for agent in "${agents[@]}"; do
		while IFS=$'\t' read -r pane cwd sid; do
			[ "$pane" = "$source" ] || continue
			if ! "${agent}_resumable" "$sid"; then
				tmux display-message "No messages to fork yet"
				return 0
			fi
			new=$(tmux split-window -h -t "$target" -c "$cwd" -P -F '#{pane_id}')
			tmux send-keys -t "$new" "$("${agent}_fork" "$sid")" Enter
			return 0
		done < <("${agent}_list")
	done
	tmux display-message "No agent session in this pane"
}

case "${1:-}" in
save) save ;;
restore) restore ;;
fork) fork "${2:?pane id required}" "${3:?target pane id required}" ;;
*)
	echo "usage: $0 save|restore|fork <pane_id> <target_pane_id>" >&2
	exit 2
	;;
esac
