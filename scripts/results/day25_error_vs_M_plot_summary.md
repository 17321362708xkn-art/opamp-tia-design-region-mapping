# Day 25 Error-vs-M Plot Summary

Day 25 uses the Day 22 clean non-ideal sweep metrics and the Day 24 robust threshold table.

M is used as a project-defined GBW margin index, not a formal stability margin.

## Baseline K = 10 thresholds

| Quantity | Value |
|---|---:|
| M_marginal | 8.505264 |
| M_safe | 18.237903 |

## Selected baseline K = 10 values

| M | abs_cutoff_error_pct | abs_phase_deviation_deg | abs_gain_error_pct |
|---:|---:|---:|---:|
| 0.50 | 65.973147 | 29.742947 | 0.015299 |
| 1.00 | 48.830452 | 20.553513 | 0.012900 |
| 2.00 | 31.950777 | 12.525969 | 0.012074 |
| 5.00 | 15.591526 | 5.707671 | 0.011698 |
| 10.00 | 8.392613 | 2.983728 | 0.011592 |
| 20.00 | 4.357090 | 1.524634 | 0.011543 |
| 50.00 | 1.778533 | 0.616513 | 0.011515 |

## Figure files

- `C:\Users\Kevin\Documents\pre-MSc electronic engineering modelling portfolio project\figures\day25_abs_cutoff_error_vs_M.png`
- `C:\Users\Kevin\Documents\pre-MSc electronic engineering modelling portfolio project\figures\day25_abs_phase_deviation_vs_M.png`
- `C:\Users\Kevin\Documents\pre-MSc electronic engineering modelling portfolio project\figures\day25_abs_gain_error_vs_M.png`

## Checks

| Check | Result |
|---|---|
| All plotted metrics finite | PASS |
| Baseline cutoff-error magnitude decreases with M | PASS |
| Baseline phase-deviation magnitude decreases with M | PASS |
| Baseline threshold sanity check | PASS |
| Overall result | PASS |
