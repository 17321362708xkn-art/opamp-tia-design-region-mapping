# Manuscript Draft v0.1

This document is a first manuscript draft for writing development. It is not a final submission, not a final bibliography, and not a claim of hardware validation, measured-noise validation, universal TIA design rules, or final Q3 submission readiness.

## Title

MATLAB-and-SPICE-Assisted Design-Region Mapping for Photodiode Transimpedance Amplifiers Under Finite Op-Amp Bandwidth Constraints

## Abstract

Photodiode transimpedance amplifier (TIA) design requires simultaneous attention to transimpedance gain, photodiode capacitance, feedback capacitance, finite op-amp bandwidth, frequency-response peaking, and noise. This draft presents a reproducible pre-design screening workflow that combines a MATLAB behavioural TIA model with project-defined design-region maps and selected vendor macromodel comparison cases. The MATLAB workflow sweeps feedback capacitance, photodiode capacitance, and op-amp transition frequency assumptions to extract bandwidth, peaking, and project-defined Safe/Marginal/Risky screening labels. The repository evidence also includes vendor macromodel comparison data for OP27, OPA818, and ADA4817 cases, plus first-pass behavioural noise estimates under stated assumptions. The contribution is not a new TIA topology; it is an organized simulation-assisted workflow for early design exploration and claim-bounded manuscript preparation. The current evidence is simulation and modelling evidence only. No hardware validation, measured-noise validation, or universal stability guarantee is claimed.

## Introduction

Photodiode TIAs are common front-end circuits for converting photocurrent into a voltage signal, but even a simple TIA design space can become coupled quickly. Feedback resistance sets the nominal low-frequency transimpedance, while photodiode capacitance and input capacitance interact with feedback capacitance and finite op-amp bandwidth to shape closed-loop response. A design that preserves bandwidth can show unacceptable peaking under some assumptions, while a more conservative compensation choice may reduce peaking at the cost of bandwidth. Published TIA work treats photodiode capacitance, bandwidth extension, regulated-cascode inputs, feedback structures, and noise as central design concerns [ANALUI_2004_BW_ENHANCEMENT], [LU_2007_BROADBAND_TIA], [PARK_YOO_2004_RGC_TIA], [NOH_2020_CF_TIA_DC_LOOP].

The purpose of this project is to build a reproducible pre-design workflow for exploring these trade-offs before committing to detailed device-level simulation or hardware work. The workflow does not replace circuit design, layout-aware SPICE analysis, or measurement. Instead, it provides a structured way to map selected assumptions and identify candidate regions that deserve further attention. The central output is a set of MATLAB-generated response curves, sweep summaries, design-region maps, vendor macromodel comparison figures, and first-pass noise estimates that can support a cautious pre-paper manuscript.

The project is framed around finite op-amp bandwidth because the single-pole behavioural approximation makes the relationship between `Rf`, `Cf`, `Cpd`, `A0`, and `ft_Hz` explicit enough for fast parameter sweeps. This simplification is intentionally limited. It cannot capture every pole, zero, package effect, output limit, nonlinear effect, or layout parasitic in a real device. That limitation is why the workflow includes selected vendor macromodel comparison cases for OP27, OPA818, and ADA4817. These cases are used as simulation-only checks of selected response trends, not as hardware evidence.

The manuscript contribution is therefore threefold. First, it organizes a MATLAB behavioural model and sweep workflow for photodiode TIA pre-design screening. Second, it visualizes selected parameter spaces through project-defined Safe/Marginal/Risky regions and feedback-capacitance trade-off figures. Third, it links behavioural trends to vendor macromodel comparison and first-pass noise estimates while preserving explicit validation boundaries. The intended manuscript claim is narrow: the workflow helps organize early-stage TIA design exploration and manuscript evidence; it does not prove a universal TIA design method.

## Related Work

