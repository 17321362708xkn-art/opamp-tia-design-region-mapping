# Manuscript Draft v0.3 With Figure Callouts

This is a paper-style working draft with figure and table callouts added. It is not a final submission or final bibliography. Citation markers are placeholder citation IDs. The validation boundary remains limited to behavioural modelling, repository-generated sweeps, and vendor macromodel comparison.

## Title

MATLAB-and-SPICE-Assisted Design-Region Mapping for Photodiode Transimpedance Amplifiers Under Finite Op-Amp Bandwidth Constraints

## Abstract

Photodiode transimpedance amplifier (TIA) design requires simultaneous attention to feedback resistance, photodiode capacitance, feedback capacitance, finite op-amp bandwidth, frequency-response peaking, and noise. This work develops a reproducible pre-design screening workflow that combines a MATLAB behavioural TIA model with project-defined design-region maps and selected vendor macromodel comparison cases. The MATLAB workflow sweeps feedback capacitance, photodiode capacitance, and op-amp transition-frequency assumptions to extract bandwidth, peaking, and project-defined Safe/Marginal/Risky screening labels. The repository evidence also includes vendor macromodel comparison data for OP27, OPA818, and ADA4817 cases, plus first-pass behavioural noise estimates under stated assumptions. The contribution is an organized simulation-assisted workflow for early design exploration, not a new TIA topology. The current evidence is modelling and simulation evidence only; no hardware validation, measured-noise validation, or universal stability guarantee is claimed.

## Introduction

Photodiode TIAs convert photocurrent into voltage and often sit at the front of optical receiver or detector readout chains. Their apparent simplicity hides a coupled design space. Feedback resistance sets nominal low-frequency transimpedance, while photodiode capacitance, input capacitance, feedback capacitance, and finite op-amp bandwidth shape the closed-loop response. A design point that preserves bandwidth can exhibit substantial peaking under some assumptions, while a more conservative compensation choice can reduce peaking at the cost of bandwidth. Published TIA work treats photodiode capacitance, bandwidth extension, regulated-cascode input stages, feedback structures, and noise as recurring design concerns [ANALUI_2004_BW_ENHANCEMENT], [LU_2007_BROADBAND_TIA], [PARK_YOO_2004_RGC_TIA], [NOH_2020_CF_TIA_DC_LOOP].

This project addresses the early screening stage of photodiode TIA design. Instead of presenting a new circuit topology, it builds a traceable workflow for exploring selected design assumptions before detailed vendor simulation, layout-aware analysis, or hardware work. The workflow produces MATLAB-generated response curves, sweep summaries, design-region maps, vendor macromodel comparison figures, and first-pass noise estimates. These artifacts support cautious manuscript claims because each figure and table is tied to committed scripts, CSV files, and limitation notes.

Finite op-amp bandwidth is central to the workflow. A single-pole behavioural approximation makes the relationship between `Rf`, `Cf`, `Cpd`, `A0`, and `ft_Hz` explicit enough for fast parameter sweeps. The same simplification also defines the model boundary: the behavioural model does not capture all vendor pole-zero behaviour, output limits, nonlinearities, package effects, or layout parasitics. The baseline behavioural magnitude and phase responses provide the first visual anchor for this finite-bandwidth model (Figure 1). A compact model-parameter table should accompany this section or the Methods section to make the assumed and swept quantities explicit (Table 1).

The resulting contribution is a reproducible and claim-bounded pre-design workflow. It maps selected operating assumptions, visualizes project-defined Safe/Marginal/Risky regions, compares selected trends with vendor macromodel data, and adds first-pass noise context. The workflow helps organize early-stage design evidence; it does not establish a universal TIA design rule.

## Related Work

