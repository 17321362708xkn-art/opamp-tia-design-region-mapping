# Manuscript Skeleton

Working title:

**MATLAB-and-SPICE-Assisted Design-Region Mapping for Photodiode Transimpedance Amplifiers under Finite Op-Amp Bandwidth Constraints**

This is a paper skeleton and writing plan, not a full manuscript. It organizes the existing evidence into a conservative pre-paper structure and preserves the current validation boundary: three real vendor SPICE macromodel comparison sets are available, but no hardware validation, measured-noise validation, or full Q3 submission readiness is claimed.

## 1. Abstract

Purpose: Summarize the motivation, method, evidence, and limits in one concise block.

Key claim: The workflow provides a reproducible pre-design screening method for photodiode TIA bandwidth, peaking, and first-pass noise trade-offs.

Evidence to use: MATLAB behavioural sweeps, OP27 smoke test, OPA818 and ADA4817 vendor macromodel imports, noise trade-off results, and figure manifest.

Figures/tables to cite: none directly in the abstract, but mention the reproducible scripts and CSV-backed figures.

Do not overclaim: Do not imply hardware validation, measured noise, universal stability rules, or final submission readiness.

Content to write later:
- State the photodiode TIA design trade-off problem.
- Mention finite op-amp bandwidth and feedback capacitance as central variables.
- Summarize the MATLAB design-region mapping workflow.
- Mention the three real vendor SPICE macromodel comparison sets.
- State that noise results are first-pass behavioural estimates.
- End with a conservative validation boundary.

## 2. Introduction

Purpose: Motivate why photodiode TIA pre-design needs fast exploration before detailed vendor simulation and hardware work.

Key claim: TIA choices are sensitive to `Rf`, `Cpd`, `Cf`, and finite op-amp bandwidth, so an explicit design-region workflow is useful.

Evidence to use: Baseline response, bandwidth versus `Cf`, peaking versus `Cf`, and design-region maps.

Figures/tables to cite: `tia_baseline_magnitude.png`, `tia_bandwidth_vs_Cf.png`, `tia_peaking_vs_Cf.png`, and `tia_design_region_map_Cpd_ft.png`.

Do not overclaim: Do not present the workflow as a replacement for device-level SPICE, layout parasitic analysis, or hardware characterization.

Content to write later:
- Introduce photodiode TIA design as a coupled bandwidth, stability, capacitance, and noise problem.
- Explain why early-stage screening can reduce unproductive design iterations.
- Explain why finite op-amp bandwidth matters even in a simplified model.
- Preview the MATLAB plus SPICE evidence chain.
- State the limited validation scope plainly.

## 3. Related Work and Motivation

Purpose: Position the workflow relative to photodiode TIA design methods, compensation practice, op-amp selection, and simulation workflows.

Key claim: The contribution is an organized, reproducible screening workflow, not a new TIA topology.

Evidence to use: Vendor datasheet candidate table, existing modelling assumptions, and comparison between behavioural and vendor macromodel roles.

Figures/tables to cite: `vendor_opamp_candidate_table.csv`, `vendor_opamp_candidate_table_si.csv`, and `vendor_opamp_candidate_selection_summary.md`.

Do not overclaim: Do not claim novelty as a circuit topology or assert superiority over published designs without literature support.

Content to write later:
- Review photodiode TIA compensation and noise-gain ideas.
- Discuss how op-amp bandwidth, input capacitance, input noise, and bias current affect selection.
- Contrast behavioural modelling, SPICE macromodels, and hardware testing.
- Explain why datasheet screening supports but does not decide final device selection.
- Identify the gap this workflow addresses: reproducible early screening with explicit claim boundaries.

## 4. Photodiode TIA Behavioural Model

Purpose: Define the simplified finite-`A0` / finite-GBW TIA model used for sweeps.

Key claim: The behavioural model captures first-order transimpedance trends well enough for pre-design exploration.

Evidence to use: Baseline response CSV, baseline metrics, modelling assumptions, and reproducible functions.

Figures/tables to cite: `tia_baseline_magnitude.png`, `tia_baseline_phase.png`, `tia_baseline_response.csv`, and `baseline_metrics.csv`.