High-speed TIA literature includes many topology-level contributions. Bandwidth-enhancement work has used passive matching, broadband networks, capacitive degeneration, regulated-cascode stages, and other circuit techniques to address capacitance and frequency-response limits [ANALUI_2004_BW_ENHANCEMENT], [LU_2007_BROADBAND_TIA]. Regulated-cascode TIA work is especially relevant because it addresses input impedance and photodiode-capacitance isolation in CMOS optical receiver settings [PARK_YOO_2004_RGC_TIA]. More recent and adjacent optical receiver papers continue to use regulated-cascode-derived, inductorless, inverter/cascode, and modified-RGC approaches for high-speed CMOS optical communication front ends [XU_2011_INDUCTORLESS_TIA], [LEE_2021_4GHZ_SDT_VG_TIA], [TAKAHASHI_2022_LOCAL_FEEDBACK_RGC], [PAN_LUO_2022_20GBPS_TIA], [ABDOLLAHI_2025_MDFRGC_TIA].

Feedback capacitance and stability-oriented frequency response also appear as recurring concerns in TIA design. The full-text Noh 2020 Sensors paper is useful in this draft because it treats capacitive-feedback TIA design, DC feedback, parasitic capacitance effects, frequency response, and stability-oriented parameters [NOH_2020_CF_TIA_DC_LOOP]. The DOI-only Vazquez 2021 source may support only broad abstract-level motivation that TIA optical detection design couples noise, frequency response, and stability, but detailed procedure or equation claims should wait for full text [VAZQUEZ_2021_OPTICAL_DETECTION_TIA].

CMOS optical receiver literature provides context for why TIA design should be treated as part of a larger receiver front-end. Full-text high-speed receiver papers include TIA, variable-gain, equalization, clock/data recovery, or integrated photodiode-readout context [PAN_2022_26GBPS_RX], [MESGARI_2024_MULTI_DOT_PIN_RX]. These sources help motivate the application area, but this project should not be presented as a complete optical receiver design. It models an op-amp-based photodiode TIA workflow and compares selected vendor macromodel cases.

Noise is another key part of the literature landscape. Full-text sources such as Noh 2020, Lu 2007, Lee 2021, Takahashi 2022, and Abdollahi 2025 support the general idea that noise, bandwidth, and topology decisions are coupled in TIA design [NOH_2020_CF_TIA_DC_LOOP], [LU_2007_BROADBAND_TIA], [LEE_2021_4GHZ_SDT_VG_TIA], [TAKAHASHI_2022_LOCAL_FEEDBACK_RGC], [ABDOLLAHI_2025_MDFRGC_TIA]. The DOI-only Li 2021 AIP source can be used only at abstract level for broad background on a low-noise optical receiver TIA using RGC and shunt-feedback ideas [LI_2021_LOW_NOISE_OPTICAL_RX_TIA]. It should not be used for detailed numeric or methods claims until the full text is available.

Several DOI-only or metadata-only papers remain valuable for future manual acquisition, especially for Cherry-Hooper optical receiver front ends, 10/40 Gb/s CMOS optical receiver analog front ends, and low-noise high-speed CMOS receiver context [HERMANS_2006_850NM_RX], [ZHOU_2021_CHERRY_HOOPER_AFE], [CHEN_2005_10GBPS_CMOS_RX_AFE], [PARK_2015_40GBPS_INVERTER_RX], [LI_2014_LOW_NOISE_CMOS_RX]. In this draft, those sources are not used for detailed claims. They are placeholders for future reading and related-work refinement.

The gap addressed by this project is not the absence of TIA topologies. The literature already contains many. The gap addressed here is a reproducible, claim-bounded pre-design mapping workflow that connects a simplified behavioural model, project-defined region labels, vendor macromodel comparison, and first-pass noise estimates in one traceable repository package.

## Methodology

The workflow starts with a simplified finite-gain, finite-bandwidth behavioural TIA model. The model is evaluated by MATLAB scripts that generate baseline response curves and sweep selected parameters. The baseline run defines a representative case and compares ideal and finite-gain responses using `tia_extension/scripts/run_01_tia_baseline.m`, with outputs recorded in `tia_extension/results/tia_baseline_response.csv` and `tia_extension/results/baseline_metrics.csv`.

The second stage sweeps feedback capacitance to expose the bandwidth and peaking trade-off. The script `tia_extension/scripts/run_03_sweep_Cf_for_peaking_bandwidth.m` generates `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv` and the figures `tia_extension/figures/tia_bandwidth_vs_Cf.png` and `tia_extension/figures/tia_peaking_vs_Cf.png`. These outputs support only the explored assumptions. The text should state that increasing `Cf` reduces bandwidth and generally lowers peaking in the selected behavioural sweep, not as a universal compensation law.

