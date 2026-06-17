# Figure And Table Final Scope Recommendation v0.1

This note recommends which figures and tables should remain in the main manuscript versus appendix or supplementary material. It uses only existing repository figures, caption packs, table drafts, and Overleaf v0.2 layout decisions. It does not regenerate figures, simulations, CSVs, or LaTeX source.

## Overall Recommendation

For the preferred engineering design workflow framing, the main paper should keep the figures and tables that directly support the workflow story:

1. baseline model response,
2. feedback-capacitance trade-off,
3. design-region mapping,
4. representative response categories,
5. vendor macromodel comparison,
6. one compact noise trade-off view if noise remains a named workflow dimension.

Appendix or supplementary material should carry source-scope documentation, detailed traceability, detailed vendor sweeps, and optional design-space variants.

## Figure Recommendations

| Figure | Current role | Main / appendix recommendation | Rationale | Required polish |
| --- | --- | --- | --- | --- |
| Figure 1. Baseline magnitude/phase | Introduces finite-bandwidth behavioural model | Keep in main | It anchors the model before sweeps and is now acceptable as a labelled two-panel figure in Overleaf v0.2. | Final caption polish; ensure panel labels are visually clear in compiled PDF. |
| Figure 2. Bandwidth versus `Cf` | Shows bandwidth cost of compensation | Keep in main | It is one half of the core compensation trade-off. | Consider pairing with Figure 3 as one two-panel figure if page limits matter. |
| Figure 3. Peaking versus `Cf` | Shows peaking reduction with compensation | Keep in main | It provides the other half of the compensation trade-off and supports the project-defined screening logic. | Keep wording that peaking is a screening proxy, not a complete stability proof. |
| Figure 4. Design-region map | Shows project-defined selected-best design-region output | Keep in main for now, but consider pairing later | It is central to the design-region mapping contribution even if it appears mostly Safe/green. Its value is methodological, not dramatic classification contrast. | Caption must explain that the map shows best available selected cases and does not imply universal safety. Pair later with safe-window fraction map if reviewers need more design-space contrast. |
| Figure 5. Representative Safe/Marginal/Risky responses | Connects labels to response shapes | Keep in main | It makes the project-defined categories interpretable and offsets the mostly Safe appearance of Figure 4. | Future re-export likely needed for legend/readability and line distinction. |
| Figure 6. Vendor macromodel comparison summary | Compares selected vendor-model export metrics | Keep in main | It is the strongest bridge from behavioural screening to model-specific simulation context. | Preserve "vendor macromodel comparison", not validation; keep supply/assumption caveats. |
| Figure 7. First-pass noise contribution baseline | Documents configured baseline noise contributions | Appendix candidate | Useful for traceability but less central than the noise-bandwidth trade-off. It may be too internal for a compact main paper. | Keep if noise remains a full subsection; otherwise move to appendix/supplementary. |
| Figure 8. Noise-bandwidth trade-off | Links compensation to first-pass noise screening | Keep in main if noise remains in scope | It is the better main-paper noise figure because it connects back to the compensation workflow. | Keep "first-pass behavioural estimate" language and avoid measured-noise framing. |

### Figure 4 Decision

Figure 4 should stay in the main text for the current engineering workflow framing, but it should not be oversold as a strong performance-discrimination figure. Because it appears mostly Safe/green, it is persuasive mainly as a demonstration of the mapping workflow and selected-best feedback-capacitance output.

Recommended final handling:

- Keep Figure 4 in the main paper.
- Pair it later with the safe-window fraction map as a panel or appendix figure if the target venue values stronger visual contrast.
- Use Figure 5 immediately after Figure 4 to show that the underlying sweep still contains Safe, Marginal, and Risky response behaviours.
- State that the labels are project-defined screening categories under stated assumptions.

### Figure 5 Decision

Figure 5 should stay in the main paper but needs visual polish before a serious draft. The legend and line readability should be improved by re-exporting the existing plotted data in a later figure-polish round. That later polish should not change simulation data.

### Figure 1 Decision

Figure 1 panel layout is now acceptable in Overleaf v0.2. Final polish should focus on the caption and panel readability rather than changing the evidence.

## Appendix Or Supplementary Figure Candidates

Recommended appendix/supplementary figures:

