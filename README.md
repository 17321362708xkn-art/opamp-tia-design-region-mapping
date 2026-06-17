# Op-Amp and Photodiode TIA Design-Region Mapping

This repository contains two related MATLAB behavioural modelling workflows:

- an original finite-gain-bandwidth op-amp active low-pass filter study; and
- a photodiode transimpedance amplifier (TIA) report/preprint evidence package under `tia_extension/`.

The current report/preprint focus is the TIA extension. It presents a reproducible early-stage design-screening workflow for photodiode TIAs using MATLAB behavioural sweeps, project-defined Safe/Marginal/Risky screening labels, selected vendor-macromodel export comparisons, and first-pass behavioural noise context.

## Scope

The TIA workflow is a simulation and modelling package for pre-design triage. It is intended to help readers reproduce the figures and tables, inspect the modelling assumptions, and see where the simplified behavioural model agrees or disagrees with selected vendor macromodel summaries.

It is not:

- a hardware validation study;
- measured-noise validation;
- a universal TIA design rule;
- a new TIA topology claim;
- complete SPICE, process, temperature, layout, or device-noise coverage; or
- a final target-journal submission package.

The main report takeaway is an applicability boundary: the behavioural model is most useful for fast screening away from the small-feedback-capacitance bandwidth-limited corner, while small-Cf cases should be treated as provisional and reviewed with detailed vendor macromodel or SPICE evidence.

## Repository Structure

```text
.
|-- functions/                  # Original active-LPF MATLAB functions
|-- scripts/                    # Original active-LPF MATLAB scripts
|-- figures/                    # Original active-LPF generated figures
|-- docs/                       # Original active-LPF documentation
|-- tia_extension/              # Photodiode TIA report/preprint package
|   |-- functions/              # TIA behavioural model and extraction helpers
|   |-- scripts/                # Reproducible TIA MATLAB scripts
|   |-- results/                # CSV response, metrics, agreement, and noise outputs
|   |-- figures/                # Generated TIA figures
|   |-- docs/                   # Model, assumption, SPICE, and noise notes
|   |-- datasheets/             # Local vendor parameter tables and source notes
|   |-- spice_interface/        # Import helpers, wrappers, and existing export records
|   |-- prepaper/               # Manuscript planning and evidence notes
|   `-- overleaf_draft_v0_9/    # Portable report/preprint LaTeX draft
`-- CITATION.cff                # Draft citation metadata template
```

## TIA Quick Start

Run MATLAB from the repository root. The main TIA scripts are deterministic AC/metric workflows and do not require random seeds.

```matlab
run('tia_extension/scripts/run_01_tia_baseline.m')
run('tia_extension/scripts/run_03_sweep_Cf_for_peaking_bandwidth.m')
run('tia_extension/scripts/run_04_sweep_Cpd_and_ft.m')
run('tia_extension/scripts/run_05_design_region_map_tia.m')
run('tia_extension/scripts/run_07_noise_baseline.m')
run('tia_extension/scripts/run_08_noise_bandwidth_tradeoff.m')
run('tia_extension/scripts/run_15_behavioural_vs_vendor_agreement_cin.m')
run('tia_extension/scripts/run_16_cin_ablation_agreement_analysis.m')
```

The vendor-agreement scripts consume existing repository CSV exports. They do not run new SPICE simulations.

## Figure and Table Reproducibility Map

This table is the public report/preprint crosswalk between manuscript artifacts and repository evidence. The complete TIA documentation lives in `tia_extension/README.md`.