High-speed TIA literature contains many topology-level contributions. Bandwidth-enhancement work has used passive matching, broadband networks, capacitive degeneration, regulated-cascode stages, and other circuit techniques to address capacitance and frequency-response limits [ANALUI_2004_BW_ENHANCEMENT], [LU_2007_BROADBAND_TIA]. Regulated-cascode TIA work is relevant because it addresses input impedance and photodiode-capacitance isolation in CMOS optical receiver settings [PARK_YOO_2004_RGC_TIA]. More recent optical receiver papers continue to use regulated-cascode-derived, inductorless, inverter/cascode, and modified-RGC approaches for CMOS optical communication front ends [XU_2011_INDUCTORLESS_TIA], [LEE_2021_4GHZ_SDT_VG_TIA], [TAKAHASHI_2022_LOCAL_FEEDBACK_RGC], [PAN_LUO_2022_20GBPS_TIA], [ABDOLLAHI_2025_MDFRGC_TIA].

Feedback capacitance and stability-oriented frequency response form a second related-work thread. Noh 2020 is directly useful because it treats capacitive-feedback TIA design, DC feedback, parasitic capacitance effects, frequency response, and stability-oriented parameters [NOH_2020_CF_TIA_DC_LOOP]. Vazquez 2021 is currently abstract-only in the project index and can support only broad background that optical detection systems based on TIAs couple noise, frequency response, and stability [VAZQUEZ_2021_OPTICAL_DETECTION_TIA].

CMOS optical receiver papers provide application context. Full-text receiver examples include TIA, variable-gain, equalization, clock/data recovery, or integrated photodiode-readout blocks [PAN_2022_26GBPS_RX], [MESGARI_2024_MULTI_DOT_PIN_RX]. These works motivate the importance of the TIA front end, but the present project remains an op-amp-based behavioural screening workflow rather than a complete optical receiver design.

Noise-aware TIA design is also important. Full-text sources such as Noh 2020, Lu 2007, Lee 2021, Takahashi 2022, and Abdollahi 2025 support the general observation that noise, bandwidth, and topology decisions are coupled in TIA design [NOH_2020_CF_TIA_DC_LOOP], [LU_2007_BROADBAND_TIA], [LEE_2021_4GHZ_SDT_VG_TIA], [TAKAHASHI_2022_LOCAL_FEEDBACK_RGC], [ABDOLLAHI_2025_MDFRGC_TIA]. Li 2021 AIP is currently abstract-only and is used only for broad background on low-noise optical receiver TIA work involving RGC and shunt-feedback ideas [LI_2021_LOW_NOISE_OPTICAL_RX_TIA].

Several DOI-only or metadata-only papers remain high-priority for manual full-text acquisition, especially for Cherry-Hooper receiver front ends, 10/40 Gb/s CMOS optical receiver analog front ends, and low-noise high-speed CMOS receiver context [HERMANS_2006_850NM_RX], [ZHOU_2021_CHERRY_HOOPER_AFE], [CHEN_2005_10GBPS_CMOS_RX_AFE], [PARK_2015_40GBPS_INVERTER_RX], [LI_2014_LOW_NOISE_CMOS_RX]. In this draft, these sources are used only as placeholder markers for future related-work refinement. A source-usage confidence table should be included to distinguish full-text, abstract-only, and metadata-only evidence before the final bibliography is prepared (Table 4).

## Methodology

The workflow begins with a simplified finite-gain, finite-bandwidth behavioural TIA model. MATLAB scripts generate a baseline response and then sweep selected parameters. The baseline run compares ideal and finite-gain responses using `tia_extension/scripts/run_01_tia_baseline.m`, with outputs stored in `tia_extension/results/tia_baseline_response.csv` and `tia_extension/results/baseline_metrics.csv` (Figure 1; Table 1).

The feedback-capacitance sweep exposes the bandwidth and peaking trade-off. The script `tia_extension/scripts/run_03_sweep_Cf_for_peaking_bandwidth.m` generates `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv` and the figures `tia_extension/figures/tia_bandwidth_vs_Cf.png` and `tia_extension/figures/tia_peaking_vs_Cf.png`. Within the selected behavioural sweep, larger `Cf` reduces extracted bandwidth and generally lowers peaking. This result is interpreted within the explored parameter range, not as a universal compensation law (Figure 2; Figure 3).