The third stage maps project-defined design regions. The script `tia_extension/scripts/run_05_design_region_map_tia.m` sweeps selected `Rf`, `Cpd`, `Cf`, and `ft_Hz` values and applies project-defined Safe/Marginal/Risky labels based on extracted behavioural metrics. The main outputs are `tia_extension/results/tia_design_region_map.csv`, `tia_extension/results/tia_sweep_summary.csv`, `tia_extension/figures/tia_design_region_map_Cpd_ft.png`, and `tia_extension/figures/tia_representative_region_responses.png`. A related safe-window fraction view is generated from `tia_extension/results/tia_safe_window_fraction_map.csv` and `tia_extension/figures/tia_safe_window_fraction_map_Cpd_ft.png`.

The fourth stage compares selected behavioural trends with vendor macromodel data. The OP27 case is a smoke-test comparison. OPA818 and ADA4817 provide additional real vendor macromodel export sets. The combined vendor summary is stored in `tia_extension/results/spice_comparison_summary_vendor_models.csv`, with figures including `spice_compare_OP27_Cf_sweep_magnitude.png`, `spice_opa818_cf_sweep_magnitude.png`, `spice_opa818_cf_sweep_phase.png`, `spice_ada4817_cf_sweep_magnitude.png`, `spice_ada4817_cf_sweep_phase.png`, and `spice_vendor_model_bandwidth_peaking_summary.png`. This stage should be described as vendor macromodel comparison rather than validation.

The final stage adds first-pass behavioural noise estimates. The noise workflow uses configured noise-density assumptions and transfer functions from the behavioural model to estimate relative output-noise contributions and a compensation-related noise-bandwidth trend. The relevant files are `tia_extension/noise_assumptions.md`, `tia_extension/functions/tia_noise_first_pass.m`, `tia_extension/functions/summarise_noise_contributions.m`, `tia_extension/results/noise_baseline_summary.csv`, `tia_extension/results/noise_tradeoff_summary.csv`, `tia_extension/figures/tia_noise_contribution_baseline.png`, and `tia_extension/figures/tia_noise_bandwidth_tradeoff.png`. These results are first-pass estimates only.

## MATLAB Behavioural TIA Model

The behavioural model represents the photodiode TIA as a feedback transimpedance stage with feedback resistance `Rf`, feedback capacitance `Cf`, photodiode capacitance `Cpd`, low-frequency op-amp gain `A0`, and op-amp transition frequency `ft_Hz`. The response is processed to extract low-frequency gain, bandwidth, peaking, and phase-related information. The repository implementation is contained in `tia_extension/functions/tia_response.m` and metric extraction is handled by `tia_extension/functions/extract_tia_metrics.m`.

The value of this model is that it makes parameter dependence explicit enough for fast sweep generation. It supports early questions such as: under these assumptions, how does increasing `Cf` change bandwidth? Where do selected `Cpd` and `ft_Hz` combinations produce stronger peaking? Which regions of the sweep should be treated as requiring more detailed vendor macromodel or circuit-level review?

The model should be described as a first-order pre-design approximation. It is not a replacement for detailed op-amp macromodels, transistor-level design, layout-aware extraction, or measurement. The full-text TIA literature helps motivate the variables and trade-offs, but the manuscript should not imply that the behavioural model reproduces the detailed methods of Analui 2004, Lu 2007, Noh 2020, or any regulated-cascode CMOS TIA paper [ANALUI_2004_BW_ENHANCEMENT], [LU_2007_BROADBAND_TIA], [NOH_2020_CF_TIA_DC_LOOP], [PARK_YOO_2004_RGC_TIA].

For manuscript figures, the baseline magnitude and phase plots should introduce the finite-bandwidth effect before presenting broader sweeps. The caption language should make clear that the curves are behavioural MATLAB outputs and that the finite-gain op-amp model is simplified.

## Design-Region Mapping Workflow

The design-region workflow translates behavioural sweep metrics into project-defined categories. The categories are named Safe, Marginal, and Risky, but these names are internal screening labels. They are not universal TIA stability classifications and do not certify hardware behaviour.

