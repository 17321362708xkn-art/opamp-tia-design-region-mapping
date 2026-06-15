# Round 4.5 Change Log

- Branch name: `tia-extension-v0.3a-spice-smoke-test`
- Date: 2026-06-16
- Real SPICE data used: YES
- Vendor op-amp macromodels compared: 1
- Q3 SPICE requirement: pending
- Hardware validation claim: none
- Active LPF validated functions modified: no

## Files Imported

- `tia_extension/spice_interface/imported_ac_data/OP27_Cf3p455_Risky.csv`
- `tia_extension/spice_interface/imported_ac_data/OP27_Cf10p_SafeCandidate.csv`
- `tia_extension/spice_interface/imported_ac_data/OP27_Cf22p_Safe.csv`
- `tia_extension/spice_interface/imported_ac_data/op27_spice_smoke_test_summary.csv`

## Files Generated

- `tia_extension/spice_interface/op27_smoke_test_metadata.csv`
- `tia_extension/spice_interface/op27_spice_smoke_test_report.md`
- `tia_extension/results/spice_comparison_summary.csv`
- `tia_extension/results/spice_comparison_response_OP27_Cf3p455_Risky.csv`
- `tia_extension/results/spice_comparison_response_OP27_Cf10p_SafeCandidate.csv`
- `tia_extension/results/spice_comparison_response_OP27_Cf22p_Safe.csv`
- OP27 comparison figures in `tia_extension/figures/`

## MATLAB Run Status

Completed successfully with `tia_extension/scripts/run_06_compare_with_spice_example.m`.

## Validation Statement

Single-model real SPICE smoke test completed; Q3 SPICE requirement still pending additional vendor macromodels. No fake SPICE data, synthetic noise curves, hardware measurements, or hardware-validation claims were added.
