# Reviewer Feedback Response Plan v0.1

Round 26 addresses external-review feedback about the behavioural TIA model and the vendor-macromodel comparison. The changes are limited to modelling transparency, input-capacitance support, and a quantitative comparison against existing vendor-exported data. No manuscript rewrite, final bibliography, SPICE rerun, hardware claim, or measured-noise claim is included in this round.

## Review Issue 1: Input Capacitance Was Not Explicitly Modelled

Reviewer concern:

- The earlier behavioural model used photodiode capacitance but did not explicitly separate op-amp input capacitance or additional stray input-node capacitance.
- This made the model look physically incomplete for photodiode TIA screening.

Response implemented:

- `tia_response.m` now accepts optional `Cin` and `Cstray` name-value arguments.
- The total input-node capacitance is modelled as:

```text
Ctotal = Cpd + Cin + Cstray
```

- The default values are `Cin = 0` and `Cstray = 0`, preserving backward compatibility for existing scripts.
- The closed-loop transfer-function note in `tia_closed_loop_transfer_function.md` documents the new capacitance term and the single-pole finite-gain assumptions.

Manuscript implication:

- Future manuscript text should describe the behavioural model as including project-specified `Cpd`, optional vendor-derived `Cin`, and optional manually specified `Cstray`.
- The text should not imply that `Cstray = 0` is a measured board parasitic value.

## Review Issue 2: Vendor Comparison Needed Quantitative Agreement Metrics

Reviewer concern:

- The earlier vendor section risked reading as qualitative or visual-only.
- A reader needs a quantified comparison between MATLAB behavioural predictions and vendor macromodel export data.

Response implemented:

- `run_15_behavioural_vs_vendor_agreement_cin.m` reads the existing vendor macromodel summary CSV and imported AC-response CSVs.
- It writes `behavioural_vs_vendor_agreement_summary.csv` with bandwidth error, peaking error, project-defined label comparison, and modelling-assumption notes.
- It creates overlay figures for OPA818, ADA4817, and OP27 plus an agreement-error summary figure.

Manuscript implication:

- The vendor section should be described as a vendor-macromodel agreement analysis under repository test assumptions.
- It should not be described as hardware validation, complete SPICE validation, or measured validation.

## Review Issue 3: Vendor Input-Capacitance Sources Needed Traceability

Reviewer concern:

- If input capacitance is used, the source and uncertainty for each device should be explicit.

Response implemented:

- `vendor_input_capacitance_assumptions_round26.md` records the device-level assumptions used in Round 26.
- OPA818 uses `2.4e-12 F` from the local SI-normalized vendor op-amp table.
- ADA4817 uses `1.4e-12 F` from the local SI-normalized vendor op-amp table.
- OP27 uses a zero-Cin fallback because the local table does not contain a scalar input-capacitance value; this row is marked `needs_manual_check`.
- `Cstray` is set to `0 F` for all rows and is not fitted.

Manuscript implication:

- OPA818 and ADA4817 may be used as the primary high-speed vendor comparison cases.
- OP27 should remain an illustrative low-GBW negative-control case, not a tuned model-agreement demonstration.

## Review Issue 4: Agreement Interpretation Needed Stronger Boundaries

Reviewer concern:

- Good agreement in selected cases could be overread as proof of universal validity.
- Poor agreement in selected cases should not be hidden.

Response implemented:

- The agreement table preserves bandwidth error sign and magnitude.
- The notes field records `A0 = 1e5` as an inherited behavioural assumption needing manual check for vendor-specific open-loop gain.
- Label agreement is reported separately from bandwidth and peaking error.
- The OP27 negative-control treatment is stated in the CSV notes and interpretation note.

Manuscript implication:

- The manuscript should report that the Cin-aware behavioural model gives useful first-order agreement for selected high-speed cases, especially at moderate and larger `Cf`.
- The manuscript should also report that small-`Cf` high-speed cases and the OP27 negative-control case expose the limits of the simplified single-pole model.
- No statement should claim universal stability, hardware readiness, measured-noise validation, or a new TIA topology.

## Files Added Or Updated In Round 26

- `tia_extension/functions/tia_response.m`
- `tia_extension/spice_interface/compare_tia_matlab_vs_spice.m`
- `tia_extension/scripts/run_15_behavioural_vs_vendor_agreement_cin.m`
- `tia_extension/docs/tia_closed_loop_transfer_function.md`
- `tia_extension/docs/vendor_input_capacitance_assumptions_round26.md`
- `tia_extension/results/behavioural_vs_vendor_agreement_summary.csv`
- `tia_extension/figures/behavioural_vs_vendor_overlay_OPA818.png`
- `tia_extension/figures/behavioural_vs_vendor_overlay_ADA4817.png`
- `tia_extension/figures/behavioural_vs_vendor_overlay_OP27_negative_control.png`
- `tia_extension/figures/behavioural_vs_vendor_agreement_error_summary.png`
- `tia_extension/prepaper/reviewer_feedback_response_plan_v0_1.md`
- `tia_extension/prepaper/model_agreement_interpretation_notes_v0_1.md`

## Explicit Non-Claims

- No hardware validation is claimed.
- No measured-noise validation is claimed.
- No final bibliography is created.
- No new SPICE simulations are run.
- No result CSVs other than the new Round 26 agreement summary are modified.
- No universal Safe/Marginal/Risky design rule is claimed.
- No new TIA topology is claimed.
