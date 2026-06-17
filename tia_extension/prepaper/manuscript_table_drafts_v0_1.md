# Manuscript Table Drafts v0.1

These table drafts are prepared from existing repository CSV files, markdown notes, and classification logic. They are manuscript-preparation material only. They do not create a final bibliography, do not add new simulation data, and do not change any model or result source file.

## Table 1. Behavioural Model Assumptions And Swept Parameters

Draft caption: Behavioural model assumptions and swept parameter ranges used in the MATLAB TIA screening workflow. The table summarizes repository-defined assumptions for `Rf`, `Cf`, `Cpd`, `A0`, and `ft_Hz`; it does not define a universal photodiode TIA design rule.

| Parameter or item | Meaning in manuscript | Baseline value if available | Swept range or values if available | Source file |
|---|---|---:|---|---|
| `Rf_ohm` | Feedback resistance | `100000` ohm | Full sweep summary: `10000` to `1000000` ohm | `tia_extension/results/baseline_metrics.csv`; `tia_extension/results/tia_sweep_summary.csv`; `tia_extension/docs/tia_model_assumptions.md` |
| `Cf_F` | Feedback capacitance | `1e-12` F | Focused `Cf` sweep: `1e-13` to `1e-11` F; design-region selected `Cf`: `1e-13` to `1e-11` F | `tia_extension/results/baseline_metrics.csv`; `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv`; `tia_extension/results/tia_design_region_map.csv`; `tia_extension/results/tia_sweep_summary.csv` |
| `Cpd_F` | Photodiode capacitance at the inverting input node | `2e-12` F | Focused `Cf` sweep uses `5e-12` F; design-region/full sweep coverage: `1e-12` to `2e-11` F | `tia_extension/results/baseline_metrics.csv`; `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv`; `tia_extension/results/tia_design_region_map.csv`; `tia_extension/results/tia_sweep_summary.csv` |
| `A0` | Low-frequency open-loop gain in the single-pole op-amp approximation | `100000` | Sweeps use `100000` | `tia_extension/results/baseline_metrics.csv`; `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv`; `tia_extension/results/tia_sweep_summary.csv`; `tia_extension/docs/tia_model_assumptions.md` |
| `ft_Hz` | Op-amp transition frequency assumption | `100000000` Hz | Focused `Cf` sweep values: `1000000`, `10000000`, `100000000` Hz; full/design sweeps cover `1000000` to `100000000` Hz | `tia_extension/results/baseline_metrics.csv`; `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv`; `tia_extension/results/tia_design_region_map.csv`; `tia_extension/results/tia_sweep_summary.csv` |
| `fp_Hz` | Open-loop pole used in the behavioural approximation, calculated as `ft_Hz / A0` | `1000` Hz | See source file for script-specific derived values | `tia_extension/results/baseline_metrics.csv`; `tia_extension/docs/tia_model_assumptions.md` |
| `Yf = 1/Rf + s*Cf` | Feedback admittance used in the behavioural model | See source file | See source file | `tia_extension/docs/tia_model_assumptions.md` |
| `Zt_nonideal` | Non-ideal transimpedance response with finite op-amp gain and bandwidth | See source file | Computed for each simulated row | `tia_extension/docs/tia_model_assumptions.md`; `tia_extension/functions/tia_response.m` |
| Bandwidth metric | Extracted `-3 dB` bandwidth relative to low-frequency transimpedance | `1642366.31572658` Hz | Focused `Cf` sweep range: `159264.075400712` to `8424705.1429956` Hz | `tia_extension/results/baseline_metrics.csv`; `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv` |
| Peaking metric | Extracted response peaking used for project-defined screening | `5.93485696013527e-11` dB | Focused `Cf` sweep range: `9.10325128426255e-13` to `10.9058121669258` dB | `tia_extension/results/baseline_metrics.csv`; `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv`; `tia_extension/functions/classify_tia_design_region.m` |
| Focused `Cf` sweep size | Feedback-capacitance sweep used for the manuscript bandwidth and peaking figures | Not applicable | `120` rows; classifications: `67` Safe, `14` Marginal, `39` Risky | `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv` |
| Full behavioural sweep size | Broader behavioural sweep used to construct design-region evidence | Not applicable | `19200` rows; classifications: `11566` Safe, `2066` Marginal, `5568` Risky | `tia_extension/results/tia_sweep_summary.csv` |
| Design-region map size | Best available feedback-capacitance selections across `Cpd` and `ft_Hz` grid | Not applicable | `480` rows; selected `Cf` range `1e-13` to `1e-11` F; stored classifications are Safe | `tia_extension/results/tia_design_region_map.csv` |

