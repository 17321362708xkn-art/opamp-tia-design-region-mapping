# Skill Usage Policy

## Purpose

This policy defines how installed skills may be used in this repository.

The repository currently contains an active LPF finite-A0 / finite-GBW MATLAB behavioural modelling project.

Future photodiode TIA work must remain separated under `tia_extension/`.

## Allowed Skill Uses

Installed skills may be used when they are relevant to the current task.

Appropriate uses include:

- plotting support
- publication-style figure formatting
- table formatting
- report generation
- workflow automation
- documentation consistency checks

## Prohibited Skill Uses

Skills must not:

- change raw data
- alter validated active LPF mathematical models
- alter transfer functions or metric extraction logic
- invent SPICE results
- claim SPICE validation without real exported SPICE data
- claim hardware validation without hardware data
- remove unfavourable cases
- smooth clean simulation data without a documented reason
- hide poor or unexpected trends

## Figure and Table Integrity

Source data must be saved to CSV before plotting.

Every figure must be reproducible from a source script.

Every result table must have a source script and parameter record.

Figures intended for paper-style use should include source data, caption, key parameters, and data type in `figure_manifest.csv`.

## Q3 Prototype Requirement

For a Q3-oriented prototype, real SPICE macromodel comparison is required.

This means imported and compared data from real vendor op-amp macromodel simulations.

It does not mean hardware validation.

It does not permit invented or illustrative SPICE data.
