# TIA Sweep Summary

Run identifier: `20260615_191548Z`

This summary reports clean MATLAB behavioural sweep results only. No SPICE comparison, noise analysis, or hardware measurement is included.

The safe / marginal / risky labels use project-defined engineering criteria, not universal design rules.

## Sweep Ranges

- `Rf = [10e3, 100e3, 1e6]` ohm
- `Cpd = [1e-12, 5e-12, 10e-12, 20e-12]` F
- `Cf = logspace(-13, -11, 40)` F
- `ft = logspace(6, 8, 40)` Hz
- `A0 = 1e5`

## Full Sweep Classification Counts

- `Marginal`: `2066`
- `Risky`: `5568`
- `Safe`: `11566`

## Design Map Classification Counts

- `Safe`: `480`

## Data Integrity Notes

- Invalid bandwidth extractions in full sweep: `0`.
- Maximum extracted peaking in full sweep: `16.993 dB`.
- The design-region map selects the best available `Cf` for each `Rf`, `Cpd`, and `ft` point by project-defined class and then peaking.
- Poor and unexpected cases are retained in `tia_extension/results/tia_sweep_summary.csv`.
- Risky high-peaking cases are present and retained for later review.

## SPICE Candidate Cases

Representative cases were written to `tia_extension/results/spice_candidate_cases.csv` for later SPICE macromodel comparison planning.

- `Safe`: Rf = 1e+04 ohm, Cpd = 1e-11 F, Cf = 3.46e-12 F, ft = 1.6e+06 Hz, peaking = 0.500 dB.
- `Marginal`: Rf = 1e+04 ohm, Cpd = 1e-12 F, Cf = 2.29e-13 F, ft = 4.38e+07 Hz, peaking = 2.000 dB.
- `Risky`: Rf = 1e+04 ohm, Cpd = 5e-12 F, Cf = 5.22e-13 F, ft = 7.02e+07 Hz, peaking = 3.998 dB.

## Generated Figures

- `tia_extension/figures/tia_bandwidth_vs_Cf.*`
- `tia_extension/figures/tia_peaking_vs_Cf.*`
- `tia_extension/figures/tia_design_region_map_Cpd_ft.*`
- `tia_extension/figures/tia_representative_region_responses.*`
