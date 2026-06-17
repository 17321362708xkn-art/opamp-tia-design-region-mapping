# Figures For Overleaf Draft v0.5

This folder contains the PNG figure assets bundled with the workflow-focused portable Overleaf draft. Draft v0.5 adds Round 26 behavioural-vs-vendor agreement figures copied into this local figure folder for Overleaf portability.

The LaTeX draft uses:

```tex
\graphicspath{{figures/}}
```

The section files also use explicit paths such as `figures/tia_baseline_magnitude.png`; keep `main.tex` at the Overleaf project root and this folder at `figures/`.

Main draft figure files:

- `tia_baseline_magnitude.png`
- `tia_baseline_phase.png`
- `tia_bandwidth_vs_Cf.png`
- `tia_peaking_vs_Cf.png`
- `tia_design_region_map_Cpd_ft.png`
- `tia_representative_region_responses.png`
- `behavioural_vs_vendor_agreement_error_summary.png`
- `tia_noise_contribution_baseline.png`
- `tia_noise_bandwidth_tradeoff.png`
- `behavioural_vs_vendor_overlay_OPA818.png`
- `behavioural_vs_vendor_overlay_ADA4817.png`
- `behavioural_vs_vendor_overlay_OP27_negative_control.png`

Figure 1 is arranged as:

- Figure 1(a): baseline magnitude response
- Figure 1(b): baseline inversion-removed phase response

Figure 4 is a project-defined selected-best design-region map under selected assumptions. Its mostly Safe/green appearance should not be interpreted as universal safety; it may be paired with the safe-window fraction map in future work if stronger design-space contrast is needed.

Figure 5 should later be re-exported from existing data with larger legend font, clearer line widths, and improved legend placement. That polish should not change simulation data.

The Round 26 overlay figures compare the Cin-aware behavioural model against existing vendor macromodel exports under repository assumptions. Do not describe these figures as hardware validation, measured-noise validation, or complete SPICE coverage.
