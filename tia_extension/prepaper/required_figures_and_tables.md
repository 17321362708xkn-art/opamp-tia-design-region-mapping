# Required Figures And Tables

## Existing Figures For A Q3 Manuscript Draft

- Baseline TIA magnitude: `tia_extension/figures/tia_baseline_magnitude.png` with PDF/SVG companions.
- Baseline TIA phase: `tia_extension/figures/tia_baseline_phase.png` with PDF/SVG companions.
- Bandwidth versus feedback capacitance: `tia_extension/figures/tia_bandwidth_vs_Cf.png` with PDF/SVG companions.
- Peaking versus feedback capacitance: `tia_extension/figures/tia_peaking_vs_Cf.png` with PDF/SVG companions.
- Design-region map: `tia_extension/figures/tia_design_region_map_Cpd_ft.png` with PDF/SVG companions.
- Representative region responses: `tia_extension/figures/tia_representative_region_responses.png` with PDF/SVG companions.
- Safe-window fraction map: `tia_extension/figures/tia_safe_window_fraction_map_Cpd_ft.png` with PDF/SVG companions.
- OP27 risky-case magnitude comparison: `tia_extension/figures/spice_compare_OP27_Cf3p455_Risky_magnitude.png` with PDF/SVG companions.
- OP27 risky-case phase comparison: `tia_extension/figures/spice_compare_OP27_Cf3p455_Risky_phase.png` with PDF/SVG companions.
- OP27 safe-candidate magnitude comparison: `tia_extension/figures/spice_compare_OP27_Cf10p_SafeCandidate_magnitude.png` with PDF/SVG companions.
- OP27 safe-candidate phase comparison: `tia_extension/figures/spice_compare_OP27_Cf10p_SafeCandidate_phase.png` with PDF/SVG companions.
- OP27 safe-case magnitude comparison: `tia_extension/figures/spice_compare_OP27_Cf22p_Safe_magnitude.png` with PDF/SVG companions.
- OP27 safe-case phase comparison: `tia_extension/figures/spice_compare_OP27_Cf22p_Safe_phase.png` with PDF/SVG companions.
- OP27 feedback-capacitance sweep magnitude: `tia_extension/figures/spice_compare_OP27_Cf_sweep_magnitude.png` with PDF/SVG companions.
- OPA818 feedback-capacitance sweep magnitude: `tia_extension/figures/spice_opa818_cf_sweep_magnitude.png` with SVG companion.
- OPA818 feedback-capacitance sweep phase: `tia_extension/figures/spice_opa818_cf_sweep_phase.png` with SVG companion.
- Noise contribution figure: `tia_extension/figures/tia_noise_contribution_baseline.png` with PDF/SVG companions.
- Noise bandwidth trade-off figure: `tia_extension/figures/tia_noise_bandwidth_tradeoff.png` with PDF/SVG companions.

## Existing Tables And CSV Source Data

- Baseline metrics: `tia_extension/results/baseline_metrics.csv`.
- Baseline response source data: `tia_extension/results/tia_baseline_response.csv`.
- Feedback-capacitance bandwidth/peaking sweep: `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv`.
- Full TIA sweep summary: `tia_extension/results/tia_sweep_summary.csv`.
- Design-region map source data: `tia_extension/results/tia_design_region_map.csv`.
- Representative response source data: `tia_extension/results/tia_representative_responses.csv`.
- Safe-window fraction source data: `tia_extension/results/tia_safe_window_fraction_map.csv`.
- SPICE candidate cases: `tia_extension/results/spice_candidate_cases.csv`.
- OP27 comparison summary CSV: `tia_extension/results/spice_comparison_summary.csv`.
- OP27 case response CSVs:
  - `tia_extension/results/spice_comparison_response_OP27_Cf3p455_Risky.csv`
  - `tia_extension/results/spice_comparison_response_OP27_Cf10p_SafeCandidate.csv`
  - `tia_extension/results/spice_comparison_response_OP27_Cf22p_Safe.csv`
- OPA818 Round 8B summary CSV: `tia_extension/results/spice_comparison_summary_opa818_round8.csv`.
- Combined vendor macromodel summary CSV: `tia_extension/results/spice_comparison_summary_vendor_models.csv`.
- OPA818 processed AC data CSVs in `tia_extension/spice_interface/imported_ac_data/round8_opa818/`.
- Noise baseline summary: `tia_extension/results/noise_baseline_summary.csv`.
- Noise trade-off summary: `tia_extension/results/noise_tradeoff_summary.csv`.
- Figure manifest: `tia_extension/figures/figure_manifest_tia.csv`.
- Vendor op-amp datasheet candidate source table: `tia_extension/datasheets/vendor_opamp_datasheet_sources.csv`.
- Vendor op-amp datasheet candidate table: `tia_extension/datasheets/vendor_opamp_candidate_table.csv` with Markdown companion `tia_extension/datasheets/vendor_opamp_candidate_table.md`.
- Vendor op-amp SI-normalized candidate table: `tia_extension/datasheets/vendor_opamp_candidate_table_si.csv`.
- Vendor op-amp candidate selection summary: `tia_extension/datasheets/vendor_opamp_candidate_selection_summary.md`.
- Vendor op-amp datasheet table manifest: `tia_extension/datasheets/vendor_opamp_table_manifest.csv`.

## Missing Figures And Tables Before Submission

- At least one additional vendor op-amp SPICE comparison table entry beyond OP27 and OPA818.
- Cross-model Safe/Marginal/Risky comparison table for selected cases.
- Final manuscript-ready verification of datasheet values before quantitative op-amp ranking.
- Final target-journal figure layouts, panel labels, and caption formatting.
- Optional SPICE noise comparison figure if a later round adds real SPICE noise data.

The Round 7 datasheet table and candidate selection summary partially address the candidate-selection blocker for later macromodel work. Round 8B adds OPA818 real vendor macromodel evidence, but it does not replace the need for at least one more vendor SPICE macromodel comparison before a final submission-readiness claim.