The design-region stage maps selected `Rf`, `Cpd`, `Cf`, and `ft_Hz` values into project-defined Safe/Marginal/Risky categories. The script `tia_extension/scripts/run_05_design_region_map_tia.m` generates `tia_extension/results/tia_design_region_map.csv`, `tia_extension/results/tia_sweep_summary.csv`, `tia_extension/figures/tia_design_region_map_Cpd_ft.png`, and `tia_extension/figures/tia_representative_region_responses.png`. The criteria and labels should be summarized explicitly as project-defined screening definitions (Table 2). The region map and representative response examples provide the main visual evidence for this stage (Figure 4; Figure 5).

The vendor macromodel comparison stage checks selected behavioural trends against vendor-model export data. OP27 provides a smoke-test comparison, while OPA818 and ADA4817 add high-speed vendor macromodel cases. The combined summary is stored in `tia_extension/results/spice_comparison_summary_vendor_models.csv`, with associated magnitude, phase, and summary figures under `tia_extension/figures/`. The combined vendor summary provides the compact main-paper view (Figure 6; Table 3).

The first-pass noise stage adds relative noise context. The workflow uses configured noise-density assumptions and behavioural transfer functions to estimate output-noise contributions and compensation-related noise-bandwidth trends. The relevant outputs are `tia_extension/results/noise_baseline_summary.csv`, `tia_extension/results/noise_tradeoff_summary.csv`, `tia_extension/figures/tia_noise_contribution_baseline.png`, and `tia_extension/figures/tia_noise_bandwidth_tradeoff.png` (Figure 7; Figure 8).

## Behavioural TIA Model

The behavioural model represents the photodiode TIA as a feedback transimpedance stage with feedback resistance `Rf`, feedback capacitance `Cf`, photodiode capacitance `Cpd`, low-frequency op-amp gain `A0`, and op-amp transition frequency `ft_Hz`. The implementation in `tia_extension/functions/tia_response.m` computes the response, and `tia_extension/functions/extract_tia_metrics.m` extracts low-frequency gain, bandwidth, peaking, and phase-related metrics. Table 1 should list the baseline assumptions and swept variables used to produce the manuscript figures.

This model makes parameter dependence explicit enough for rapid sweep generation. It shows how selected `Cf`, `Cpd`, and `ft_Hz` assumptions influence bandwidth and peaking, and it identifies regions that deserve later vendor macromodel or circuit-level review. The baseline magnitude and phase plots introduce the finite-bandwidth effect before the broader sweeps (Figure 1).

The model remains a first-order pre-design approximation. It does not reproduce detailed vendor macromodel dynamics, transistor-level behaviour, layout-aware extraction, or measurement. Full-text TIA literature motivates the variables and trade-offs, but the project does not reproduce the circuit methods of Analui 2004, Lu 2007, Noh 2020, or regulated-cascode CMOS TIA papers [ANALUI_2004_BW_ENHANCEMENT], [LU_2007_BROADBAND_TIA], [NOH_2020_CF_TIA_DC_LOOP], [PARK_YOO_2004_RGC_TIA].

## Design-Region Mapping

The design-region workflow translates behavioural sweep metrics into project-defined categories. Safe, Marginal, and Risky are internal screening labels, not universal stability classifications and not hardware certification labels. They organize the current sweep results and help select cases for review. Table 2 should define the project-specific criteria and point readers to the committed classification helper and source CSVs.

The primary design-region map shows how selected photodiode capacitance and op-amp transition-frequency assumptions affect the best available feedback-capacitance choice under the project screening rules (Figure 4). The related safe-window fraction map remains an appendix or supplementary candidate if a target venue permits additional design-space figures. Together, these figures shift the discussion from isolated response curves to a broader view of the explored design space.

Representative Safe, Marginal, and Risky responses connect the label system back to actual frequency-response curves (Figure 5). Peaking is used as a practical screening metric in this workflow, but it is not by itself a complete phase-margin or stability proof. The map is therefore useful for prioritizing further analysis, not for certifying hardware behaviour.

## Vendor Macromodel Comparison

The vendor macromodel comparison stage adds model-specific simulation context. It compares selected behavioural trends with OP27, OPA818, and ADA4817 vendor macromodel export data. These comparisons are not hardware measurements and do not constitute experimental validation.

