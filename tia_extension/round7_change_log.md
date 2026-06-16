# Round 7 Change Log

Branch: `tia-extension-v0.6-vendor-opamp-datasheet-table`

Date: 2026-06-16

## Files Created

- `tia_extension/datasheets/README.md`
- `tia_extension/datasheets/vendor_opamp_datasheet_sources.csv`
- `tia_extension/datasheets/vendor_opamp_candidate_table.csv`
- `tia_extension/datasheets/vendor_opamp_candidate_table.md`
- `tia_extension/datasheets/vendor_opamp_candidate_table_si.csv`
- `tia_extension/datasheets/vendor_opamp_candidate_selection_summary.md`
- `tia_extension/datasheets/vendor_opamp_datasheet_parameter_record.md`
- `tia_extension/datasheets/vendor_opamp_table_manifest.csv`
- `tia_extension/scripts/run_09_vendor_opamp_datasheet_table.m`
- `tia_extension/round7_change_log.md`

## Files Modified

- `tia_extension/README.md`
- `tia_extension/prepaper/required_figures_and_tables.md`
- `tia_extension/prepaper/q3_readiness_report.md`
- `tia_extension/prepaper/next_submission_tasks.md`

## Scope Control

- Added a datasheet-derived vendor op-amp candidate table for later TIA SPICE macromodel planning.
- Added an SI-normalized machine-readable table generated from the same curated datasheet source.
- Added a candidate selection summary for choosing the first additional vendor SPICE macromodels.
- Removed the local untracked `tmp/` PDF cache from the working tree and did not commit any PDF cache files.
- Did not modify active LPF functions.
- Did not modify existing TIA behavioural equations.
- Did not import or invent SPICE data.
- Did not add SPICE noise analysis.
- Did not add hardware measurement or hardware-validation claims.
- Q3 SPICE requirement is still pending additional real vendor macromodel comparisons.

## Candidate Coverage

The Round 7 table includes eight datasheet-screening candidates: OPA818, LTC6268-10, OPA858, ADA4817-1, OPA657, LMH6629, OPA847, and OP27.

OP27 remains the only real imported LTspice macromodel comparison in the current repository. The new datasheet table is planning evidence only.

## Remaining Submission Blockers

- Add additional real vendor SPICE macromodel comparisons, ideally reaching 2-3 op-amp models total.
- Compare project-defined Safe, Marginal, and Risky cases across additional models.
- Confirm candidate-table values against final datasheet PDFs before using them for quantitative manuscript ranking.
- Prepare final target-journal figure layouts, panel labels, and caption formatting.
