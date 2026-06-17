# Photodiode TIA Report/Preprint Evidence Package

This folder contains the photodiode transimpedance amplifier (TIA) behavioural screening extension for the op-amp design-region mapping project.

The current report/preprint package is built around a reproducible MATLAB workflow:

1. define design assumptions for `Rf`, `Cf`, `Cpd`, `Cin`, `Cstray`, `A0`, `ft`, and supply context;
2. evaluate a simplified closed-loop TIA behavioural model;
3. run MATLAB sweeps and extract bandwidth, peaking, and response metrics;
4. assign project-defined Safe/Marginal/Risky screening labels;
5. compare selected cases with existing OP27, OPA818, and ADA4817 vendor-macromodel export summaries; and
6. add first-pass behavioural noise context.

This is a simulation-only pre-design triage workflow. It is not hardware validation, measured-noise validation, complete SPICE coverage, a universal stability guarantee, or a new TIA topology claim.

## Folder Structure

| Folder | Purpose |
| --- | --- |
| `functions/` | Reusable TIA behavioural model, metric extraction, classification, and noise helpers. |
| `scripts/` | MATLAB scripts that generate or check the TIA evidence package. |
| `results/` | CSV response, sweep, metric, agreement, and noise summaries. |
| `figures/` | Generated TIA figures used by the manuscript draft. |
| `docs/` | Assumption notes, transfer-function notes, SPICE planning notes, and noise-positioning notes. |
| `datasheets/` | Local vendor candidate table, SI-normalized parameter table, and datasheet source notes. |
| `spice_interface/` | Import helpers, manual-export records, wrappers, and vendor macromodel comparison documentation. |
| `prepaper/` | Reading notes, evidence maps, manuscript planning, and citation-verification notes. |
| `overleaf_draft_v0_9/` | Portable report/preprint LaTeX draft with bundled figures. |

## Reproducibility Quick Start

Run MATLAB from the repository root:

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

The vendor-agreement scripts consume existing CSV export summaries. They do not run new SPICE simulations.

## Figure/Table To Script Crosswalk

| Report artifact | Script or source | CSV/source data | Output asset |
| --- | --- | --- | --- |
| Workflow overview | `overleaf_draft_v0_9/figures/methodology_workflow_figure.tex` | LaTeX-native diagram | Bundled in Overleaf draft |
| Model assumptions table | `overleaf_draft_v0_9/tables/tables.tex`; `docs/tia_model_assumptions.md` | `results/baseline_metrics.csv`; `results/tia_sweep_Cf_peaking_bandwidth.csv`; `results/tia_sweep_summary.csv`; `results/tia_design_region_map.csv` | Table macro in `overleaf_draft_v0_9/tables/tables.tex` |
| Baseline magnitude/phase response | `scripts/run_01_tia_baseline.m` | `results/tia_baseline_response.csv`; `results/baseline_metrics.csv` | `figures/tia_baseline_magnitude.png`; `figures/tia_baseline_phase.png` |
| Feedback-capacitance bandwidth sweep | `scripts/run_03_sweep_Cf_for_peaking_bandwidth.m` | `results/tia_sweep_Cf_peaking_bandwidth.csv` | `figures/tia_bandwidth_vs_Cf.png` |
| Feedback-capacitance peaking sweep | `scripts/run_03_sweep_Cf_for_peaking_bandwidth.m` | `results/tia_sweep_Cf_peaking_bandwidth.csv` | `figures/tia_peaking_vs_Cf.png` |
| Project-defined screening criteria table | `functions/classify_tia_design_region.m`; `overleaf_draft_v0_9/tables/tables.tex` | Classification rules encoded in MATLAB helper and manuscript table macro | Table macro in `overleaf_draft_v0_9/tables/tables.tex` |
| Design-region map | `scripts/run_04_sweep_Cpd_and_ft.m`; `scripts/run_05_design_region_map_tia.m` | `results/tia_sweep_summary.csv`; `results/tia_design_region_map.csv` | `figures/tia_design_region_map_Cpd_ft.png` |
| Representative Safe/Marginal/Risky responses | `scripts/run_05_design_region_map_tia.m` | `results/tia_representative_responses.csv` | `figures/tia_representative_region_responses.png` |
| Behavioural-vs-vendor agreement table | `scripts/run_15_behavioural_vs_vendor_agreement_cin.m`; `overleaf_draft_v0_9/tables/tables.tex` | `results/behavioural_vs_vendor_agreement_summary.csv`; `results/spice_comparison_summary_vendor_models.csv` | Table macro in `overleaf_draft_v0_9/tables/tables.tex` |
| Agreement error summary figure | `scripts/run_15_behavioural_vs_vendor_agreement_cin.m` | `results/behavioural_vs_vendor_agreement_summary.csv` | `figures/behavioural_vs_vendor_agreement_error_summary.png` |
| Cin ablation compact metrics | `scripts/run_16_cin_ablation_agreement_analysis.m` | `results/cin_ablation_agreement_summary.csv`; `results/cin_ablation_compact_metrics.csv` | Numeric discussion in manuscript text |
| Small-Cf boundary overlays | `scripts/run_16_cin_ablation_agreement_analysis.m` | Existing vendor export summaries and behavioural recomputation | `figures/behavioural_vs_vendor_overlay_OPA818_Cf0p5_worstcase.png`; `figures/behavioural_vs_vendor_overlay_ADA4817_Cf0p5_worstcase.png`; `figures/behavioural_vs_vendor_overlay_OP27_Cf3p455_negative_control.png` |
| First-pass noise contribution | `scripts/run_07_noise_baseline.m` | `results/noise_baseline_summary.csv` | `figures/tia_noise_contribution_baseline.png` |
| Noise-bandwidth trade-off | `scripts/run_08_noise_bandwidth_tradeoff.m` | `results/noise_tradeoff_summary.csv` | `figures/tia_noise_bandwidth_tradeoff.png` |

