# Manuscript Positioning Options v0.1

This note compares defensible framings for the current manuscript package after the Overleaf v0.2 layout cleanup. It is a manuscript-scope planning note only. It does not create a final bibliography, does not claim target-journal readiness, and does not expand the technical evidence base.

Current evidence boundary:

- Repository evidence supports behavioural MATLAB modelling, project-defined design-region mapping, selected vendor macromodel comparison, and first-pass behavioural noise estimates.
- The current evidence does not include hardware validation, measured-noise validation, full SPICE noise analysis, layout extraction, process/temperature coverage, or a new TIA topology.
- Citation metadata is partly verified, but final bibliography work remains open. Abstract-only and metadata-only sources are not usable for detailed numerical or methods-level claims.

## Summary Recommendation

The most defensible positioning is Option 1: engineering design workflow paper. Option 3 is a close secondary framing if the paper title and abstract emphasize photodiode TIA pre-design rather than broad publication-grade circuit performance. Option 2 is viable only if the analytical modelling and related-work comparison are strengthened. Option 4 is safest for immediate sharing but has lower formal publication value.

## Option 1. Engineering Design Workflow Paper

Main claim: a reproducible MATLAB/SPICE-assisted early-stage photodiode TIA screening workflow organizes bandwidth, peaking, design-region, vendor macromodel, and first-pass noise evidence under stated assumptions.

Best title style:

- "A MATLAB- and Vendor-Macromodel-Assisted Workflow for Early-Stage Photodiode TIA Design Screening"
- "Design-Region Mapping for Photodiode TIAs Using Behavioural MATLAB Sweeps and Vendor Macromodel Comparisons"

Suitable abstract angle:

- Start from the practical difficulty of early TIA compensation choices.
- Present the workflow as a traceable screening process rather than as a circuit innovation.
- Emphasize repository-generated figures, project-defined screening categories, and bounded simulation evidence.

Key contribution statement:

- The contribution is a reproducible workflow that links behavioural TIA response extraction, feedback-capacitance sweeps, project-defined design-region labels, selected vendor macromodel comparisons, and first-pass behavioural noise estimates.

Evidence already available:

- Overleaf v0.2 draft with Figure 1 through Figure 8 and Tables 1 through 4.
- MATLAB behavioural response and sweep outputs already in repository figures and CSVs.
- Vendor macromodel comparison summary for OP27, OPA818, and ADA4817.
- Project-defined Safe/Marginal/Risky criteria and traceability notes.
- Citation metadata table with 11 active draft BibTeX entries and 7 manual-check exclusions.

Missing evidence:

- Final bibliography and target-template formatting.
- Stronger close-reading integration of full-text sources.
- Optional additional vendor macromodel cases if reviewers expect broader device coverage.
- Optional SPICE noise analysis if noise remains a main contribution rather than a first-pass extension.

Overclaim risk:

- Medium if the workflow is described as validation or as a universal design rule.
- Low if the manuscript consistently uses "project-defined", "under stated assumptions", "vendor macromodel comparison", and "first-pass behavioural noise estimate".

Distance from current manuscript:

- Close. The existing v0.4 manuscript and Overleaf v0.2 draft already use this shape.

Recommendation:

- High. This framing best matches the repository evidence and avoids forcing circuit-topology novelty or measurement claims.

## Option 2. Electronics Modelling Application Paper

Main claim: behavioural modelling and design-region mapping reveal how finite op-amp bandwidth, feedback capacitance, and photodiode capacitance shape TIA screening outcomes.

Best title style:

- "Behavioural Design-Region Mapping of Photodiode TIAs Under Finite Op-Amp Bandwidth Constraints"
- "Finite-Bandwidth Behavioural Modelling for Early Photodiode TIA Design-Region Exploration"

Suitable abstract angle:

- Lead with the finite-bandwidth model and the mapping procedure.
- Treat vendor macromodel comparison and first-pass noise estimates as secondary checks on model usefulness.
- Avoid implying that the behavioural model is a complete circuit simulator.

Key contribution statement:

- The contribution is a modelling application that uses a simplified finite-bandwidth op-amp TIA model to generate project-defined screening maps and compare selected trends with vendor macromodel exports.

Evidence already available:

- Baseline magnitude/phase response.
- Feedback-capacitance bandwidth and peaking sweeps.
- Design-region map and representative responses.
- Project-defined classification logic.
- Traceability from figures to scripts and CSVs.

Missing evidence:

- More explicit derivation of the behavioural transfer function and assumptions.
- More direct comparison to analytical TIA compensation formulas or prior modelling approaches.
- Sensitivity analysis or error discussion versus vendor macromodel data.
- Stronger explanation of why the chosen grid, thresholds, and op-amp assumptions are sufficient for the modelling claim.

