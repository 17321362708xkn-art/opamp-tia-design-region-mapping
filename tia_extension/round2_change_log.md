# Round 2 Change Log

## Branch

`tia-extension-v0.1-skill-aware-baseline`

## Purpose

Add the first skill-aware photodiode TIA v0.1 behavioural baseline under `tia_extension/`.

## Files Created Or Modified

- Created `AGENTS.md`.
- Created `tia_extension/README.md`.
- Created `tia_extension/docs/tia_model_assumptions.md`.
- Created `tia_extension/docs/spice_comparison_preparation.md`.
- Created `tia_extension/functions/tia_response.m`.
- Created `tia_extension/functions/extract_tia_metrics.m`.
- Created `tia_extension/functions/classify_tia_design_region.m`.
- Created `tia_extension/scripts/run_01_tia_baseline.m`.
- Created `tia_extension/scripts/run_all_tia_first_pass.m`.
- Created this change log.

Generated outputs after MATLAB execution:

- `tia_extension/results/tia_baseline_response.csv`
- `tia_extension/results/baseline_metrics.csv`
- `tia_extension/figures/figure_manifest_tia.csv`
- baseline magnitude figures
- baseline phase figures

## Guardrail Confirmation

- `functions/active_lpf_response.m` was not modified.
- Existing active LPF scripts, figures, and results were not moved, deleted, or renamed.
- No SPICE comparison data was added.
- No TIA noise analysis was added.
- No hardware measurement claim was added.

## Figure Pipeline

The baseline script saves CSV source data before plotting, generates MATLAB behavioural baseline figures, exports available PDF/SVG/600 dpi PNG formats, and records figure metadata in `tia_extension/figures/figure_manifest_tia.csv`.
