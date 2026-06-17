# Generic Overleaf Draft v0.1

This folder is a generic Overleaf/LaTeX draft converted from `tia_extension/prepaper/manuscript_draft_v0_4_audit_fixed.md`.

It is not a target-journal template, not a final submission package, and not a final bibliography.

## Folder Contents

- `main.tex`: generic `article`-class manuscript wrapper.
- `sections/`: manuscript section files.
- `tables/tables.tex`: draft LaTeX tables converted from the manuscript table drafts.
- `figures/README.md`: figure upload/path notes.
- `references_draft.bib`: draft BibTeX entries for verified full-text-available sources only.

## Using This In Overleaf

Option 1: upload the whole repository structure around `tia_extension/` so that the existing relative figure paths still work.

Option 2: upload only this folder, then manually upload the required figure PNG files and update `\graphicspath` or the `\includegraphics` paths in the section files.

The current draft uses:

```tex
\graphicspath{{../figures/}}
```

That path works only if `overleaf_draft_v0_1/` remains inside `tia_extension/` and the existing repository figures remain one folder above it.

## Figures Needing Manual Upload If Folder Is Uploaded Alone

- `tia_baseline_magnitude.png`
- `tia_baseline_phase.png`
- `tia_bandwidth_vs_Cf.png`
- `tia_peaking_vs_Cf.png`
- `tia_design_region_map_Cpd_ft.png`
- `tia_representative_region_responses.png`
- `spice_vendor_model_bandwidth_peaking_summary.png`
- `tia_noise_contribution_baseline.png`
- `tia_noise_bandwidth_tradeoff.png`

Figure 1 still needs final panel layout, likely magnitude as panel (a) and phase as panel (b).

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
- no final Q3 readiness claim

## Remaining Work Before PDF Export

- Decide whether to upload/copy figure files or adjust paths.
- Run a full Overleaf compile and fix package/path issues.
- Finalize Figure 1 panel layout.
- Decide whether Table 1 should be split and whether Table 4 should move to an appendix.
- Select a target journal or conference template.
- Review and format the bibliography after the seven excluded/manual-check sources are resolved.
- Complete supervisor or domain review before any submission-oriented formatting.
