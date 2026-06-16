# OPA818 SPICE Import Report

Round 8B run identifier: `20260616_193646Z`

## Model Source

- Source: TI OPA818 official PSpice model, `SBOMB74B.ZIP`.
- Subcircuit used locally: `.subckt OPA818 IN+ IN- OUT VCC VEE`.
- Vendor model files are kept under the local ignored `vendor_models_local/` tree and are not committed or redistributed.

## LTspice Setup Summary

- Tool: LTspice manual AC simulation export.
- Circuit: photodiode TIA test case using the OPA818 vendor PSpice macromodel.
- Parameters: `Rf = 10 kOhm`, `Cpd = 10 pF`, `AC current = 1 A`, supply `+5 V / -5 V`.
- Sweep: `.ac dec 200 10 10G`.
- Saved signals: `V(out)`, `V(nin)`.

## Raw Files Imported

- `OPA818_Rf10k_Cpd10p_Cf0p5_raw.txt` from `tia_extension/spice_interface/round8_manual_exports/OPA818_Cf0.5p/OPA818_Rf10k_Cpd10p_Cf0p5_raw.txt`
- `OPA818_Rf10k_Cpd10p_Cf1p0_raw.txt` from `tia_extension/spice_interface/round8_manual_exports/OPA818_Cf1p/OPA818_Rf10k_Cpd10p_Cf1p0_raw.txt`
- `OPA818_Rf10k_Cpd10p_Cf1p5_raw.txt` from `tia_extension/spice_interface/round8_manual_exports/OPA818_Cf1.5p/OPA818_Rf10k_Cpd10p_Cf1p5_raw.txt`
- `OPA818_Rf10k_Cpd10p_Cf2p2_raw.txt` from `tia_extension/spice_interface/round8_manual_exports/OPA818_Cf2.2p/OPA818_Rf10k_Cpd10p_Cf2p2_raw.txt`

## Summary Metrics

| Case | Cf (pF) | Low-frequency Zt (dBOhm) | Peak Zt (dBOhm) | Peaking (dB) | -3 dB bandwidth (Hz) | Region |
|---|---:|---:|---:|---:|---:|---|
| `OPA818_Rf10k_Cpd10p_Cf0p5` | 0.5 | 80.0001 | 80.0001 | 7.10543e-14 | 2.48313e+07 | Safe |
| `OPA818_Rf10k_Cpd10p_Cf1p0` | 1 | 80.0001 | 80.0001 | 1.13687e-13 | 1.47911e+07 | Safe |
| `OPA818_Rf10k_Cpd10p_Cf1p5` | 1.5 | 80.0001 | 80.0001 | 1.98952e-13 | 1.03514e+07 | Safe |
| `OPA818_Rf10k_Cpd10p_Cf2p2` | 2.2 | 80.0001 | 80.0001 | 3.97904e-13 | 7.16143e+06 | Safe |

## Interpretation

- Low-frequency transimpedance is approximately 80 dBOhm, consistent with a 10 kOhm transimpedance when the AC current source amplitude is 1 A.
- Increasing `Cf` reduces the extracted -3 dB bandwidth across the four OPA818 cases.
- The imported OPA818 cases show little or no peaking in this `Rf = 10 kOhm`, `Cpd = 10 pF` setup.
- Compared with OP27, the OPA818 result strengthens the evidence that stability and bandwidth boundaries depend on the vendor macromodel and operating assumptions.

## Limitations

- SPICE macromodel comparison only.
- No hardware validation.
- No measured noise.
- No vendor model redistribution.
- Round 9 subsequently adds ADA4817 as the third real vendor macromodel comparison set; full Q3 final readiness still needs final manuscript review, figure/caption polish, related-work positioning, and supervisor or domain review.
