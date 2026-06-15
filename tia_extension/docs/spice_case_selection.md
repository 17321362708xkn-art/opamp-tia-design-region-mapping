# SPICE Candidate Case Selection

This document explains how `tia_extension/results/spice_candidate_cases.csv` is prepared for a later SPICE macromodel comparison round.

No SPICE simulation data is included in Round 3. The candidate table only selects MATLAB behavioural cases that can later be recreated in a SPICE tool using real vendor macromodels.

## Selection Purpose

The candidate cases are chosen to cover representative project-defined regions:

- Safe
- Marginal
- Risky

These regions are based on the Round 3 behavioural criteria:

- Safe: valid bandwidth and peaking below 1 dB.
- Marginal: valid bandwidth and peaking from 1 dB to 3 dB.
- Risky: peaking above 3 dB or invalid bandwidth extraction.

These are project-defined engineering criteria, not universal design rules.

## Intended Later SPICE Use

For a later Q3-oriented validation module, each selected case should be recreated with:

- the same `Rf`;
- the same `Cf`;
- the same `Cpd`;
- comparable op-amp finite-gain and bandwidth assumptions where possible;
- 2-3 real op-amp vendor macromodels;
- AC response export.

The later comparison should evaluate bandwidth, peaking, magnitude error, and phase error.

SPICE macromodel comparison is model-level comparison, not hardware validation.
