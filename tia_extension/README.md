# Photodiode TIA Extension v0.1

This folder contains the first controlled photodiode transimpedance amplifier (TIA) behavioural modelling extension for the active LPF finite-GBW project.

The current TIA extension is a MATLAB behavioural workflow with controlled first-pass sweeps, a single-model OP27 LTspice smoke-test frequency-response comparison, and a first-pass behavioural noise estimate. It is not hardware measurement, not a complete photodiode TIA design study, not experimental noise validation, and not full Q3 SPICE validation.

## Scope

The current behavioural workflow includes:

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
- first-pass configured output-noise estimates for feedback resistor thermal noise, op-amp input voltage noise, op-amp input current noise, and optional photodiode shot noise.

The model is intended to establish reproducible behavioural evidence before later rounds add broader vendor SPICE macromodel comparisons and prototype evidence.

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
run('tia_extension/scripts/run_07_noise_baseline.m')
run('tia_extension/scripts/run_08_noise_bandwidth_tradeoff.m')
```

The baseline script writes:

- `tia_extension/results/tia_baseline_response.csv`
- `tia_extension/results/baseline_metrics.csv`
- `tia_extension/figures/figure_manifest_tia.csv`
- baseline magnitude and phase figures in PDF, SVG, and 600 dpi PNG where supported by MATLAB.

The Round 5 noise scripts write:

- `tia_extension/results/noise_baseline_summary.csv`
- `tia_extension/results/noise_tradeoff_summary.csv`
- first-pass noise contribution and noise-bandwidth trade-off figures in PDF, SVG, and 600 dpi PNG where supported by MATLAB.

## Current Limitations

- MATLAB behavioural model only.
- OP27 is the only imported real SPICE macromodel comparison so far.
- No hardware measurement.
- First-pass TIA noise estimates are behavioural calculations only, not measured or experimentally validated noise.
- No datasheet-based op-amp case study yet.
- The classification helper is an initial placeholder for later design-region mapping, not a validated design rule.
- Q3 SPICE readiness still requires additional vendor macromodel comparisons.
