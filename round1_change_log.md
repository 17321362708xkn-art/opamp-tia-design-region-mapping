# Round 1 Change Log

## Branch

- `round1-q3-guardrails`

## Purpose

Prepare the existing active LPF finite-A0 / finite-GBW MATLAB behavioural modelling repository for a controlled Q3-oriented photodiode TIA extension.

## Files Created

- `AGENTS.md`
- `project_audit.md`
- `docs/q3_validation_plan.md`
- `run_all_active_lpf.m`
- `round1_change_log.md`
- `tia_extension/README.md`

## Files Modified

- None of the existing active LPF MATLAB functions were modified.
- No existing scripts, figures, or result files were modified.

## Active LPF Function Safety Confirmation

- `functions/active_lpf_response.m` was not modified.
- `functions/extract_frequency_metrics.m` was not modified.
- `functions/classify_design_region.m` was not modified.
- `functions/find_margin_thresholds.m` was not modified.
- `functions/compare_frequency_responses.m` was not modified.
- `functions/add_measurement_noise.m` was not modified.

## Guardrails Added

- TIA extension work must be placed in `tia_extension/`.
- SPICE data must not be invented.
- Hardware measurement must not be claimed unless real hardware data exists.
- SPICE validation must not be claimed unless actual exported SPICE macromodel data has been imported and compared.
- SPICE macromodel comparison is required for a Q3 prototype path.
- Figures and result tables must remain reproducible from scripts and parameter records.

## Validation Status

- MATLAB was not run in this round.
- No TIA modelling code was added in this round.
- This round adds planning, audit, guardrails, and workflow entry-point documentation only.
