# Follow Local Conventions

Code MUST look like it was written by the team that owns the package. Before
writing code in a package, and again before uploading it, find out how that
package and team do things, and do it their way.

## Where to look

- **The package itself.** README, CONTRIBUTING, review-bot and linter config and
  the standards files they import, the review description template, commit hooks.
- **Sibling code.** Find the closest existing example of what you are building —
  another modal, another action handler, another feature-flag check — and copy its
  shape: file layout, where styles live, naming, how tests are set up and mocked.
  When there are several, copy the newest or most complete one, and check the
  one you copy against the others for anything it lacks, such as accessibility,
  safe areas or rotation.
- **The team's docs.** Best-practice pages linked from the package or from the
  team's wiki and chat channels.
- **History.** `git log` on the destination branch shows how commit subjects,
  scopes and trailers are written, and whether changes land as one commit.

Check structure as well as style: where a file goes, whether styles sit in the
component or in their own file, how strings, metrics and feature flags are registered,
and what else must ship first, such as config or feature-flag registration.

## When they disagree

The package's own code and history win over a team document, and both win over
my general defaults. Where a team convention conflicts with one of the user's
rules — a commit trailer the team requires, for example — follow the team in that
package and tell the user about the conflict.

Automated reviewers and checkers apply the team's standards unevenly. Treat each
finding as a claim to check against the code around it. Fix the ones that
hold. When one does not hold, say why rather than changing the code to satisfy it.

## Report it

When starting work in a package that is new to the session, tell the user in a
line or two which conventions you found and are following. Before upload, say
which you checked, as part of [[self-review-before-upload]].

## Why

Reviewers judge a change against the code around it. A change that ignores local
conventions costs a review round even when it works, and the user ends up
explaining standards they expected to be picked up from the code.
