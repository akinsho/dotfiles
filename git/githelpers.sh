#!/bin/bash

function delete_local_merged_branches() {
  branch=${1:-master}
  git branch --merged "$branch" | grep -v "$branch" | xargs git branch -d
}

function delete_remote_merged_branches() {
  branch=${1:-master}
  target=${1:-origin}
  git fetch "$target"
  git remote prune "$target"

  for BRANCH in `git branch -r --merged origin/master |\
                 egrep "^\s*origin/"                  |\
                 grep -v "${branch}"                  |\
                 grep Akin909                         |\
                 cut -d/ -f2-`
  do
    git push origin :"$BRANCH"
  done
}

function weekly_summary() {
  LAST_WEEK=$(date -v-7d +%m/%d)

  STATS=$(
    git log --since=1.week --oneline |
    tail -n 1                        |
    awk '{ print $1 }'               |
    xargs git diff --shortstat
  )

  FEATURES=$(
    git log --since=1.week --oneline |
    grep -E "Merge (pull|branch) "
  )

  FEATURES_COUNT=$(
    echo "$FEATURES" |
    sed '/^\s*$/d'   |
    wc -l            |
    awk '{ print $1 }'
  )

  echo "Stats ($LAST_WEEK - Today)"
  echo "---------------------"
  echo "$STATS"
  echo
  echo "Features ($FEATURES_COUNT)"
  echo "-------------"
  echo "$FEATURES"
}
