# Repository Guardrails for Agents

This repository is currently an active LPF finite-A0 / finite-GBW behavioural modelling project.

## Scope Rules

- TIA extension work must be placed in `tia_extension/`.
- Do not modify validated active LPF functions unless explicitly requested.
- Do not change active LPF transfer-function logic, metric extraction logic, or validated result-generation scripts unless the requested task explicitly requires it.
- Do not delete, move, or rename existing active LPF scripts, figures, functions, or results without explicit user approval.

## Validation and Evidence Rules

- Do not invent SPICE data.
- Do not claim hardware measurement.
- Do not claim SPICE validation unless actual exported SPICE macromodel data has been imported and compared.
- For a Q3 prototype, SPICE macromodel comparison is a required later module.
- SPICE macromodel comparison must be treated as model-level validation, not hardware validation.

## Reproducibility Rules

- Every generated figure must be reproducible from a script.
- Every result table must have a source script and parameter record.
- Every change must be recorded in a change log.

## Documentation Tone

- Keep claims conservative and evidence-based.
- State clearly when a result is behavioural-model-only.
- State clearly when TIA work is planned rather than already complete.
