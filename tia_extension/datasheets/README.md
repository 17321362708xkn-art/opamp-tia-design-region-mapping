# Round 7 Datasheet Candidate Table

This folder contains the Round 7 vendor op-amp datasheet candidate table for the photodiode TIA extension.

The table is a reproducible screening artifact generated from a curated CSV source:

```matlab
run('tia_extension/scripts/run_09_vendor_opamp_datasheet_table.m')
```

Generated artifacts:

- `vendor_opamp_datasheet_sources.csv`
- `vendor_opamp_candidate_table.csv`
- `vendor_opamp_candidate_table.md`
- `vendor_opamp_table_manifest.csv`
- `vendor_opamp_datasheet_parameter_record.md`

This is not SPICE validation and does not add hardware evidence. It only documents datasheet parameters to guide later real vendor macromodel selection.