Do not overclaim: Do not claim the single-pole op-amp model captures vendor macromodel dynamics, output limits, package parasitics, or layout effects.

Content to write later:
- Define `Rf`, `Cf`, `Cpd`, `A0`, `ft_Hz`, and `Zt = Vout / Ipd`.
- Present the feedback admittance and finite-gain transimpedance relationship.
- State the single-pole op-amp approximation.
- Explain extracted metrics: low-frequency gain, bandwidth, peaking, and phase.
- Connect the model to later sweep and classification steps.

## 5. Design-Region Mapping Method

Purpose: Explain how sweeps over `Rf`, `Cpd`, `Cf`, and `ft_Hz` produce project-defined Safe, Marginal, and Risky regions.

Key claim: The sweep workflow gives a structured way to see where bandwidth and peaking trade-offs become problematic.

Evidence to use: Full TIA sweep summary, design-region map, representative region responses, and safe-window fraction map.

Figures/tables to cite: `tia_design_region_map_Cpd_ft.png`, `tia_representative_region_responses.png`, `tia_safe_window_fraction_map_Cpd_ft.png`, and `tia_sweep_summary.csv`.

Do not overclaim: Do not describe Safe, Marginal, and Risky as universal stability classifications or guaranteed hardware outcomes.

Content to write later:
- Define the sweep dimensions and parameter ranges.
- Explain the project-defined classification thresholds.
- Show how representative cases are selected.
- Discuss how safe-window fraction helps compare regions.
- State how later vendor SPICE comparisons test selected trends.

## 6. Feedback-Capacitance Sweep and Stability Proxy

Purpose: Present `Cf` as a practical compensation knob that trades bandwidth against peaking.

Key claim: Increasing `Cf` generally reduces bandwidth and peaking risk in the behavioural sweeps.

Evidence to use: `Cf` bandwidth/peaking sweep and selected response examples.

Figures/tables to cite: `tia_bandwidth_vs_Cf.png`, `tia_peaking_vs_Cf.png`, and `tia_sweep_Cf_peaking_bandwidth.csv`.

Do not overclaim: Do not call peaking alone a complete stability proof or guarantee stable hardware.

Content to write later:
- Explain why `Cf` shapes noise gain and closed-loop response.
- Show bandwidth reduction as `Cf` increases.
- Show peaking reduction as `Cf` increases in the selected sweep.
- Connect the `Cf` trend to Safe/Marginal/Risky labels.
- Identify the trade-off that motivates vendor SPICE checks.

## 7. Vendor SPICE Macromodel Comparison

Purpose: Use real vendor macromodel data to check whether selected behavioural trends remain plausible across specific op-amp models.

Key claim: OP27, OPA818, and ADA4817 show that bandwidth and peaking boundaries depend on the vendor macromodel and operating assumptions.

Evidence to use: OP27 smoke-test comparison, OPA818 vendor Cf sweep, ADA4817 vendor Cf sweep, and combined vendor summary table.

Figures/tables to cite: `spice_compare_OP27_Cf_sweep_magnitude.png`, `spice_opa818_cf_sweep_magnitude.png`, `spice_opa818_cf_sweep_phase.png`, `spice_ada4817_cf_sweep_magnitude.png`, `spice_ada4817_cf_sweep_phase.png`, `spice_vendor_model_bandwidth_peaking_summary.png`, and `spice_comparison_summary_vendor_models.csv`.

Do not overclaim: Do not call the vendor macromodels experimental data, complete SPICE validation, or proof of hardware performance.

Content to write later:
- Describe OP27 as a lower-GBW smoke-test case with strong small-`Cf` peaking.
- Describe OPA818 as a high-speed TIA-oriented vendor macromodel with stable selected cases.
- Describe ADA4817 as a third vendor macromodel with a borderline small-`Cf` case.
- Discuss supply and operating-point differences clearly.
- Use the combined summary as design evidence, not identical operating-point equivalence.

## 8. First-Pass Noise and Bandwidth Trade-off

Purpose: Add first-pass noise context to bandwidth and peaking decisions.

