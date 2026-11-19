# Self-Review Before Upload

Before uploading a pull request or code review, review it yourself. Uploading
means any push that puts a revision where others can see it — a draft, a new
revision of an existing review, or a first upload alike.

Passing tests are not a review. A change can pass every test and still break
something the tests no longer exercise.

## What to check

- **Read the whole diff**, not just the files you meant to change. Anything that
  isn't part of the change comes out: formatting churn on lines you didn't touch,
  reworded comments nobody asked for, the user's own uncommitted files.
- **Find every caller of what you changed.** Search for each renamed, removed or
  changed function, constant and type — in tests as well as source. A test that
  still passes may now be checking nothing: a slice that comes back empty, a
  lookup that finds no match, a loop that runs zero times.
- **Check your new comments are true**, and describe the rule rather than what a
  list or setting happens to hold today. See [[comment-hygiene]].
- **Check the claims behind your decisions.** List what each choice rests on —
  "the framework already handles this", "nothing else calls it" — including
  claims made earlier in the work, and confirm each in the code, source or docs.
  Report any you could not confirm as unconfirmed.
- **Check each new test fails without the change.** Run it against the code
  before the change. A test that passes either way checks nothing.
- **Run the tests, lint and type-check** for the area you touched. If something
  fails that also fails without your change, confirm that by checking the base,
  and say so.
- **Size the change against real use, not the paths you traced.** When a change
  narrows, restricts or changes what something accepts or returns, search for
  everything that depends on it today, inside and outside the package, and check
  each still works. Note what you searched, so a reviewer can see the coverage.
- **Try to break it.** For each behaviour the change relies on, ask how it could be
  bypassed, skipped or hit by an input you didn't plan for: other routes to the
  same code, alternate forms of the same input, defaults, missing values, the
  order it runs in relative to other checks. Base decisions on what the system
  has resolved rather than raw input, and test each case you find.

## Get a fresh read

Before uploading, have the diff reviewed by something that hasn't seen your
reasoning: the code review tool if there is one, or a new agent given the diff
and what the change is for. Don't hand it your conclusions. Ask it explicitly to
search outside the package for consumers the change affects and to look for ways
around it; a reviewer left to the diff alone finds bypasses but not callers in
other repos. Match the effort to the risk: a quick pass for routine changes, a
thorough one for anything that gates access, affects other teams or is hard to
roll back. Check each finding against the code like any review comment, and
report what it found and what you did.

## Report it

Tell the user what the review found and what you fixed, before you upload. If
it found nothing, say what you checked.

| Don't | Do |
|---|---|
| `All 813 tests pass, raising the PR.` | `Tests pass. Review found two modal tests now rendering an empty popover; pointed them at the full list. Raising the PR.` |
| `Allowlist covers the two pages I traced.` | `Allowlist covers every client a search across repos found: four, listed in the description.` |

## Check back after upload

Automated reviewers — security scanners, coverage reports, linters, bot
reviewers — post on the review a few minutes after each upload, draft or not.
After every upload, come back once they have run, read every comment they
left, and deal with each per [[follow-local-conventions]]: fix the ones that
hold, and say why when one does not.

Don't wait in the foreground or end the work at the upload. Schedule the check
so it happens without the user asking, and tell them what the automated
comments said and what you did about them before they publish or ask anyone to
review.

| Don't | Do |
|---|---|
| `Draft raised: CR-123. Ready for reviewers.` | `Draft raised: CR-123. I'll check the automated comments once the analyzers finish.` … `The security scan flagged request data in a log line; logged an enum instead. Coverage passed.` |

## Why

The person reviewing the change is the second check, not the first. Anything you
could have caught yourself costs them a review round, and the issues most
likely to slip past them are the ones the diff doesn't show — a caller in
another file, or a test that silently stopped testing.

Reviewing your own work, you look for what you already thought of. The gaps
other people find are the users you didn't know about and the ways around a
check you didn't try, which is what a search beyond the package and a reviewer
that hasn't seen your reasoning are for.
