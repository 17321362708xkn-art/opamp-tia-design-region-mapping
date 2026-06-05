# Day 26 Safe / Marginal / Risky Design Map Summary

M is used as a project-defined GBW margin index, not a formal stability margin or phase margin.

## Classification Criteria

| Region | Gain error | Cutoff error | Phase deviation |
|---|---:|---:|---:|
| Safe | < 1% | < 5% | < 5 deg |
| Marginal | < 2% | < 10% | < 10 deg |
| Risky | otherwise | otherwise | otherwise |

## Region Counts by K

| K | Safe | Marginal | Risky |
|---:|---:|---:|---:|
| 1 | 41 | 13 | 53 |
| 2 | 37 | 13 | 57 |
| 5 | 34 | 13 | 60 |
| 10 | 32 | 14 | 61 |
| 20 | 32 | 13 | 62 |

## Robust Thresholds from Day 24

| K | M_marginal | M_safe | ft_required_marginal_Hz | ft_required_safe_Hz |
|---:|---:|---:|---:|---:|
| 1 | 5.318863 | 10.755294 | 1.063773e+05 | 2.151059e+05 |
| 2 | 6.725945 | 13.600560 | 2.017783e+05 | 4.080168e+05 |
| 5 | 8.020551 | 16.218387 | 4.812330e+05 | 9.731032e+05 |
| 10 | 8.505264 | 18.237903 | 9.355791e+05 | 2.006169e+06 |
| 20 | 9.019271 | 18.237903 | 1.894047e+06 | 3.829960e+06 |

## Baseline K = 10 Interpretation

| M | Region code | Region label |
|---:|---:|---|
| 5 | 3 | Risky |
| 10 | 2 | Marginal |
| 20 | 1 | Safe |

For the baseline case K = 10, the extracted thresholds are M_marginal = 8.505264 and M_safe = 18.237903.

## Report Wording

The design map shows that low M values lead to large cutoff-frequency and phase deviations, while sufficiently high M values allow the non-ideal response to remain within the selected safe thresholds. The map should be interpreted as a design aid under the assumptions of this behavioural model, not as a universal op-amp selection rule.

## Checks

| Check | Result |
|---|---|
| Region code grid check | PASS |
| Grid complete check | PASS |
| Metric grid finite check | PASS |
| Threshold K coverage check | PASS |
| Baseline region check | PASS |
| Baseline threshold sanity check | PASS |
