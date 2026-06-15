# Project Audit

## Repository Purpose

This repository documents a MATLAB behavioural modelling project for finite-A0 and finite-GBW effects in an op-amp active low-pass filter.

The current portfolio focus is design-region mapping under a behavioural model, not hardware validation and not a full photodiode TIA implementation.

## Current Active LPF Stage

The current stage models a first-order inverting op-amp active low-pass filter with ideal and finite-op-amp responses.

The project extracts response metrics, performs parameter sweeps, classifies safe / marginal / risky regions, and generates model-based design-aid plots.

## Main Folders

- `functions/`: reusable MATLAB functions for response modelling, metric extraction, comparison, noise injection, classification, and threshold extraction.
- `scripts/`: staged MATLAB scripts for model checks, parameter sweeps, classification, and final plots.
- `figures/`: exported portfolio figures.
- `scripts/figures/`: early-stage script-generated figures.
- `scripts/results/`: CSV, MAT, and Markdown result summaries.
- `docs/`: supporting documentation.
- `tia_extension/`: reserved location for future photodiode TIA extension work.

## Main MATLAB Functions

- `functions/active_lpf_response.m`
- `functions/extract_frequency_metrics.m`
- `functions/compare_frequency_responses.m`
- `functions/add_measurement_noise.m`
- `functions/classify_design_region.m`
- `functions/find_margin_thresholds.m`

## Main Scripts

- `scripts/run_01_ideal_model_verification.m`
- `scripts/run_02_nonideal_model_check.m`
- `scripts/run_03_day9_M_sweep_nonideal_response.m`
- `scripts/run_04_day10_high_ft_limit_check.m`
- `scripts/run_05_day11_ideal_limit_consistency_check.m`
- `scripts/run_06_day12_A0_DC_gain_sensitivity_table.m`
- `scripts/run_07_day15_clean_ideal_extraction_verification.m`
- `scripts/run_08_day16_clean_nonideal_extraction_test.m`
- `scripts/run_09_day17_virtual_measurement_noise_check.m`
- `scripts/run_10_day18_noisy_extraction_smoothing_test.m`
- `scripts/run_11_day19_monte_carlo_noise_test.m`
- `scripts/run_12_day22_parameter_sweep_metrics.m`
- `scripts/run_13_day23_classify_design_regions.m`
- `scripts/run_14_day24_find_margin_thresholds.m`
- `scripts/run_15_day25_error_vs_M_plots.m`
- `scripts/run_16_day26_safe_marginal_risky_design_map.m`
- `scripts/run_17_day27_required_ft_plot.m`

## Main Existing Outputs

- finite-GBW response comparison plots in `figures/`
- noisy-response and Monte Carlo robustness plots in `figures/`
- error-versus-M plots in `figures/day25_abs_*`
- safe / marginal / risky map in `figures/day26_safe_marginal_risky_design_map.png`
- required `ft` versus `K` plots in `figures/day27_required_ft_vs_K*.png`
- sweep, classification, threshold, design-map, and required-`ft` tables in `scripts/results/`
- Markdown result summaries in `scripts/results/`

## Readiness for TIA Extension

The repository is ready for a controlled TIA extension in a separate `tia_extension/` area.

The active LPF workflow already provides useful infrastructure:

- finite-op-amp behavioural modelling pattern
- frequency-response metric extraction
- parameter sweep workflow
- design-region classification workflow
- reproducible figure and table outputs
- documentation that distinguishes behavioural modelling from validation

The active LPF functions should remain stable while the TIA extension is scoped and added separately.

## Missing Modules for Q3 Prototype

The following modules are still missing for a Q3-oriented photodiode TIA prototype:

1. TIA behavioural model
2. TIA design-region map
3. real datasheet op-amp case table
4. SPICE macromodel comparison with 2-3 real op-amp models
5. first-pass TIA noise analysis
6. pre-paper package

## Audit Summary

The current repository is a public portfolio-ready active LPF finite-GBW behavioural modelling project.

It is not yet a Q3 prototype because the TIA model, real op-amp case study, SPICE macromodel comparison, and first-pass TIA noise analysis are not yet implemented.