Caution for manuscript use: Table 1 combines several repository evidence layers. The baseline row, focused `Cf` sweep, full sweep summary, and design-region map do not all use identical parameter settings, so the final manuscript text should identify which evidence layer supports each claim.

## Table 2. Project-Defined Safe/Marginal/Risky Screening Criteria

Draft caption: Project-defined Safe, Marginal, and Risky screening criteria used to organize extracted behavioural metrics. The labels are internal design-screening categories and should not be interpreted as universal stability classifications or hardware guarantees.

| Label | Code | Interpretation for this project | Metric threshold or rule | Caution |
|---|---:|---|---|---|
| Safe | `1` | Behavioural response has valid extracted bandwidth and low peaking under the project metric. | `valid_bandwidth == true` and `peaking_dB < 1` dB | Safe is a screening label, not a hardware guarantee, measured stability result, or universal phase-margin rule. |
| Marginal | `2` | Behavioural response has valid extracted bandwidth but peaking is high enough to require review. | `valid_bandwidth == true` and `1 <= peaking_dB <= 3` dB | Marginal should trigger closer review of response shape, phase, vendor macromodel behaviour, and later circuit evidence. |
| Risky | `3` | Behavioural response is outside the project peaking limit or the metric extraction is invalid. | `peaking_dB > 3` dB, invalid bandwidth extraction, or non-finite peaking | Risky is not a failure certificate; it is a project-defined prompt for redesign or deeper analysis. |

Source rule text from `tia_extension/functions/classify_tia_design_region.m`:

```text
Safe: valid bandwidth and peaking < 1 dB;
Marginal: valid bandwidth and peaking from 1 dB to 3 dB;
Risky: peaking > 3 dB or invalid extraction.
```

Manuscript caution: Peaking is used as a practical screening metric in this workflow, but it is not a complete stability proof and should not be presented as a substitute for phase-margin, transient, layout-aware, or hardware evidence.

## Table 3. Vendor Macromodel Comparison Summary

Draft caption: Summary of OP27, OPA818, and ADA4817 vendor macromodel comparison cases, including feedback capacitance, extracted peaking, extracted `-3 dB` bandwidth, and project-defined visual region label. These rows are simulation-only vendor macromodel comparisons under repository test assumptions, not hardware validation and not identical operating-point equivalence.

Numeric values are taken from `tia_extension/results/spice_comparison_summary_vendor_models.csv` and shown at manuscript-readable precision. Use the CSV for exact machine-readable values.

