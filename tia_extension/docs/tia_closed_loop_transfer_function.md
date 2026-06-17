# TIA Closed-Loop Transfer Function With Input Capacitance

This note documents the behavioural photodiode TIA transfer function used by the MATLAB screening model. It is a modelling note only. It is not hardware validation, measured-noise validation, or a universal stability proof.

## Feedback Network

The feedback impedance is modelled as a feedback resistor in parallel with a feedback capacitor:

```text
Zf(s) = Rf / (1 + s Rf Cf)
```

where `Rf` is the feedback resistance and `Cf` is the feedback capacitance.

## Op-Amp Model

The op-amp is represented by a single-pole finite-gain model:

```text
A(s) = A0 / (1 + s/wp)
```

The pole frequency is selected from the transition-frequency assumption:

```text
wp = 2 pi fp
fp = ft / A0
```

where `A0` is low-frequency open-loop gain and `ft` is the transition-frequency or GBW-style proxy used by the behavioural model.

## Total Input-Node Capacitance

Round 26 extends the behavioural model to include op-amp input capacitance and stray input-node capacitance:

```text
CT = Cpd + Cin + Cstray
```

where:

- `Cpd` is photodiode capacitance.
- `Cin` is op-amp input capacitance.
- `Cstray` is any additional manually specified stray input-node capacitance.

The default values are `Cin = 0` and `Cstray = 0` so earlier scripts remain backward-compatible unless a caller explicitly passes `Cin` or `Cstray`.

## Closed-Loop Transimpedance

With an input current source at the summing node and the non-inverting input at AC ground, the behavioural closed-loop transimpedance is:

```text
Vout(s) / Iin(s) = -A(s) Zf(s) / [1 + A(s) + s CT Zf(s)]
```

The MATLAB implementation uses the equivalent admittance form:

```text
Yf(s) = 1/Rf + s Cf
Vout(s) / Iin(s) = -A(s) / [s CT + (1 + A(s)) Yf(s)]
```

## Design Interpretation

Increasing `CT` increases input-node capacitive loading. In the simplified model, this increases the capacitive noise-gain term and can reduce closed-loop bandwidth or increase peaking when the op-amp transition-frequency assumption is not large enough for the selected `Rf`, `Cf`, and `CT`.

Increasing `Cf` usually reduces peaking in the explored behavioural sweeps, but it also lowers the ideal feedback pole and therefore reduces bandwidth. Increasing `Rf` raises nominal transimpedance but lowers the ideal feedback pole for a fixed `Cf`. Increasing `ft` improves the available loop-gain bandwidth in this single-pole approximation. Increasing `A0` changes the dominant-pole placement through `fp = ft/A0` and affects low-frequency loop gain.

## Limitations

This expression is intentionally simple. It does not include:

- multiple op-amp poles or zeros,
- input common-mode and differential capacitance split beyond a scalar `Cin`,
- package, board, and layout parasitics unless manually represented through `Cstray`,
- output loading or swing limits,
- nonlinear effects,
- vendor macromodel internal compensation details,
- transistor-level noise behaviour,
- measured detector or hardware effects.

Therefore the model supports early-stage screening and behavioural-vs-vendor-macromodel comparison under stated assumptions. It should not be presented as complete SPICE coverage, hardware validation, measured-noise validation, or a universal TIA stability rule.
