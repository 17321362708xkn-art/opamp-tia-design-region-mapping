# Vendor Input-Capacitance Assumptions For Round 26

This note records the input-capacitance assumptions used by `run_15_behavioural_vs_vendor_agreement_cin.m`. Values are taken from existing repository datasheet tables where available. No new datasheet lookup or external web search was performed in this round.

Source table:

- `tia_extension/datasheets/vendor_opamp_candidate_table_si.csv`

## Assumptions

| Device | Cin used in agreement script | Source status | Notes |
| --- | ---: | --- | --- |
| OPA818 | `2.4e-12 F` | datasheet-derived local table | Uses `input_capacitance_total_F` from the SI-normalized vendor op-amp candidate table. |
| ADA4817 | `1.4e-12 F` | datasheet-derived local table | Uses `input_capacitance_total_F` from the SI-normalized vendor op-amp candidate table for ADA4817-1. |
| OP27 | `0 F` fallback | needs_manual_check | The local SI table records `NaN` for scalar OP27 input capacitance. Round 26 keeps the backward-compatible zero-Cin assumption for the OP27 negative-control comparison and marks the value as needing manual check. |

## Stray Capacitance

`Cstray` is set to `0 F` for all Round 26 agreement rows. This is a manually specified zero-stray assumption, not a fitted board or package parasitic estimate.

## A0 And ft Assumptions

The agreement script uses `ft_proxy_Hz` from the local SI-normalized vendor op-amp table when available. The script uses `A0 = 1e5` as the inherited behavioural-model low-frequency gain assumption because a case-matched open-loop gain value is not available in the vendor comparison summary table. Rows therefore mark the A0 assumption as `needs_manual_check` in the notes.

## Claim Boundary

The resulting agreement analysis compares a simplified MATLAB behavioural model with existing vendor macromodel export data under stated assumptions. It is not hardware validation, not measured-noise validation, not complete SPICE coverage, and not a universal TIA design rule.
