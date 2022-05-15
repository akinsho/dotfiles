# Copied from: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/last-working-dir
# Flag indicating if we've previously jumped to last directory
typeset -g ZSH_LAST_WORKING_DIRECTORY

# Ensure cache directory exists.
if [ -z "$ZSH_CACHE_DIR" -o ! -d "$ZSH_CACHE_DIR" ]; then
  ZSH_CACHE_DIR="$HOME/.zsh/cache"
  mkdir -p "$ZSH_CACHE_DIR"
fi

# Updates the last directory once directory is changed
chpwd_last_working_dir() {
  # Don't run in subshells
  [[ "$ZSH_SUBSHELL" -eq 0 ]] || return 0
  # Add ".$SSH_USER" suffix to cache file if $SSH_USER is set and non-empty
  local cache_file="$ZSH_CACHE_DIR/last-working-dir${SSH_USER:+.$SSH_USER}"
  pwd >| "$cache_file"
}

# Changes directory to the last working directory
lwd() {
  # Add ".$SSH_USER" suffix to cache file if $SSH_USER is set and non-empty
  local cache_file="$ZSH_CACHE_DIR/last-working-dir${SSH_USER:+.$SSH_USER}"
  [[ -r "$cache_file" ]] && cd "$(cat "$cache_file")"
}

# Jump to last directory automatically unless:
# - this isn't the first time the plugin is loaded
# - it's not in $HOME directory
[[ -n "$ZSH_LAST_WORKING_DIRECTORY" ]] && return
[[ "$PWD" != "$HOME" ]] && return

lwd 2>/dev/null && ZSH_LAST_WORKING_DIRECTORY=1 || true
