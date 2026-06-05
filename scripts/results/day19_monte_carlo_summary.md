# Day 19 Monte Carlo Noisy Extraction Summary

This is a virtual measurement-style noisy extraction test. It is not experimental measurement.

- Number of seeds: 20
- Valid runs: 20 / 20
- Failed runs: 0 / 20
- Magnitude noise: 0.0500 dB
- Phase noise: 0.5000 deg

| Metric | Unit | Clean value | MC mean | MC std | Mean - clean |
|---|---:|---:|---:|---:|---:|
| K_eff | linear | 9.998845677 | 9.998630248 | 0.002650972451 | -0.0002154291416 |
| fc_eff | Hz | 9564.291021 | 9553.664352 | 58.38346446 | -10.62666932 |
| gain_error | percent | -0.01154323155 | -0.01369752297 | 0.02650972451 | -0.002154291416 |
| cutoff_error | percent | -4.357089785 | -4.463356478 | 0.5838346446 | -0.1062666932 |
| phase_deviation | degrees | 1.52463418 | 1.514190102 | 0.1805438967 | -0.0104440784 |

## Interpretation

The Monte Carlo results show whether the noisy extraction method remains stable across multiple random seeds. The reported values are mean ± standard deviation over valid runs. Failed extraction cases, if any, are counted explicitly.
