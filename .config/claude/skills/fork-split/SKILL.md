---
name: fork-split
description: Fork this conversation into a new terminal split (tmux or Rex) that carries on with a task. Use whenever the user asks to fork the session, fork a copy, or spin off a fork to implement or investigate something. Use this instead of the Agent tool's "fork" subagent type.
---

When the user asks for a fork, open it as a visible split with this script.
Do not use the Agent tool's `fork` subagent type.

```bash
~/.claude/skills/fork-split/fork-split.sh -n <label> "<task>"
```

- `<task>` is the full instruction for the fork, written so it makes sense
  without the latest message: what to build, where, and any constraints the
  user gave. The fork has the whole conversation up to this point.
- `<label>` is two to four lowercase hyphenated words naming the task.
- `-d right|left|above|below` sets where the split opens (default `right`).
  Use it when the user names a side.

The script uses tmux when it runs inside tmux and Rex otherwise. It refuses
to fork a conversation that has no messages yet.

After it runs, tell the user the fork has opened and what it was asked to do,
then carry on in this session. Do not do the forked task here as well.
