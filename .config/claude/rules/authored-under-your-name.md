# Text Published Under The User's Name

CR descriptions, commit messages, tickets, PR bodies, review replies, chat messages — anything
that appears as if the user wrote it — MUST be shown to them and approved before it is published
or edited. This holds for corrections too: if something already published is wrong, say what is
wrong and propose the replacement wording, rather than fixing it directly.

Drafting it in the reply costs one message. Publishing it unasked spends their credibility.

## Pitch it at the reader

The reader wants what changed, why it matters to them, and what they need to do. They are not
reading an account of how the conclusion was reached.

You MUST NOT pad this kind of text with:

- Dependency chains, call stacks, or line-by-line mechanism walkthroughs
- Which tests fail, how many, and the exact assertion output
- Tooling, commands, or the sequence of attempts behind the finding
- Counts and measurements that change nothing for the reader

Keep the detail that a reviewer needs in order to judge the change. Cut the rest. If depth
genuinely helps, offer it and let them ask — a reviewer can always ask a question, and the
investigation can go in a reply where it does not weigh down the summary.

| Don't | Do |
|---|---|
| `Four new tests, two of which fail without this change, one per guard: the one that re-renders with a fresh callback mid-animation fails with "Received number of calls: 2", and…` | `Four new tests cover both guards.` |
| `blur = useCallback(…, [inputTextMetadata]) → onSubmit → animationCallback → effect re-runs → …` | `Pressing the button blurs the input, which changes the callback the animation holds.` |

## Why

Verbosity reads as uncertainty, and detail that only made sense while the work was happening dates
badly — see [[no-historical-artifacts]]. The user is accountable for what their name is on, so
they decide what it says.
