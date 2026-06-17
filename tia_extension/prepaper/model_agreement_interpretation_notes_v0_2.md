# Model Agreement Interpretation Notes v0.2

This note updates the Round 26 interpretation after the second external-review feedback. The stronger manuscript framing is not that the model simply achieves `9/11` project-defined label agreement. The stronger framing is that the simplified behavioural model is useful for early screening at moderate and larger feedback capacitance, while small-`Cf` bandwidth-limited cases expose predictable limitations of the single-pole op-amp approximation and omitted higher-order vendor macromodel dynamics.

Source outputs:

- `tia_extension/results/behavioural_vs_vendor_agreement_summary.csv`
- `tia_extension/results/cin_ablation_agreement_summary.csv`
- `tia_extension/results/cin_ablation_compact_metrics.csv`
- `tia_extension/figures/behavioural_vs_vendor_overlay_OPA818_Cf0p5_worstcase.png`
- `tia_extension/figures/behavioural_vs_vendor_overlay_ADA4817_Cf0p5_worstcase.png`
- `tia_extension/figures/behavioural_vs_vendor_overlay_OP27_Cf3p455_negative_control.png`

## Main Framing

The agreement pattern is strongest for moderate and larger `Cf` cases. In these rows, the MATLAB behavioural model and vendor-export summaries generally agree in project-defined label terms, and the bandwidth error becomes smaller as the compensation capacitance increases.

Agreement degrades in small-`Cf` cases. As `Cf` shrinks, the closed-loop bandwidth moves closer to op-amp bandwidth limits. The simplified MATLAB model uses a single-pole finite-gain op-amp approximation, while vendor macromodels include additional internal dynamics. The expected result is that the behavioural model can overestimate bandwidth or understate peaking when the design is pushed toward the edge of the loop-bandwidth envelope.

This is a useful outcome rather than a failure of the workflow. The model is appropriate as an early screening tool, and the small-`Cf` cases identify where vendor macromodel review becomes most important.

## Cin Ablation Findings

Round 28 computes each existing vendor case twice:

- `Cin = 0`
- documented/vendor-specific `Cin` where available

Summary:

| Group | Mean abs. BW error no-Cin | Mean abs. BW error with-Cin | Max abs. BW error no-Cin | Max abs. BW error with-Cin | Label agreement no-Cin | Label agreement with-Cin |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| All cases | 18.83% | 19.33% | 61.92% | 68.84% | 9/11 | 9/11 |
| OPA818 + ADA4817 | 17.29% | 17.96% | 61.92% | 68.84% | 7/8 | 7/8 |
| OPA818 | 20.91% | 23.31% | 61.92% | 68.84% | 4/4 | 4/4 |
| ADA4817 | 13.67% | 12.62% | 30.85% | 28.95% | 3/4 | 3/4 |
| OP27 | 22.95% | 22.95% | 35.17% | 35.17% | 2/3 | 2/3 |

Interpretation:

- The documented `Cin` values do not improve label agreement in this dataset.
- `Cin` slightly improves ADA4817 bandwidth-error metrics, but slightly worsens OPA818 bandwidth-error metrics under the current simplified assumptions.
- Across the combined high-speed group, `Cin` changes the mean absolute bandwidth error only modestly.
- This limited impact is expected because the tested vendor rows use `Cpd = 10 pF`, while documented `Cin` is `2.4 pF` for OPA818 and `1.4 pF` for ADA4817.
- OP27 should be excluded from any `Cin` improvement claim because no scalar OP27 input capacitance is available in the local SI table.

Safe wording:

- "Adding `Cin` improves the physical completeness and documentation of the behavioural model."
- "In the current `Cpd = 10 pF` vendor cases, the `Cin` ablation shows mixed and modest bandwidth-error changes rather than a uniform agreement improvement."

Unsafe wording:

- "Adding `Cin` validates the behavioural model."
- "Adding `Cin` improves agreement across all devices."
- "The `Cin` ablation proves the model is accurate."

## Small-Cf Boundary Cases

OPA818 `Cf = 0.5 pF`:

- Label agreement remains project-defined Safe with or without documented `Cin`.
- Bandwidth error is large: `61.92%` no-Cin and `68.84%` with-Cin.
- The worst-case overlay shows that the behavioural response rolls off later than the vendor export.
- The manuscript should describe this as a boundary case where the simplified model overestimates bandwidth.

ADA4817 `Cf = 0.5 pF`:

- Label disagreement remains with and without documented `Cin`: MATLAB is Safe, vendor summary is Marginal.
- Bandwidth error is `30.85%` no-Cin and `28.95%` with-Cin.
- The vendor macromodel reports peaking that the simplified model does not reproduce.
- The manuscript should use this row as the cleanest high-speed example of small-`Cf` model sensitivity.

OP27 `Cf = 3.455 pF`:

- OP27 remains the negative-control / low-GBW illustrative case.
- Label disagreement remains: MATLAB is Safe, vendor summary is Risky.
- The vendor macromodel shows strong peaking not captured by the simplified model.
- OP27 should not be used as primary high-speed evidence or as a `Cin` improvement example.

## Mechanism To Explain In The Manuscript

The simplified closed-loop model is useful when the selected `Rf`, `Cf`, `Cpd`, `Cin`, `A0`, and `ft` assumptions keep the response away from high-order vendor-model dynamics. For moderate and larger `Cf`, the compensation capacitance lowers the bandwidth and suppresses peaking, so the single-pole approximation is more likely to track the broad response trend.

For small `Cf`, the feedback pole rises and the closed-loop response pushes closer to the op-amp bandwidth limit. The single-pole model does not include vendor macromodel excess phase, extra poles and zeros, package effects, output-stage limitations, or other internal compensation details. Therefore it can predict a cleaner response than the vendor macromodel produces.

## Noise Note

The current noise scripts use `photodiode_dc_current_A = 1e-9` with photodiode shot noise enabled. However, `tia_noise_first_pass.m` currently calls `tia_response` without `Cin` or `Cstray`, and its op-amp voltage-noise transfer still uses `Cpd` rather than `Ctotal`. The manuscript should not claim that the first-pass noise figures already use the Round 26 `Ctotal` noise-gain path. A later technical round can update the noise helper if needed.

## Recommended Manuscript Posture

Lead with:

- Useful early-screening behaviour at moderate/larger `Cf`.
- Small-`Cf` breakdown as a diagnostic boundary.
- Quantified errors and overlays that show where vendor review is required.

Keep, but do not lead with:

- `9/11` project-defined label agreement.

Avoid:

- Hardware validation.
- Measured-noise validation.
- Complete SPICE coverage.
- Universal stability or design-rule claims.
- A claim that `Cin` improves agreement unless a future dataset supports it more clearly.
