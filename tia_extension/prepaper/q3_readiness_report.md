# Q3 Readiness Report

## Current Project Status

The photodiode TIA extension is a simulation-assisted research prototype built around a MATLAB behavioural model, design-region sweeps, a single OP27 LTspice macromodel smoke-test comparison, and first-pass behavioural noise estimates.

Current status: **research prototype / Q3 pre-paper prototype, not yet fully Q3 submission-ready**.

Required status wording for this round: **Q3 pre-paper prototype formed; additional vendor SPICE macromodel comparisons are still required before submission.**

No hardware measurement was performed. The first-pass noise estimates are calculated MATLAB behavioural estimates, not measured detector noise.

## Evidence That Exists

- Baseline finite-A0 / finite-GBW TIA magnitude and phase response from `tia_extension/scripts/run_01_tia_baseline.m`.
- Feedback-capacitance sweep for bandwidth and peaking from `tia_extension/scripts/run_03_sweep_Cf_for_peaking_bandwidth.m`.
- Design-region mapping over `Rf`, `Cpd`, `Cf`, and `ft_Hz` from `tia_extension/scripts/run_05_design_region_map_tia.m`.
- Safe-window fraction map from the behavioural sweep workflow.
- Real LTspice OP27 AC smoke-test comparison for three feedback-capacitance cases from `tia_extension/scripts/run_06_compare_with_spice_example.m`.
- First-pass behavioural noise contribution and noise-bandwidth trade-off analysis from `tia_extension/scripts/run_07_noise_baseline.m` and `tia_extension/scripts/run_08_noise_bandwidth_tradeoff.m`.
- Reproducible figure manifest at `tia_extension/figures/figure_manifest_tia.csv`.

## Evidence Still Missing

- Additional real SPICE macromodel comparisons, ideally **2-3 vendor op-amp models total**.
- Datasheet parameter table for 5-8 candidate op-amps.
- Cross-model comparison of Safe, Marginal, and Risky project-defined cases.
- Target-journal figure formatting and caption finalization.
- Related-work synthesis and positioning against prior photodiode TIA design workflows.
- Independent review of the behavioural assumptions by a supervisor or domain expert.
- Optional later SPICE noise analysis if the paper scope requires it.

## Portfolio / Research Prototype / Submission Status

- Portfolio evidence: strong enough to show a reproducible MATLAB TIA workflow, figures, tables, and disciplined validation boundaries.
- Research prototype evidence: formed, because the workflow includes behavioural modelling, design-region sweeps, OP27 smoke-test comparison, and first-pass noise trade-off analysis.
- Submission status: not final, because the SPICE comparison evidence currently uses only one real vendor op-amp macromodel.

Final status: **research prototype / Q3 pre-paper prototype, not yet fully Q3 submission-ready**.

## Submission Blockers

- Import and compare additional real vendor SPICE macromodels.
- Build a defensible op-amp candidate table from datasheets.
- Confirm that the project-defined classification criteria remain useful across multiple op-amp models.
- Convert the current pre-paper package into a complete manuscript with related work, final captions, and target-journal formatting.
