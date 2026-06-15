# TIA Model Assumptions

## 1. Purpose

This document records the assumptions used in the first photodiode TIA behavioural baseline model under `tia_extension/`.

The purpose of this round is to create a reproducible MATLAB baseline, not to claim SPICE validation, hardware validation, or a complete TIA design methodology.

## 2. Circuit Scope

The model represents a first-pass photodiode transimpedance amplifier with:

- a photodiode current input `Ipd`;
- photodiode capacitance `Cpd` at the inverting input node;
- feedback resistor `Rf`;
- feedback capacitor `Cf`;
- grounded non-inverting input;
- finite op-amp DC open-loop gain `A0`;
- finite op-amp unity-gain frequency `ft_Hz`.

The output quantity is the transimpedance:

```text
Zt = Vout / Ipd
```

## 3. Feedback Network

The feedback admittance is:

```text
Yf = 1/Rf + s*Cf
```

The ideal op-amp transimpedance is:

```text
Zt_ideal = -1/Yf
```

This gives the expected first-order transimpedance response set by `Rf` and `Cf`.

## 4. Finite-Gain Op-Amp Model

The finite op-amp model uses a single-pole open-loop gain:

```text
A(s) = A0 / (1 + s/(2*pi*fp))
fp = ft_Hz / A0
```

This is a behavioural approximation intended for first-pass frequency-response exploration.

## 5. Non-Ideal TIA Response

Using nodal analysis at the inverting input, with `Vout = -A(s)*vn`, the current input relation is:

```text
Ipd = vn*s*Cpd + (vn - Vout)*Yf
```

The resulting non-ideal transimpedance is:

```text
Zt_nonideal = -A(s) / (s*Cpd + (1 + A(s))*Yf)
```

This equation is implemented in `tia_extension/functions/tia_response.m`.

## 6. Metrics

The baseline extracts:

- effective low-frequency transimpedance gain;
- bandwidth using a -3 dB crossing relative to the low-frequency transimpedance;
- gain error relative to `Rf`;
- gain peaking;
- phase at the extracted bandwidth.

The current metric extraction is intended for clean behavioural simulation data only.

## 7. Out Of Scope For v0.1

- SPICE macromodel comparison;
- hardware measurement;
- noise analysis;
- real op-amp datasheet case studies;
- complete design-region threshold calibration.
