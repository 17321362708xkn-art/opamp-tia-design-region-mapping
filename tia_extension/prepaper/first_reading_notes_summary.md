# First Reading Notes Summary

These are writing-oriented starter notes for sources with full text available locally. They are not a final literature review, not a bibliography, and not proof that any source has been fully read end to end. Use them to decide which papers to read first and where each source can support the manuscript.

## Core Full-Text Sources

### NOH_2020_CF_TIA_DC_LOOP

- Full title: A Capacitive Feedback Transimpedance Amplifier with a DC Feedback Loop Using a Transistor for High DC Dynamic Range
- Why it matters: Directly supports the feedback-capacitance, frequency-response, and stability side of the manuscript. The paper discusses a capacitive-feedback TIA, DC feedback, parasitic capacitance effects, and stability-oriented design parameters.
- Manuscript section supported: Introduction; Related Work; Feedback-capacitance sweep and stability proxy; Noise analysis limitations.
- Usable claims:
  - Capacitive-feedback TIA design can be framed around frequency response, DC feedback, stability, and noise trade-offs.
  - Feedback-network and parasitic-capacitance details matter enough that a simplified project model must be presented as screening, not complete design.
  - This source can support the need for cautious compensation discussion.
- Caution:
  - The paper proposes its own circuit; do not imply the project implements or validates that circuit.
  - Do not copy its design equations into the manuscript until a dedicated close reading is done.
- Priority: core.

### LEE_2021_4GHZ_SDT_VG_TIA

- Full title: A 4 GHz Single-to-Differential Cross-Coupled Variable-Gain Transimpedance Amplifier for Optical Communication
- Why it matters: Provides a full-text CMOS optical-communication TIA example with an inductorless single-to-differential input stage, modified cross-coupled regulated-cascode design, bandwidth enhancement, variable gain, and optical-receiver framing.
- Manuscript section supported: Related Work; CMOS optical receiver TIA examples; inductorless/front-end topology context.
- Usable claims:
  - CMOS optical-receiver TIA literature includes inductorless and regulated-cascode-derived front-end structures.
  - Bandwidth enhancement and gain/peaking control appear as design objectives in optical-communication TIA work.
  - The project should be positioned as a screening workflow rather than a competing circuit topology.
- Caution:
  - The paper reports measured IC results; do not compare the project's behavioural or vendor-macromodel results as if they were equivalent measurements.
  - Use any numeric performance values only after a close reading and with clear context.
- Priority: core.

### TAKAHASHI_2022_LOCAL_FEEDBACK_RGC

- Full title: Low-Power Regulated Cascode CMOS Transimpedance Amplifier with Local Feedback Circuit
- Why it matters: Full-text regulated-cascode CMOS TIA source with local feedback, bandwidth extension, optical receiver motivation, and post-layout simulation context.
- Manuscript section supported: Related Work; regulated-cascode context; Methodology boundary between circuit-level TIA papers and this behavioural workflow.
- Usable claims:
  - Regulated-cascode TIA variants remain active in CMOS optical receiver research.
  - Local feedback is one published route for bandwidth extension in TIA circuits.
  - Optical TIA papers often distinguish circuit topology contribution from simulation/measurement evidence, which helps frame the project's more limited evidence.
- Caution:
  - This is not hardware evidence for the project.
  - Keep its post-layout simulation results separate from the repository's MATLAB and vendor-macromodel results.
- Priority: core.

### ANALUI_2004_BW_ENHANCEMENT

- Full title: Bandwidth Enhancement for Transimpedance Amplifiers
- Why it matters: Formal JSSC full-text paper on bandwidth enhancement for TIAs in the presence of photodiode capacitance. It is useful for motivating bandwidth limits and enhancement approaches in high-speed TIA work.
- Manuscript section supported: Introduction; Related Work; Feedback-capacitance and bandwidth motivation.
- Usable claims:
  - TIA bandwidth can be limited by parasitic capacitances and gain-stage interactions.
  - Published TIA work uses circuit techniques to shape transfer functions and bandwidth, so this project should claim screening support rather than topology novelty.
  - Photodiode capacitance is an explicit design concern in high-speed TIA literature.
- Caution:
  - Do not present passive matching or filter-synthesis details as part of the project method.
  - Use detailed equations only after a focused read.
- Priority: core.

### LU_2007_BROADBAND_TIA

