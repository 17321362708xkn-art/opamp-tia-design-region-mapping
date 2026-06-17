# Manuscript Consistency Audit v0.1

This audit reviews the current manuscript package for consistency, overclaim risk, figure/table numbering mismatch, citation-scope mismatch, result alignment, and remaining finalization tasks. It does not rewrite the manuscript and does not create a final bibliography.

Files audited:

- `tia_extension/prepaper/manuscript_draft_v0_3_with_figure_callouts.md`
- `tia_extension/prepaper/figure_caption_pack_v0_1.md`
- `tia_extension/prepaper/table_caption_pack_v0_1.md`
- `tia_extension/prepaper/manuscript_table_drafts_v0_1.md`
- `tia_extension/prepaper/table_draft_notes_v0_1.md`
- `tia_extension/prepaper/writing_evidence_map.md`
- `tia_extension/prepaper/abstract_only_sources_policy.md`
- `tia_extension/prepaper/first_reading_notes_summary.md`
- `tia_extension/prepaper/limitations_and_no_overclaim.md`
- `tia_extension/prepaper/claims_vs_evidence_matrix.md`

## 1. Overclaim Audit

Overall status: the current manuscript draft mostly keeps the required validation boundaries. It explicitly states that the work is modelling/simulation only, not a new TIA topology, not hardware validated, not measured-noise validated, and not a final Q3 submission-ready manuscript. The items below are not fatal overclaims, but they should be softened before a serious pre-submission draft.

| Risk area | Current sentence | Risk | Safer wording |
|---|---|---|---|
| Vendor macromodel wording | "The vendor macromodel comparison stage checks selected behavioural trends against vendor-model export data." | "Checks" can sound like validation if read quickly. | "The vendor macromodel comparison stage compares selected behavioural trends with vendor-model export data under the repository's test assumptions." |
| Vendor macromodel wording | "The vendor macromodel comparison adds model-specific realism." | "Realism" can imply stronger validation than vendor macromodel evidence supports. | "The vendor macromodel comparison adds model-specific simulation context." |
| OPA818 result scope | "OPA818 provides selected high-speed macromodel cases that remain Safe under the project peaking metric." | The sentence is mostly bounded, but "remain Safe" should keep the project-defined/test-assumption boundary close by. | "In the selected OPA818 vendor macromodel rows, the tested cases remain project-defined Safe under the peaking metric and stated test assumptions." |
| ADA4817 result scope | "ADA4817 adds a borderline smallest-`Cf` case and Safe larger-`Cf` cases." | "Safe" should be explicitly project-defined and tied to the rows in Table 3. | "The selected ADA4817 rows include a project-defined Marginal smallest-`Cf` case and project-defined Safe larger-`Cf` cases." |
| Noise framing | "The first-pass noise figures add a final design dimension." | "Final" can be misread as final validation or completeness. | "The first-pass noise figures add an additional screening dimension." |
| Results framing | "This evidence supports including noise in the screening process while leaving measured-noise or SPICE-noise validation for future work." | This is acceptable, but "SPICE-noise validation" should be scoped carefully because optional SPICE noise would still be simulation evidence, not measured validation. | "This evidence supports including noise in the screening process while leaving SPICE noise analysis or measured-noise validation for future work." |

Checks against forbidden claim types:

- Hardware validation: no positive hardware-validation claim found. The manuscript repeatedly states no hardware validation.
- Measured-noise validation: no positive measured-noise-validation claim found. The manuscript repeatedly frames noise as first-pass behavioural estimation.
- Universal TIA design rules: no universal rule is claimed; the manuscript uses "selected sweep", "project-defined", and "not universal" language.
- New TIA topology: no new-topology claim found; the abstract explicitly says the contribution is not a new TIA topology.
- Final Q3 submission readiness: no readiness claim found; the manuscript says it is not final Q3 submission-ready.

## 2. Figure/Table Consistency Audit

### Figure Callouts

Manuscript callout counts:

| Figure | Manuscript callout count | Caption-pack entry | Status |
|---|---:|---|---|
| Figure 1 | 4 | Baseline TIA response magnitude and phase | Present and consistent |
| Figure 2 | 2 | Feedback-capacitance sweep: bandwidth versus `Cf` | Present and consistent |
| Figure 3 | 2 | Feedback-capacitance sweep: peaking versus `Cf` | Present and consistent |
| Figure 4 | 3 | Project-defined design-region map across `Cpd` and op-amp `ft` | Present and consistent |
| Figure 5 | 3 | Representative Safe/Marginal/Risky responses | Present and consistent |
| Figure 6 | 3 | Vendor macromodel comparison summary | Present and consistent |
| Figure 7 | 3 | First-pass behavioural noise contribution baseline | Present and consistent |
| Figure 8 | 3 | First-pass noise-bandwidth trade-off | Present and consistent |

