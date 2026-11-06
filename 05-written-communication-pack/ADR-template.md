# Architecture Decision Record — Template

> **How to use:** copy this file into each repo as `docs/adr/ADR-NNNN-<slug>.md`.
> One decision per file. Write it when you make the decision, not after. An ADR that
> exists only in your head helps nobody — including you, six months later.
>
> Numbering: sequential (ADR-0001, ADR-0002...). Never renumber; superseded ADRs stay
> and link forward.

---

# ADR-NNNN: <Short title of the decision>

**Date:** YYYY-MM-DD
**Status:** Proposed | Accepted | Superseded by ADR-XXXX
**Deciders:** <names/roles>

## Context

What situation forces a decision now? Include the constraints — team size, deadlines,
existing infra, compliance needs. 3–6 sentences. A reader with no context should
understand why this decision exists at all.

## Decision

One sentence, active voice: **"We will <do X>."** Then 2–3 sentences of nuance —
what's in scope, what's explicitly not.

## Alternatives considered

| Option | Pros | Cons | Why not |
|---|---|---|---|
| Chosen: X | ... | ... | — |
| Y | ... | ... | <decisive reason> |
| Z | ... | ... | <decisive reason> |

Honest pros for the rejected options matter — a strawman list signals the decision was
made before it was written.

## Consequences

**Positive:** what becomes easier/better.
**Negative:** what becomes harder/worse — accepted knowingly. (Every real decision
has these; "none" means you haven't found them yet.)
**Follow-ups:** new work this decision creates.

## Review trigger

State when this decision should be revisited, e.g. "when the cluster exceeds 100
nodes" or "when Karpenter 1.0 ships".
