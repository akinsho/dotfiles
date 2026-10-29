# Self-Review Before Upload

Before uploading a CR or PR, review it yourself. Uploading means any `cr` or
`git push` that puts a revision where others can see it — a draft, a new
revision of an existing CR, or a first upload alike.

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
- **Run the tests, lint and type-check** for the area you touched. If something
  fails that also fails without your change, confirm that by checking the base,
  and say so.

## Report it

Tell the user what the review found and what you fixed, before you upload. If
it found nothing, say what you checked.

| Don't | Do |
|---|---|
| `All 813 tests pass, raising the CR.` | `Tests pass. Review found two modal tests now rendering an empty popover; pointed them at the full list. Raising the CR.` |

## Why

The person reviewing the CR is the second check, not the first. Anything you
could have caught yourself costs them a review round, and the issues most
likely to slip past them are the ones the diff doesn't show — a caller in
another file, or a test that silently stopped testing.