| Case ID | Device/model | `Rf` (ohm) | `Cpd` (F) | `Cf` (F) | Supplies (V) | Peaking (dB) | `-3 dB` bandwidth (Hz) | Project-defined label |
|---|---|---:|---:|---:|---|---:|---:|---|
| `OP27_Cf3p455_Risky` | OP27 | `10000` | `1e-11` | `3.455e-12` | `+15/-15` | `11.8631` | `3.126e6` | Risky |
| `OP27_Cf10p_SafeCandidate` | OP27 | `10000` | `1e-11` | `1e-11` | `+15/-15` | `0.480286` | `2.692e6` | Safe |
| `OP27_Cf22p_Safe` | OP27 | `10000` | `1e-11` | `2.2e-11` | `+15/-15` | `3.31e-11` | `8.414e5` | Safe |
| `OPA818_Rf10k_Cpd10p_Cf0p5` | OPA818 | `10000` | `1e-11` | `5e-13` | `+5/-5` | `7.11e-14` | `2.483e7` | Safe |
| `OPA818_Rf10k_Cpd10p_Cf1p0` | OPA818 | `10000` | `1e-11` | `1e-12` | `+5/-5` | `1.14e-13` | `1.479e7` | Safe |
| `OPA818_Rf10k_Cpd10p_Cf1p5` | OPA818 | `10000` | `1e-11` | `1.5e-12` | `+5/-5` | `1.99e-13` | `1.035e7` | Safe |
| `OPA818_Rf10k_Cpd10p_Cf2p2` | OPA818 | `10000` | `1e-11` | `2.2e-12` | `+5/-5` | `3.98e-13` | `7.161e6` | Safe |
| `ADA4817_Rf10k_Cpd10p_Cf0p5` | ADA4817 | `10000` | `1e-11` | `5e-13` | `+5/-5` | `2.9911` | `3.311e7` | Marginal |
| `ADA4817_Rf10k_Cpd10p_Cf1p0` | ADA4817 | `10000` | `1e-11` | `1e-12` | `+5/-5` | `0.002388` | `2.213e7` | Safe |
| `ADA4817_Rf10k_Cpd10p_Cf2p2` | ADA4817 | `10000` | `1e-11` | `2.2e-12` | `+5/-5` | `0.0008829` | `7.943e6` | Safe |
| `ADA4817_Rf10k_Cpd10p_Cf4p7` | ADA4817 | `10000` | `1e-11` | `4.7e-12` | `+5/-5` | `4.55e-13` | `3.467e6` | Safe |

Source-note wording to preserve near this table: OP27 used `+15/-15 V`; OPA818 and ADA4817 used `+5/-5 V`. These rows are design-evidence comparisons across vendor macromodels, not identical operating-point equivalence and not hardware validation.

## Table 4. Literature/Source Usage Confidence Table

Draft caption: Source-usage confidence table separating full-text, abstract-only, and metadata-only literature candidates used in the manuscript draft. Full-text sources may support detailed reading after verification; abstract-only sources are limited to broad background visible in official abstracts; metadata-only sources are placeholders for future full-text acquisition.

This table uses placeholder citation IDs only. It is not a final bibliography.

### Table 4a. Full-Text Available Sources

| Citation ID | Access level | Usage allowed in current manuscript draft | Manuscript role | Caution |
|---|---|---|---|---|
| `NOH_2020_CF_TIA_DC_LOOP` | Full text available locally | Supports broad discussion of capacitive-feedback TIA design, DC feedback, parasitic capacitance effects, frequency response, stability-oriented design parameters, and noise trade-offs. | Introduction; Related Work; compensation and noise limitations | Do not imply the project implements or validates this circuit; use detailed equations only after a dedicated close reading. |
| `LEE_2021_4GHZ_SDT_VG_TIA` | Full text available locally | Supports CMOS optical-communication TIA context, inductorless/front-end topology context, bandwidth enhancement, variable gain, and regulated-cascode-derived examples. | Related Work | Do not compare measured IC results directly with behavioural or vendor macromodel results. |
| `TAKAHASHI_2022_LOCAL_FEEDBACK_RGC` | Full text available locally | Supports regulated-cascode CMOS TIA context, local feedback, bandwidth extension, and optical receiver motivation. | Related Work; methodology boundary | Keep post-layout simulation evidence separate from repository MATLAB and vendor macromodel evidence. |
| `ANALUI_2004_BW_ENHANCEMENT` | Full text available locally | Supports motivation around TIA bandwidth limits, photodiode capacitance, and bandwidth-enhancement approaches. | Introduction; Related Work | Do not present passive matching or filter-synthesis methods as part of the project method. |
| `LU_2007_BROADBAND_TIA` | Full text available locally | Supports broad-band TIA framing, photodiode capacitance, input matching, group delay, and noise-bandwidth coupling. | Related Work; Methodology motivation; noise context | The project does not implement this paper's broadband design method. |
| `PARK_YOO_2004_RGC_TIA` | Full text available locally | Supports regulated-cascode CMOS TIA background and photodiode-capacitance motivation. | Related Work | Do not compare measured performance directly with project sweeps. |
| `XU_2011_INDUCTORLESS_TIA` | Full text available locally | Supports inductorless optical-communication TIA context and RGC input-stage continuity. | Related Work | Keep as topology context unless the final paper builds a detailed taxonomy. |
| `PAN_LUO_2022_20GBPS_TIA` | Full text available locally | Supports high-speed CMOS optical-communication TIA examples, off-chip photodiode capacitive loading, and compensation motivation. | Related Work | Do not cite measured performance numbers unless a verified comparison table is later prepared. |
| `PAN_2022_26GBPS_RX` | Full text available locally | Supports receiver-level context where a TIA is part of a larger optical receiver chain. | Introduction; Related Work | Do not claim receiver-level validation for this project. |
| `ABDOLLAHI_2025_MDFRGC_TIA` | Full text available locally | Supports recent modified-RGC, bandwidth, photodiode capacitance, and noise/bandwidth context. | Related Work; noise and bandwidth framing | Do not imply the repository reproduces its topology or measurements. |
| `MESGARI_2024_MULTI_DOT_PIN_RX` | Full text available locally | Supports integrated photodiode/readout context and TIA/equalizer framing. | Optional Introduction or Related Work context | Keep optional unless the manuscript expands toward integrated detector readout. |

