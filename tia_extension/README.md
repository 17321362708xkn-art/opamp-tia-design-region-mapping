# Photodiode TIA Extension v0.1

This folder contains the first controlled photodiode transimpedance amplifier (TIA) behavioural modelling extension for the active LPF finite-GBW project.

The current TIA extension is a MATLAB-only behavioural baseline. It is not a SPICE comparison, not a hardware measurement, and not a complete photodiode TIA design study.

## Scope

The v0.1 model includes:

- photodiode current input;
- photodiode capacitance `Cpd`;
- feedback resistor `Rf`;
- feedback capacitor `Cf`;
- finite op-amp DC open-loop gain `A0`;
- finite op-amp unity-gain frequency `ft_Hz`;
- transimpedance gain `Zt = Vout / Ipd`;
- bandwidth extraction;
- gain peaking extraction;
- phase response.

The model is intended to establish a reproducible baseline before later rounds add parameter sweeps, SPICE macromodel comparison, and TIA-specific noise analysis.

## Folder Structure

- `docs/` contains modelling assumptions and future SPICE comparison preparation notes.
- `functions/` contains reusable TIA behavioural modelling and metric extraction functions.
- `scripts/` contains reproducible MATLAB workflow scripts.
- `results/` stores CSV source data and metric outputs.
- `figures/` stores generated baseline figures and the figure manifest.

## Running The Baseline

From the repository root in MATLAB:

```matlab
run('tia_extension/scripts/run_01_tia_baseline.m')
run('tia_extension/scripts/run_all_tia_first_pass.m')
```

The baseline script writes:

- `tia_extension/results/tia_baseline_response.csv`
- `tia_extension/results/baseline_metrics.csv`
- `tia_extension/figures/figure_manifest_tia.csv`
- baseline magnitude and phase figures in PDF, SVG, and 600 dpi PNG where supported by MATLAB.

## Current Limitations

- MATLAB behavioural model only.
- No SPICE macromodel comparison yet.
- No hardware measurement.
- No TIA noise analysis yet.
- No datasheet-based op-amp case study yet.
- The classification helper is an initial placeholder for later design-region mapping, not a validated design rule.
