# Figures For Overleaf Draft v0.1

No figure files are copied into this folder in Round 21.

The LaTeX draft points to the existing repository figure directory with:

```tex
\graphicspath{{../figures/}}
```

This works when `overleaf_draft_v0_1/` remains inside `tia_extension/` and the repository figure files are present one level above it. If this folder is uploaded alone to Overleaf, manually upload the required figure files or update the paths in `main.tex` and the section files.

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

Figure 1 still needs final panel layout. A likely final arrangement is:

- Figure 1(a): baseline magnitude response
- Figure 1(b): baseline inversion-removed phase response

Do not describe these figures as hardware validation or measured-noise validation.
