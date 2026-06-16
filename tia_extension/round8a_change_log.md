# Round 8A Change Log

Branch: `tia-extension-v0.7-vendor-spice-prep-opa818-ada4817`

Date: 2026-06-16

## Purpose

Prepare the repository for future real vendor SPICE macromodel comparison using OPA818 and ADA4817-1. This round is workflow preparation only; real exported OPA818 and ADA4817-1 LTspice data are still pending.

## Files Created

- `tia_extension/spice_interface/round8_vendor_spice_plan.md`
- `tia_extension/spice_interface/round8_vendor_model_acquisition_guide.md`
- `tia_extension/spice_interface/round8_ltspice_manual_simulation_guide.md`
- `tia_extension/spice_interface/round8_vendor_spice_case_metadata_template.csv`
- `tia_extension/scripts/run_10_compare_vendor_spice_models.m`
- `tia_extension/round8a_change_log.md`

## Files Modified

- `.gitignore`
- `tia_extension/README.md`
- `tia_extension/prepaper/next_submission_tasks.md`
- `tia_extension/prepaper/q3_readiness_report.md`

## Target Models

- OPA818
- ADA4817-1

## Scope Control

- No active LPF validated function was modified.
- No existing TIA behavioural equation was modified.
- No real new SPICE data was added in this round.
- No vendor macromodel file was committed.
- No LTspice `.raw`, `.log`, generated `.net`, or local scratch PDF file was committed.
- No fake SPICE data or synthetic vendor curves were created.
- No SPICE noise comparison was added.
- No hardware measurement, hardware validation, experimental validation, or Q3 readiness claim was added.

## Current Status

OP27 remains the only real imported vendor macromodel comparison in the repository. Round 8A prepares OPA818 and ADA4817-1 for future manual LTspice export and MATLAB comparison.

Q3 SPICE requirement remains pending until real Round 8 exported data are imported and compared.
