# Round 8 Vendor Model Acquisition Guide

## Purpose

This guide records how to acquire OPA818 and ADA4817-1 vendor macromodels for local LTspice comparison work. Do not commit vendor model files unless redistribution is explicitly permitted.

Store local-only model files under:

```text
tia_extension/spice_interface/vendor_models_local/
```

Downloaded archives or temporary vendor packages can be kept under:

```text
tia_extension/spice_interface/vendor_model_cache/
```

Both locations are ignored by Git.

## OPA818

- Manufacturer: Texas Instruments
- Product page: `https://www.ti.com/product/OPA818`
- Round 7 model note: TI product information lists TINA-TI and PSpice model resources.

Where to look:

- TI product page design and development section.
- TI simulation model links for PSpice or TINA-TI.
- Any model package documentation that identifies supported SPICE tools and pin order.

Local handling:

1. Download the official model package manually.
2. Save the local copy under `tia_extension/spice_interface/vendor_models_local/OPA818/`.
3. Record the source URL, access date, local model filename, and package notes in the Round 8 metadata template.
4. Do not commit the vendor model file or downloaded archive.

Notes:

- OPA818 is decompensated and stable for gain >= 7 V/V.
- Use valid model pins and supply pins from the vendor model documentation.
- If the model rejects the suggested dual +5 V / -5 V setup, document the legal supply condition used.

## ADA4817-1

- Manufacturer: Analog Devices
- Product page: `https://www.analog.com/en/products/ada4817-1.html`
- Round 7 model note: ADI product information lists an ADA4817 SPICE macro model.

Where to look:

- ADI product page design resources or simulation model section.
- ADI SPICE macro model download link.
- Model readme, symbol, and pin-order notes included with the download.

Local handling:

1. Download the official model package manually.
2. Save the local copy under `tia_extension/spice_interface/vendor_models_local/ADA4817-1/`.
3. Record the source URL, access date, local model filename, and package notes in the Round 8 metadata template.
4. Do not commit the vendor model file or downloaded archive.

Notes:

- ADA4817-1 is a FET-input unity-gain-stable photodiode preamp candidate.
- Use valid model pins and supply pins from the vendor model documentation.
- If the model rejects the suggested dual +5 V / -5 V setup, document the legal supply condition used.

## Recording Source Details

For every downloaded model, record:

- product page URL;
- exact model download URL if distinct;
- access date;
- local model filename;
- vendor package version or revision, if available;
- any license or redistribution warning;
- pin-order or symbol notes needed to reproduce the schematic.

This guide does not add SPICE validation and does not add hardware evidence.
