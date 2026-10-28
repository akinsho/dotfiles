# Plain Phrasing

Three habits to avoid in anything written for people — replies, commit messages,
docs, tickets, PR bodies.

## No scaffolding openers

You MUST NOT announce the shape of a sentence before writing it. Say the thing
instead.

Openers to cut: "two things need to be true:", "there are three things to
consider", "the reason X is that Y", "it is worth noting that".

| Don't | Do |
|---|---|
| `Before that can happen, two things need to be true: the backend has to be on, and we need to see whether it works.` | `Before that can happen the backend needs switching on, and we need to see whether it works.` |

## No rhetorical flourishes

You MUST NOT dramatise a point the reader already understands. Contrast pairs and
closing zingers read as artificial.

| Don't | Do |
|---|---|
| `we would have no signal and would find out from customers rather than from a dashboard` | `we would not know` |
| `The more plausible quiet failure is the reverse of a breakage: … That is what this change exists to avoid.` | `The more likely problem is …` |

## No jargon words

You MUST NOT reach for a specialist word where an everyday one exists. This
applies to single words, not just sentence shape. Terms from the code — tool
names, weblab ids, config keys — are fine. Terms borrowed from linguistics,
rhetoric, or spec documents are not.

| Don't | Do |
|---|---|
| `the utterance in requirement #4` | `the wording requirement #4 asks for` |
| `the postpositive reads oddly` | `the words are the wrong way round` |
| `this is idempotent` | `running it twice changes nothing` |

The test: would a product or QA colleague say this word out loud? Text written
here gets forwarded to them, and a word that needs a dictionary makes the message
useless to its real audience.

## No "X, not Y" framing

You MUST NOT define something by pairing it with what it isn't. Say what is true
and stop. The negative half reads as formulaic and makes the reader hold two ideas
to receive one — and it usually smuggles in a comparison nobody asked for.

| Don't | Do |
|---|---|
| `These are gaps in the eval, not defects.` | `These can't be judged from this run.` |
| `This is a routing problem, not a prompt problem.` | `The request reaches the wrong agent.` |
| `It's inconsistent, not reliably broken.` | `It happens sometimes.` |

## No abstract nouns doing a verb's job

You MUST NOT turn an action into a noun. The noun hides who did what.

| Don't | Do |
|---|---|
| `context is lost on 7 rows` | `7 rows never received the selection` |
| `a measurement of a path customers cannot reach` | `this tests something customers can't do yet` |
| `non-determinism` | `the same input gave different answers` |
| `the deflection constitutes a failure` | `it asked the customer instead of answering` |

## No hedging that adds length without adding doubt

Qualify the specific part that is uncertain, in one clause. Do not spread
uncertainty across a whole sentence to feel safe.

| Don't | Do |
|---|---|
| `This may suggest that routing could potentially be a factor.` | `Routing looks likely; three samples can't confirm it.` |

## No metaphors or figurative framing

You MUST NOT dress up a mechanism in figurative language. Name the actual thing
and say what it does.

| Don't | Do |
|---|---|
| `Our lever is the weblab.` | `Set the weblab back to control.` |
| `The groundwork goes in and is verified on its own` | `The backend change goes in and is checked on its own` |
| `a single switch with a known-good backend behind it` | `just the switch, with the backend already checked` |
| `every new code path sits behind the gate` | `all the new code only runs when the weblab is on` |
| `Doing it now separates the risk` | `Doing it now keeps the two changes apart` |

## Why

The first habit pads the sentence and delays the content. The second states the
obvious for effect and sounds like copywriting. The third reads as faux-literary
and makes a simple mechanism harder to follow than describing it directly.

## Write for whoever actually reads it

Findings, reports and summaries are read by product, design and QA as often as by
engineers, and they are the ones who decide what happens next. They do not know
your internal acronyms, service names, config formats or field names.

Name the mechanism in everyday words. Where an engineer will need the exact term
to search for it, give it once in brackets and move on. Never write the term alone
and hope the reader infers the mechanism from it.

| Don't | Do |
|---|---|
| `the flag resolved to control` | `the new version was switched off for that customer` |
| `the backoff coefficient was unset` | `it gave up too quickly between attempts` |
| `the request carried no source identifier` | `the request didn't say where it came from (the source field)` |

Where a finding has counts, lead with the number and then what happened to those
cases. Someone reading only the bold text and the numbers should get the shape of
it.

## How to apply

After drafting prose, cut any clause that only restates the implication of the
previous one, any opener that counts or classifies the clauses that follow, and
any noun used figuratively rather than literally.

Then read it back as though saying it to the person out loud. Anything you would
not say in a sentence — a frontloaded `not`, an abstract noun standing in for a
verb, a conclusion announced before it is stated — comes out.