The OP27 smoke-test set contains three feedback-capacitance cases. In the repository evidence, the smallest-`Cf` OP27 case exhibits strong peaking, while larger-`Cf` cases reduce peaking and bandwidth. This result supports a qualitative compensation caution in a low-GBW macromodel case. OP27 is treated as a smoke-test comparison point rather than a preferred photodiode TIA recommendation.

The OPA818 set adds four high-speed vendor macromodel cases. In the selected data, the tested OPA818 cases fall within the project-defined Safe peaking category. The result provides selected macromodel evidence under the specified supply, capacitance, and export assumptions, not a proof that OPA818 is universally stable or optimal.

The ADA4817 set adds a third vendor macromodel comparison. In the selected data, the smallest-`Cf` ADA4817 case is borderline under the project-defined metric, while larger `Cf` cases are Safe. This contrast supports the broader observation that vendor macromodels can show different bandwidth and peaking boundaries under comparable project test structures.

The combined vendor summary table and figure present these cases as design-evidence comparisons rather than identical operating-point equivalence (Figure 6; Table 3). The vendor models and operating assumptions differ, so the comparison is useful for screening and discussion but does not represent complete SPICE coverage.

## First-Pass Noise Analysis

The first-pass noise workflow extends the bandwidth and peaking discussion by estimating relative noise contributions under configured assumptions. The model includes configured feedback resistor, op-amp voltage-noise, op-amp current-noise, and photodiode shot-noise terms. The baseline contribution figure summarizes the configured output-noise terms for the baseline behavioural case (Figure 7).

These outputs are first-pass behavioural estimates. They are not measured noise, detector-complete noise validation, or SPICE noise validation. Their purpose is to show how the same workflow can carry noise assumptions into the screening discussion when compensation choices change. The noise-bandwidth trade-off figure connects this estimate back to the compensation sweep (Figure 8).

The literature supports the relevance of discussing noise and bandwidth together. Noh 2020 supports capacitive-feedback and noise/stability context [NOH_2020_CF_TIA_DC_LOOP]. Lu 2007 and Abdollahi 2025 support broad-band and noise-aware TIA framing [LU_2007_BROADBAND_TIA], [ABDOLLAHI_2025_MDFRGC_TIA]. Li 2021 AIP remains abstract-only and supports only broad background that low-noise optical receiver TIA work is relevant [LI_2021_LOW_NOISE_OPTICAL_RX_TIA].

## Results and Discussion

The baseline behavioural response establishes the finite-gain, finite-bandwidth model and anchors the later sweeps. It is a reproducible response case rather than a complete design validation (Figure 1).

The feedback-capacitance sweep shows the central compensation trade-off. In the selected behavioural sweep, increasing `Cf` reduces extracted bandwidth and generally reduces peaking. The bandwidth and peaking figures are interpreted together because each captures only one side of the design trade-off (Figure 2; Figure 3). Compensation choices are therefore screened jointly for bandwidth and peaking rather than selected from bandwidth alone.

The design-region map extends the feedback-capacitance sweep across a broader parameter space. It shows how selected `Cpd` and `ft_Hz` assumptions affect project-defined Safe, Marginal, or Risky outcomes (Figure 4; Table 2). The representative response figure provides example response shapes for selected categories (Figure 5).

The vendor macromodel comparison adds model-specific realism. OP27 illustrates strong small-`Cf` peaking in a low-GBW smoke-test case. OPA818 provides selected high-speed macromodel cases that remain Safe under the project peaking metric. ADA4817 adds a borderline smallest-`Cf` case and Safe larger-`Cf` cases. The combined vendor summary supports the claim that behavioural screening and vendor macromodel behaviour are related but not interchangeable (Figure 6; Table 3).

The first-pass noise figures add a final design dimension. They show that configured noise assumptions can be propagated through the behavioural workflow to produce relative noise-contribution and noise-bandwidth views (Figure 7; Figure 8). This evidence supports including noise in the screening process while leaving measured-noise or SPICE-noise validation for future work.

