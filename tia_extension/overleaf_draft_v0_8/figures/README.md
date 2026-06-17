# Figures For Overleaf Draft v0.8

This folder contains the figure assets bundled with the workflow-focused portable Overleaf draft. Draft v0.8 retains the LaTeX-native TikZ methodology workflow figure.

The LaTeX draft uses:

```tex
\graphicspath{{figures/}}
```

The section files also use explicit paths such as `figures/tia_baseline_magnitude.png`; keep `main.tex` at the Overleaf project root and this folder at `figures/`.

Main draft figure files:

- `methodology_workflow_figure.tex` (TikZ source, compiled by Overleaf)
- `tia_baseline_magnitude.png`
- `tia_baseline_phase.png`
- `tia_bandwidth_vs_Cf.png`
- `tia_peaking_vs_Cf.png`
- `tia_design_region_map_Cpd_ft.png`
- `tia_representative_region_responses.png`
- `behavioural_vs_vendor_agreement_error_summary.png`
- `tia_noise_contribution_baseline.png`
- `tia_noise_bandwidth_tradeoff.png`
- `behavioural_vs_vendor_overlay_OPA818_Cf0p5_worstcase.png`
- `behavioural_vs_vendor_overlay_ADA4817_Cf0p5_worstcase.png`
- `behavioural_vs_vendor_overlay_OP27_Cf3p455_negative_control.png`

The workflow overview is inserted near the start of the Methodology section. The baseline response figure is arranged as:

- baseline magnitude response
- baseline inversion-removed phase response

The design-region map is a project-defined selected-best design-region map under selected assumptions. Its mostly Safe/green appearance should not be interpreted as universal safety; it may be paired with the safe-window fraction map in future work if stronger design-space contrast is needed.

Figure 5 should later be re-exported from existing data with larger legend font, clearer line widths, and improved legend placement. That polish should not change simulation data.

The Round 28 overlay figures compare no-Cin and documented-Cin behavioural responses against existing vendor macromodel exports for boundary cases. They are intended to show where the simplified model is strained; do not describe these figures as hardware validation, measured-noise validation, or complete SPICE coverage.
