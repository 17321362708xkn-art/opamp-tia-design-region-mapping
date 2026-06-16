# Paper Structure

## 1. Introduction

- Motivate photodiode TIA design as a bandwidth, stability, capacitance, and noise trade-off problem.
- Position the work as a simulation-assisted MATLAB behavioural workflow with limited SPICE smoke-test evidence.
- State that the current package is a research prototype and not a final submission package.
- Supported by: `tia_extension/figures/tia_baseline_magnitude.png`, `tia_extension/figures/tia_bandwidth_vs_Cf.png`, `tia_extension/figures/tia_noise_bandwidth_tradeoff.png`.
- Still needed: concise literature-backed motivation and a target application scenario.

## 2. Related Work

- Summarize prior photodiode TIA design methods, noise-gain compensation, and op-amp selection strategies.
- Compare behavioural modelling, SPICE simulation, and hardware characterization roles.
- Identify where design-region mapping adds workflow value.
- Supported by: no dedicated current figure; use existing results only after literature context is written.
- Still needed: journal-quality literature review and citation table.

## 3. Photodiode TIA Behavioural Model

- Present the TIA model equations for `Yf`, finite op-amp gain `A(s)`, and nonideal transimpedance.
- Explain assumptions: single-pole op-amp model, lumped photodiode capacitance, ideal passive feedback components.
- Define extracted metrics: effective transimpedance, bandwidth, peaking, and phase at bandwidth.
- Supported by: `tia_extension/results/tia_baseline_response.csv`, `tia_extension/results/baseline_metrics.csv`, `tia_extension/figures/tia_baseline_magnitude.png`, `tia_extension/figures/tia_baseline_phase.png`.
- Still needed: concise derivation text and notation table.

## 4. MATLAB Design-Region Mapping Workflow

- Describe the reproducible sweep structure over `Rf`, `Cpd`, `Cf`, and `ft_Hz`.
- Explain Safe, Marginal, and Risky as project-defined engineering classifications rather than universal rules.
- Discuss how candidate cases were selected for later SPICE smoke-test comparison.
- Supported by: `tia_extension/figures/tia_bandwidth_vs_Cf.png`, `tia_extension/figures/tia_peaking_vs_Cf.png`, `tia_extension/figures/tia_design_region_map_Cpd_ft.png`, `tia_extension/figures/tia_safe_window_fraction_map_Cpd_ft.png`, `tia_extension/results/tia_sweep_summary.csv`, `tia_extension/results/spice_candidate_cases.csv`.
- Still needed: final threshold justification and sensitivity discussion.

## 5. SPICE Macromodel Smoke-Test Comparison

- State that OP27 is the only real vendor op-amp macromodel comparison currently imported.
- Explain the three OP27 feedback-capacitance cases and their relationship to the behavioural classifications.
- Compare magnitude and phase agreement and mismatch without implying broad SPICE coverage.
- Supported by: `tia_extension/figures/spice_compare_OP27_Cf3p455_Risky_magnitude.png`, `tia_extension/figures/spice_compare_OP27_Cf3p455_Risky_phase.png`, `tia_extension/figures/spice_compare_OP27_Cf10p_SafeCandidate_magnitude.png`, `tia_extension/figures/spice_compare_OP27_Cf10p_SafeCandidate_phase.png`, `tia_extension/figures/spice_compare_OP27_Cf22p_Safe_magnitude.png`, `tia_extension/figures/spice_compare_OP27_Cf22p_Safe_phase.png`, `tia_extension/figures/spice_compare_OP27_Cf_sweep_magnitude.png`, `tia_extension/results/spice_comparison_summary.csv`.
- Still needed: additional real vendor SPICE macromodel comparisons, ideally 2-3 vendor op-amp models total.

## 6. First-Pass Noise and Bandwidth Trade-off Analysis

- Present the first-pass behavioural noise terms: feedback resistor thermal noise, op-amp voltage noise, op-amp current noise, and optional photodiode shot noise.
- Explain that noise values are configured assumptions and are not measured noise.
- Show that higher `Cf` reduces peaking and bandwidth while generally reducing integrated output noise in the selected sweep.
- Supported by: `tia_extension/figures/tia_noise_contribution_baseline.png`, `tia_extension/figures/tia_noise_bandwidth_tradeoff.png`, `tia_extension/results/noise_baseline_summary.csv`, `tia_extension/results/noise_tradeoff_summary.csv`, `tia_extension/noise_assumptions.md`.
- Still needed: optional SPICE noise analysis and device-specific noise-density justification if the target journal requires it.

## 7. Results and Discussion

- Combine behavioural design maps, OP27 smoke-test trends, and first-pass noise results into a single discussion.
- Highlight the practical trade-off among bandwidth, peaking, feedback capacitance, and output noise.
- Discuss OP27 agreement and mismatch as a limited single-model smoke test.
- Supported by: all figures listed in `tia_extension/figures/figure_manifest_tia.csv`, especially design-region, OP27 comparison, and noise figures.
- Still needed: manuscript-level result ordering, figure selection, and cross-model evidence.

## 8. Limitations

- State no hardware measurement was performed.
- State OP27 is the only real SPICE macromodel comparison so far.
- State the single-pole MATLAB op-amp model is simplified.
- Supported by: `tia_extension/prepaper/limitations_and_no_overclaim.md`, `tia_extension/docs/noise_and_validation_position.md`, `tia_extension/spice_interface/spice_validation_status.md`.
- Still needed: supervisor or domain-expert review of assumptions and thresholds.

## 9. Conclusion

- Summarize the workflow as a reproducible pre-paper research prototype.
- Emphasize that the current evidence supports a Q3 pre-paper package, not a final submission package.
- State the next evidence step: additional real vendor SPICE macromodel comparisons.
- Supported by: `tia_extension/prepaper/q3_readiness_report.md`, `tia_extension/prepaper/next_submission_tasks.md`.
- Still needed: final submission claims after the missing SPICE evidence is added.
