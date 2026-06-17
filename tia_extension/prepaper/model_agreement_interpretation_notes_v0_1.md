# Model Agreement Interpretation Notes v0.1

This note interprets the Round 26 behavioural-vs-vendor-macromodel agreement outputs. It is intended to support later manuscript wording and reviewer-response drafting. It does not update the Overleaf manuscript and does not create a final bibliography.

Source output:

- `tia_extension/results/behavioural_vs_vendor_agreement_summary.csv`
- `tia_extension/figures/behavioural_vs_vendor_overlay_OPA818.png`
- `tia_extension/figures/behavioural_vs_vendor_overlay_ADA4817.png`
- `tia_extension/figures/behavioural_vs_vendor_overlay_OP27_negative_control.png`
- `tia_extension/figures/behavioural_vs_vendor_agreement_error_summary.png`

## Scope Of The Agreement Analysis

The analysis compares the MATLAB behavioural TIA model against existing vendor-macromodel export data under the repository's test assumptions. The MATLAB model uses a single-pole op-amp approximation, the selected feedback network, photodiode capacitance, optional op-amp input capacitance, and zero manually specified stray capacitance. The vendor side uses previously exported AC-response data and the existing vendor comparison summary CSV.

This is a model-agreement screen, not hardware validation, not measured-noise validation, and not complete transistor-level or layout-aware SPICE coverage.

## Input-Capacitance Effect

Round 26 adds `Cin` to the behavioural model so that the total input-node capacitance is:

```text
Ctotal = Cpd + Cin + Cstray
```

For the high-speed vendor cases, the agreement script uses the local SI-normalized input-capacitance values:

- OPA818: `Cin = 2.4e-12 F`
- ADA4817: `Cin = 1.4e-12 F`

The OP27 row uses `Cin = 0 F` because the local vendor table does not contain a scalar OP27 input-capacitance value. That value remains a manual-check item and should not be presented as a verified OP27 capacitance.

The Cin term improves the physical completeness of the behavioural model by representing op-amp input-node loading. Round 26 does not include a paired no-Cin ablation table, so the manuscript should not claim a quantified Cin-only improvement. A safe statement is that the Cin-aware model provides a better documented and physically more complete basis for comparing MATLAB predictions with vendor-exported AC responses.

## High-Speed Vendor Cases

OPA818 and ADA4817 are the main high-speed comparison cases.

For OPA818:

- All four tested cases agree in the project-defined label comparison.
- Bandwidth error is largest at `Cf = 0.5 pF`, where MATLAB bandwidth is higher than the vendor summary by about `68.8%`.
- Bandwidth error decreases as `Cf` increases: about `15.9%` at `1.0 pF`, `5.9%` at `1.5 pF`, and `2.6%` at `2.2 pF`.
- Peaking error is effectively negligible in these rows because both the behavioural model and vendor summary are nearly flat by the project-defined peaking metric.

Interpretation:

- The Cin-aware behavioural model captures the broad bandwidth trend for the OPA818 comparison set.
- Agreement is strongest at moderate and larger `Cf`.
- The smallest-`Cf` case should be discussed as a limit case where simplified single-pole assumptions and vendor macromodel dynamics diverge.

For ADA4817:

- Three of four tested cases agree in the project-defined label comparison.
- The `Cf = 0.5 pF` case is labelled Safe by MATLAB and Marginal by the vendor summary, with about `28.9%` bandwidth error and about `-2.68 dB` peaking error.
- Bandwidth error is about `-14.4%` at `1.0 pF`, `-5.6%` at `2.2 pF`, and `-1.6%` at `4.7 pF`.

Interpretation:

- The ADA4817 rows show useful agreement for moderate and larger feedback capacitance values.
- The smallest-`Cf` case should remain a cautionary example because the vendor macromodel reports more peaking than the simplified behavioural model.

## OP27 Negative-Control Case

OP27 is treated as a low-GBW negative-control or illustrative comparison case, not as a primary high-speed model-agreement demonstration.

Round 26 results:

- Two OP27 rows agree in project-defined label comparison.
- The `OP27_Cf3p455_Risky` row does not agree: MATLAB labels it Safe while the vendor summary labels it Risky.
- That same row has about `22.2%` bandwidth error and about `-10.9 dB` peaking error.
- The OP27 `Cf = 10 pF` row has about `-35.2%` bandwidth error despite label agreement.

Interpretation:

- OP27 usefully exposes the limitation of applying the simplified model across a low-GBW device and uncertain input-capacitance assumptions.
- The OP27 rows should not be used to claim strong behavioural-vendor agreement.
- In the manuscript, OP27 should be framed as a negative-control check that motivates cautious interpretation of project-defined labels.

## Safe Manuscript Claims

Safe statements:

- The behavioural model now represents total input-node capacitance as `Cpd + Cin + Cstray`.
- Under the repository's assumptions, the high-speed OPA818 and ADA4817 vendor comparisons show broadly consistent project-defined labels for most moderate and larger `Cf` cases.
- The bandwidth-error summary shows that agreement improves as feedback capacitance increases in the selected OPA818 and ADA4817 rows.
- Small-`Cf` cases remain sensitive to modelling assumptions and vendor macromodel dynamics.
- OP27 is best interpreted as a negative-control or low-GBW illustrative case.

Statements to avoid:

- The MATLAB model is validated against hardware.
- The MATLAB model is validated against measured noise.
- The vendor macromodel comparison proves universal stability.
- The Safe label certifies hardware stability.
- Cin has been proven to improve agreement by a quantified amount.
- OP27 demonstrates strong agreement across the design space.
- The workflow introduces a new TIA topology.

## Remaining Work Before Manuscript Integration

- Decide whether to add a paired no-Cin ablation table if a reviewer asks for a direct Cin improvement claim.
- Verify vendor-specific `A0` assumptions before claiming case-level quantitative accuracy.
- Manually check OP27 input-capacitance metadata if OP27 remains in a final table.
- Add this Round 26 agreement figure set to the manuscript only after deciding where the previous vendor-comparison figure should be replaced or supplemented.
- Keep the existing final-bibliography work separate from this model-agreement update.
