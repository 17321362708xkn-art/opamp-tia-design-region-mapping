# Manual SPICE Data To Collect

This checklist records the real SPICE macromodel data needed for the later Q3 comparison module.

No fake SPICE data should be added to the repository.

## Required Vendor Models

Collect AC response exports from 2-3 real vendor op-amp SPICE macromodels.

For each model, record:

- vendor;
- model name;
- macromodel source URL or package reference;
- macromodel version or date if available;
- supply voltage;
- load condition;
- simulation tool and version.

## Required Circuit Parameters

For each candidate case, record:

- `Rf_ohm`;
- `Cf_F`;
- `Cpd_F`;
- op-amp model;
- AC current source amplitude;
- simulation frequency range;
- number of points per decade.

## Required Exported Quantities

Export:

- frequency in Hz;
- transimpedance magnitude in ohms or dB-ohms;
- phase in degrees;
- any case label or parameter metadata needed to match MATLAB candidate cases.

## Candidate Cases

Use:

```text
tia_extension/results/spice_candidate_cases.csv
```

This table contains representative MATLAB behavioural safe, marginal, and risky cases for later SPICE macromodel comparison planning.

## Claim Boundary

SPICE macromodel comparison is not hardware measurement.

Do not claim SPICE validation until real exported SPICE data has been imported and compared.
