# Comment Hygiene

Comments MUST be timeless. Every comment you write — in code, config, or any
committed file — is read by someone who has no idea what was true on the day it
was written. Write for that reader.

## Write almost none

No comment is the default. Add one only when a competent reader of the code would
otherwise get it wrong, and the comment is the only way to tell them.

You MUST NOT write a comment that:

- Says what the next line says, in prose
- Labels a block (`# link rules`, `// set up state`) that is already named by the
  function, key or variable beneath it
- Explains a language or library feature the reader already knows
- Pads an entry in a list or config to match the one above it that does have a
  real comment

Delete rather than reword. A file with two comments that each earn their place
reads better than one where every section has a sentence over it, because the
reader learns the comments are worth reading.

## Never encode a moment in time

You MUST NOT put any of the following in a comment:

- **Real-time status.** "the service is currently running", "this is broken right now", "tests are failing"
- **Temporary blockers** or workarounds for something being fixed as you write
- **Migration state.** "for now", "until we move to X", "pending the fix in Y"
- **The present contents of something configurable elsewhere.** Restating which
  apps are in a list, which flag is set, or what a value happens to be today
- **Session or task context.** What the user just asked for, what a previous
  attempt did, what you tried before

The words `currently`, `right now`, `at the moment`, `today`, `for now`, and
`still` are strong signals you are about to write a stale comment. Restructure the
sentence rather than reaching for them.

## Write instead

Describe permanent behaviour, intent, or a genuine constraint of the tool.

| Don't | Do |
|---|---|
| `X hasn't fired for your existing windows yet` | `X fires once per window, when first detected` |
| `Chrome currently defaults to workspace C` | `Each app's default workspace is set below` |
| `Set to 0 for now until we fix the padding bug` | `0 disables padding: children share one frame` |
| `Existing workspaces keep their old layout` | `Applied at creation; not retroactive` |

## Where transient information belongs

If something genuinely is temporary, it goes in your reply to the user, a commit
message, a ticket, or a PR description — never in the file. A stale comment is
worse than no comment, because it is trusted and then misleads.

## What does earn a comment

A surprising constraint of a library, a reason the obvious approach does not work,
or a non-obvious consequence of a value — things the reader cannot recover from the
code. Phrase them as durable statements. If you cannot name what the reader would
get wrong without it, there is nothing to write.
