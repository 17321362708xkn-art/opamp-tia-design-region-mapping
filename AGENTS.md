# Project Guardrails

This repository is currently an active low-pass filter finite-A0 / finite-GBW MATLAB behavioural modelling project, with a controlled photodiode TIA extension being developed under `tia_extension/`.

## Priority Order

1. User instruction
2. AGENTS.md project rules
3. Validated model equations and existing active LPF code
4. Installed skills
5. Styling preferences

## Active LPF Scope

- The existing active LPF MATLAB functions are treated as validated project assets.
- Do not modify validated active LPF functions unless explicitly requested by the user.
- Do not rewrite or restructure the existing active LPF project when working on the TIA extension.

## TIA Extension Scope

- All photodiode TIA work must be placed under `tia_extension/`.
- Round 2 TIA work is a v0.1 behavioural baseline only.
- Do not claim that the TIA extension is complete.
- Do not add SPICE comparison or noise analysis unless the user explicitly requests that round of work.

## Skills And Figure Rules

- Installed skills may be used only when relevant.
- Skills may improve plotting, formatting, export, tables, reporting, and workflow automation.
- Skills must not change raw data, alter validated model equations, invent SPICE results, remove unfavourable cases, or smooth clean simulation data without justification.
- Every generated figure must be reproducible from a script.
- Source data must be saved to CSV before plotting.
- Every generated TIA figure must have a manifest entry with source script, source data, key parameters, caption, data type, and export formats.

## Validation Claims

- SPICE macromodel comparison is required for a later Q3 prototype evidence module.
- Do not claim SPICE validation unless actual exported SPICE macromodel data has been imported and compared.
- Do not invent SPICE data.
- Do not claim hardware measurement or hardware validation without hardware data.

## Change Tracking

- Every round of TIA extension work must include a change log.
- Every result table must have a source script and parameter record.
