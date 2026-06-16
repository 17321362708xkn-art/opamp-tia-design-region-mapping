# Paper Screening Criteria

Use these criteria when deciding whether a paper, book section, datasheet, or application note should support the pre-paper.

## Must Include

Prioritize sources that cover at least one of these:

- Photodiode TIA design fundamentals.
- Feedback capacitance compensation in TIAs.
- Op-amp bandwidth, loop gain, phase margin, noise gain, or gain peaking in a TIA context.
- TIA noise analysis with feedback resistor noise, op-amp voltage noise, op-amp current noise, or photodiode shot noise.
- Vendor application notes from reputable op-amp manufacturers.
- Sources with equations, design rules, simulation methods, measurement context, or experimentally relevant discussion.

## Useful But Optional

These sources may help but should not dominate the core bibliography:

- General analog feedback theory that clearly supports finite-bandwidth reasoning.
- Design automation or design-space exploration papers in adjacent analog domains.
- Op-amp datasheets used only for parameter context.
- SPICE modelling notes that explain limitations but are not TIA-specific.
- Open-access engineering articles with clear methods but limited citation history.

## Exclude / Avoid

Do not rely on:

- Sources unrelated to photodiode TIAs.
- Generic op-amp tutorials with no relevance to TIA compensation, noise, or bandwidth.
- Blog posts or forum posts without technical depth.
- Papers with no accessible method details.
- Sources that cannot support any claim in `tia_extension/prepaper/claims_vs_evidence_matrix.md`.
- Unreliable sources, unattributed content, or pages with unclear origin.

## Scoring Rubric

Use a 0-3 score for each dimension:

| Score | Meaning |
|---:|---|
| 0 | Not relevant or unusable. |
| 1 | Weak relevance; may provide background only. |
| 2 | Useful; supports at least one manuscript claim or section. |
| 3 | Core source; directly supports a central claim or method explanation. |

Score dimensions:

- Relevance to photodiode TIA design.
- Relevance to finite bandwidth, compensation, peaking, or stability proxy.
- Relevance to noise modelling.
- Relevance to SPICE, behavioural modelling, or validation limits.
- Citation/source quality.
- Usefulness for a specific manuscript section.

Suggested decision:

- Keep: average score near 2 or higher and at least one dimension scored 3.
- Maybe: useful but narrow, background-only, or missing method detail.
- Reject: no direct support for the claims matrix or unreliable source quality.
