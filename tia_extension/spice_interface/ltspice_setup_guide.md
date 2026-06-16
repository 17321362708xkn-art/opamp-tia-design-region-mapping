# LTspice Setup Guide For Later TIA Comparison

This guide describes how to prepare real AC data for a later MATLAB-vs-SPICE macromodel comparison.

It does not provide or invent SPICE results.

## 1. Circuit

Use the same TIA assumptions as the MATLAB behavioural candidate case:

- photodiode current input;
- photodiode capacitance `Cpd`;
- feedback resistor `Rf`;
- feedback capacitor `Cf`;
- selected op-amp vendor macromodel;
- AC current excitation at the photodiode input.

## 2. AC Excitation

Use an AC current source at the photodiode input. A convenient setup is:

```text
AC 1
```

With 1 A small-signal current, the output voltage magnitude directly represents transimpedance magnitude in ohms.

## 3. Simulation Range

Use a frequency range that covers the MATLAB behavioural response and the expected bandwidth region.

For the current Round 3 candidate cases, a practical first pass is:

```text
.ac dec 100 10 10G
```

## 4. Export

Export frequency, output magnitude, and output phase to CSV.

The preferred exported columns are:

- `f_Hz`
- `mag_Zt_ohm` or `mag_Zt_dBohm`
- `phase_Zt_deg`
- `vendor_model`
- `Rf_ohm`
- `Cf_F`
- `Cpd_F`
- `A0`
- `ft_Hz`

## 5. Claim Boundary

SPICE macromodel comparison is model-level comparison.

It is not hardware validation and should not be described as hardware measurement.