- Safe-window fraction map, especially if Figure 4 remains mostly Safe/green.
- OP27 feedback-capacitance sweep magnitude/phase details.
- OPA818 vendor macromodel sweep details.
- ADA4817 vendor macromodel sweep details.
- Figure 7 if the main text is shortened and only one noise figure is retained.

Do not add fake or regenerated figures for these candidates. Use only existing repository figures or schedule a later figure-polish round that re-exports existing data without changing simulations.

## Table Recommendations

| Table | Current role | Main / appendix recommendation | Rationale | Required polish |
| --- | --- | --- | --- | --- |
| Table 1. Behavioural model assumptions and swept parameters | Summarizes assumptions and evidence layers | Keep in main for v0.2; consider split later | It is important for traceability, but it mixes baseline, focused sweep, full sweep, and design-region evidence layers. | Split into a compact assumptions table plus appendix traceability table if page limits or reviewer feedback require it. |
| Table 2. Project-defined Safe/Marginal/Risky criteria | Defines screening labels | Keep in main | Essential for preventing "Safe" from sounding like hardware certification. | Keep concise and close to the first use of Safe/Marginal/Risky. |
| Table 3. Vendor macromodel comparison summary | Summarizes selected OP27/OPA818/ADA4817 cases | Keep in main | It is useful, compact, and supports the vendor macromodel comparison section. | Preserve supply caveats and project-defined label wording. Keep pF/MHz columns and compact labels. |
| Table 4. Source-usage confidence table | Documents citation-access discipline | Appendix only | Useful for evidence discipline but too large and not a result table. It should not interrupt References or main results. | Keep as appendix/source-scope table or supplementary material. Do not convert it into a final bibliography. |

### Table 1 Decision

Table 1 may be too broad for a serious journal draft. It currently combines model assumptions, focused feedback-capacitance sweep information, full sweep scale, and design-region map evidence. This is useful for traceability but dense for a main-paper table.

Recommended final handling:

- Keep Table 1 in main for the current v0.2 draft.
- Later split into:
  - Table 1: compact behavioural model assumptions and baseline/sweep ranges.
  - Appendix table: evidence-layer traceability and source files.

### Table 3 Decision

Table 3 should remain a main-paper result table. It gives the clearest compact numerical summary of vendor macromodel comparison evidence. It must retain the caveat that OP27 uses different supply assumptions from OPA818 and ADA4817 and that these are vendor macromodel comparisons, not hardware validation.

### Table 4 Decision

Table 4 should remain appendix-only or supplementary. It is valuable for source discipline, but it is not a main result and is too large for the central manuscript flow. The Overleaf v0.2 decision to place it as an appendix longtable before References is correct for the current draft.

## Recommended Main-Paper Package

Recommended main figures:

- Figure 1: baseline magnitude/phase response.
- Figure 2: bandwidth versus `Cf`.
- Figure 3: peaking versus `Cf`.
- Figure 4: design-region map, with careful caption and optional future pairing.
- Figure 5: representative Safe/Marginal/Risky responses.
- Figure 6: vendor macromodel comparison summary.
- Figure 8: noise-bandwidth trade-off, if noise remains a named workflow dimension.

Conditional main or appendix:

- Figure 7: keep in main only if the noise subsection remains substantive; otherwise move to appendix.

Recommended main tables:

- Table 1, with later split likely.
- Table 2.
- Table 3.

Recommended appendix/supplementary tables:

- Table 4 source-scope table.
- Future detailed sweep summary.
- Future figure/source-data traceability table.

## Polishing Needed Before A Serious Draft

- Finalize Figure 1 caption and panel references.
- Improve Figure 5 legend/readability by re-exporting existing data in a later polish round.
- Decide whether Figure 2 and Figure 3 should be combined as a two-panel compensation trade-off figure.
- Decide whether Figure 4 should be paired with safe-window fraction map for visual contrast.
- Keep Table 3 compact and readable; do not expand it with non-comparable measured-performance rows.
- Split Table 1 if the selected venue has tight page or table-width constraints.
- Keep Table 4 out of the main results flow and out of the References section.
- Preserve all boundary language: no hardware validation, no measured-noise validation, no universal stability guarantee, no new topology claim, and no final submission-readiness claim.
