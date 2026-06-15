# Agent Guardrails

## Repository Scope

This repository contains an existing active LPF finite-A0 / finite-GBW MATLAB behavioural modelling project.

Work in this repository. Do not create a separate repository for the photodiode TIA extension.

TIA extension work must be placed in `tia_extension/`.

Do not modify validated active LPF functions unless explicitly requested.

## Skill Usage

Installed skills may be used only when they are relevant to the task.

Skills may be used for plotting, figure styling, table formatting, report generation, and automation.

Skills must not change raw data.

Skills must not alter validated models.

Skills must not invent SPICE results.

Skills must not remove unfavourable cases.

Skills must not smooth clean simulation data without justification.

Skills must not claim experimental validation.

## Validation Claims

Do not invent SPICE data.

Do not claim SPICE validation without real exported SPICE macromodel data.

Do not claim hardware measurement without hardware data.

For a Q3 prototype, real SPICE macromodel comparison is a required evidence module.

SPICE macromodel comparison is model-level evidence, not hardware validation.

## Figure and Result Reproducibility

Save source data to CSV before plotting.

Every generated figure must have:

- source script
- source data
- key parameters
- caption
- data type
- an entry in `figure_manifest.csv`

Every result table must have a source script and parameter record.

Every change must be recorded in a change log.

If a trend looks poor or unexpected, report it instead of hiding it.
