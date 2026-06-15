# Round 1 Change Log

## Branch

- `round1-q3-skills-figure-guardrails`

## Purpose

Add skill-aware Q3 guardrails and a publication figure pipeline.

This round prepares the repository for controlled later photodiode TIA extension work.

No TIA code is added in this round.

## Files Created

- `AGENTS.md`
- `docs/skill_usage_policy.md`
- `docs/figure_generation_pipeline.md`
- `docs/q3_validation_plan.md`
- `run_all_active_lpf.m`
- `round1_change_log.md`

## Files Modified

- No existing active LPF MATLAB functions were modified.
- No existing scripts, figures, or result files were modified.
- No SPICE data was added.
- No TIA model code was added.

## Active LPF Function Safety Confirmation

- `functions/active_lpf_response.m` was not modified.
- `functions/extract_frequency_metrics.m` was not modified.
- `functions/classify_design_region.m` was not modified.
- `functions/find_margin_thresholds.m` was not modified.
- `functions/compare_frequency_responses.m` was not modified.
- `functions/add_measurement_noise.m` was not modified.

## Guardrails Added

- TIA extension work belongs under `tia_extension/`.
- Installed skills may be used only when relevant.
- Skills must obey no-data-alteration rules.
- SPICE macromodel comparison is required for the Q3 prototype path.
- No SPICE validation claim is allowed without real exported SPICE data.
- No hardware measurement claim is allowed without hardware data.
- Every generated figure must have traceable source data and manifest metadata.

## MATLAB Execution

MATLAB was not run in this round.
