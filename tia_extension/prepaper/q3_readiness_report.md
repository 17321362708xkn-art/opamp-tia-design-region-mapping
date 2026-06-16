# Q3 Readiness Report

## Current Project Status

The photodiode TIA extension is a simulation-assisted research prototype built around a MATLAB behavioural model, design-region sweeps, a single OP27 LTspice macromodel smoke-test comparison, and first-pass behavioural noise estimates.

Round 7 also adds a datasheet-derived vendor op-amp candidate table for later macromodel planning. This is screening evidence only.

Round 8A prepares the OPA818 and ADA4817-1 vendor SPICE manual-export and comparison workflow. It does not itself complete additional SPICE validation because real exported OPA818 and ADA4817-1 data are still pending.

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
- Datasheet-derived vendor op-amp candidate table from `tia_extension/scripts/run_09_vendor_opamp_datasheet_table.m`.
- Round 8A vendor SPICE preparation documents, metadata template, and guarded comparison entry point for future OPA818 and ADA4817-1 exports.

## Evidence Still Missing

- Additional real SPICE macromodel comparisons, ideally **2-3 vendor op-amp models total**.
- Real OPA818 and ADA4817-1 LTspice exports and imported comparison results.
- Cross-model comparison of Safe, Marginal, and Risky project-defined cases.
- Final datasheet value verification before quantitative op-amp ranking.
- Target-journal figure formatting and caption finalization.
- Related-work synthesis and positioning against prior photodiode TIA design workflows.
- Independent review of the behavioural assumptions by a supervisor or domain expert.
- Optional later SPICE noise analysis if the paper scope requires it.

## Portfolio / Research Prototype / Submission Status

- Portfolio evidence: strong enough to show a reproducible MATLAB TIA workflow, figures, tables, and disciplined validation boundaries.
- Research prototype evidence: formed, because the workflow includes behavioural modelling, design-region sweeps, OP27 smoke-test comparison, first-pass noise trade-off analysis, and datasheet candidate screening.
- Submission status: not final, because the SPICE comparison evidence currently uses only one real vendor op-amp macromodel.

Final status: **research prototype / Q3 pre-paper prototype, not yet fully Q3 submission-ready**.

## Submission Blockers

- Import and compare additional real vendor SPICE macromodels.
- Use the Round 8A workflow to collect and import real OPA818 and ADA4817-1 LTspice exports.
- Use the datasheet candidate table to select and confirm additional vendor macromodel cases.
- Confirm that the project-defined classification criteria remain useful across multiple op-amp models.
- Convert the current pre-paper package into a complete manuscript with related work, final captions, and target-journal formatting.
