# Manuscript v0.4 Revision Notes

These notes document the wording and consistency fixes applied after `manuscript_consistency_audit_v0_1.md`. This round creates a safer v0.4 manuscript draft only. It does not create final bibliography entries and does not change project data or code.

## Audit Issues Fixed

- Replaced vendor-comparison wording that could sound like validation.
- Tightened OPA818 and ADA4817 Safe/Marginal/Safe language so it stays project-defined and tied to stated test assumptions.
- Replaced "model-specific realism" with "model-specific simulation context".
- Replaced "final design dimension" in the noise discussion with "additional screening dimension".
- Replaced "SPICE-noise validation" style wording with "SPICE noise analysis or measured-noise validation" where the future-work boundary needed to distinguish simulation analysis from measured validation.
- Added explicit notes that Table 4 remains one grouped source-confidence table with 4a/4b/4c subsections in the table draft and may move to an appendix after target journal selection.
- Added a Table 1 caution in the manuscript text explaining that it combines baseline, focused sweep, full sweep, and design-region evidence layers.

## Exact Wording Categories Changed

- Validation-sensitive verbs:
  - From: "checks selected behavioural trends against vendor-model export data"
  - To: "compares selected behavioural trends with vendor-model export data under the repository's test assumptions"
- Vendor comparison strength:
  - From: "vendor macromodel comparison adds model-specific realism"
  - To: "vendor macromodel comparison adds model-specific simulation context"
- OPA818 result scope:
  - From: "tested OPA818 cases fall within the project-defined Safe peaking category"
  - To: "tested cases remain project-defined Safe under the peaking metric and stated test assumptions"
- ADA4817 result scope:
  - From: "the smallest-`Cf` ADA4817 case is borderline ... while larger `Cf` cases are Safe"
  - To: "the smallest-`Cf` case is project-defined Marginal ... while the larger-`Cf` cases are project-defined Safe under the same table context"
- Noise scope:
  - From: "first-pass noise figures add a final design dimension"
  - To: "first-pass noise figures add an additional screening dimension"
- Future noise work:
  - From: "measured-noise or SPICE-noise validation"
  - To: "SPICE noise analysis or measured-noise validation"

## What Was Intentionally Not Changed

- Figure numbering remains Figure 1 through Figure 8.
- Table numbering remains Table 1 through Table 4.
- Table 4 was not split into final Tables 4-6.
- Table 1 was not split into separate assumptions and sweep-grid tables.
- Placeholder citation IDs were retained.
- No final bibliography was created.
- No citations, DOI strings, author lists, journal names, or publication status were added.
- No abstract-only or metadata-only source was promoted to detailed-claim evidence.
- No manuscript figures or table source CSVs were regenerated.

## Remaining Tasks Before Final Bibliography

- Verify all placeholder citation IDs against source access level.
- Build final bibliography entries only after author lists, titles, DOI strings, venues, years, and publication status are verified.
- Complete close reading of core full-text sources before using detailed equations or numeric performance claims.
- Obtain full text for high-priority abstract-only or metadata-only candidates if they are needed for detailed related-work claims.
- Keep abstract-only sources broad-background only and metadata-only sources as future-review placeholders until full text is available.

## Remaining Tasks Before Target-Journal Formatting

- Select the target journal or conference.
- Apply the target template and reference style.
- Finalize figure panel layout, especially Figure 1 magnitude/phase panel labels.
- Polish figure and table captions after final numbering is locked.
- Decide whether Table 1 should be split for readability.
- Decide whether Table 4 should remain in the main paper or move to appendix/supplementary material.
- Clean Table 3 display precision and units after target formatting is selected.
- Request supervisor or domain review of claim strength, modelling assumptions, and venue fit.

## Code/Data/PDF Confirmation

- No MATLAB model functions were modified.
- No result CSVs were modified.
- No simulations were run or generated.
- No figures were regenerated.
- No PDFs were added or modified.
- No `tia_extension/literature_local/` files were added or committed.
- No source was marked fully read.
- No hardware validation, measured-noise validation, universal TIA design rule, new TIA topology, or final Q3 readiness claim was added.
