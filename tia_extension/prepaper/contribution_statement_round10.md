# Contribution Statement Drafts

## Short Version

This work contributes a reproducible MATLAB-and-SPICE-assisted workflow for early photodiode TIA design-region screening under finite op-amp bandwidth constraints. The workflow combines behavioural TIA modelling, feedback-capacitance bandwidth and peaking sweeps, project-defined Safe/Marginal/Risky design maps, three real vendor SPICE macromodel comparison sets for OP27, OPA818, and ADA4817, and first-pass behavioural noise trade-off analysis. The contribution is not a new circuit topology and does not claim hardware or measured-noise validation. Instead, it provides an organized pre-paper evidence package for transparent early-stage TIA design exploration.

## Medium Version

This work contributes a reproducible pre-design workflow for photodiode transimpedance amplifier exploration using MATLAB behavioural modelling and real vendor SPICE macromodel comparison evidence. The MATLAB workflow models finite op-amp DC gain and unity-gain bandwidth, sweeps feedback capacitance and other TIA parameters, extracts bandwidth and peaking metrics, and organizes the explored space into project-defined Safe, Marginal, and Risky screening regions. The SPICE evidence extends beyond a single example by including real LTspice macromodel comparison sets for OP27, OPA818, and ADA4817, supported by processed CSV data, summary tables, and generated figures. A first-pass behavioural noise workflow adds context for bandwidth and integrated output-noise trade-offs under stated assumptions. The intended contribution is a transparent, script-backed method for early design screening and manuscript preparation. It is not presented as a new TIA topology, a universal stability rule, a hardware-validated design, or measured-noise validation. Full Q3 submission readiness still depends on related-work positioning, manuscript drafting, figure and caption polish, and supervisor or domain review.

## Bullet-Point Version

- Reproducible MATLAB-and-SPICE-assisted workflow for photodiode TIA pre-design screening.
- Behavioural finite-`A0` / finite-GBW TIA model with script-generated response metrics.
- Feedback-capacitance sweeps showing bandwidth and peaking trade-offs.
- Project-defined design-region maps over `Rf`, `Cpd`, `Cf`, and op-amp `ft_Hz`.
- Real vendor SPICE macromodel comparison sets for OP27, OPA818, and ADA4817.
- Combined vendor summary table for bandwidth and peaking trends across the three models.
- First-pass behavioural noise trade-off analysis under stated assumptions.
- Conservative validation boundaries: no hardware validation, no measured-noise validation, and no full Q3 submission-readiness claim.
