# Q3 Validation Plan

## Purpose

This plan defines the validation path needed to move from a MATLAB portfolio project toward a controlled Q3-oriented photodiode TIA prototype.

The current repository is strong enough for a behavioural modelling portfolio because it shows a reproducible MATLAB workflow, parameter sweeps, extracted metrics, result tables, and design-aid plots.

MATLAB-only modelling is not enough for a Q3 prototype because a paper-oriented prototype must show that the behavioural assumptions remain consistent with more detailed circuit-level models.

## Why MATLAB-Only Is Enough for Portfolio but Not for Q3 Prototype

For a portfolio, MATLAB behavioural modelling can demonstrate:

- analytical modelling discipline
- reproducible scripts
- parameter-sweep design thinking
- metric extraction
- classification of design regions
- clear documentation of limitations

For a Q3-oriented prototype, MATLAB-only results are insufficient because the behavioural model must be compared against circuit-level reference models.

The comparison does not need to be hardware measurement at this stage, but it must include real SPICE macromodel data for selected op-amps.

## What SPICE Macromodel Comparison Means

SPICE macromodel comparison means using vendor-provided op-amp macromodels in a circuit simulator and exporting response data for comparison against the MATLAB behavioural model.

The comparison should use the same assumed circuit topology and component values as the MATLAB model wherever possible.

The exported SPICE data should be imported into the repository workflow and compared numerically and visually.

SPICE macromodel comparison must not be described as hardware validation.

## Difference from Hardware Measurement

SPICE macromodel comparison is model-level validation.

It checks MATLAB behavioural predictions against more detailed vendor macromodel simulations.

Hardware measurement would require a physical circuit, measurement equipment, calibration, uncertainty handling, and measured response data.

This repository does not currently include hardware measurement.

## Minimum SPICE Requirement

A minimum Q3 prototype comparison should include:

- 2-3 real op-amp vendor macromodels
- the same TIA circuit assumptions as the MATLAB model
- exported AC response data from the SPICE simulations
- comparison of bandwidth
- comparison of peaking
- comparison of magnitude error
- comparison of phase error
- summary table of model-versus-SPICE metrics
- comparison figures showing MATLAB and SPICE responses

The selected op-amps should be documented with datasheet references and macromodel source information.

## Proposed SPICE Comparison Workflow

1. Select 2-3 real op-amp devices with available vendor SPICE macromodels.
2. Define a small set of TIA design cases.
3. Record circuit assumptions and component values.
4. Simulate AC response for each op-amp and design case.
5. Export frequency, magnitude, and phase data.
6. Import exported SPICE data into MATLAB or a documented analysis script.
7. Compare behavioural model response against SPICE response.
8. Generate comparison figures.
9. Generate a summary table with bandwidth, peaking, magnitude error, and phase error.
10. Document deviations and limitations.

## Required Outputs for Q3 Prototype

The Q3 validation package should include:

- op-amp device table
- datasheet and macromodel source record
- SPICE simulation setup record
- exported AC response files
- MATLAB-vs-SPICE comparison scripts
- comparison figures
- summary metrics table
- notes on where the behavioural model agrees or disagrees with SPICE macromodel results

## Claims Allowed After Completion

After actual SPICE macromodel data has been imported and compared, it is reasonable to claim model-level comparison against selected vendor macromodels.

It is not reasonable to claim hardware validation unless physical measurement data exists.

It is not reasonable to claim universal op-amp selection rules based only on this comparison.

## Current Status

At the time of this plan, SPICE macromodel comparison has not yet been completed.

The current repository contains behavioural MATLAB modelling results only.

SPICE macromodel comparison is a required later module for the Q3 prototype path.