Overall, the results support a coherent pre-design workflow: behavioural response, feedback-capacitance trade-off, design-region mapping, vendor macromodel comparison, and first-pass noise context. The repository provides a reproducible and traceable way to organize these steps.

## Limitations

The MATLAB behavioural model is simplified. It uses a finite-gain, finite-bandwidth abstraction and does not claim to capture detailed vendor pole-zero behaviour, output swing limits, nonlinearities, package parasitics, layout parasitics, or device-level noise behaviour.

The Safe/Marginal/Risky regions are project-defined screening categories. They are not universal engineering standards or certified stability labels. They organize the current sweep outputs and help select cases for later review.

The vendor macromodel comparison is simulation-only. OP27, OPA818, and ADA4817 macromodel cases are real vendor-model export comparisons, but they are not hardware measurements. They do not constitute complete SPICE coverage, process/temperature coverage, layout extraction, or experimental validation.

The noise analysis is first-pass behavioural estimation only. The current project does not include measured detector noise, measured output noise, or SPICE noise validation. The noise figures support relative discussion under stated assumptions, not final device claims.

The literature review remains in progress. Several useful DOI-only sources are available only at abstract or metadata level and are not used for detailed claims. Detailed Cherry-Hooper, 10/40 Gb/s CMOS receiver, and low-noise receiver comparisons remain future work until full text is available and read. Table 4 documents the current source-usage confidence boundary.

The package remains a manuscript-development prototype. It is not a final Q3 submission-ready manuscript. Final readiness requires close reading notes, final captions, a verified final bibliography, target-format editing, and supervisor or domain review.

## Conclusion

This v0.3 draft presents a MATLAB-and-SPICE-assisted workflow for photodiode TIA design-region mapping under finite op-amp bandwidth constraints. The workflow combines a simplified MATLAB behavioural model, feedback-capacitance sweeps, project-defined design-region maps, vendor macromodel comparison for OP27, OPA818, and ADA4817, and first-pass behavioural noise estimates. The evidence is traceable through committed scripts, CSV files, figures, and prepaper planning documents.

The defensible contribution is a reproducible early-stage screening workflow for photodiode TIA design exploration. The work organizes how feedback capacitance, photodiode capacitance, finite op-amp bandwidth, peaking, and first-pass noise assumptions interact under selected conditions. The literature context shows that bandwidth enhancement, regulated-cascode structures, inductorless CMOS TIAs, and noise-aware optical receiver front ends are established topics, so the project is positioned as a workflow contribution rather than a new circuit topology.

Future work includes deeper full-text reading, full reference formatting, target-journal figure and caption polish, additional vendor macromodel cases if needed, optional SPICE noise analysis, and independent review of modelling assumptions. Hardware measurement and measured-noise validation remain outside the current evidence package.

## Placeholder References

This section intentionally lists citation IDs only. It is not a final bibliography.

- [NOH_2020_CF_TIA_DC_LOOP]
- [LEE_2021_4GHZ_SDT_VG_TIA]
- [TAKAHASHI_2022_LOCAL_FEEDBACK_RGC]
- [ANALUI_2004_BW_ENHANCEMENT]
- [LU_2007_BROADBAND_TIA]
- [PARK_YOO_2004_RGC_TIA]
- [XU_2011_INDUCTORLESS_TIA]
- [PAN_LUO_2022_20GBPS_TIA]
- [PAN_2022_26GBPS_RX]
- [ABDOLLAHI_2025_MDFRGC_TIA]
- [MESGARI_2024_MULTI_DOT_PIN_RX]
- [VAZQUEZ_2021_OPTICAL_DETECTION_TIA] abstract-level only
- [LI_2021_LOW_NOISE_OPTICAL_RX_TIA] abstract-level only
- [HERMANS_2006_850NM_RX] metadata-only until full text is obtained
- [ZHOU_2021_CHERRY_HOOPER_AFE] metadata-only until full text is obtained
- [CHEN_2005_10GBPS_CMOS_RX_AFE] metadata-only until full text is obtained
- [PARK_2015_40GBPS_INVERTER_RX] metadata-only until full text is obtained
- [LI_2014_LOW_NOISE_CMOS_RX] metadata-only until full text is obtained
