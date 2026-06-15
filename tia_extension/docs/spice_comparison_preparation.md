# SPICE Comparison Preparation

## 1. Purpose

This note defines the preparation needed for a later SPICE macromodel comparison module.

No SPICE data is included in the v0.1 TIA baseline. The current baseline must not be described as SPICE-validated.

## 2. Why SPICE Is A Later Required Module

The MATLAB model is useful for behavioural exploration and portfolio demonstration, but a Q3-oriented prototype needs model-level comparison against realistic op-amp macromodel behaviour.

SPICE macromodel comparison is not the same as hardware measurement. It compares the MATLAB behavioural assumptions against vendor-supplied circuit macromodels under matched circuit assumptions.

## 3. Minimum Later SPICE Scope

A later SPICE comparison module should include:

- 2-3 real op-amp vendor macromodels;
- the same TIA circuit assumptions used by the MATLAB model;
- AC response export from SPICE;
- comparison of bandwidth;
- comparison of peaking;
- comparison of magnitude error;
- comparison of phase error;
- summary tables;
- comparison figures.

## 4. Data Handling Requirements

Later SPICE exported data should be stored as source data before plotting.

Every SPICE comparison figure should record:

- vendor macromodel name;
- circuit parameters;
- source data file;
- source script;
- plotted metric;
- export formats.

## 5. Claim Boundaries

SPICE macromodel comparison is model-level validation, not hardware validation.

No SPICE validation claim should be made until real exported SPICE macromodel data has been imported and compared.

No hardware validation claim should be made without real hardware measurement data.
