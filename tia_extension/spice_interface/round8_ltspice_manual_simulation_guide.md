# Round 8 LTspice Manual Simulation Guide

## Purpose

This beginner-friendly guide defines the manual LTspice AC simulations to run for OPA818 and ADA4817-1. The repository does not include vendor model files or new Round 8 SPICE results yet.

## Common TIA AC Setup

Use the following common circuit parameters for every Round 8A planned case:

- Feedback resistor: `Rf = 10k`
- Photodiode capacitance: `Cpd = 10p`
- AC current source amplitude: `1 A`
- Current source DC value: `DC 0`
- AC current source phase: `0` or blank
- Response node: `V(out)`
- Interpretation: because the AC input current is 1 A, `V(out)` is the transimpedance in ohms.

Use this AC sweep directive:

```text
.ac dec 200 10 10G
```

Use this save directive:

```text
.save V(out) V(nin)
```

Suggested supply setup:

- OPA818: use dual supply `+5 V` and `-5 V` if accepted by the model and datasheet operating range.
- ADA4817-1: use dual supply `+5 V` and `-5 V` if accepted by the model and datasheet operating range.
- If the vendor model requires a different legal supply arrangement, document it and do not force invalid supply conditions.

## Suggested Cf Sweep

OPA818:

- `Cf = 0.5p`
- `Cf = 1p`
- `Cf = 1.5p`
- `Cf = 2.2p`

ADA4817-1:

- `Cf = 0.5p`
- `Cf = 1p`
- `Cf = 2.2p`
- `Cf = 4.7p`

## Manual LTspice Steps

1. Place the vendor op-amp symbol or subcircuit according to the vendor model documentation.
2. Connect the TIA topology with the photodiode current source into the inverting node `nin`.
3. Add `Rf` from `out` to `nin`.
4. Add `Cf` in parallel with `Rf`.
5. Add `Cpd = 10p` from `nin` to the photodiode reference or AC ground used in the schematic.
6. Bias the noninverting input according to the selected supply arrangement and vendor model requirements.
7. Add the `.ac` and `.save` directives above.
8. Run the AC simulation.
9. Plot `V(out)` magnitude and phase.
10. Export waveform data as text after simulation.

For each simulation, save:

- one full schematic screenshot;
- one full frequency-response screenshot;
- one exported `V(out)` data file;
- source URL and local model filename in the metadata template.

Do not commit the vendor model file.

## Recommended Raw Export Filenames

- `OPA818_Rf10k_Cpd10p_Cf0p5_raw.txt`
- `OPA818_Rf10k_Cpd10p_Cf1p0_raw.txt`
- `OPA818_Rf10k_Cpd10p_Cf1p5_raw.txt`
- `OPA818_Rf10k_Cpd10p_Cf2p2_raw.txt`
- `ADA4817_Rf10k_Cpd10p_Cf0p5_raw.txt`
- `ADA4817_Rf10k_Cpd10p_Cf1p0_raw.txt`
- `ADA4817_Rf10k_Cpd10p_Cf2p2_raw.txt`
- `ADA4817_Rf10k_Cpd10p_Cf4p7_raw.txt`

## Recommended Screenshot Filenames

- `schematic_OPA818_Rf10k_Cpd10p_Cf0p5.png`
- `response_OPA818_Rf10k_Cpd10p_Cf0p5.png`
- `schematic_OPA818_Rf10k_Cpd10p_Cf1p0.png`
- `response_OPA818_Rf10k_Cpd10p_Cf1p0.png`
- `schematic_OPA818_Rf10k_Cpd10p_Cf1p5.png`
- `response_OPA818_Rf10k_Cpd10p_Cf1p5.png`
- `schematic_OPA818_Rf10k_Cpd10p_Cf2p2.png`
- `response_OPA818_Rf10k_Cpd10p_Cf2p2.png`
- `schematic_ADA4817_Rf10k_Cpd10p_Cf0p5.png`
- `response_ADA4817_Rf10k_Cpd10p_Cf0p5.png`
- `schematic_ADA4817_Rf10k_Cpd10p_Cf1p0.png`
- `response_ADA4817_Rf10k_Cpd10p_Cf1p0.png`
- `schematic_ADA4817_Rf10k_Cpd10p_Cf2p2.png`
- `response_ADA4817_Rf10k_Cpd10p_Cf2p2.png`
- `schematic_ADA4817_Rf10k_Cpd10p_Cf4p7.png`
- `response_ADA4817_Rf10k_Cpd10p_Cf4p7.png`

## Export Notes

The future imported CSV should contain frequency and response columns compatible with `import_spice_ac_data.m`, such as:

- `f_Hz`
- `mag_Zt_dBohm` and `phase_Zt_deg`

or:

- `f_Hz`
- `real_Zt` and `imag_Zt`

The processed CSV should also include case metadata columns such as `case_label`, `vendor_model`, `Rf_ohm`, `Cpd_F`, `Cf_F`, `A0`, and `ft_Hz` if the MATLAB comparison is expected to run automatically.

This guide does not add SPICE validation; it only prepares the manual export workflow.
