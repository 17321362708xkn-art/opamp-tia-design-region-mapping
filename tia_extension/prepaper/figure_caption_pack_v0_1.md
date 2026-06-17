# Figure Caption Pack v0.1

This caption pack uses existing repository figures only. Captions are cautious and evidence-bound. No new figures are generated in this round.

## Main Figure Order

### Figure 1. Baseline TIA response magnitude and phase

- Source files:
  - `tia_extension/figures/tia_baseline_magnitude.png`
  - `tia_extension/figures/tia_baseline_phase.png`
- Source data:
  - `tia_extension/results/tia_baseline_response.csv`
  - `tia_extension/results/baseline_metrics.csv`
- Draft caption: Baseline MATLAB behavioural transimpedance response for the selected photodiode TIA case, comparing ideal and finite-gain op-amp assumptions in magnitude and inversion-removed phase. The curves are behavioural model outputs and are not vendor macromodel or hardware measurement data.

### Figure 2. Feedback-capacitance sweep: bandwidth versus `Cf`

- Source file: `tia_extension/figures/tia_bandwidth_vs_Cf.png`
- Source data: `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv`
- Draft caption: Extracted -3 dB bandwidth versus feedback capacitance for the selected MATLAB behavioural TIA sweep. The figure shows the bandwidth cost associated with increasing `Cf` under the explored assumptions; it is not a universal compensation rule.

### Figure 3. Feedback-capacitance sweep: peaking versus `Cf`

- Source file: `tia_extension/figures/tia_peaking_vs_Cf.png`
- Source data: `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv`
- Draft caption: Extracted gain peaking versus feedback capacitance for the selected MATLAB behavioural TIA sweep. Peaking is used here as a project screening metric and stability proxy, not as a complete proof of phase margin or hardware stability.

### Figure 4. Project-defined design-region map across `Cpd` and op-amp `ft`

- Source file: `tia_extension/figures/tia_design_region_map_Cpd_ft.png`
- Source data:
  - `tia_extension/results/tia_design_region_map.csv`
  - `tia_extension/results/tia_sweep_summary.csv`
- Draft caption: Project-defined behavioural design-region map over photodiode capacitance and op-amp transition frequency. Each tile selects the best available feedback capacitance from the behavioural sweep according to the repository's Safe/Marginal/Risky screening labels. The labels organize the explored design space and are not universal stability classifications.

### Figure 5. Representative Safe/Marginal/Risky responses

- Source file: `tia_extension/figures/tia_representative_region_responses.png`
- Source data: `tia_extension/results/tia_representative_responses.csv`
- Draft caption: Representative MATLAB behavioural transimpedance responses for selected project-defined Safe, Marginal, and Risky cases. The figure connects the screening labels to example frequency-response shapes within the explored assumptions; it does not certify hardware stability.

### Figure 6. Vendor macromodel comparison summary

- Source file: `tia_extension/figures/spice_vendor_model_bandwidth_peaking_summary.png`
- Source data: `tia_extension/results/spice_comparison_summary_vendor_models.csv`
- Draft caption: Three-vendor macromodel comparison summary for OP27, OPA818, and ADA4817 feedback-capacitance cases. The plot compares extracted peaking and -3 dB bandwidth from vendor macromodel exports under the repository's test assumptions. This is vendor macromodel comparison evidence, not hardware validation or complete SPICE coverage.

### Figure 7. First-pass behavioural noise contribution baseline

- Source file: `tia_extension/figures/tia_noise_contribution_baseline.png`
- Source data: `tia_extension/results/noise_baseline_summary.csv`
- Draft caption: First-pass behavioural estimate of integrated output-noise contributions for the baseline TIA case under the configured noise-density assumptions. The estimate is intended for relative screening context and is not measured noise or detector-complete noise validation.

### Figure 8. First-pass noise-bandwidth trade-off

- Source file: `tia_extension/figures/tia_noise_bandwidth_tradeoff.png`
- Source data: `tia_extension/results/noise_tradeoff_summary.csv`
- Draft caption: First-pass behavioural noise-bandwidth trade-off across the selected feedback-capacitance sweep. The figure connects compensation choices to relative bandwidth, peaking, and configured integrated output-noise estimates. It is not measured-noise validation.

## Optional Or Appendix-Candidate Figures

### Figure A1. Safe-window fraction map

- Source file: `tia_extension/figures/tia_safe_window_fraction_map_Cpd_ft.png`
- Source data: `tia_extension/results/tia_safe_window_fraction_map.csv`
- Draft caption: Fraction of explored feedback-capacitance values classified as project-defined Safe for each selected `Rf`, `Cpd`, and `ft_Hz` point. This behavioural map is a screening visualization, not a universal design guarantee.

### Figure A2. OP27 feedback-capacitance sweep magnitude

- Source file: `tia_extension/figures/spice_compare_OP27_Cf_sweep_magnitude.png`
- Source data: `tia_extension/results/spice_comparison_summary.csv`
- Draft caption: OP27 LTspice macromodel smoke-test magnitude sweep across selected feedback-capacitance cases. OP27 is used as a low-GBW smoke-test comparison point and is not presented as a preferred photodiode TIA recommendation.

### Figure A3. OPA818 vendor macromodel magnitude and phase sweep

- Source files:
  - `tia_extension/figures/spice_opa818_cf_sweep_magnitude.png`
  - `tia_extension/figures/spice_opa818_cf_sweep_phase.png`
- Source data: `tia_extension/spice_interface/imported_ac_data/round8_opa818/*_processed.csv`
- Draft caption: OPA818 vendor macromodel feedback-capacitance sweep for magnitude and phase under the repository's selected test assumptions. The figure provides simulation-only vendor macromodel comparison evidence.

### Figure A4. ADA4817 vendor macromodel magnitude and phase sweep

- Source files:
  - `tia_extension/figures/spice_ada4817_cf_sweep_magnitude.png`
  - `tia_extension/figures/spice_ada4817_cf_sweep_phase.png`
- Source data: `tia_extension/spice_interface/imported_ac_data/round9_ada4817/*_processed.csv`
- Draft caption: ADA4817 vendor macromodel feedback-capacitance sweep for magnitude and phase under the repository's selected test assumptions. The figure provides simulation-only vendor macromodel comparison evidence and should not be described as hardware validation.
