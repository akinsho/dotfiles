# Evolve The Rules

These rules describe how the user and I work together, and they should change as
that does. When a conversation settles how something should be done, propose a
change to the rules without waiting to be asked.

## When to propose

- The user corrects me, or tells me to do something differently.
- We go back and forth before agreeing on an approach.
- The user approves a choice that was not obvious, and would want it again.
- A rule turned out wrong, too broad or too narrow, or two rules conflict.
- A rule exists and I did not follow it, or it was not installed.

A one-off preference for a single task does not need a rule. Memory covers facts
about a project; rules cover how to work.

## How to propose

At a natural pause, usually the end of the reply, propose the change in a few
lines: which rule file, and the wording to add or change. Prefer editing an
existing rule over adding a new one. New rules follow the shape of the existing
ones: a short statement, how to apply it, a Don't/Do table where it helps, and why.

Word rules so they hold in any job, team or stack. Name the general practice —
"automated reviewers", "feature flags", "the review tool" — and keep company
tools, product names and team specifics out unless the rule is about that tool.

Write the change once the user agrees. Rules live in the dotfiles repo, so they
are changed in a worktree and landed per [[git-worktrees]], and new files need
linking into `~/.claude/rules/`.

## Why

The user should not have to notice a pattern, ask for a rule, and then word it.
Each correction should only need making once.
