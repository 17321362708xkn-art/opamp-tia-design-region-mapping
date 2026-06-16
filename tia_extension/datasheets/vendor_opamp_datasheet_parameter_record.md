# Vendor Op-Amp Datasheet Parameter Record

## Scope

Round 7 adds a datasheet-derived candidate table for photodiode TIA op-amp screening. The table is intended to support later selection of additional real vendor SPICE macromodel comparisons.

This record does not change the validated active LPF code, does not change the TIA behavioural equations, and does not add any new SPICE or hardware validation claim.

## Source Script And Data

- Source script: `tia_extension/scripts/run_09_vendor_opamp_datasheet_table.m`
- Curated source CSV: `tia_extension/datasheets/vendor_opamp_datasheet_sources.csv`
- Generated table CSV: `tia_extension/datasheets/vendor_opamp_candidate_table.csv`
- Generated table Markdown: `tia_extension/datasheets/vendor_opamp_candidate_table.md`
- Generated SI-normalized CSV: `tia_extension/datasheets/vendor_opamp_candidate_table_si.csv`
- Candidate selection summary: `tia_extension/datasheets/vendor_opamp_candidate_selection_summary.md`
- Table manifest: `tia_extension/datasheets/vendor_opamp_table_manifest.csv`

## Candidate Set

The Round 7 candidate set covers eight op-amps:

- TI OPA818
- ADI LTC6268-10
- TI OPA858
- ADI ADA4817-1
- TI OPA657
- TI LMH6629
- TI OPA847
- ADI OP27

OP27 is included as the existing smoke-test reference and is not treated as a preferred new high-speed photodiode TIA selection.

## Extraction Rules

- Use vendor datasheet/product-page values only.
- Keep raw numeric values in datasheet units where possible.
- Use ASCII unit names in CSV column headers, for example `nV_per_sqrtHz`.
- Do not infer unavailable input capacitance or current-noise values.
- Use `NaN` only when a scalar value was not available in the reviewed source.
- Convert datasheet-unit values to SI units only in `vendor_opamp_candidate_table_si.csv`.
- Treat `ft_proxy_MHz` as a screening parameter for the simplified finite-GBW MATLAB model.
- For decompensated op-amps, record GBWP and minimum stable gain; do not describe GBWP as unity-gain-stable bandwidth.
- Record SPICE model availability only as a future-planning note; do not claim comparison evidence.

## Validation Boundary

This table is datasheet-derived screening evidence only. It is not a SPICE comparison, not a noise simulation result, not hardware measurement, and not a final op-amp selection rule.

The candidate selection summary partially addresses later macromodel candidate selection, but additional real vendor SPICE macromodel comparisons are still required before any Q3 submission-readiness claim.
