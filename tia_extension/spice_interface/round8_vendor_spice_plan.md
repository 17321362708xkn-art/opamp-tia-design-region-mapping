# Round 8 Vendor SPICE Plan

## Purpose

Round 8 prepares the TIA extension for additional real vendor SPICE macromodel comparison beyond the existing OP27 smoke test. Round 8A is preparation only: it defines target models, local model handling, manual LTspice export steps, metadata requirements, and a guarded MATLAB comparison entry point.

This plan does not itself add SPICE validation. Additional validation claims must wait until real exported OPA818 and ADA4817-1 LTspice data are collected, imported, and compared.

## Target Models

- OPA818 from Texas Instruments
- ADA4817-1 from Analog Devices

These two models were selected from the Round 7 datasheet candidate table and selection summary:

- `tia_extension/datasheets/vendor_opamp_candidate_table.csv`
- `tia_extension/datasheets/vendor_opamp_candidate_table_si.csv`
- `tia_extension/datasheets/vendor_opamp_candidate_selection_summary.md`

## Selection Rationale

OPA818 is the first target because it is a high-priority modern wideband FET-input TIA candidate with low current noise, moderate input capacitance, and high GBWP. It provides a direct next comparison after OP27 and an upgrade-context comparison to OPA657.

ADA4817-1 is the second target because it is a unity-gain-stable FET-input photodiode preamp candidate. It is expected to be easier to simulate and interpret than more aggressive decompensated GHz-class options, while still being relevant to photodiode TIA design.

## Relationship To OP27 Smoke Test

The repository already contains a real LTspice OP27 smoke-test comparison for three feedback-capacitance cases. OP27 remains the current single-model SPICE evidence. Round 8A prepares the same evidence path for OPA818 and ADA4817-1 but does not add the real exported data yet.

Correct status after Round 8A:

- OP27 real LTspice smoke-test comparison exists.
- OPA818 and ADA4817-1 workflow preparation exists.
- Real OPA818 and ADA4817-1 exported LTspice data are still pending.
- Q3 SPICE requirement remains pending additional real vendor macromodel comparisons.

## Vendor Model File Policy

Vendor macromodel files should remain local unless redistribution is clearly permitted by the vendor license. Prefer storing local model copies under:

```text
tia_extension/spice_interface/vendor_models_local/
```

or temporary downloaded archives under:

```text
tia_extension/spice_interface/vendor_model_cache/
```

Do not commit vendor `.lib`, `.sub`, `.cir`, `.mod`, `.raw`, `.log`, generated `.net`, or downloaded archive files.

## Manual Data To Collect

For each OPA818 and ADA4817-1 case, collect:

- op-amp model name;
- manufacturer;
- source product page URL;
- model access date;
- local model filename, not committed;
- LTspice version or SPICE tool name;
- Rf, Cpd, Cf, supply rails, and biasing notes;
- AC current source amplitude;
- raw export filename;
- processed CSV filename for MATLAB import;
- schematic screenshot filename;
- frequency-response screenshot filename;
- visual region notes, if any.

Use `tia_extension/spice_interface/round8_vendor_spice_case_metadata_template.csv` to record the planned cases before real exports are imported.

## Expected Next Step After Manual LTspice Export

After real LTspice exports are available, convert the raw text exports into CSV files compatible with `import_spice_ac_data.m` and place them under:

```text
tia_extension/spice_interface/imported_ac_data/
```

Then run:

```matlab
run('tia_extension/scripts/run_10_compare_vendor_spice_models.m')
```

The script will not generate synthetic data. It only compares real OPA818 or ADA4817 exported CSV files that are present and sufficiently described.
