# Round 8B Change Log

- Branch: `tia-extension-v0.8-real-opa818-spice-import`
- Run identifier: `20260616_193646Z`
- Commit scope: import real OPA818 LTspice AC text exports, create processed CSVs, summary tables, Cf sweep figures, and conservative validation-status documentation.

## Raw Input Files Used

- `tia_extension/spice_interface/round8_manual_exports/OPA818_Cf0.5p/OPA818_Rf10k_Cpd10p_Cf0p5_raw.txt`
- `tia_extension/spice_interface/round8_manual_exports/OPA818_Cf1p/OPA818_Rf10k_Cpd10p_Cf1p0_raw.txt`
- `tia_extension/spice_interface/round8_manual_exports/OPA818_Cf1.5p/OPA818_Rf10k_Cpd10p_Cf1p5_raw.txt`
- `tia_extension/spice_interface/round8_manual_exports/OPA818_Cf2.2p/OPA818_Rf10k_Cpd10p_Cf2p2_raw.txt`

## Generated Processed CSV Files

- `tia_extension/spice_interface/imported_ac_data/round8_opa818/OPA818_Rf10k_Cpd10p_Cf0p5_processed.csv`
- `tia_extension/spice_interface/imported_ac_data/round8_opa818/OPA818_Rf10k_Cpd10p_Cf1p0_processed.csv`
- `tia_extension/spice_interface/imported_ac_data/round8_opa818/OPA818_Rf10k_Cpd10p_Cf1p5_processed.csv`
- `tia_extension/spice_interface/imported_ac_data/round8_opa818/OPA818_Rf10k_Cpd10p_Cf2p2_processed.csv`

## Generated Summary CSV Files

- `tia_extension/results/spice_comparison_summary_opa818_round8.csv`
- `tia_extension/results/spice_comparison_summary_vendor_models.csv`

## Generated Figures

- `tia_extension/figures/spice_opa818_cf_sweep_magnitude.png`
- `tia_extension/figures/spice_opa818_cf_sweep_magnitude.svg`
- `tia_extension/figures/spice_opa818_cf_sweep_phase.png`
- `tia_extension/figures/spice_opa818_cf_sweep_phase.svg`

## Status Updates

- Real SPICE data used: YES.
- Vendor op-amp macromodels compared: 2 (`OP27`, `OPA818`).
- OPA818 cases imported: 4.
- No vendor model files committed.
- No raw LTspice export text files committed.
- No fake SPICE, noise, or hardware validation data added.
- Q3 remains pending at least one additional vendor macromodel comparison before any final submission-readiness claim.