- Full title: Broad-Band Design Techniques for Transimpedance Amplifiers
- Why it matters: Formal TCAS-I paper connecting regulated-cascode input stage, capacitive degeneration, broadband matching, photodiode capacitance, bandwidth, group delay, and noise.
- Manuscript section supported: Related Work; Methodology motivation; Noise-analysis context.
- Usable claims:
  - Regulated-cascode input stages and bandwidth-enhancement networks are established TIA design topics.
  - Photodiode capacitance and input matching are important in broad-band TIA design.
  - Noise and bandwidth must be discussed together rather than as isolated metrics.
- Caution:
  - The project does not implement the paper's fifth-order Butterworth design method.
  - Avoid numeric comparison until the paper is read in detail.
- Priority: core.

### PARK_YOO_2004_RGC_TIA

- Full title: 1.25-Gb/s regulated cascode CMOS transimpedance amplifier for gigabit ethernet applications
- Why it matters: Canonical full-text RGC CMOS TIA reference. Its abstract explicitly ties the RGC input stage to isolation of input parasitic capacitance including photodiode capacitance.
- Manuscript section supported: Related Work; regulated-cascode topology background; photodiode-capacitance motivation.
- Usable claims:
  - RGC input stages are a known CMOS TIA approach for optical receiver applications.
  - Photodiode capacitance can be part of the bandwidth problem addressed by TIA topology choices.
  - This reinforces that the project is not proposing RGC topology novelty.
- Caution:
  - The paper's measured performance should not be compared directly with the project's behavioural sweeps.
  - Use its noise analysis only after close reading.
- Priority: core.

### XU_2011_INDUCTORLESS_TIA

- Full title: A 3.125-Gb/s inductorless transimpedance amplifier for optical communication in 0.35 um CMOS
- Why it matters: Full-text inductorless optical-communication TIA source with RGC input stage, DC cancellation, noise optimization, and measured eye-diagram context.
- Manuscript section supported: Related Work; inductorless CMOS optical receiver TIA category.
- Usable claims:
  - Inductorless CMOS TIAs are a relevant optical-communication receiver category.
  - RGC input stages appear in both classic and later inductorless TIA work.
  - DC operating-point stabilization can be a front-end design concern in optical TIA circuits.
- Caution:
  - This is measured circuit literature; do not equate it with project simulation evidence.
  - Keep it in Related Work unless the manuscript needs a detailed topology taxonomy.
- Priority: useful.

### PAN_LUO_2022_20GBPS_TIA

- Full title: A 58-dBOhm 20-Gb/s inverter-based cascode transimpedance amplifier for optical communications
- Why it matters: Full-text high-speed CMOS optical-communication TIA source with bandwidth-enhancement techniques, off-chip photodiode capacitive loading, and negative-capacitance compensation language.
- Manuscript section supported: Related Work; high-speed CMOS optical receiver TIA examples; compensation motivation.
- Usable claims:
  - High-speed CMOS TIA papers explicitly address photodiode capacitive loading and bandwidth enhancement.
  - Inverter/cascode TIA approaches are part of the CMOS optical receiver landscape.
  - The project can cite this as motivation for modelling capacitance and bandwidth trade-offs.
- Caution:
  - Do not cite the paper's measured performance numbers unless the final draft uses a verified comparison table.
  - Keep topology details separate from the project's op-amp behavioural model.
- Priority: core/useful.

### PAN_2022_26GBPS_RX

- Full title: A 26-Gb/s CMOS optical receiver with a reference-less CDR in 65-nm CMOS
- Why it matters: Full-text complete optical receiver source, including TIA/VGA/CDR blocks. Useful for showing that TIA design sits inside larger receiver front-end systems.
- Manuscript section supported: Introduction; Related Work; high-speed optical receiver context.
- Usable claims:
  - TIA front ends are central blocks in CMOS optical receivers.
  - Receiver-level papers often include TIA, gain control/equalization, and data-recovery context.
  - This supports a motivation paragraph without turning the project into a full receiver paper.
- Caution:
  - The manuscript should not claim receiver-level validation.
  - Use only high-level context unless a later section explicitly compares receiver architectures.
- Priority: useful.

### ABDOLLAHI_2025_MDFRGC_TIA

