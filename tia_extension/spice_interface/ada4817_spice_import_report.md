# ADA4817 SPICE Import Report

Round 9 run identifier: `20260616_222610Z`

## Model Source

- Source: ADI ADA4817 official SPICE Macro Model from the ADA4817-1 product page.
- Local ignored model file: `tia_extension/spice_interface/vendor_models_local/ADA4817/ada4817.cir`.
- Vendor model files are not committed or redistributed.

## Subcircuit Pin Order

`.Subckt ADA4817 100 101 102 103 104 105 106`

- `100`: non-inverting input
- `101`: inverting input
- `102`: positive supply
- `103`: negative supply
- `104`: output
- `105`: FB
- `106`: PD

## LTspice Setup Summary

- Tool: LTspice manual AC simulation export.
- Parameters: `Rf = 10 kOhm`, `Cpd = 10 pF`, `AC current = 1 A`, supply `+5 V / -5 V`.
- ADA4817 wiring: `+IN` tied to ground, `-IN` tied to `nin`, `OUT` tied to `out`, `FB` tied to output, and `PD` tied to `+5 V`.
- Sweep: `.ac dec 200 10 10G`.
- Saved signals: `V(out)`, `V(nin)`.

## Raw Files Imported

- `ADA4817_Rf10k_Cpd10p_Cf0p5_raw.txt` from `tia_extension/spice_interface/round9_manual_exports/ADA4817/ADA4817_Cf0p5/ADA4817_Rf10k_Cpd10p_Cf0p5_raw.txt`
- `ADA4817_Rf10k_Cpd10p_Cf1p0_raw.txt` from `tia_extension/spice_interface/round9_manual_exports/ADA4817/ADA4817_Cf1p0/ADA4817_Rf10k_Cpd10p_Cf1p0_raw.txt`
- `ADA4817_Rf10k_Cpd10p_Cf2p2_raw.txt` from `tia_extension/spice_interface/round9_manual_exports/ADA4817/ADA4817_Cf2p2/ADA4817_Rf10k_Cpd10p_Cf2p2_raw.txt`
- `ADA4817_Rf10k_Cpd10p_Cf4p7_raw.txt` from `tia_extension/spice_interface/round9_manual_exports/ADA4817/ADA4817_Cf4p7/ADA4817_Rf10k_Cpd10p_Cf4p7_raw.txt`

## Summary Metrics

| Case | Cf (pF) | Low-frequency Zt (dBOhm) | Peak Zt (dBOhm) | Peaking (dB) | -3 dB bandwidth (Hz) | Region |
|---|---:|---:|---:|---:|---:|---|
| `ADA4817_Rf10k_Cpd10p_Cf0p5` | 0.5 | 79.9945 | 82.9856 | 2.99106 | 3.31131e+07 | Marginal |
| `ADA4817_Rf10k_Cpd10p_Cf1p0` | 1 | 79.9945 | 79.9969 | 0.00238794 | 2.21309e+07 | Safe |
| `ADA4817_Rf10k_Cpd10p_Cf2p2` | 2.2 | 79.9945 | 79.9954 | 0.000882863 | 7.94328e+06 | Safe |
| `ADA4817_Rf10k_Cpd10p_Cf4p7` | 4.7 | 79.9945 | 79.9945 | 4.54747e-13 | 3.46737e+06 | Safe |

## Interpretation

- Low-frequency transimpedance is approximately 80 dBOhm, consistent with a 10 kOhm transimpedance when the AC current source amplitude is 1 A.
- Increasing `Cf` generally reduces extracted -3 dB bandwidth.
- The `Cf = 0.5 pF` case is borderline because peaking is near the Marginal/Risky threshold.
- Larger `Cf` values are safer in peaking terms but reduce bandwidth.
- Compared with OP27 and OPA818, ADA4817 strengthens the vendor-model-dependent design-boundary argument.

## Limitations

- SPICE macromodel comparison only.
- No hardware validation.
- No measured noise.
- No vendor model redistribution.
- Final submission readiness still needs manuscript review, related-work positioning, figure/caption polish, and supervisor or domain review.
