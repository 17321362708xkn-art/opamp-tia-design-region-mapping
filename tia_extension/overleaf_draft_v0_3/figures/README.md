# Figures For Overleaf Draft v0.3

This folder contains the PNG figure assets bundled with the workflow-focused portable Overleaf draft.

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
- `spice_vendor_model_bandwidth_peaking_summary.png`
- `tia_noise_contribution_baseline.png`
- `tia_noise_bandwidth_tradeoff.png`

Figure 1 is arranged as:

- Figure 1(a): baseline magnitude response
- Figure 1(b): baseline inversion-removed phase response

Do not describe these figures as hardware validation or measured-noise validation.
