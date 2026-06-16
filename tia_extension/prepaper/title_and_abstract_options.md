# Title And Abstract Options

## Title Options

1. Simulation-Assisted Design-Region Mapping for Photodiode Transimpedance Amplifier Trade-offs
2. MATLAB Behavioural Mapping of Bandwidth, Peaking, and Noise Trade-offs in Photodiode TIAs
3. A Reproducible Behavioural Workflow for Photodiode TIA Design-Region Exploration
4. From Behavioural TIA Mapping to Three-Vendor LTspice Macromodel Evidence: A Pre-Paper Study
5. Feedback-Capacitance and Op-Amp Bandwidth Trade-offs in Photodiode TIA Behavioural Design

## Abstract Outline 1

- Problem: photodiode TIA design requires balancing capacitance, feedback compensation, op-amp bandwidth, stability, and noise.
- Method: MATLAB behavioural finite-A0 / finite-GBW TIA model, sweep workflow, and project-defined design-region mapping.
- Evidence: baseline response figures, `Cf` bandwidth and peaking sweeps, design-region maps, OP27 LTspice smoke-test comparison, and OPA818/ADA4817 vendor macromodel Cf sweeps.
- Noise: first-pass behavioural noise contribution and noise-bandwidth trade-off estimates.
- Limitation: no hardware measurement, no experimental noise evidence, and final manuscript polish/review still required.

## Abstract Outline 2

- Introduce a reproducible simulation-assisted workflow for selecting photodiode TIA design regions.
- Describe extracted metrics and Safe/Marginal/Risky project-defined classification.
- Summarize real OP27 LTspice smoke-test comparison and OPA818/ADA4817 vendor macromodel Cf sweeps as limited SPICE macromodel evidence.
- Add first-pass noise estimates to connect bandwidth and integrated output-noise trade-offs.
- Close with honest status: research prototype / Q3 pre-paper prototype, not a final submission package.

## Conservative Abstract Draft

Photodiode transimpedance amplifier (TIA) design involves coupled trade-offs among feedback resistance, feedback capacitance, photodiode capacitance, op-amp gain-bandwidth, frequency-response peaking, and output noise. This work presents a reproducible MATLAB behavioural workflow for first-pass design-region mapping of photodiode TIAs using a finite-DC-gain and finite-unity-gain-frequency op-amp model. The workflow generates baseline transimpedance responses, sweeps feedback capacitance to extract bandwidth and peaking trends, and maps project-defined Safe, Marginal, and Risky regions across selected photodiode capacitance and op-amp bandwidth assumptions. Limited LTspice macromodel evidence is included using OP27, OPA818, and ADA4817 comparison sets, with OPA818 and ADA4817 adding real vendor macromodel Cf sweeps across four feedback-capacitance cases each; these comparisons are treated as simulation evidence rather than hardware validation. The workflow also adds first-pass behavioural noise estimates for feedback resistor thermal noise, op-amp input voltage noise, op-amp input current noise, and optional photodiode shot noise, enabling reproducible noise-bandwidth trade-off figures. All figures are tied to scripts and CSV source data to support transparent review. The current package forms a research prototype / Q3 pre-paper prototype, not yet fully Q3 submission-ready. Final manuscript polish, related-work positioning, figure/caption review, and supervisor or domain review remain required, and no hardware measurement or experimental noise evidence is claimed.