- Full title: Low-Noise Modified-RGC Transimpedance Amplifier With Bandwidth Enhancement Using an Intrinsic Negative-RC Network
- Why it matters: Full-text recent modified-RGC TIA paper that discusses bandwidth and noise improvement, photodiode capacitance, input/output node bandwidth, and circuit-level validation.
- Manuscript section supported: Related Work; regulated-cascode and noise/bandwidth trade-off context.
- Usable claims:
  - Modified RGC topologies remain current in optical TIA research.
  - Noise and bandwidth improvement are coupled design goals in recent TIA circuits.
  - Full-text availability makes it a strong recent source for positioning the project.
- Caution:
  - It is a circuit contribution; do not imply the repository reproduces its topology or measurements.
  - Avoid detailed figure-of-merit comparison until the source is read closely.
- Priority: core.

### MESGARI_2024_MULTI_DOT_PIN_RX

- Full title: A 4 Gb/s Multi-Dot PIN-Photodiode-Based CMOS Optical Receiver Using a Single to Differential TIA-Equalizer
- Why it matters: Full-text integrated photodiode/readout receiver source with single-to-differential TIA equalizer and bandwidth-extension framing.
- Manuscript section supported: Introduction; Related Work; integrated photonic detector/readout context.
- Usable claims:
  - TIA/equalizer circuits can be used to compensate limited photodiode bandwidth in integrated optical receiver work.
  - Photodiode bandwidth/capacitance and readout electronics are coupled in receiver design.
- Caution:
  - This is an integrated receiver design, not an op-amp photodiode TIA model.
  - Keep it as context or optional related work unless the manuscript expands toward integrated photonic detector readout.
- Priority: useful/optional.

## Additional Local Full-Text Sources For Optional Context

| Citation ID | Role | Suggested use | Caution |
|---|---|---|---|
| CMOS_QTIA_SUN_2021 | useful | Optical receiver ASIC context and multi-channel TIA/background reading. | arXiv/preprint row; verify publication status before final citation. |
| CMOS_TIA_ZITO_2023 | optional | Compact CMOS TIA example outside optical receiver focus. | Qubit readout context is adjacent, not core. |
| BALANCED_TIA_MASALOV_2017 | optional | Balanced optical detector/TIA noise context. | arXiv/preprint row; not a CMOS optical receiver topology source. |
| RESONANT_TIA_BOWDEN_2019 | optional | Low-noise resonant photodetector/TIA context. | Resonant detector context differs from the project's model. |
| BOOTSTRAP_PD_RYGER_2026 | optional | Recent photodetector/readout background. | arXiv/preprint and very recent; verify status before final use. |
| LOWNOISE_TIA_STUBIAN_2020 | optional | Wideband low-noise TIA context. | Scanning tunneling microscopy context is adjacent. |
| WIDEBAND_TIA_CARNITI_2026 | optional | SiPM/wideband current-readout context. | arXiv/preprint and sensor readout, not optical receiver TIA core. |
| AGC_TIA_HODISAN_2024 | optional | Optical signal acquisition with AGC context. | Memristor AGC topic is adjacent and should not dominate Related Work. |
| FD_TIA_ARGIMBAYEV_2018 | optional | Fully differential TIA adjacent context. | Keep in manual review unless relevance is clear. |
| EPIC_DETECTOR_TASKER_2023 | optional | Integrated electronic-photonic detector context. | Quantum light detector application is background only. |

## Reading Order Recommendation

1. NOH_2020_CF_TIA_DC_LOOP
2. ANALUI_2004_BW_ENHANCEMENT
3. LU_2007_BROADBAND_TIA
4. PARK_YOO_2004_RGC_TIA
5. TAKAHASHI_2022_LOCAL_FEEDBACK_RGC
6. LEE_2021_4GHZ_SDT_VG_TIA
7. PAN_LUO_2022_20GBPS_TIA
8. ABDOLLAHI_2025_MDFRGC_TIA
9. XU_2011_INDUCTORLESS_TIA
10. PAN_2022_26GBPS_RX
11. MESGARI_2024_MULTI_DOT_PIN_RX

## Notes For The First Manuscript Pass

- Use full-text sources for topology families and design-motivation claims.
- Use DOI-only abstract sources only under the policy in `abstract_only_sources_policy.md`.
- Keep all quantitative project claims tied to committed result CSVs and figures.
- Do not write final citation prose until each selected source has a dedicated reading note or annotated margin pass.
