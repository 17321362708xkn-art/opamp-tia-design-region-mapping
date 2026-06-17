# Manuscript v0.1 Writing Plan

This is a section-by-section plan for drafting. It is not the manuscript and does not create a final bibliography.

## Abstract

- What to write: One concise paragraph stating the photodiode TIA screening problem, the MATLAB behavioural design-region workflow, the three vendor macromodel comparison sets, first-pass noise estimates, and the validation boundary.
- Project files: `tia_extension/prepaper/contribution_and_claims.md`; `tia_extension/prepaper/q3_readiness_report.md`; `tia_extension/prepaper/claims_vs_evidence_matrix.md`; `tia_extension/figures/figure_manifest_tia.csv`.
- Literature support: Use no detailed citations in the first abstract draft; rely on cited Introduction/Related Work later.
- Do not overclaim: No hardware validation, no measured noise, no universal stability rule, no final Q3 readiness.

## Introduction

- What to write: Motivate photodiode TIA pre-design as a coupled bandwidth, capacitance, compensation, peaking, and noise problem. Introduce why a reproducible screening workflow is useful before detailed vendor simulation or hardware work.
- Project files: `tia_extension/figures/tia_baseline_magnitude.png`; `tia_extension/figures/tia_bandwidth_vs_Cf.png`; `tia_extension/figures/tia_peaking_vs_Cf.png`; `tia_extension/figures/tia_design_region_map_Cpd_ft.png`; `tia_extension/prepaper/results_storyline.md`.
- Literature support: NOH_2020_CF_TIA_DC_LOOP; ANALUI_2004_BW_ENHANCEMENT; LU_2007_BROADBAND_TIA; PARK_YOO_2004_RGC_TIA; VAZQUEZ_2021_OPTICAL_DETECTION_TIA as abstract-level only.
- Do not overclaim: Do not say the workflow replaces circuit design, layout-aware SPICE, or measurement.

## Related Work

- What to write: Organize literature by role: feedback/compensation and bandwidth enhancement; regulated-cascode and modified-RGC TIAs; inductorless CMOS optical receiver TIAs; high-speed CMOS receiver front ends; low-noise/noise-bandwidth sources; simulation/screening workflow context.
- Project files: `tia_extension/prepaper/first_reading_notes_summary.md`; `tia_extension/prepaper/abstract_only_sources_policy.md`; `tia_extension/prepaper/related_work_taxonomy.md`; `tia_extension/prepaper/related_work_to_claims_map.md`.
- Literature support: NOH_2020_CF_TIA_DC_LOOP; ANALUI_2004_BW_ENHANCEMENT; LU_2007_BROADBAND_TIA; PARK_YOO_2004_RGC_TIA; XU_2011_INDUCTORLESS_TIA; LEE_2021_4GHZ_SDT_VG_TIA; TAKAHASHI_2022_LOCAL_FEEDBACK_RGC; PAN_LUO_2022_20GBPS_TIA; PAN_2022_26GBPS_RX; ABDOLLAHI_2025_MDFRGC_TIA; MESGARI_2024_MULTI_DOT_PIN_RX. DOI-only Cherry-Hooper and low-noise sources can be mentioned only according to policy.
- Do not overclaim: Do not claim a literature gap as topology novelty; the gap is reproducible early-stage mapping with explicit claim boundaries.

## Methodology

- What to write: Explain the workflow architecture: define assumptions, run MATLAB behavioural model, sweep `Cf`, sweep `Cpd` and `ft_Hz`, classify project-defined regions, select representative cases, compare selected trends with vendor macromodels, and add first-pass noise context.
- Project files: `tia_extension/scripts/run_01_tia_baseline.m`; `tia_extension/scripts/run_03_sweep_Cf_for_peaking_bandwidth.m`; `tia_extension/scripts/run_05_design_region_map_tia.m`; `tia_extension/scripts/run_06_compare_with_spice_example.m`; `tia_extension/scripts/run_07_noise_baseline.m`; `tia_extension/scripts/run_08_noise_bandwidth_tradeoff.m`; `tia_extension/scripts/run_11_import_opa818_spice_round8b.m`; `tia_extension/scripts/run_12_import_ada4817_spice_round9.m`.
- Literature support: Use full-text TIA papers for motivation only, not for claiming method equivalence.
- Do not overclaim: Do not present the scripts as design automation or optimizer output.

## MATLAB Behavioural TIA Model

- What to write: Define `Rf`, `Cf`, `Cpd`, `A0`, `ft_Hz`, transimpedance response, ideal versus finite-gain comparison, and extracted metrics. State the simplified single-pole op-amp assumption.
- Project files: `tia_extension/functions/tia_response.m`; `tia_extension/functions/extract_tia_metrics.m`; `tia_extension/results/tia_baseline_response.csv`; `tia_extension/results/baseline_metrics.csv`; `tia_extension/docs/tia_model_assumptions.md`; `tia_extension/figures/tia_baseline_magnitude.png`; `tia_extension/figures/tia_baseline_phase.png`.
- Literature support: ANALUI_2004_BW_ENHANCEMENT; LU_2007_BROADBAND_TIA; NOH_2020_CF_TIA_DC_LOOP.
- Do not overclaim: Do not claim the behavioural model includes vendor pole/zero structure, slew limits, layout parasitics, package parasitics, saturation, or noise beyond configured first-pass terms.

