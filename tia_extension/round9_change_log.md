# Round 9 Change Log

- Branch: `tia-extension-v0.9-real-ada4817-spice-import`
- Run identifier: `20260616_222610Z`
- Commit scope: import real ADA4817 LTspice AC text exports, create processed CSVs, summary tables, Cf sweep figures, a three-vendor summary figure, and conservative validation-status documentation.

## Raw Input Files Used

- `tia_extension/spice_interface/round9_manual_exports/ADA4817/ADA4817_Cf0p5/ADA4817_Rf10k_Cpd10p_Cf0p5_raw.txt`
- `tia_extension/spice_interface/round9_manual_exports/ADA4817/ADA4817_Cf1p0/ADA4817_Rf10k_Cpd10p_Cf1p0_raw.txt`
- `tia_extension/spice_interface/round9_manual_exports/ADA4817/ADA4817_Cf2p2/ADA4817_Rf10k_Cpd10p_Cf2p2_raw.txt`
- `tia_extension/spice_interface/round9_manual_exports/ADA4817/ADA4817_Cf4p7/ADA4817_Rf10k_Cpd10p_Cf4p7_raw.txt`

## Generated Processed CSV Files

- `tia_extension/spice_interface/imported_ac_data/round9_ada4817/ADA4817_Rf10k_Cpd10p_Cf0p5_processed.csv`
- `tia_extension/spice_interface/imported_ac_data/round9_ada4817/ADA4817_Rf10k_Cpd10p_Cf1p0_processed.csv`
- `tia_extension/spice_interface/imported_ac_data/round9_ada4817/ADA4817_Rf10k_Cpd10p_Cf2p2_processed.csv`
- `tia_extension/spice_interface/imported_ac_data/round9_ada4817/ADA4817_Rf10k_Cpd10p_Cf4p7_processed.csv`

## Generated Summary CSV Files

- `tia_extension/results/spice_comparison_summary_ada4817_round9.csv`
- `tia_extension/results/spice_comparison_summary_vendor_models.csv`

## Generated Figures

- `tia_extension/figures/spice_ada4817_cf_sweep_magnitude.png`
- `tia_extension/figures/spice_ada4817_cf_sweep_magnitude.svg`
- `tia_extension/figures/spice_ada4817_cf_sweep_phase.png`
- `tia_extension/figures/spice_ada4817_cf_sweep_phase.svg`
- `tia_extension/figures/spice_vendor_model_bandwidth_peaking_summary.png`
- `tia_extension/figures/spice_vendor_model_bandwidth_peaking_summary.svg`

## Status Updates

- Real SPICE data used: YES.
- Vendor op-amp macromodels compared: 3 (`OP27`, `OPA818`, `ADA4817`).
- ADA4817 cases imported: 4.
- No vendor model files committed.
- No raw LTspice export text files committed.
- No fake SPICE, noise, or hardware validation data added.
- No measured noise claim added.
- No active LPF validated functions modified.
- Full Q3 submission readiness is not claimed; final manuscript polish and review remain required.