## Vendor Case Assumptions

The compared vendor rows are existing macromodel export summaries under stated repository assumptions.

| Device group | Main role | Supply context | Shared TIA assumptions | Input capacitance assumption |
| --- | --- | --- | --- | --- |
| OP27 | Low-GBW negative-control / limitation case | `+15/-15 V` | `Rf = 10 kOhm`, `Cpd = 10 pF`, selected `Cf` rows | `Cin = 0 F` fallback; scalar OP27 value remains `needs_manual_check` |
| OPA818 | Main high-speed vendor comparison case | `+5/-5 V` | `Rf = 10 kOhm`, `Cpd = 10 pF`, selected `Cf` rows | `Cin = 2.4 pF` from local SI-normalized datasheet table |
| ADA4817 | Main high-speed vendor comparison case | `+5/-5 V` | `Rf = 10 kOhm`, `Cpd = 10 pF`, selected `Cf` rows | `Cin = 1.4 pF` from local SI-normalized datasheet table |

Additional assumptions:

- `Cstray = 0 F` in the agreement analysis; it is not fitted.
- `A0 = 1e5` remains an inherited behavioural-model assumption because case-matched vendor open-loop gain values are not part of the current vendor comparison table.
- `ft_proxy_Hz` is read from the local SI-normalized vendor op-amp table where available.

Primary source records:

- `docs/vendor_input_capacitance_assumptions_round26.md`
- `datasheets/vendor_opamp_candidate_table_si.csv`
- `results/spice_comparison_summary_vendor_models.csv`
- `results/behavioural_vs_vendor_agreement_summary.csv`
- `results/cin_ablation_compact_metrics.csv`

## Vendor Macromodel And Copyright Notes

Vendor macromodel source files, simulator libraries, and simulator project packages may be governed by vendor licence terms. Before public release or DOI archival:

- audit `spice_interface/vendor_models_local/` and simulator-package files;
- remove or replace files that cannot be redistributed;
- document official vendor download locations and access dates where available;
- keep wrapper/testbench notes and extracted CSV summaries only where redistribution is allowed; and
- make clear that vendor macromodel summaries are simulation evidence, not hardware measurement.

The current repository contains historical working files from local vendor-model import work. They should be reviewed before a public archival release.

## Environment Notes

Known workflow requirements:

- MATLAB with standard table I/O and plotting support.
- LTspice or vendor simulator tools only if regenerating manual vendor macromodel exports.
- No hardware measurement setup.
- No random seed requirement for the deterministic AC/metric scripts.

Environment fields still needing manual check before a public release:

- MATLAB release and installed toolboxes.
- LTspice or vendor simulator version.
- Operating system and any path assumptions.
- Whether the behavioural scripts run unchanged in GNU Octave.

## Report/Preprint Boundaries

Use these wording boundaries in public-facing text:

- Use "vendor macromodel comparison" or "vendor export comparison", not "hardware validation".
- Use "first-pass behavioural noise estimate", not "measured-noise validation".
- Use "project-defined screening labels", not universal Safe/Marginal/Risky design rules.
- Treat small-Cf labels near the bandwidth-limited corner as provisional until detailed vendor macromodel or SPICE evidence is reviewed.
- Keep abstract-only and metadata-only sources out of detailed methods or numerical claims.

## Public Release Checklist

Before minting a DOI or circulating a public preprint:

1. Audit vendor model redistribution rights.
2. Record MATLAB, simulator, and OS versions.
3. Replace repository/DOI placeholders after release archival.
4. Finalize `CITATION.cff` author and DOI fields.
5. Format references only after manual-check sources are resolved.
6. Run the figure/table scripts and compare regenerated CSV/figure timestamps.