## SPICE Validation

- What to write: Prefer the phrase "vendor macromodel comparison" in the section text. Explain OP27 as a smoke-test set, OPA818 and ADA4817 as real vendor macromodel export sets, and the combined summary as a check of selected trends.
- Project files: `tia_extension/spice_interface/spice_validation_status.md`; `tia_extension/results/spice_comparison_summary_vendor_models.csv`; `tia_extension/figures/spice_compare_OP27_Cf_sweep_magnitude.png`; `tia_extension/figures/spice_opa818_cf_sweep_magnitude.png`; `tia_extension/figures/spice_opa818_cf_sweep_phase.png`; `tia_extension/figures/spice_ada4817_cf_sweep_magnitude.png`; `tia_extension/figures/spice_ada4817_cf_sweep_phase.png`; `tia_extension/figures/spice_vendor_model_bandwidth_peaking_summary.png`.
- Literature support: Use literature only for context that circuit-level TIA work requires device-aware analysis. The evidence for this section is repository-generated macromodel data.
- Do not overclaim: Do not call this hardware validation, experimental validation, complete SPICE coverage, or measured performance.

## Noise Analysis

- What to write: Present configured noise terms and relative noise-bandwidth trends. Explain that the workflow estimates integrated output-noise contributions from behavioural transfer functions under stated assumptions.
- Project files: `tia_extension/noise_assumptions.md`; `tia_extension/functions/tia_noise_first_pass.m`; `tia_extension/functions/summarise_noise_contributions.m`; `tia_extension/results/noise_baseline_summary.csv`; `tia_extension/results/noise_tradeoff_summary.csv`; `tia_extension/figures/tia_noise_contribution_baseline.png`; `tia_extension/figures/tia_noise_bandwidth_tradeoff.png`.
- Literature support: NOH_2020_CF_TIA_DC_LOOP; LU_2007_BROADBAND_TIA; ABDOLLAHI_2025_MDFRGC_TIA; LI_2021_LOW_NOISE_OPTICAL_RX_TIA as abstract-level only.
- Do not overclaim: Do not claim measured noise, detector-complete noise, or SPICE noise validation.

## Datasheet/Vendor Case Study

- What to write: Explain datasheet-driven candidate screening as a planning step for vendor macromodel selection. Use OP27, OPA818, and ADA4817 as examples of model-dependent comparisons.
- Project files: `tia_extension/datasheets/vendor_opamp_candidate_table.csv`; `tia_extension/datasheets/vendor_opamp_candidate_table_si.csv`; `tia_extension/datasheets/vendor_opamp_candidate_selection_summary.md`; `tia_extension/datasheets/vendor_opamp_datasheet_sources.csv`; `tia_extension/results/spice_comparison_summary_vendor_models.csv`.
- Literature support: TIA literature can motivate why bandwidth, capacitance, input noise, and bias current matter, but the datasheet table itself is project evidence.
- Do not overclaim: Do not rank a universal best op amp and do not present datasheet screening as final device selection.

## Results

- What to write: Follow the storyline: baseline response, `Cf` bandwidth/peaking trade-off, design-region maps, safe-window fraction, OP27/OPA818/ADA4817 macromodel comparison, and first-pass noise trade-off.
- Project files: `tia_extension/prepaper/results_storyline.md`; `tia_extension/prepaper/figure_table_plan.md`; all main figures in `tia_extension/figures/`; result CSVs in `tia_extension/results/`.
- Literature support: Use citations mostly in setup and discussion, not as direct evidence for repository-generated figures.
- Do not overclaim: Keep all claims tied to explored assumptions and source data. Avoid claims of universal behaviour.

## Limitations

- What to write: State the model limitations, SPICE macromodel limitations, noise limitations, literature limitations, and writing readiness limitations.
- Project files: `tia_extension/prepaper/limitations_and_no_overclaim.md`; `tia_extension/prepaper/claims_vs_evidence_matrix.md`; `tia_extension/prepaper/abstract_only_sources_policy.md`; `tia_extension/docs/noise_and_validation_position.md`.
- Literature support: Not necessary; this is primarily a project evidence boundary.
- Do not overclaim: This section should actively prevent hardware, measured-noise, and final-readiness claims.

## Conclusion

- What to write: Summarize the reproducible workflow and current evidence: behavioural maps, vendor macromodel comparison sets, and first-pass noise estimates. Close with the honest next steps: source reading, manuscript drafting, figure/caption polish, and supervisor/domain review.
- Project files: `tia_extension/prepaper/q3_readiness_report.md`; `tia_extension/prepaper/contribution_and_claims.md`; `tia_extension/prepaper/next_submission_tasks.md`; `tia_extension/round12_change_log.md`.
- Literature support: Keep conclusion citation-light; the conclusion should not introduce new source claims.
- Do not overclaim: Do not say the method is publication-ready, hardware validated, measured-noise validated, or a final TIA design rule.

## Drafting Sequence

1. Draft Introduction and Related Work from the reading notes.
2. Draft Methodology from scripts and model assumptions.
3. Draft Results from `results_storyline.md` and `figure_table_plan.md`.
4. Draft Limitations before polishing the Abstract.
5. Draft Abstract and Conclusion last.
6. Only then build a final bibliography from verified full-text sources.
