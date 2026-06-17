# Workflow-Focused Overleaf Draft v0.7

This folder is a workflow-focused Overleaf/LaTeX draft copied from `tia_extension/overleaf_draft_v0_6/` and updated with a LaTeX-native methodology workflow figure.

It is not a target-journal template, not a final submission package, and not a final bibliography.

## Folder Contents

- `main.tex`: generic `article`-class manuscript wrapper with workflow-paper title and abstract.
- `sections/`: manuscript section files.
- `tables/tables.tex`: reusable table commands for Tables 1--3. A source-scope macro remains in the file for documentation continuity but is not called by `main.tex`.
- `figures/`: bundled PNG figure assets, the TikZ workflow figure source, and figure notes.
- `references_draft.bib`: draft BibTeX entries for verified full-text-available sources only.

## Using This In Overleaf

Upload this folder, or the ZIP export generated from it, directly to Overleaf. `main.tex` sits at the project root, and the required figure PNG files remain in the local `figures/` folder.

The current draft uses:

```tex
\graphicspath{{figures/}}
```

PNG figure calls use explicit paths such as:

```tex
\includegraphics[width=\linewidth]{figures/tia_baseline_magnitude.png}
```

The Methodology workflow figure is LaTeX-native and is included with:

```tex
\input{figures/methodology_workflow_figure.tex}
```

The portable Overleaf package avoids parent-directory figure paths.

## Included Figures

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

Figure 1 is the Methodology workflow overview. The baseline response figure is laid out with labelled panels: magnitude response and phase response.

## Positioning And Layout Notes

- `placeins` and `\FloatBarrier` are used around major transitions.
- The workflow overview uses `tikz` with simple black-and-white manuscript-safe boxes and arrows.
- Figures use local `figures/<file>.png` paths.
- Tables 1--3 are placed near the relevant main-text discussion.
- Table 3 is the behavioural-vs-vendor agreement table with compact case labels, pF/MHz units in column headers, and a width-limited table wrapper.
- The behavioural-vs-vendor agreement error summary remains in the Methodology section after the agreement table.
- OPA818, ADA4817, and OP27 small-Cf boundary overlays are placed in an appendix.
- Table 4/source-scope material is not compiled into the manuscript PDF in v0.6. Source-scope boundaries remain documented in repository prepaper notes and this README.
- References begin after the small-Cf overlay appendix so table floats do not interrupt bibliography entries.
- The manuscript is positioned as an engineering design workflow paper with photodiode TIA pre-design as the application angle.
- The design-region map is treated as a project-defined selected-best design-region map under selected assumptions, not universal safety evidence.
- The Round 28 agreement evidence is framed around small-Cf model breakdown and screening-level agreement at moderate/larger Cf, not around label agreement alone.

## Citation Scope

`references_draft.bib` includes only the 11 full-text-available rows marked ready in `citation_metadata_verification_table_v0_1.md`.

Excluded pending manual check:

- `CHEN_2005_10GBPS_CMOS_RX_AFE`
- `HERMANS_2006_850NM_RX`
- `LI_2014_LOW_NOISE_CMOS_RX`
- `LI_2021_LOW_NOISE_OPTICAL_RX_TIA`
- `PARK_2015_40GBPS_INVERTER_RX`
- `VAZQUEZ_2021_OPTICAL_DETECTION_TIA`
- `ZHOU_2021_CHERRY_HOOPER_AFE`

The LaTeX section files keep TODO comments where these excluded sources appeared in the Markdown manuscript. Do not silently add them to `references_draft.bib` until official metadata and source access are manually checked.

## Manuscript Boundaries

This draft preserves the evidence boundaries:

- no hardware validation
- no measured-noise validation
- no universal TIA design rule
- no new TIA topology claim
- no final submission-readiness claim
- no quantified Cin-only improvement claim; the ablation result is mixed and modest in the current Cpd=10 pF vendor rows

## Remaining Work Before PDF Export

- Run a full Overleaf compile and fix any remaining package/path issues.
- Re-export Figure 5 from existing data with larger legend font, clearer line widths, and improved legend placement; do not change simulation data.
- Consider splitting Table 1 after target-journal formatting.
- Decide whether the source-scope table should stay in README/prepaper notes or return as appendix/supplementary material after target selection.
- Select a target journal or conference template.
- Review and format the bibliography after the seven excluded/manual-check sources are resolved.
- Complete supervisor or domain review before any submission-oriented formatting.
