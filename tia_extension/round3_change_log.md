# Round 3 Change Log

## Branch

`tia-extension-v0.2-design-map-publication-figures`

## Purpose

Add TIA parameter sweeps, project-defined design-region mapping, SPICE candidate case selection, and publication-ready MATLAB behavioural figures.

## Files Created Or Modified

- Updated `tia_extension/functions/classify_tia_design_region.m` to use the Round 3 project-defined peaking and valid-bandwidth criteria.
- Added `tia_extension/scripts/run_03_sweep_Cf_for_peaking_bandwidth.m`.
- Added `tia_extension/scripts/run_04_sweep_Cpd_and_ft.m`.
- Added `tia_extension/scripts/run_05_design_region_map_tia.m`.
- Added `tia_extension/scripts/run_all_tia_sweeps.m`.
- Added `tia_extension/docs/spice_case_selection.md`.
- Added this change log.

Generated outputs after MATLAB execution:

- `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv`
- `tia_extension/results/tia_sweep_summary.csv`
- `tia_extension/results/tia_design_region_map.csv`
- `tia_extension/results/spice_candidate_cases.csv`
- `tia_extension/results/tia_representative_responses.csv`
- updated `tia_extension/figures/figure_manifest_tia.csv`
- bandwidth versus `Cf` figures
- peaking versus `Cf` figures
- design-region map figures
- representative response figures
- `tia_extension/sweep_summary.md`

## Guardrail Confirmation

- Existing active LPF validated functions were not modified.
- The TIA v0.1 baseline structure was retained.
- No SPICE comparison data was added.
- No TIA noise analysis was added.
- No hardware measurement claim was added.
- The safe / marginal / risky criteria are project-defined engineering criteria, not universal design rules.
