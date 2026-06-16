# OP27 LTspice Smoke-Test Report

## Purpose

This smoke test verifies that the TIA SPICE workflow can ingest real LTspice macromodel AC data and compare it with the MATLAB behavioural TIA model. It is a SPICE macromodel comparison only, not hardware validation and not full Q3 SPICE validation.

## Model And Circuit

- LTspice model: built-in OP27 op-amp macromodel
- Feedback resistor: `Rf = 10 kOhm`
- Photodiode capacitance: `Cpd = 10 pF`
- Feedback capacitors: `Cf = 3.455 pF`, `10 pF`, and `22 pF`
- Supplies: `+15 V` and `-15 V`
- AC current source amplitude: `1 A`
- Response: `V(out)`, interpreted as transimpedance `Zt` because `Ipd = 1 A`

## Imported Data

- `tia_extension/spice_interface/imported_ac_data/OP27_Cf3p455_Risky.csv`
- `tia_extension/spice_interface/imported_ac_data/OP27_Cf10p_SafeCandidate.csv`
- `tia_extension/spice_interface/imported_ac_data/OP27_Cf22p_Safe.csv`
- `tia_extension/spice_interface/imported_ac_data/op27_spice_smoke_test_summary.csv`

The raw imported CSV files were not modified. The MATLAB behavioural response is evaluated directly on the LTspice frequency points, so no SPICE smoothing or resampling is applied.

## Summary Of Results

- `Cf = 3.455 pF` shows strong peaking in OP27 SPICE and should be treated as `Risky`.
- `Cf = 10 pF` reduces peaking and is a `Safe` or `SafeCandidate` case.
- `Cf = 22 pF` is more strongly compensated and safer, but has lower bandwidth.

The generated comparison outputs are:

- `tia_extension/results/spice_comparison_summary.csv`
- `tia_extension/results/spice_comparison_response_OP27_Cf3p455_Risky.csv`
- `tia_extension/results/spice_comparison_response_OP27_Cf10p_SafeCandidate.csv`
- `tia_extension/results/spice_comparison_response_OP27_Cf22p_Safe.csv`

## Interpretation

The OP27 smoke test demonstrates that the MATLAB behavioural workflow can ingest real LTspice macromodel data and compare trends, but it also shows that a simplified single-pole MATLAB op-amp model may underpredict peaking for a real op-amp macromodel.

## Limitations

- Only one op-amp macromodel was compared.
- No hardware data was used.
- OP27 is not necessarily an optimized photodiode TIA op-amp.
- Additional high-speed and low-noise op-amp macromodels are needed later.
- Later rounds add OPA818 and ADA4817 real vendor macromodel imports, bringing the package to three real vendor macromodel comparison sets. Full Q3 submission readiness still requires manuscript polish and review.
