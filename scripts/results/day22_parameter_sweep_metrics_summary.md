# Day 22 Parameter Sweep Metrics Summary

This table contains clean non-ideal performance extraction results. Classification is not performed on Day 22.

- A0 = 1.000000e+05
- fc_target = 10000.000000 Hz
- K_list = [1   2   5  10  20]
- Number of M values = 107
- Total cases = 535

## Checks

| Check | Result |
|---|---|
| All extracted metrics finite | PASS |
| M index consistency | PASS |
| Baseline K=10 cutoff-error magnitude decreases with M | PASS |
| Baseline K=10 phase-deviation magnitude decreases with M | PASS |

## Selected baseline rows, K = 10

| M | ft_Hz | K_eff | fc_eff_Hz | cutoff_error_pct | phase_deviation_fc_deg |
|---:|---:|---:|---:|---:|---:|
| 0.50 | 5.500000e+04 | 9.99847012 | 3402.6853 | -65.973147 | 29.742947 |
| 1.00 | 1.100000e+05 | 9.99871001 | 5116.9548 | -48.830452 | 20.553513 |
| 2.00 | 2.200000e+05 | 9.99879262 | 6804.9223 | -31.950777 | 12.525969 |
| 5.00 | 5.500000e+05 | 9.99883023 | 8440.8474 | -15.591526 | 5.707671 |
| 10.00 | 1.100000e+06 | 9.99884078 | 9160.7387 | -8.392613 | 2.983728 |
| 20.00 | 2.200000e+06 | 9.99884568 | 9564.2910 | -4.357090 | 1.524634 |
| 50.00 | 5.500000e+06 | 9.99884850 | 9822.1467 | -1.778533 | 0.616513 |
