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

## How to apply

After drafting prose, cut any clause that only restates the implication of the
previous one, any opener that counts or classifies the clauses that follow, and
any noun used figuratively rather than literally.
