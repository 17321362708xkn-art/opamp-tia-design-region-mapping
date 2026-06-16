# Round 7 Datasheet Candidate Table

This folder contains the Round 7 vendor op-amp datasheet candidate table for the photodiode TIA extension.

The table is a reproducible screening artifact generated from a curated CSV source:

```matlab
run('tia_extension/scripts/run_09_vendor_opamp_datasheet_table.m')
```

Generated artifacts:

- `vendor_opamp_datasheet_sources.csv` is the curated source file with datasheet-unit values and source metadata.
- `vendor_opamp_candidate_table.csv` is the generated human-readable datasheet-unit table.
- `vendor_opamp_candidate_table.md` is the generated Markdown companion for quick review.
- `vendor_opamp_candidate_table_si.csv` is the generated machine-readable SI-normalized table.
- `vendor_opamp_candidate_selection_summary.md` summarizes recommended first additional SPICE candidates for Round 8 planning.
- `vendor_opamp_datasheet_parameter_record.md` records extraction rules and validation boundaries.
- `vendor_opamp_table_manifest.csv` records table provenance.

This is not SPICE validation and does not add hardware evidence. It only documents datasheet parameters to guide later real vendor macromodel selection.
