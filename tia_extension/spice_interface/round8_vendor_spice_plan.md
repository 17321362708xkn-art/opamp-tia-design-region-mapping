# Round 8 Vendor SPICE Plan

## Purpose

Round 8 prepares the TIA extension for additional real vendor SPICE macromodel comparison beyond the existing OP27 smoke test. Round 8A is preparation only: it defines target models, local model handling, manual LTspice export steps, metadata requirements, and a guarded MATLAB comparison entry point.

Round 8B has now imported real OPA818 LTspice text exports generated from the official TI OPA818 PSpice macromodel. This plan remains the workflow reference for the next vendor comparison, preferably ADA4817-1 or LTC6268-10. It does not claim hardware validation or final Q3 readiness.

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

The repository already contains a real LTspice OP27 smoke-test comparison for three feedback-capacitance cases. Round 8B adds the OPA818 real vendor macromodel Cf sweep for four feedback-capacitance cases. Together, OP27 and OPA818 provide two macromodel comparison sets, but the Q3 SPICE requirement remains pending at least one additional vendor macromodel comparison.

Correct status after Round 8B:

- OP27 real LTspice smoke-test comparison exists.
- OPA818 real LTspice vendor macromodel import exists.
- ADA4817-1 workflow preparation exists.
- Real ADA4817-1 or LTC6268-10 exported LTspice data are still pending.
- Q3 SPICE requirement remains pending at least one additional real vendor macromodel comparison.

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

For each remaining vendor case, collect:

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

Use `tia_extension/spice_interface/round8_vendor_spice_case_metadata_template.csv` to record planned cases before real exports are imported. The OPA818 rows now document the Round 8B imported cases.

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
