# Table Draft Notes v0.1

These notes document how `manuscript_table_drafts_v0_1.md` was prepared. They are traceability notes for manuscript writing and not a final bibliography.

## Source Files Used

- `tia_extension/prepaper/table_caption_pack_v0_1.md`
- `tia_extension/prepaper/manuscript_draft_v0_3_with_figure_callouts.md`
- `tia_extension/docs/tia_model_assumptions.md`
- `tia_extension/functions/classify_tia_design_region.m`
- `tia_extension/results/baseline_metrics.csv`
- `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv`
- `tia_extension/results/tia_sweep_summary.csv`
- `tia_extension/results/tia_design_region_map.csv`
- `tia_extension/results/spice_comparison_summary_vendor_models.csv`
- `tia_extension/prepaper/first_reading_notes_summary.md`
- `tia_extension/prepaper/abstract_only_sources_policy.md`
- `tia_extension/prepaper/writing_evidence_map.md`

## Values Taken Directly From CSVs

- Table 1 baseline values for `Rf_ohm`, `Cf_F`, `Cpd_F`, `A0`, `ft_Hz`, `fp_Hz`, `bandwidth_Hz`, `peaking_dB`, and baseline classification come from `tia_extension/results/baseline_metrics.csv`.
- Table 1 focused `Cf` sweep ranges and row/classification counts come from `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv`.
- Table 1 full behavioural sweep ranges and row/classification counts come from `tia_extension/results/tia_sweep_summary.csv`.
- Table 1 design-region row count, `Cpd_F` range, `ft_Hz` range, selected-`Cf` range, and stored classification summary come from `tia_extension/results/tia_design_region_map.csv`.
- Table 3 device/model names, case IDs, feedback capacitance values, supply values, peaking values, extracted `-3 dB` bandwidth values, and project-defined labels come from `tia_extension/results/spice_comparison_summary_vendor_models.csv`.

## Display Precision

- Table 3 numeric values are displayed at manuscript-readable precision rather than full CSV precision.
- The exact machine-readable values remain in `tia_extension/results/spice_comparison_summary_vendor_models.csv`.
- Table 1 keeps exact strings or compact scientific notation where that is clearer for manuscript drafting.

## Values Left As "See Source File"

- Table 1 leaves the full model equations and symbolic response details as "see source file" because `tia_extension/docs/tia_model_assumptions.md` and `tia_extension/functions/tia_response.m` are the authoritative sources.
- Table 1 leaves script-specific derived `fp_Hz` sweep values as "see source file" because the main result CSVs emphasize `ft_Hz`, `A0`, bandwidth, and peaking rather than a manuscript-ready pole-frequency table.
- Table 4 does not include author lists, DOI strings, journal names, or publication status because this round intentionally avoids creating final bibliography entries.

## Missing Data Or Cautions

- Table 1 combines baseline, focused `Cf` sweep, full sweep, and design-region evidence. These evidence layers do not all use the same `Rf`, `Cpd`, or `ft_Hz` values, so manuscript prose should name the relevant evidence layer.
- Table 2 is based on current project classification logic only. The Safe/Marginal/Risky labels are project-defined screening categories, not universal stability guarantees.
- Table 3 is vendor macromodel comparison evidence only. It is not hardware validation, not measured-noise validation, and not identical operating-point equivalence across devices.
- OP27 rows use `+15/-15 V`, while OPA818 and ADA4817 rows use `+5/-5 V`; this caution should stay attached to Table 3.
- Table 4 separates full-text available, abstract-only, and metadata-only sources. Abstract-only and metadata-only sources should not be used for numerical comparison, detailed methods claims, equations, or conclusions.
- No source access state was changed while preparing these tables.

## Remaining Steps Before Final Tables

- Decide final target-journal table formatting and precision.
- Confirm whether Table 1 should be split into "baseline assumptions" and "sweep grid" tables for readability.
- Decide whether the full behavioural sweep summary belongs in the main paper or an appendix.
- Build final captions after figure/table numbering is fixed.
- Create final bibliography entries only after bibliographic metadata and source access are verified.
- Recheck all literature rows before any numerical literature comparison is introduced.