### Table 4b. Abstract-Only Sources

| Citation ID | Access level | Usage allowed in current manuscript draft | Manuscript role | Caution |
|---|---|---|---|---|
| `VAZQUEZ_2021_OPTICAL_DETECTION_TIA` | Abstract visible, no full text | Broad background only: optical detection systems based on TIAs involve coupled noise, frequency response, and stability constraints; feedback-network component search and phase margin are visible at abstract level. | Related Work background | Do not cite procedure, equations, merit-function details, component-selection algorithm, or numeric examples without full text. |
| `LI_2021_LOW_NOISE_OPTICAL_RX_TIA` | Abstract visible, no full text | Broad background only: low-noise optical receiver TIA work involving RGC, shunt-feedback ideas, noise optimization, photodetector capacitance, gain, and bandwidth is visible at abstract level. | Noise-aware Related Work background | Do not cite measured values, detailed circuit sizing, matching network details, or conclusions without full text. |

### Table 4c. Metadata-Only Sources

| Citation ID | Access level | Usage allowed in current manuscript draft | Manuscript role | Caution |
|---|---|---|---|---|
| `HERMANS_2006_850NM_RX` | Publisher landing page / metadata only | Title-level placement as an 850-nm CMOS optical receiver front-end candidate. | Future Cherry-Hooper or receiver context | Do not claim modified Cherry-Hooper details, measured performance, photodetector implementation, or TIA architecture until full text is obtained. |
| `ZHOU_2021_CHERRY_HOOPER_AFE` | Publisher landing page / metadata only | Title-level placement as a 25-Gbps inductorless optical receiver AFE based on modified Cherry-Hooper amplifier. | Future Cherry-Hooper and inductorless AFE positioning | Do not claim topology details, shunt-feedback details, measured bandwidth, power, or BER without full text. |
| `CHEN_2005_10GBPS_CMOS_RX_AFE` | Publisher landing page / metadata only | Title-level placement as a 10-Gb/s fully integrated CMOS optical receiver analog front-end. | Future classic high-speed CMOS receiver AFE context | Do not cite architecture, sensitivity, gain, bandwidth, transformers, or measurement details without full text. |
| `PARK_2015_40GBPS_INVERTER_RX` | Publisher landing page / metadata only | Title-level placement as a 40-Gb/s inverter-based CMOS optical receiver front-end. | Future high-speed CMOS optical receiver context | Do not cite energy efficiency, bandwidth, noise, topology details, or measured results without full text. |
| `LI_2014_LOW_NOISE_CMOS_RX` | Publisher landing page / metadata only | Title-level placement as low-noise high-speed CMOS optical receiver context. | Future low-noise receiver framing | Do not cite topology comparison, noise-reduction claims, receiver implementation, or measured performance without full text. |

Manuscript caution: Abstract-only and metadata-only sources should not be used for numerical comparison rows, methods-level claims, equations, or conclusions. They may remain as placeholders for future full-text acquisition and bibliography work.