| Manuscript artifact | Regeneration or source file | Data source | Figure/table asset |
| --- | --- | --- | --- |
| Workflow overview figure | `tia_extension/overleaf_draft_v0_9/figures/methodology_workflow_figure.tex` | LaTeX-native diagram, not simulation data | Bundled in Overleaf draft |
| Baseline TIA response | `tia_extension/scripts/run_01_tia_baseline.m` | `tia_extension/results/tia_baseline_response.csv`; `tia_extension/results/baseline_metrics.csv` | `tia_extension/figures/tia_baseline_magnitude.png`; `tia_extension/figures/tia_baseline_phase.png` |
| Feedback-capacitance bandwidth and peaking sweeps | `tia_extension/scripts/run_03_sweep_Cf_for_peaking_bandwidth.m` | `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv` | `tia_extension/figures/tia_bandwidth_vs_Cf.png`; `tia_extension/figures/tia_peaking_vs_Cf.png` |
| Design-region map and representative responses | `tia_extension/scripts/run_04_sweep_Cpd_and_ft.m`; `tia_extension/scripts/run_05_design_region_map_tia.m` | `tia_extension/results/tia_sweep_summary.csv`; `tia_extension/results/tia_design_region_map.csv`; `tia_extension/results/tia_representative_responses.csv` | `tia_extension/figures/tia_design_region_map_Cpd_ft.png`; `tia_extension/figures/tia_representative_region_responses.png` |
| Behavioural-vs-vendor agreement table and error summary | `tia_extension/scripts/run_15_behavioural_vs_vendor_agreement_cin.m` | `tia_extension/results/behavioural_vs_vendor_agreement_summary.csv`; `tia_extension/results/spice_comparison_summary_vendor_models.csv` | `tia_extension/figures/behavioural_vs_vendor_agreement_error_summary.png` |
| Input-capacitance ablation and boundary overlays | `tia_extension/scripts/run_16_cin_ablation_agreement_analysis.m` | `tia_extension/results/cin_ablation_agreement_summary.csv`; `tia_extension/results/cin_ablation_compact_metrics.csv` | `tia_extension/figures/behavioural_vs_vendor_overlay_OPA818_Cf0p5_worstcase.png`; `tia_extension/figures/behavioural_vs_vendor_overlay_ADA4817_Cf0p5_worstcase.png`; `tia_extension/figures/behavioural_vs_vendor_overlay_OP27_Cf3p455_negative_control.png` |
| First-pass noise contribution | `tia_extension/scripts/run_07_noise_baseline.m` | `tia_extension/results/noise_baseline_summary.csv` | `tia_extension/figures/tia_noise_contribution_baseline.png` |
| Noise-bandwidth trade-off | `tia_extension/scripts/run_08_noise_bandwidth_tradeoff.m` | `tia_extension/results/noise_tradeoff_summary.csv` | `tia_extension/figures/tia_noise_bandwidth_tradeoff.png` |

## Vendor-Macromodel Assumptions

The selected vendor rows are model-comparison evidence under stated assumptions, not hardware measurements.

- OP27 rows use `Rf = 10 kOhm`, `Cpd = 10 pF`, selected `Cf` values, and `+15/-15 V` supply assumptions from the existing OP27 smoke-test export summaries.
- OPA818 and ADA4817 rows use `Rf = 10 kOhm`, `Cpd = 10 pF`, selected `Cf` values, and `+5/-5 V` supply assumptions from the existing manual export summaries.
- Documented input capacitance values are used where available: OPA818 uses `Cin = 2.4 pF`, ADA4817 uses `Cin = 1.4 pF`, and OP27 retains a `Cin = 0 F` fallback because the scalar OP27 value remains a manual-check item.
- `Cstray = 0 F` is used in the agreement analysis and is not fitted.
- The inherited behavioural open-loop gain assumption is `A0 = 1e5`; vendor-specific open-loop gain remains a manual-check item.

See `tia_extension/docs/vendor_input_capacitance_assumptions_round26.md` and `tia_extension/results/spice_comparison_summary_vendor_models.csv` for the current source records.

## Vendor Model Copyright and Public Release Note

Vendor macromodel files and simulator project files may be governed by TI, Analog Devices, or other vendor terms. Before any public archival release, audit `tia_extension/spice_interface/vendor_models_local/` and any simulator-package files. The preferred public-release pattern is to document vendor download locations and provide wrappers, testbench notes, extracted CSV summaries, and generated figures only where redistribution is permitted.

## Requirements

Known requirements for the TIA workflow:

- MATLAB with standard plotting and table I/O support.
- LTspice or vendor simulator tools only for manual regeneration of vendor macromodel exports.
- No external hardware is required.
- No random seed is required for the deterministic AC/metric scripts.

Exact MATLAB release, toolbox requirements, LTspice version, and OS should be recorded before public DOI archival.

## Citation

`CITATION.cff` is included as a draft citation metadata template. Replace placeholder author, affiliation, version, and DOI fields before a public release.

Recommended public archival workflow:

1. Audit vendor model redistribution terms.
2. Create a GitHub release tag.
3. Archive the release with Zenodo or a similar service.
4. Replace repository/DOI placeholders in the manuscript and `CITATION.cff`.

## Original Active-LPF Workflow

The original active low-pass filter project remains available under the top-level `functions/`, `scripts/`, `figures/`, and `docs/` folders. Its core scripts are unchanged by the TIA report/preprint documentation work.
