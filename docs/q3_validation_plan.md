# Q3 Validation Plan

## Purpose

This plan defines the evidence path needed to move from a MATLAB portfolio project toward a controlled Q3-oriented photodiode TIA prototype.

The current repository is suitable for a portfolio because it provides a reproducible MATLAB behavioural modelling workflow.

For a Q3 prototype, MATLAB-only modelling is not enough.

Real SPICE macromodel comparison is a required evidence module.

## Why MATLAB-Only Is Enough for Portfolio but Not for Q3 Prototype

MATLAB behavioural modelling is enough for a portfolio because it can demonstrate:

- modelling discipline
- reproducible scripts
- parameter sweeps
- metric extraction
- design-region classification
- clear documentation of limitations

For a Q3-oriented prototype, the behavioural assumptions must be compared against circuit-level reference models.

That comparison does not require hardware measurement at this stage.

It does require real exported SPICE macromodel simulation data.

## What SPICE Macromodel Comparison Means

SPICE macromodel comparison means simulating selected vendor op-amp macromodels in a circuit simulator.

The SPICE circuit should use the same TIA circuit assumptions as the MATLAB model wherever possible.

The SPICE AC response must be exported.

The exported data must be imported and compared with the MATLAB behavioural model.

This is model-level validation or comparison.

It is not hardware validation.

## Minimum SPICE Requirement

The minimum Q3 evidence package should include:

- 2-3 real op-amp vendor macromodels
- same TIA circuit assumptions as the MATLAB model
- AC response export
- comparison of bandwidth
- comparison of peaking
- comparison of magnitude error
- comparison of phase error
- summary table
- comparison figures

Each selected op-amp must have a datasheet record and macromodel source record.

## Required Comparison Outputs

The comparison module should generate:

- imported SPICE AC response CSV files
- MATLAB behavioural response CSV files
- comparison summary tables
- magnitude comparison figures
- phase comparison figures
- bandwidth and peaking tables
- notes on agreement and disagreement
- `figure_manifest.csv` entries for all generated figures

## Figure and Data Rules

Save source data to CSV before plotting.

Export figures as PDF, SVG, and 600 dpi PNG where possible.

Record source script, source data, key parameters, caption, and data type in `figure_manifest.csv`.

Do not hide poor or unexpected trends.

Do not smooth clean simulation data without justification.

Do not invent missing SPICE data.

## Difference from Hardware Measurement

SPICE macromodel comparison checks MATLAB behavioural predictions against vendor macromodel simulations.

Hardware measurement would require a physical circuit, measurement equipment, calibration, uncertainty handling, and measured response data.

This repository does not currently include hardware measurement.

SPICE macromodel comparison must not be described as hardware validation.

## Current Status

At this round, no TIA code is added.

At this round, no SPICE data is added.

At this round, no SPICE validation is claimed.

The active LPF MATLAB functions remain unchanged.

The Q3 prototype path requires later implementation of the TIA model, datasheet case table, SPICE macromodel comparison, first-pass TIA noise analysis, and pre-paper package.
