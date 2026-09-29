# No Historical Artifacts in Documents

Anything written for another reader — code comments, design docs, tickets, PR
bodies, change records — MUST NOT contain statements that only make sense to
someone who watched the work happen.

Specifically: never state that something was *not* done, or was ruled out, when
the reader had no reason to think it would be done.

## The mistake

Work is scoped down from "do A and B" to just "A". The document then says "this
does not do B", and spends a paragraph on the implications of not doing B.

Saying the scope is A was fine. Elaborating on the discarded option was noise,
because no reader knew B had been on the table.

## Why

A negative statement implies its alternative was plausible, so the reader stops to
work out why it was ruled out — and finds no context. It reads as confusing noise,
not as helpful precision.

## How to apply

State what the change *is*, not what it isn't. Before writing a "we do not / this
is not / rather than X" sentence, check whether the reader would have considered X
on their own. If not, cut it.

Transient or superseded context belongs in the reply to the user, not in the
artifact. A related failure mode is writing a temporary problem hit while building
something into a code comment as if it were permanent — see
[[comment-hygiene]].