Overclaim risk:

- Medium to high if the map is framed as generally predictive beyond the explored assumptions.
- Medium if Figure 4 appears mostly Safe/green and is presented as a strong performance-discrimination result rather than a selected-best screening map.

Distance from current manuscript:

- Medium. The current manuscript has the model and figures, but it would need more mathematical exposition and model-limit discussion.

Recommendation:

- Medium. Viable, but it requires more analytical writing than the current draft contains.

## Option 3. Photodiode TIA Pre-Design Methodology Paper

Main claim: a practical pre-design workflow helps evaluate feedback capacitance, photodiode capacitance, op-amp transition frequency, first-pass noise, and selected vendor macromodel behaviour before detailed circuit design.

Best title style:

- "A Practical Pre-Design Methodology for Photodiode TIA Compensation and Screening"
- "Photodiode TIA Pre-Design Screening with Behavioural Sweeps, Design-Region Maps, and Vendor Macromodel Comparisons"

Suitable abstract angle:

- Emphasize photodiode TIA design decisions: compensation, bandwidth, peaking, and noise.
- Position the workflow as a bridge between hand analysis and detailed vendor/circuit simulation.
- State clearly that the method is not a hardware-validated design rule.

Key contribution statement:

- The contribution is a practical pre-design methodology that links compensation sweeps, project-defined screening criteria, vendor macromodel comparison, and first-pass noise estimates for photodiode TIA exploration.

Evidence already available:

- Strong photodiode TIA framing in v0.4 and Overleaf v0.2.
- Full set of current main figures for response, compensation, region maps, vendor summary, and noise.
- Vendor macromodel rows for three op-amp families under stated assumptions.
- Literature context from full-text TIA and optical receiver sources.

Missing evidence:

- More vendor macromodel coverage if targeting venues that expect broad device validation.
- SPICE noise analysis or measured-noise data if noise becomes a central performance claim.
- More detailed discussion of photodiode current/noise assumptions and detector context.
- Potential refinement of Figure 4 and Figure 5 for readability and persuasive design-space coverage.

Overclaim risk:

- Medium. The word "methodology" can sound broad unless all claims remain tied to project-defined screening and stated assumptions.

Distance from current manuscript:

- Close to medium. The manuscript is already near this framing, but serious journal use may require extra macromodel/noise support.

Recommendation:

- High as a secondary framing. It is especially suitable if the manuscript keeps a practical engineering tone and avoids universal claims.

## Option 4. Technical Note / Preprint / Portfolio-Style Paper

Main claim: the repository demonstrates a reproducible educational or research-prototype workflow for photodiode TIA modelling and screening.

Best title style:

- "A Reproducible MATLAB Workflow for Photodiode TIA Design-Region Exploration"
- "Technical Note: Behavioural TIA Screening Maps and Vendor Macromodel Comparisons"

Suitable abstract angle:

- Lead with reproducibility, traceability, and educational value.
- Present figures and tables as a documented workflow package.
- Keep limitations prominent.

Key contribution statement:

- The contribution is a transparent research prototype showing how behavioural modelling, repository data, vendor macromodel comparison, and source-scope discipline can be organized into a manuscript-ready evidence package.

Evidence already available:

- Strong repository traceability.
- Clean Overleaf v0.2 draft and portable ZIP export.
- Evidence maps, audit notes, citation metadata verification, and table/figure plans.

Missing evidence:

- Less missing evidence than journal routes, because this route can tolerate the current prototype boundary.
- Still needs final spelling, figure polish, and reference cleanup before public distribution.

Overclaim risk:

- Low if the note is explicitly labelled as a technical note or preprint prototype.
- Publication-value risk is higher than technical overclaim risk.

Distance from current manuscript:

- Very close. The current draft could be adapted quickly.

Recommendation:

- Medium. Safest and quickest, but less valuable if the goal is a formal manuscript submission.

## Preferred Path

Preferred immediate path:

1. Use Option 1 as the main manuscript positioning.
2. Borrow title and abstract language from Option 3 to keep the photodiode TIA application visible.
3. Avoid Option 2 as the primary framing until a stronger analytical derivation and model-comparison section are added.
4. Keep Option 4 as the fallback if the priority becomes rapid public sharing rather than formal review.

Recommended one-sentence positioning:

"This manuscript presents a reproducible early-stage photodiode TIA screening workflow that combines behavioural MATLAB sweeps, project-defined design-region mapping, selected vendor macromodel comparisons, and first-pass behavioural noise estimates under clearly stated modelling assumptions."
