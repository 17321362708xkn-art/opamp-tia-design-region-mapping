# Q3 Readiness Report

## Current Project Status

The photodiode TIA extension is a simulation-assisted research prototype built around a MATLAB behavioural model, design-region sweeps, real LTspice macromodel comparison sets for OP27 and OPA818, and first-pass behavioural noise estimates.

Round 7 also adds a datasheet-derived vendor op-amp candidate table for later macromodel planning. This is screening evidence only.

Round 8A prepared the OPA818 and ADA4817-1 vendor SPICE manual-export and comparison workflow.

Round 8B imports the real OPA818 LTspice text exports generated from the official TI OPA818 PSpice macromodel for four `Cf` cases. This strengthens the SPICE evidence, but it is still macromodel evidence only.

Current status: **research prototype / Q3 pre-paper prototype, not yet fully Q3 submission-ready**.

Required status wording for this round: **Q3 pre-paper prototype formed; additional vendor SPICE macromodel comparisons are still required before submission.**

No hardware measurement was performed. The first-pass noise estimates are calculated MATLAB behavioural estimates, not measured detector noise.

## Evidence That Exists

- Baseline finite-A0 / finite-GBW TIA magnitude and phase response from `tia_extension/scripts/run_01_tia_baseline.m`.
- Feedback-capacitance sweep for bandwidth and peaking from `tia_extension/scripts/run_03_sweep_Cf_for_peaking_bandwidth.m`.
- Design-region mapping over `Rf`, `Cpd`, `Cf`, and `ft_Hz` from `tia_extension/scripts/run_05_design_region_map_tia.m`.
- Safe-window fraction map from the behavioural sweep workflow.
- Real LTspice OP27 AC smoke-test comparison for three feedback-capacitance cases from `tia_extension/scripts/run_06_compare_with_spice_example.m`.
- Real LTspice OPA818 vendor PSpice macromodel import for four feedback-capacitance cases from `tia_extension/scripts/run_11_import_opa818_spice_round8b.m`.
- First-pass behavioural noise contribution and noise-bandwidth trade-off analysis from `tia_extension/scripts/run_07_noise_baseline.m` and `tia_extension/scripts/run_08_noise_bandwidth_tradeoff.m`.
- Reproducible figure manifest at `tia_extension/figures/figure_manifest_tia.csv`.
- Datasheet-derived vendor op-amp candidate table from `tia_extension/scripts/run_09_vendor_opamp_datasheet_table.m`.
- Round 8A vendor SPICE preparation documents, metadata template, and guarded comparison entry point for future vendor exports.
- OPA818 summary table and combined OP27/OPA818 vendor-model summary.

## Evidence Still Missing

- At least one additional real SPICE macromodel comparison beyond OP27 and OPA818, preferably ADA4817-1 or LTC6268-10.
- Real ADA4817-1 or LTC6268-10 LTspice exports and imported comparison results.
- Cross-model comparison of Safe, Marginal, and Risky project-defined cases.
- Final datasheet value verification before quantitative op-amp ranking.
- Target-journal figure formatting and caption finalization.
- Related-work synthesis and positioning against prior photodiode TIA design workflows.
- Independent review of the behavioural assumptions by a supervisor or domain expert.
- Optional later SPICE noise analysis if the paper scope requires it.

## Portfolio / Research Prototype / Submission Status

- Portfolio evidence: strong enough to show a reproducible MATLAB TIA workflow, figures, tables, and disciplined validation boundaries.
- Research prototype evidence: formed, because the workflow includes behavioural modelling, design-region sweeps, OP27 smoke-test comparison, OPA818 vendor macromodel import, first-pass noise trade-off analysis, and datasheet candidate screening.
- Submission status: not final, because the SPICE comparison evidence still needs at least one additional vendor macromodel comparison and final manuscript review.

Final status: **research prototype / Q3 pre-paper prototype, not yet fully Q3 submission-ready**.

## Submission Blockers

- Import and compare at least one additional real vendor SPICE macromodel beyond OP27 and OPA818.
- Use the Round 8A workflow to collect and import real ADA4817-1 or LTC6268-10 LTspice exports.
- Use the datasheet candidate table to select and confirm additional vendor macromodel cases.
- Confirm that the project-defined classification criteria remain useful across multiple op-amp models.
- Convert the current pre-paper package into a complete manuscript with related work, final captions, and target-journal formatting.