The primary design-region map shows how selected photodiode capacitance and op-amp transition frequency assumptions affect the best available feedback-capacitance choice under the project's screening rules. This map is supported by `tia_extension/figures/tia_design_region_map_Cpd_ft.png` and `tia_extension/results/tia_design_region_map.csv`. The related safe-window fraction map, `tia_extension/figures/tia_safe_window_fraction_map_Cpd_ft.png`, shows how much of the explored `Cf` range satisfies the screening criteria for each point.

The workflow also creates representative responses from selected Safe, Marginal, and Risky cases. These responses are useful because they connect the label system back to actual frequency-response curves. In the manuscript, this section should emphasize visualization and organization rather than proof. The design map can help prioritize later vendor macromodel or hardware work, but it cannot eliminate the need for those later stages.

This section should also define how peaking is used. Peaking is a practical screening metric in the current workflow, but it is not by itself a complete phase-margin or stability proof. If phase-margin language is used, it should be tied either to full-text source support or to future work.

## Vendor SPICE Macromodel Comparison

The vendor comparison stage checks selected behavioural trends against real vendor macromodel export data. The manuscript should use the term "vendor macromodel comparison" throughout this section. The data are not hardware measurements and should not be called experimental validation.

The OP27 smoke-test set provides three cases across feedback capacitance. In the current repository evidence, the smallest `Cf` OP27 case has strong peaking, while larger `Cf` cases reduce peaking and bandwidth. This supports the qualitative caution that compensation choices can strongly affect peaking in a low-GBW macromodel case. OP27 should be described as a smoke-test comparison point, not as an optimized photodiode TIA recommendation.

The OPA818 set adds a high-speed vendor macromodel sweep over four feedback-capacitance cases. In the selected repository data, the OPA818 cases are classified as Safe by the project-defined peaking metric over the tested `Cf` range. This should be framed as selected macromodel evidence under the specified supply, capacitance, and export assumptions, not as proof that OPA818 is universally stable or optimal.

The ADA4817 set adds a third vendor macromodel comparison. In the selected data, the smallest `Cf` case is borderline under the project-defined metric, while larger `Cf` cases are Safe. This gives the manuscript a useful contrast: different vendor macromodels show different bandwidth and peaking boundaries under comparable project test structures. The combined table `tia_extension/results/spice_comparison_summary_vendor_models.csv` and summary figure `tia_extension/figures/spice_vendor_model_bandwidth_peaking_summary.png` should be used to summarize this point.

This section should explicitly state that OP27, OPA818, and ADA4817 rows are design-evidence comparisons rather than identical operating-point equivalence. The models use different vendor macromodels and operating assumptions. The result is useful for screening and discussion, but it is not complete SPICE coverage.

## First-Pass Noise Analysis

The first-pass noise workflow extends the bandwidth and peaking discussion by adding relative noise context. It uses configured assumptions for feedback resistor noise, op-amp voltage noise, op-amp current noise, and photodiode shot-noise terms. The output files `tia_extension/results/noise_baseline_summary.csv` and `tia_extension/results/noise_tradeoff_summary.csv` support figures for baseline noise contribution and feedback-capacitance-related noise-bandwidth trade-off.

The manuscript should describe these outputs as first-pass behavioural estimates. They are not measured noise, not detector-complete noise validation, and not SPICE noise validation. The purpose is to show how the same workflow can track relative noise implications when changing compensation assumptions.

The literature supports the need to discuss noise and bandwidth together. Noh 2020 is useful for capacitive-feedback and noise/stability context [NOH_2020_CF_TIA_DC_LOOP]. Lu 2007 and Abdollahi 2025 are useful full-text sources for broad-band/noise-aware TIA framing [LU_2007_BROADBAND_TIA], [ABDOLLAHI_2025_MDFRGC_TIA]. The DOI-only Li 2021 AIP source can be used only at abstract level to support the general relevance of low-noise optical receiver TIA design [LI_2021_LOW_NOISE_OPTICAL_RX_TIA].

In the results discussion, the safest claim is that the noise workflow provides relative first-pass estimates under stated assumptions. Any future claim about device-validated or detector-measured noise should wait for SPICE noise simulation or physical measurement.

## Results and Discussion

The result sequence should begin with the baseline behavioural response. The baseline magnitude and phase figures establish the finite-gain, finite-bandwidth model and show how the simplified model is used to produce reproducible response data. The manuscript should avoid over-interpreting this baseline case. It is an anchor for later sweeps rather than proof of a complete design method.

