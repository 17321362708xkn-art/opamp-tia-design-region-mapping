# Contribution And Claims

## Conservative Contribution Statement

This work provides a reproducible MATLAB behavioural workflow for exploring photodiode TIA bandwidth, peaking, design-region classification, OP27 and OPA818 LTspice macromodel comparison evidence, and first-pass behavioural noise trade-offs. The current package is a research prototype and requires at least one additional vendor SPICE macromodel comparison before journal submission.

## Stronger But Still Defensible Contribution Statement

This work demonstrates a pre-paper workflow for simulation-assisted photodiode TIA design exploration: finite-gain MATLAB modelling, design-region mapping, OP27 LTspice smoke-test comparison, OPA818 vendor macromodel import, and first-pass noise-bandwidth trade-off figures, all tied to reproducible scripts, CSV source data, and a figure manifest.

## Claims Allowed

- The MATLAB behavioural TIA workflow is reproducible from scripts in `tia_extension/scripts/`.
- The design-region maps use project-defined Safe, Marginal, and Risky criteria.
- Increasing feedback capacitance in the existing sweeps reduces peaking and bandwidth.
- The Round 4.5 comparison uses real LTspice OP27 macromodel AC smoke-test data.
- The Round 8B import uses real LTspice OPA818 AC data generated from the official TI OPA818 PSpice macromodel.
- Vendor macromodel comparison evidence currently covers OP27 and OPA818; at least one more vendor model is still recommended before submission.
- Round 5 noise results are first-pass MATLAB behavioural estimates based on stated assumptions.
- Current status is **research prototype / Q3 pre-paper prototype, not yet fully Q3 submission-ready**.

## Claims Not Allowed

- Do not claim hardware measurement.
- Do not claim experimental noise evidence.
- Do not claim full SPICE coverage.
- Do not claim detector-level experimental results.
- Do not claim universal photodiode TIA design laws.
- Do not claim final journal submission readiness before at least one additional vendor SPICE macromodel comparison and final review are added.
- Do not imply OP27 is an optimized or preferred photodiode TIA choice from the current evidence alone.

## Safe/Marginal/Risky Classification Wording

Use: "Safe, Marginal, and Risky are project-defined engineering categories based on extracted behavioural metrics such as peaking and bandwidth trends. They are used to organize this study's sweep results and are not universal TIA design thresholds."

Avoid wording that implies the categories are formal industry standards or guaranteed hardware outcomes.

## MATLAB/SPICE Agreement And Mismatch Wording

Use: "The OP27 LTspice smoke-test comparison and OPA818 vendor macromodel import check whether selected MATLAB behavioural trends are directionally consistent with real macromodel data. Agreement and mismatch should be interpreted as limited macromodel comparison evidence, not broad SPICE coverage or hardware validation."

Use when discussing mismatch: "Observed differences are expected because the MATLAB model uses a simplified single-pole op-amp representation, while the LTspice OP27 macromodel includes more detailed frequency-response behaviour."

## Noise Model Limitations Wording

Use: "The noise analysis is a first-pass behavioural estimate using configured noise-density assumptions and transfer functions from the MATLAB TIA model. It is intended to compare relative noise-bandwidth trends, not to replace device-level noise simulation or measured detector noise."

Avoid wording that presents the noise results as measured, experimentally confirmed, or device-complete.
