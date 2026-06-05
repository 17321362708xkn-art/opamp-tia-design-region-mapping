# Technical Note: Finite-GBW Behavioural Modelling and Design-Region Mapping

## 1. Background

This project studies how finite open-loop gain and finite gain-bandwidth product,
represented by unity-gain frequency, affect the closed-loop behaviour of an op-amp active
low-pass filter.

The work is a MATLAB-only behavioural modelling project. It is not a SPICE simulation,
and it does not include hardware measurement.

## 2. Circuit and Modelling Scope

The current model represents a first-order inverting op-amp active low-pass filter. It is
not yet a complete photodiode transimpedance amplifier model.

The modelling workflow can provide a foundation for later photodiode TIA modelling, where
photodiode capacitance, transimpedance gain, and additional noise mechanisms would need to
be included explicitly.

## 3. Ideal Transfer Function

The ideal model uses the following component and design quantities:

- `Rin`: input resistance
- `Rf`: feedback resistance
- `Cf`: feedback capacitance
- `K = Rf / Rin`: closed-loop gain magnitude parameter
- `fc = 1 / (2*pi*Rf*Cf)`: ideal first-order cutoff frequency

The inverting transfer response is represented by `H`. For magnitude and phase metric
extraction, the project uses an inversion-removed response:

```text
G = -H
```

This makes the extracted magnitude and phase behaviour easier to compare against the
expected low-pass response.

## 4. Non-Ideal Op-Amp Model

The non-ideal model uses a behavioural single-pole open-loop gain model with finite DC
open-loop gain `A0` and finite unity-gain frequency `ft_Hz`.

The project uses the following gain-bandwidth margin index:

```text
M_index = ft_Hz / ((1 + K) * fc)
```

M_index is a GBW margin index, not a formal stability margin. It should not be interpreted
as phase margin or as a complete loop-stability criterion.

## 5. Metric Extraction

The project extracts several response-level metrics from the inversion-removed response:

- effective low-frequency gain `K_eff`
- effective cutoff frequency `fc_eff`
- gain error
- cutoff frequency error
- phase deviation at `fc`

The phase-deviation metric is defined to express additional phase lag relative to the
ideal response at the cutoff frequency. Positive phase-deviation values indicate
additional phase lag under the project's sign convention.

## 6. Noise and Monte Carlo Robustness

The project includes virtual measurement noise, optional smoothing, and Monte Carlo tests.
These checks are used to evaluate whether the metric-extraction workflow remains stable
when the response contains synthetic noisy perturbations.

These are simulated robustness checks. They are not hardware measurements.

## 7. Parameter Sweep and Design-Region Classification

The project sweeps combinations of closed-loop gain parameter `K` and GBW margin index
`M_index`.

Each case is classified into one of three design regions:

- Safe
- Marginal
- Risky

The classification is based on thresholds for gain error, cutoff-frequency error, and
phase deviation.

## 8. Key Results

The current results support three project-level observations:

1. Error metrics generally decrease as `M_index` increases.
2. The safe / marginal / risky design-region map summarises usable regions under the
   assumptions of this behavioural model.
3. The required `ft` versus `K` plot converts extracted margin thresholds into design-aid
   values.

The main design-region map is:

![Safe marginal risky design map](../figures/day26_safe_marginal_risky_design_map.png)

Related result figures are available in the repository:

- `figures/day26_safe_marginal_risky_design_map.png`
- `figures/day27_required_ft_vs_K.png`
- `figures/day25_abs_phase_deviation_vs_M.png`

## 9. Limitations

- MATLAB behavioural model only
- no SPICE simulation
- no hardware measurement
- no formal loop-stability analysis
- no real op-amp datasheet case study yet
- not yet a complete photodiode TIA model
- required `ft` plot is a model-based design aid, not a universal op-amp selection rule

## 10. Future Work

- improve documentation
- add datasheet-based op-amp case studies
- add SPICE comparison
- extend model to photodiode TIA with photodiode capacitance and transimpedance gain
- add noise analysis for TIA
- compare behavioural predictions with circuit-level simulations
