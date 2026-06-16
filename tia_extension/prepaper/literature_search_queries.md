# Literature Search Query Plan

This file provides search routes only. It intentionally contains no paper titles, authors, DOI numbers, journal names, or fabricated references.

| Query group | Database/source | Goal | Expected useful result | Screening notes | Likely manuscript support |
|---|---|---|---|---|---|
| `photodiode transimpedance amplifier feedback capacitance stability` | Google Scholar, IEEE Xplore, ScienceDirect | Find core TIA compensation sources. | Papers or notes explaining `Cf`, bandwidth, and stability/peaking. | Prioritize sources with equations or measured/simulated response discussion. | Introduction, Related Work, Method |
| `photodiode TIA noise gain compensation` | Google Scholar, Analog Devices, Texas Instruments | Connect compensation to noise-gain reasoning. | Application notes or papers with noise-gain plots and phase margin discussion. | Prefer TIA-specific sources over generic op-amp tutorials. | Related Work, Method, Discussion |
| `transimpedance amplifier photodiode capacitance bandwidth op amp GBW` | IEEE Xplore, ScienceDirect, SpringerLink | Support finite-GBW and photodiode-capacitance sensitivity claims. | Papers describing how detector capacitance and op-amp bandwidth affect TIA response. | Check whether the source discusses assumptions and parameter ranges. | Introduction, Related Work, Method |
| `op amp finite gain bandwidth transimpedance amplifier peaking` | Google Scholar, IEEE Xplore | Support bandwidth and peaking extraction discussion. | Sources relating finite op-amp bandwidth to closed-loop peaking. | Avoid sources that only discuss voltage amplifiers with no TIA relevance unless theory is clearly transferable. | Method, Discussion, Limitations |
| `photodiode TIA noise analysis feedback resistor op amp voltage noise current noise` | Google Scholar, ScienceDirect, MDPI/open-access engineering journals | Support the first-pass noise model terms. | Papers or notes with feedback resistor noise, op-amp voltage/current noise, shot noise, and integrated noise. | Must separate calculated noise from measured noise. | Related Work, Noise section, Limitations |
| `high speed photodiode TIA design op amp application note` | Analog Devices, Texas Instruments, general web search | Collect reputable manufacturer design guidance. | Vendor application notes with practical photodiode TIA design advice. | Record source type as manufacturer note, not peer-reviewed paper. | Introduction, Related Work, Discussion |
| `FET input op amp photodiode transimpedance amplifier application note` | Analog Devices, Texas Instruments, general web search | Support op-amp selection discussion. | Notes explaining FET-input op-amps, low bias current, capacitance, voltage noise, and current noise. | Prioritize notes with parameter-selection rules and circuit examples. | Related Work, Op-amp selection, Limitations |
| `transimpedance amplifier design automation MATLAB SPICE` | Google Scholar, IEEE Xplore, SpringerLink | Position this repository as design-space mapping and reproducible workflow. | Papers using parameter sweeps, MATLAB, SPICE, or automated design exploration for analog circuits. | Accept adjacent analog-design workflow papers if the relevance is explicit. | Related Work, Method, Discussion |
| `vendor SPICE macromodel limitations op amp` | Google Scholar, manufacturer websites, general web search | Support conservative SPICE-validation boundaries. | Sources explaining macromodel scope, limitations, and simulation versus hardware distinction. | Avoid unsupported forum posts unless only used as search leads, not cited. | Limitations, Discussion |
| `photodiode transimpedance amplifier phase margin capacitance compensation` | IEEE Xplore, Google Scholar, ScienceDirect | Relate peaking/stability proxy to standard phase-margin reasoning. | Papers or notes linking capacitance compensation and phase margin. | Use only if source gives enough technical detail. | Related Work, Method, Limitations |

## Search Process

1. Run broad Google Scholar queries first to identify recurring terms and highly cited sources.
2. Repeat targeted searches in IEEE Xplore, ScienceDirect, SpringerLink, and open-access engineering journals.
3. Search Analog Devices and Texas Instruments application notes separately because useful vendor notes may not rank highly in academic databases.
4. Record candidates in `tia_extension/prepaper/citation_tracking_table_template.csv` or a copied working table.
5. Only move a source into the manuscript outline after completing a reading note.

## Screening Reminder

Do not add a citation to the manuscript only because a search result looks relevant. Verify the source, record its URL or DOI if real, and write a reading note first.
