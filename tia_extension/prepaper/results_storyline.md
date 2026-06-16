# Results Storyline

This document organizes the current TIA extension evidence into a narrative for a future manuscript. It is not a finished results section.

## Paper Narrative In One Paragraph

Photodiode TIA design is sensitive to feedback resistance, photodiode capacitance, compensation capacitance, and finite op-amp bandwidth. The current workflow first uses a MATLAB behavioural model to explore these coupled parameters quickly, extracting bandwidth, peaking, and project-defined design-region labels. Feedback-capacitance sweeps show the expected trade-off: larger `Cf` generally reduces peaking risk while lowering bandwidth. Design-region maps then organize the parameter space into Safe, Marginal, and Risky screening regions. Real LTspice macromodel comparisons add model-specific checks: OP27 highlights low-GBW and small-`Cf` peaking risk, OPA818 shows stable high-speed behaviour over the selected sweep, and ADA4817 adds a third vendor case with a borderline small-`Cf` result. First-pass behavioural noise estimates add design context without claiming measured noise. The result is a reproducible pre-design screening workflow, not a replacement for vendor simulation review, layout-aware modelling, or hardware validation.

## Logical Story

1. Start with the design sensitivity.
   - Photodiode TIA response depends on `Rf`, `Cpd`, `Cf`, and finite op-amp bandwidth.
   - Small compensation capacitance may preserve bandwidth but can increase peaking risk.
   - Larger compensation capacitance can improve peaking behaviour while reducing bandwidth.

2. Establish the behavioural model as a fast exploration tool.
   - The MATLAB workflow computes transimpedance response and extracted metrics from reproducible scripts.
   - It is intentionally simplified and should be framed as early-stage screening.
   - Baseline magnitude and phase figures anchor the model behaviour.

3. Show `Cf` as the visible compensation knob.
   - `tia_bandwidth_vs_Cf.png` shows the bandwidth trade-off.
   - `tia_peaking_vs_Cf.png` shows the peaking trend.
   - This motivates the later Safe/Marginal/Risky classification.

4. Use design-region maps to organize the parameter space.
   - Design-region maps classify combinations of `Cpd` and `ft_Hz` under project-defined criteria.
   - Safe-window fraction maps show how much of the explored `Cf` range satisfies the screening criteria.
   - The labels are for screening only, not universal stability guarantees.

5. Add OP27 as the first real LTspice smoke test.
   - OP27 gives a low-GBW / traditional op-amp comparison point.
   - The small-`Cf` OP27 case shows strong peaking, consistent with the need for cautious compensation.
   - It is a smoke test, not a complete validation set.

6. Add OPA818 as a high-speed TIA-oriented vendor macromodel.
   - OPA818 provides four real vendor PSpice macromodel cases.
   - The selected OPA818 sweep is stable in peaking terms.
   - The results show that vendor-specific macromodel behaviour matters.

7. Add ADA4817 as the third vendor macromodel case.
   - ADA4817 provides four real vendor SPICE macromodel cases.
   - The `Cf = 0.5 pF` case is borderline, while larger `Cf` cases are Safe in the project-defined peaking metric.
   - This strengthens the cross-model discussion without turning the result into hardware evidence.

8. Use noise as design context.
   - First-pass behavioural noise estimates connect compensation choices to integrated output-noise trends.
   - Noise results are configured estimates, not measured detector noise.
   - Optional later SPICE noise work may be added if the submission scope requires it.

9. End with the correct claim.
   - The workflow is useful as a reproducible pre-design screening method.
   - The evidence includes three real vendor SPICE macromodel comparison sets.
   - The package remains a Q3 pre-paper prototype, not a final submission-ready manuscript or hardware-validated design.
