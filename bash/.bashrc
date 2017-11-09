source ~/.profile
# =====================================
# Aliases
# =====================================
alias cl="clear"
alias gss="git status -s"
alias gst="git status"
alias gc="git commit"
alias gd="git diff"
alias gp="git push"
alias gaa="git add ."
alias x="exit"
alias del="rm -rf"
alias src="source ~/.bashrc"
alias ys="yarn start"
alias yd="yarn develop"
alias ydl="yarn develop local"
alias yt="yarn test"
# aliases dont take arguments so need to define a function here
function gcm() {
  git add . && git commit -m "$*"
}

if command -v brew >/dev/null 2>&1; then
  if [ -f "$(brew --prefix)"/etc/bash_completion ]; then
    . "$(brew --prefix)"/etc/bash_completion.d
  fi
fi
# =====================================
# get current branch in git repo
# =====================================
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# =====================================
# get current status of git repo
# =====================================
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

GREEN="\[$(tput setaf 2)\]"
RESET="\[$(tput sgr0)\]"

export PS1="${GREEN}\`parse_git_branch\`@\h ${RESET}> "


# =====================================
# FZF
# =====================================
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
