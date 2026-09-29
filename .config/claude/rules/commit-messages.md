# Commit Messages

Terse. A subject line is the default, and most commits need nothing more.

## Format

Conventional Commits, per `git/.gitmessage`:

```
type(scope): subject
```

Lowercase, imperative, no trailing period. Types: `fix`, `feat`, `docs`, `style`,
`refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

## Body

You MUST NOT add a body to explain *what* changed — the diff says that. Add one
only when the *why* is not recoverable from the change itself, and keep it to a
line or two.

Never include:

- A bullet per file or per hunk
- A restatement of the subject in longer words
- Notes on what you tried first, or what you considered and rejected
- Attribution or co-authorship trailers

| Don't | Do |
|---|---|
| `refactor(nvim): tidy vscode mappings and options`<br><br>`- moved mappings into the vscode profile`<br>`- removed the unused options table`<br>`- renamed the helper for clarity` | `refactor(nvim): tidy vscode mappings and options` |
| `fix(zsh): fix the thing that was broken` | `fix(zsh): quote $PATH before the tmux exec` |

## Why

The subject is what gets read — in `git log --oneline`, in blame, in a bisect. A
body that paraphrases the diff pushes the useful line out of view and dates
badly, because the diff stays true and the prose does not.