Key claim: The behavioural noise workflow supports relative noise-bandwidth trade-off discussion under stated assumptions.

Evidence to use: Noise baseline summary, noise trade-off summary, noise contribution figure, and noise-bandwidth trade-off figure.

Figures/tables to cite: `tia_noise_contribution_baseline.png`, `tia_noise_bandwidth_tradeoff.png`, `noise_baseline_summary.csv`, and `noise_tradeoff_summary.csv`.

Do not overclaim: Do not call the noise results measured, detector-complete, or device-validated noise.

Content to write later:
- List the configured noise terms and assumptions.
- Explain how integrated output noise is computed in the behavioural workflow.
- Discuss the selected noise-bandwidth trend.
- Tie noise discussion back to `Cf` and bandwidth choices.
- State that SPICE noise and measured detector noise remain outside the current evidence.

## 9. Discussion

Purpose: Integrate behavioural maps, vendor macromodel comparisons, noise context, and datasheet screening into a coherent pre-design argument.

Key claim: The workflow helps organize early photodiode TIA decisions and exposes where further vendor simulation or hardware testing is needed.

Evidence to use: All main figures, combined vendor summary, candidate table, and claims-vs-evidence matrix.

Figures/tables to cite: `figure_table_plan.md`, `claims_vs_evidence_matrix.md`, and the selected main-paper figures.

Do not overclaim: Do not generalize beyond the explored parameter ranges or the three vendor macromodels.

Content to write later:
- Compare behavioural trends with vendor macromodel trends.
- Explain where OP27 differs from OPA818 and ADA4817.
- Discuss the ADA4817 small-`Cf` borderline case.
- Explain how datasheet screening guides future model choices.
- Convert results into conservative design-screening guidance.

## 10. Limitations

Purpose: State exactly what the current evidence does and does not support.

Key claim: The package is useful for pre-design screening, but it is not hardware validation, measured-noise validation, or final journal-submission evidence.

Evidence to use: `limitations_and_no_overclaim.md`, `spice_validation_status.md`, and `claims_vs_evidence_matrix.md`.

Figures/tables to cite: none required, but cross-reference the claims matrix.

Do not overclaim: This section should actively prevent overclaiming.

Content to write later:
- State that no hardware measurement was performed.
- State that vendor SPICE macromodels are simulation models.
- State that noise is first-pass behavioural estimation.
- State that labels are project-defined screening labels.
- State that final readiness requires manuscript writing and domain review.

## 11. Conclusion

Purpose: Close with a concise summary of what has been built and what remains.

Key claim: The current package forms a conservative Q3 pre-paper prototype with reproducible evidence and clear validation boundaries.

Evidence to use: Q3 readiness report, figure/table plan, results storyline, and change logs.

Figures/tables to cite: optional reference to the combined vendor summary table.

Do not overclaim: Do not say the work is publication-ready, accepted, complete, or validated in hardware.

Content to write later:
- Summarize the MATLAB behavioural workflow.
- Summarize the three real vendor macromodel comparison sets.
- Summarize the first-pass noise trade-off contribution.
- Emphasize reproducibility and conservative claims.
- Identify related work, caption polish, and supervisor/domain review as next steps.

## 12. Reproducibility Notes

Purpose: Tell a reviewer how the evidence package is generated and where the source data live.

Key claim: The package is traceable through scripts, CSV source data, generated figures, and markdown reports.

Evidence to use: `README.md`, script list, figure manifest, result CSVs, processed vendor CSVs, and change logs.

Figures/tables to cite: `figure_manifest_tia.csv`, `round10_change_log.md`, and `spice_comparison_summary_vendor_models.csv`.

Do not overclaim: Do not imply that local vendor model files or raw exports are redistributed in the repository.

Content to write later:
- List the scripts used for baseline, sweeps, noise, datasheet screening, and imports.
- State that vendor model files and raw exports remain local and ignored.
- Point to processed CSVs and generated figures committed to the repository.
- Explain that `run_10_compare_vendor_spice_models.m` is guarded and does not synthesize SPICE data.
- Point to the Round 10 claims check script.
