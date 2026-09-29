# Comment Hygiene

Comments MUST be timeless. Every comment you write — in code, config, or any
committed file — is read by someone who has no idea what was true on the day it
was written. Write for that reader.

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

## Explaining *why* is still encouraged

This rule bans time-bound facts, not commentary. Non-obvious reasoning, a
surprising constraint of a library, or the reason an approach was rejected are all
worth a comment — phrase them as durable statements.
