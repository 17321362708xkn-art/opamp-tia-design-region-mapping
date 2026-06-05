# Day 23 Classification Summary

Classification uses absolute errors. The quantity M is a GBW margin index, not a stability margin.

## Thresholds

| Region | Gain error | Cutoff error | Phase deviation |
|---|---:|---:|---:|
| Safe | < 1% | < 5% | < 5 deg |
| Marginal | < 2% | < 10% | < 10 deg |
| Risky | otherwise | otherwise | otherwise |

## Overall Counts

| Region | Count |
|---|---:|
| Safe | 176 |
| Marginal | 66 |
| Risky | 293 |

## Counts by K

| K | Safe | Marginal | Risky |
|---:|---:|---:|---:|
| 1 | 41 | 13 | 53 |
| 2 | 37 | 13 | 57 |
| 5 | 34 | 13 | 60 |
| 10 | 32 | 14 | 61 |
| 20 | 32 | 13 | 62 |

## Selected Baseline Rows, K = 10

| M | gain_error_pct | cutoff_error_pct | phase_deviation_fc_deg | region_code | region_label |
|---:|---:|---:|---:|---:|---|
| 0.50 | -0.015299 | -65.973147 | 29.742947 | 3 | Risky |
| 1.00 | -0.012900 | -48.830452 | 20.553513 | 3 | Risky |
| 2.00 | -0.012074 | -31.950777 | 12.525969 | 3 | Risky |
| 5.00 | -0.011698 | -15.591526 | 5.707671 | 3 | Risky |
| 10.00 | -0.011592 | -8.392613 | 2.983728 | 2 | Marginal |
| 20.00 | -0.011543 | -4.357090 | 1.524634 | 1 | Safe |
| 50.00 | -0.011515 | -1.778533 | 0.616513 | 1 | Safe |

## Checks

| Check | Result |
|---|---|
| Region code check | PASS |
| All finite classification check | PASS |
| Classification consistency check | PASS |
| Large cutoff error not Safe check | PASS |
| Large cutoff error Risky check | PASS |
| Severe negative cutoff error Risky check | PASS |
