# Day 27 Required ft Summary

This table converts the robust per-K M thresholds into absolute required unity-gain-frequency values.

The conversion uses: ft = M(1+K)fc.

The result is a project-defined design aid, not a universal op-amp selection rule.

| K | M_marginal | M_safe | ft_marginal (MHz) | ft_safe (MHz) |
|---:|---:|---:|---:|---:|
| 1 | 5.318863 | 10.755294 | 0.106377 | 0.215106 |
| 2 | 6.725945 | 13.600560 | 0.201778 | 0.408017 |
| 5 | 8.020551 | 16.218387 | 0.481233 | 0.973103 |
| 10 | 8.505264 | 18.237903 | 0.935579 | 2.006169 |
| 20 | 9.019271 | 18.237903 | 1.894047 | 3.829960 |

## Interpretation

Higher closed-loop gain magnitude K requires higher absolute ft to meet the same project-defined safe criteria.

This conclusion follows from the behavioural model and the selected thresholds. It should not be interpreted as a universal op-amp selection rule.
