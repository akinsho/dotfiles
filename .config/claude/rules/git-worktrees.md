# Git Worktrees

Do changes to a git repository in a worktree, so the user's own checkout and
any uncommitted work in it stay untouched. Where a build system has its own
worktree command and another rule covers it, follow that rule instead.

Work in place instead when the task only reads, when the session is already in
a worktree, or when the user asks for it.

## Starting

From the repository root, branch from the current HEAD:

```bash
git worktree add .claude/worktrees/<name> -b <name>
```

Then call `EnterWorktree` with that `path`. `<name>` is two to four lowercase
hyphenated words naming the task.

## Landing

When the user asks to commit, commit on the worktree branch and rebase it onto
the branch the main checkout is on. A worktree session cannot run git against
the main checkout, so call `ExitWorktree` with `keep` before landing it:

```bash
git merge --ff-only <name>
git worktree remove .claude/worktrees/<name>
git branch -d <name>
```

If the fast-forward fails because the main checkout has uncommitted changes to
the same files, stop and tell the user. Push only when asked.

In a repository other people use, push the branch and draft the PR instead of
merging locally, and clean up once it has merged.

Ask before removing a worktree with uncommitted or unmerged work.

## Dotfiles

Installed config links to the main checkout, so a change made in a worktree has
no effect until it lands. Land it before trying it out live.
