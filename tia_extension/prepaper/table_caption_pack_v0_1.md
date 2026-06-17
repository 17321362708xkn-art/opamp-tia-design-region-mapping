# Table Caption Pack v0.1

This table caption pack uses existing repository CSVs, markdown notes, and project evidence. It does not create new data or a final bibliography.

## Suggested Main Tables

### Table 1. Behavioural model assumptions and swept parameters

- Source files:
  - `tia_extension/docs/tia_model_assumptions.md`
  - `tia_extension/figures/figure_manifest_tia.csv`
  - `tia_extension/results/baseline_metrics.csv`
  - `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv`
  - `tia_extension/results/tia_sweep_summary.csv`
- Draft caption: Behavioural model assumptions and swept parameter ranges used in the MATLAB TIA screening workflow. The table summarizes repository-defined assumptions for `Rf`, `Cf`, `Cpd`, `A0`, and `ft_Hz`; it does not define a universal photodiode TIA design rule.
- Notes for construction: Derive entries from existing files only. Do not regenerate sweeps.

### Table 2. Project-defined Safe/Marginal/Risky screening criteria

- Source files:
  - `tia_extension/functions/classify_tia_design_region.m`
  - `tia_extension/prepaper/claims_vs_evidence_matrix.md`
  - `tia_extension/results/tia_design_region_map.csv`
  - `tia_extension/results/tia_sweep_summary.csv`
- Draft caption: Project-defined Safe, Marginal, and Risky screening criteria used to organize extracted behavioural metrics. The labels are internal design-screening categories and should not be interpreted as universal stability classifications or hardware guarantees.
- Notes for construction: Summarize thresholds and label meanings from existing classification logic and claims notes. Do not alter MATLAB functions.

### Table 3. Vendor macromodel comparison summary

- Source file: `tia_extension/results/spice_comparison_summary_vendor_models.csv`
- Draft caption: Summary of OP27, OPA818, and ADA4817 vendor macromodel comparison cases, including feedback capacitance, extracted peaking, extracted -3 dB bandwidth, and project-defined visual region label. These rows are simulation-only vendor macromodel comparisons under repository test assumptions, not hardware validation and not identical operating-point equivalence.
- Notes for construction: Use the existing CSV directly. Preserve the note that OP27 uses +15/-15 V while OPA818 and ADA4817 use +5/-5 V.

### Table 4. Literature/source usage confidence table

- Source files:
  - `tia_extension/prepaper/first_reading_notes_summary.md`
  - `tia_extension/prepaper/abstract_only_sources_policy.md`
  - `tia_extension/prepaper/writing_evidence_map.md`
- Draft caption: Source-usage confidence table separating full-text, abstract-only, and metadata-only literature candidates used in the manuscript draft. Full-text sources may support detailed reading after verification; abstract-only sources are limited to broad background visible in official abstracts; metadata-only sources are placeholders for future full-text acquisition.
- Notes for construction: Use placeholder citation IDs only. Do not create final bibliography entries in this table.

## Optional Or Appendix-Candidate Tables

### Table A1. Detailed behavioural sweep summary

- Source file: `tia_extension/results/tia_sweep_summary.csv`
- Draft caption: Detailed MATLAB behavioural sweep summary for the explored TIA parameter grid. This table supports reproducibility and may be too large for the main paper unless condensed.

### Table A2. Datasheet-derived vendor op-amp candidate table

- Source files:
  - `tia_extension/datasheets/vendor_opamp_candidate_table.csv`
  - `tia_extension/datasheets/vendor_opamp_candidate_table_si.csv`
  - `tia_extension/datasheets/vendor_opamp_candidate_selection_summary.md`
- Draft caption: Datasheet-derived vendor op-amp candidate information used for planning macromodel comparisons. The table is a screening aid and not a final op-amp ranking or universal selection rule.

### Table A3. Figure/source-data traceability table

- Source file: `tia_extension/figures/figure_manifest_tia.csv`
- Draft caption: Figure traceability manifest linking each manuscript figure to the script, source data, key parameters, and export formats used to generate it. The manifest supports reproducibility of the repository evidence package.

## Table Safety Rules

- Do not use DOI-only or metadata-only sources for numerical literature comparison rows.
- Do not add measured hardware columns unless actual hardware measurement data exist.
- Do not add measured-noise columns unless actual measured-noise data exist.
- Do not modify source CSVs or regenerate simulations while preparing tables.
- Keep placeholder citation IDs until a verified final bibliography is created in a later round.
