# Workflow-Focused Overleaf Draft v0.4

This folder is a workflow-focused Overleaf/LaTeX draft visually cleaned from `tia_extension/overleaf_draft_v0_3/`.

It is not a target-journal template, not a final submission package, and not a final bibliography.

## Folder Contents

- `main.tex`: generic `article`-class manuscript wrapper with workflow-paper title and abstract.
- `sections/`: manuscript section files.
- `tables/tables.tex`: reusable table commands for Tables 1--3 and an appendix source-scope longtable.
- `figures/`: bundled PNG figure assets and figure notes.
- `references_draft.bib`: draft BibTeX entries for verified full-text-available sources only.

## Using This In Overleaf

Upload this folder, or the ZIP export generated from it, directly to Overleaf. `main.tex` sits at the project root, and the required figure PNG files remain in the local `figures/` folder.

The current draft uses:

```tex
\graphicspath{{figures/}}
```

The current figure calls use explicit paths such as:

```tex
\includegraphics[width=\linewidth]{figures/tia_baseline_magnitude.png}
```

The portable Overleaf package avoids parent-directory figure paths.

## Included Figures

- `tia_baseline_magnitude.png`
- `tia_baseline_phase.png`
- `tia_bandwidth_vs_Cf.png`
- `tia_peaking_vs_Cf.png`
- `tia_design_region_map_Cpd_ft.png`
- `tia_representative_region_responses.png`
- `spice_vendor_model_bandwidth_peaking_summary.png`
- `tia_noise_contribution_baseline.png`
- `tia_noise_bandwidth_tradeoff.png`

Figure 1 is laid out with labelled panels: Figure 1(a) magnitude response and Figure 1(b) phase response.

## Positioning And Layout Notes

- `placeins` and `\FloatBarrier` are used around major transitions.
- Figures use local `figures/<file>.png` paths.
- Tables 1--3 are placed near the relevant main-text discussion.
- Table 3 uses compact case labels, pF/MHz units in column headers, and a width-limited table wrapper.
- Table 4 is placed as an appendix source-scope longtable before References.
- Table 4 uses a grouped two-column source-scope layout so Citation IDs and access notes have more separation.
- References begin after the appendix table so table floats do not interrupt bibliography entries.
- The manuscript is positioned as an engineering design workflow paper with photodiode TIA pre-design as the application angle.
- Figure 4 is treated as a project-defined selected-best design-region map under selected assumptions, not universal safety evidence.

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

This draft preserves the v0.4 evidence boundaries:

- no hardware validation
- no measured-noise validation
- no universal TIA design rule
- no new TIA topology claim
- no final submission-readiness claim

## Remaining Work Before PDF Export

- Run a full Overleaf compile and fix any remaining package/path issues.
- Re-export Figure 5 from existing data with larger legend font, clearer line widths, and improved legend placement; do not change simulation data.
- Consider splitting Table 1 after target-journal formatting.
- Select a target journal or conference template.
- Review and format the bibliography after the seven excluded/manual-check sources are resolved.
- Complete supervisor or domain review before any submission-oriented formatting.