The feedback-capacitance sweep should then show the key compensation trade-off. In the selected behavioural sweep, increasing `Cf` reduces extracted bandwidth and generally reduces peaking. The two figures `tia_bandwidth_vs_Cf.png` and `tia_peaking_vs_Cf.png` should be paired because each figure alone tells only half the story. This result supports a design-screening statement: compensation choices should be evaluated jointly for bandwidth and peaking rather than selected from bandwidth alone.

The design-region map extends the `Cf` sweep by organizing a larger parameter space. The map can be used to show where selected combinations of `Cpd` and `ft_Hz` are more likely to produce Safe, Marginal, or Risky project-defined outcomes. The safe-window fraction map can be used as an appendix or supplementary figure if the main paper needs a compact narrative.

The vendor macromodel comparison then adds model-specific realism. OP27 illustrates how a low-GBW smoke-test model can show strong small-`Cf` peaking. OPA818 and ADA4817 add high-speed vendor macromodel evidence, with the ADA4817 smallest-`Cf` case providing a useful borderline example. The combined summary figure and CSV should support the claim that macromodel behaviour is device-dependent and that behavioural maps should be treated as screening tools.

The first-pass noise figures add a final design dimension. They show that the workflow can carry configured noise assumptions through to relative output-noise estimates and a noise-bandwidth trade-off view. This discussion should be short and cautious in v0.1. It should support the idea that noise belongs in the screening conversation, while leaving detailed noise validation for future work.

Overall, the results support a coherent pre-design workflow: behavioural response, feedback-capacitance trade-off, design-region mapping, vendor macromodel comparison, and first-pass noise context. The strongest manuscript claim is that the repository provides a reproducible and traceable way to organize these steps.

## Limitations

This draft has several intentional limitations. First, the MATLAB behavioural model is simplified. It uses a finite-gain, finite-bandwidth abstraction and does not claim to capture detailed vendor pole/zero behaviour, output swing limits, nonlinearities, package parasitics, layout parasitics, or device-level noise behaviour.

Second, the Safe/Marginal/Risky regions are project-defined screening categories. They should not be described as universal engineering standards or certified stability labels. The labels organize the current sweep outputs and help select cases for later review.

Third, the vendor macromodel comparison is simulation-only. OP27, OPA818, and ADA4817 macromodel cases are real vendor-model export comparisons, but they are not hardware measurements. They do not constitute complete SPICE coverage, process/temperature coverage, layout extraction, or experimental validation.

Fourth, the noise analysis is first-pass behavioural estimation only. The current project does not include measured detector noise, measured output noise, or SPICE noise validation. The noise figures are useful for relative discussion under stated assumptions, not for final device claims.

Fifth, the literature review remains in progress. Several useful DOI-only sources are available only at abstract or metadata level and should not be used for detailed claims. Detailed Cherry-Hooper, 10/40 Gb/s CMOS receiver, and low-noise receiver comparisons should wait until full text is available and read.

Finally, this package is a manuscript-development prototype. It is not a final Q3 submission-ready manuscript. Final readiness still requires close reading notes, final captions, a verified final bibliography, target-format editing, and supervisor or domain review.

## Conclusion

This v0.1 draft presents a cautious manuscript structure for a MATLAB-and-SPICE-assisted photodiode TIA design-region mapping workflow. The project combines a simplified MATLAB behavioural model, feedback-capacitance sweeps, project-defined design-region maps, vendor macromodel comparison for OP27, OPA818, and ADA4817, and first-pass behavioural noise estimates. The evidence is reproducible through committed scripts, CSV files, figures, and prepaper planning documents.

The most defensible contribution is a traceable early-stage screening workflow for photodiode TIA design exploration. The work helps organize how feedback capacitance, photodiode capacitance, finite op-amp bandwidth, peaking, and first-pass noise assumptions interact under selected conditions. The literature context shows that bandwidth enhancement, regulated-cascode structures, inductorless CMOS TIAs, and noise-aware optical receiver front ends are established topics, so this project should be positioned as a workflow contribution rather than a new circuit topology.

Future work should include deeper full-text reading, full reference formatting, target-journal figure and caption polish, additional vendor macromodel cases if needed, optional SPICE noise analysis, and independent review of modelling assumptions. Hardware measurement and measured-noise validation remain outside the current evidence package.

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