No missing main figure captions were found for Figures 1-8. No repeated numbering conflict was found in the main figure sequence.

Figure notes for later polish:

- Figure 1 currently combines magnitude and phase into one manuscript figure while the caption pack lists two source image files. Final layout should define panel labels, probably Figure 1(a) magnitude and Figure 1(b) phase.
- Figure 4 and the design-region text should distinguish the full behavioural sweep, which contains Safe/Marginal/Risky rows, from the design-region map CSV, which stores selected best cases and currently reports Safe rows. This is a wording precision issue rather than a numbering mismatch.
- Appendix candidates A1-A4 are present in the caption pack but are not called out in the main manuscript draft. That is acceptable for the current main-paper draft.

### Table Callouts

Manuscript callout counts:

| Table | Manuscript callout count | Caption-pack entry | Table-draft entry | Status |
|---|---:|---|---|---|
| Table 1 | 3 | Behavioural model assumptions and swept parameters | Present | Present and consistent, but broad |
| Table 2 | 3 | Project-defined Safe/Marginal/Risky screening criteria | Present | Present and consistent |
| Table 3 | 3 | Vendor macromodel comparison summary | Present | Present and consistent |
| Table 4 | 2 | Literature/source usage confidence table | Present, split into 4a/4b/4c subsections | Needs final formatting decision |

No missing main table captions were found for Tables 1-4. No repeated numbering conflict was found in the main table sequence.

Table notes for later polish:

- Table 4 is called out as a single table in the manuscript and caption pack, but `manuscript_table_drafts_v0_1.md` splits it into Table 4a, 4b, and 4c. The final paper should decide whether to keep these as one table with grouped sections, separate Tables 4-6, or move the source-confidence table to an appendix.
- Table 1 is consistent with the caption pack but combines baseline assumptions, focused `Cf` sweep ranges, full sweep counts, and design-region map counts. It may be too dense for a main-paper table.
- Table A1-A3 appendix candidates are defined in the caption pack but not drafted as final tables. This is acceptable for now.

## 3. Citation-Scope Audit

Overall status: citation scope is mostly correct. The manuscript uses full-text sources for detailed topology/background claims, uses abstract-only sources for broad background, and marks metadata-only sources as future placeholders.

Full-text source usage:

- `NOH_2020_CF_TIA_DC_LOOP`, `ANALUI_2004_BW_ENHANCEMENT`, `LU_2007_BROADBAND_TIA`, `PARK_YOO_2004_RGC_TIA`, `XU_2011_INDUCTORLESS_TIA`, `LEE_2021_4GHZ_SDT_VG_TIA`, `TAKAHASHI_2022_LOCAL_FEEDBACK_RGC`, `PAN_LUO_2022_20GBPS_TIA`, `PAN_2022_26GBPS_RX`, `ABDOLLAHI_2025_MDFRGC_TIA`, and `MESGARI_2024_MULTI_DOT_PIN_RX` are used for background and related-work framing.
- The current draft avoids numerical literature-performance comparison tables, which is appropriate at this stage.
- Detailed equations, measured values, and topology-specific performance claims should still wait for close reading and final bibliography work.

Abstract-only source usage:

- `VAZQUEZ_2021_OPTICAL_DETECTION_TIA` is used for broad background on TIA noise/frequency-response/stability coupling. This matches `abstract_only_sources_policy.md`.
- `LI_2021_LOW_NOISE_OPTICAL_RX_TIA` is used for broad background on low-noise optical receiver TIA context. This matches the policy.
- Neither source is used for detailed numerical or methods-level claims in the draft.

Metadata-only source usage:

- `HERMANS_2006_850NM_RX`, `ZHOU_2021_CHERRY_HOOPER_AFE`, `CHEN_2005_10GBPS_CMOS_RX_AFE`, `PARK_2015_40GBPS_INVERTER_RX`, and `LI_2014_LOW_NOISE_CMOS_RX` are described as DOI-only or metadata-only high-priority candidates.
- The manuscript does not use these sources for numerical, measured, architecture-detail, or methods-level claims.
- These placeholder IDs should be held for final bibliography review and full-text acquisition decisions.

Placeholder citation IDs that require final bibliography review:

- All IDs in the placeholder references list require final metadata verification before final bibliography creation.
- The highest-risk IDs are the abstract-only and metadata-only group because they must not migrate into detailed comparison rows without full text.
- Preprint or status-sensitive optional sources in the reading notes should be verified before final citation formatting.

## 4. Results Consistency Audit

Vendor macromodel comparison:

