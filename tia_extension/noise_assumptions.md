# TIA First-Pass Noise Assumptions

Round 5 adds a first-pass MATLAB behavioural noise estimate for the photodiode TIA extension. The results are calculated estimates from the existing behavioural TIA transfer functions. They are not hardware measurement, not experimental noise validation, and not SPICE noise validation.

## Default Configurable Parameters

- Temperature: `300 K`.
- Op-amp input voltage noise density: `3e-9 V/sqrt(Hz)`.
- Op-amp input current noise density: `0.4e-12 A/sqrt(Hz)`.
- Photodiode shot noise: configurable and off by default in `tia_noise_first_pass`.
- Round 5 baseline scripts enable an illustrative photodiode shot-noise term with `I_DC = 1e-9 A` so the optional term appears in the contribution table.
- Frequency grid used by the Round 5 scripts: `1 Hz` to `1e9 Hz`.

The op-amp noise density values are representative first-pass constants for behavioural exploration. They are not fitted to measured data in this round.

## Noise Terms

Feedback resistor thermal current noise is estimated as:

```text
i_Rf = sqrt(4*k*T/Rf)  A/sqrt(Hz)
```

Op-amp input current noise is treated as an equivalent inverting-input current-noise source:

```text
i_n = configured op-amp input current noise density  A/sqrt(Hz)
```

Optional photodiode shot noise is estimated as:

```text
i_shot = sqrt(2*q*I_DC)  A/sqrt(Hz)
```

Op-amp input voltage noise is passed through a finite-gain TIA noise-gain transfer derived from the same first-order op-amp gain model used by `tia_response`:

```text
H_en(s) = A(s) * (s*Cpd + Yf) / (s*Cpd + (1 + A(s))*Yf)
Yf = 1/Rf + s*Cf
A(s) = A0 / (1 + s/(2*pi*fp))
fp = ft/A0
```

The current-noise terms use the existing finite-gain transimpedance magnitude `|Zt_nonideal|` as the output transfer magnitude.

## Integrated Noise

The scripts integrate output noise power spectral density directly over the saved frequency grid:

```text
v_rms = sqrt(integral(Sv(f) df))
```

For reporting a simple bandwidth reference, the scripts also store an effective noise bandwidth approximation:

```text
ENBW_approx = (pi/2) * f_3dB
```

This approximation is a single-pole reference only. The reported integrated output noise is obtained from the behavioural PSD integration, not from measured data.
