# Related Work Section Outline

This is an outline only. Do not write the final related-work section until real sources have been collected, screened, and read.

## 1. Photodiode TIA Design And Compensation

Purpose: Establish the standard photodiode TIA problem and the role of `Rf`, `Cpd`, and `Cf`.

Required citation types:
- Photodiode TIA fundamentals.
- Feedback capacitance compensation.
- Bandwidth/stability trade-off source.

Repository results that connect:
- Baseline response figures.
- Bandwidth and peaking versus `Cf`.

Possible paragraph logic:
- Start from transimpedance gain and detector capacitance.
- Introduce feedback capacitance as compensation.
- Connect compensation to bandwidth and peaking.

What not to claim:
- Do not claim the repository derives a new TIA topology.

## 2. Finite Op-Amp Bandwidth And Noise-Gain Constraints

Purpose: Explain why finite op-amp bandwidth matters in TIA design.

Required citation types:
- Finite GBW / loop-gain theory.
- Noise-gain and phase-margin discussion.
- TIA-specific peaking or stability discussion.

Repository results that connect:
- Design-region map over `Cpd` and `ft_Hz`.
- Safe-window fraction map.

Possible paragraph logic:
- Explain finite bandwidth and loop-gain limitations.
- Relate noise gain to TIA stability and peaking.
- Position the repository metrics as screening proxies.

What not to claim:
- Do not claim peaking fully proves phase margin or hardware stability.

## 3. Noise Mechanisms In Photodiode TIA Design

Purpose: Justify the first-pass noise terms used in the repository.

Required citation types:
- Feedback resistor Johnson noise.
- Op-amp voltage and current noise.
- Photodiode shot noise.
- Integrated output-noise calculations.

Repository results that connect:
- Noise contribution baseline.
- Noise-bandwidth trade-off figure.

Possible paragraph logic:
- List standard TIA noise sources.
- Explain why bandwidth and compensation affect integrated noise.
- State that the repository implements first-pass behavioural estimates.

What not to claim:
- Do not claim measured noise validation or detector-complete noise modelling.

## 4. Simulation-Assisted Op-Amp Selection And Vendor Macromodels

Purpose: Position datasheet screening and vendor macromodel comparison.

Required citation types:
- Op-amp selection guidance for photodiode TIAs.
- FET-input/high-speed op-amp application notes.
- SPICE macromodel limitation sources.

Repository results that connect:
- Vendor op-amp candidate table.
- OP27, OPA818, and ADA4817 summaries.
- Three-vendor bandwidth/peaking summary figure.

Possible paragraph logic:
- Explain datasheet screening variables.
- Describe vendor macromodels as design evidence.
- State why macromodels do not replace hardware tests.

What not to claim:
- Do not claim a final best op-amp or hardware-validated comparison.

## 5. Design-Space Exploration And Reproducible Workflow Positioning

Purpose: Support the workflow contribution.

Required citation types:
- Parameter sweep or design-space mapping methods.
- MATLAB/SPICE-assisted design exploration.
- Reproducible modelling workflow sources.

Repository results that connect:
- Design-region maps.
- Figure/table plan.
- Claims-vs-evidence matrix.

Possible paragraph logic:
- Present design-space mapping as an early-stage decision tool.
- Explain why reproducibility matters for pre-paper review.
- Connect scripts and CSV source data to transparent claims.

What not to claim:
- Do not claim fully automated design synthesis.

## 6. Gap Addressed By This Project

Purpose: Define the manuscript opening created by the repository.

Required citation types:
- Sources from the previous subsections that leave room for an integrated workflow contribution.

Repository results that connect:
- Manuscript skeleton.
- Results storyline.
- Combined vendor summary.
- Claims matrix.

Possible paragraph logic:
- Existing sources cover theory, device guidance, or simulation practices separately.
- This repository organizes those threads into a reproducible design-region screening package.
- The package remains bounded as a Q3 pre-paper prototype.

What not to claim:
- Do not claim final submission readiness or complete validation.