- Table 3 in `manuscript_table_drafts_v0_1.md` is consistent with `tia_extension/results/spice_comparison_summary_vendor_models.csv`.
- OP27 rows: `OP27_Cf3p455_Risky` is Risky with high peaking; `OP27_Cf10p_SafeCandidate` and `OP27_Cf22p_Safe` are Safe in the project-defined visual labels.
- OPA818 rows: all four selected rows are Safe under the project-defined visual labels.
- ADA4817 rows: `ADA4817_Rf10k_Cpd10p_Cf0p5` is Marginal, and the larger `Cf` rows are Safe.
- The manuscript text is consistent with this pattern, but the results section should keep "project-defined" close to all Safe/Marginal/Risky wording.

Supply and operating assumptions:

- The supply caveat is present in the table draft and table notes: OP27 uses `+15/-15 V`; OPA818 and ADA4817 use `+5/-5 V`.
- The manuscript mentions that vendor models and operating assumptions differ, which is consistent with the CSV note.
- Final Table 3 should preserve the supply caveat either in the caption, a table note, or both.

Safe/Marginal/Risky thresholds:

- Table 2 matches `classify_tia_design_region.m`:
  - Safe: valid bandwidth and peaking `< 1 dB`.
  - Marginal: valid bandwidth and peaking from `1 dB` to `3 dB`.
  - Risky: peaking `> 3 dB` or invalid extraction.
- The manuscript correctly describes the labels as project-defined screening categories.
- The final draft should avoid any wording that turns these labels into certified stability labels.

Peaking/stability boundary:

- The manuscript states that peaking is a practical screening metric and not a complete phase-margin or stability proof.
- Figure 3 caption also says peaking is a project screening metric and stability proxy, not a complete proof.
- This boundary is consistent and should remain in the Results and Limitations sections.

## 5. Table-Readiness Audit

Table 1:

- Recommendation: consider splitting Table 1 into two tables or a table plus appendix.
- A compact main-paper table could list baseline assumptions and model equations.
- A separate appendix or supplemental table could list sweep ranges, row counts, and classification counts.
- Reason: the current Table 1 mixes baseline, focused `Cf` sweep, full behavioural sweep, and design-region map data. It is useful for traceability but may be too dense for a journal page.

Table 2:

- Recommendation: keep as a compact main-paper table.
- The thresholds are simple and important for avoiding overclaim.
- Include a caption or footnote stating that labels are project-defined screening categories, not universal stability guarantees.

Table 3:

- Recommendation: keep as a main-paper table, but clean numeric precision.
- Suggested precision cleanup:
  - Use pF for `Cf` in the display table while retaining SI source traceability.
  - Use MHz for `-3 dB` bandwidth in the display table.
  - Use two or three significant figures for peaking where values are not near zero.
  - For near-zero peaking values, consider `<0.001 dB` or a consistent scientific notation rule.
- Preserve OP27 versus OPA818/ADA4817 supply caveat.
- Keep "vendor macromodel comparison", not "validation".

Table 4:

- Recommendation: decide whether Table 4 belongs in the main paper or appendix after target journal selection.
- For an internal prepaper or thesis-style draft, Table 4 is useful in the main text because it documents evidence discipline.
- For a compact journal paper, Table 4 may be better as an appendix/supplementary table or replaced by a short source-scope paragraph.
- Do not turn Table 4 into a final bibliography.

## 6. Finalization Task List

Tasks needed before a serious pre-submission draft:

- Build final bibliography entries from verified sources only.
- Verify author lists, DOI strings, venues, years, and publication status before final citation formatting.
- Decide target journal or conference.
- Apply target journal manuscript template and reference style.
- Finalize figure panel layout, especially Figure 1 magnitude/phase panels and any vendor macromodel appendix figures.
- Polish captions after final figure/table numbering is fixed.
- Decide whether Table 1 should be split and whether Table 4 belongs in main text or appendix.
- Recheck all placeholder citation IDs against source access level.
- Complete close reading of core full-text sources before using detailed equations or performance values.
- Obtain full text for high-priority abstract-only or metadata-only sources if they are needed for detailed related-work claims.
- Add optional SPICE noise analysis or additional vendor macromodel work only if required by final manuscript scope.
- Keep measured-noise validation and hardware validation out of the manuscript unless actual measured evidence is added later.
- Request supervisor/domain review for claim strength, modelling assumptions, and target-venue fit.

## Summary

The current manuscript package is internally consistent enough for the next writing round. The main risks are wording-level: vendor macromodel phrases should avoid sounding like validation, "Safe" labels should stay explicitly project-defined, and first-pass noise wording should avoid any hint of measured-noise validation. Figure numbering is consistent. Table numbering is consistent, with the main formatting decision being whether Table 4 remains one grouped confidence table or becomes appendix material. Citation scope is currently controlled, but final bibliography work must verify every placeholder ID before formal submission formatting.
