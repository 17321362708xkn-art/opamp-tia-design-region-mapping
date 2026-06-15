# SPICE AC Data Format

This document defines the CSV format expected by `import_spice_ac_data.m`.

No example or synthetic SPICE data is included in this repository. Only real exported SPICE macromodel AC data should be placed in the import folder.

## Required Frequency Column

Use one of:

- `f_Hz`
- `frequency_Hz`
- `freq_Hz`
- `frequency`
- `freq`

Frequency must be in Hz.

## Required Response Columns

Use one of the following response formats.

### Magnitude In Ohms And Phase In Degrees

- `mag_Zt_ohm`
- `phase_Zt_deg`

### Magnitude In dB-Ohm And Phase In Degrees

- `mag_Zt_dBohm`
- `phase_Zt_deg`

### Complex Transimpedance

- `real_Zt`
- `imag_Zt`

The imported quantity must be transimpedance:

```text
Zt = Vout / Ipd
```

If the SPICE AC current source is set to 1 A, then `Vout` numerically equals `Zt`.

## Recommended Metadata Columns

Include constant columns so the importer can match the SPICE export to a MATLAB behavioural candidate case:

- `case_label`
- `vendor_model`
- `Rf_ohm`
- `Cf_F`
- `Cpd_F`
- `A0`
- `ft_Hz`

## Import Folder

Place real exported SPICE CSV files in:

```text
tia_extension/spice_interface/imported_ac_data/
```

The folder is intentionally not populated with fake data.
