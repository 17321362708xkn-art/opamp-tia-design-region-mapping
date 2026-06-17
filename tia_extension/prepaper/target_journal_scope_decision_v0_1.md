# Target Journal And Scope Decision v0.1

This note proposes journal-family categories for the current manuscript package. It does not claim current journal ranking, quartile, acceptance likelihood, or final submission readiness. Any specific target journal must be checked separately against current author guidelines, scope, article type, figure limits, reference style, and expectations for validation evidence.

Current draft assessed:

- Source manuscript: `tia_extension/prepaper/manuscript_draft_v0_4_audit_fixed.md`
- LaTeX draft: `tia_extension/overleaf_draft_v0_2/`
- Local exports checked: v0.1 and v0.2 ZIP packages were present in `exports/`; no compiled PDF was found locally during this round.

## Summary Recommendation

Recommended primary journal-family category: engineering design workflow or modelling journals.

Recommended secondary category: electronics/circuits application journals, only if the manuscript remains explicit that it is a workflow and modelling paper rather than a new circuit topology or hardware-validated design.

The sensors/instrumentation route is plausible but riskier because reviewers may expect experimental detector or measurement evidence. The student/preprint/technical-report route is the safest route for rapid dissemination but offers less formal publication value.

## Category 1. Electronics/Circuits Application Journals

Fit level:

- Medium.

Likely reviewer expectations:

- Clear circuit-design motivation and comparison with relevant TIA literature.
- Strong distinction between behavioural modelling, vendor macromodel comparison, and hardware evidence.
- More analytical explanation of the model and thresholds.
- Possibly more SPICE cases or topology-specific discussion.

Evidence gap:

- No hardware validation.
- No measured noise.
- No layout-aware or process/temperature coverage.
- Vendor macromodel comparison is limited to selected OP27, OPA818, and ADA4817 cases under repository assumptions.
- Related-work section still needs final close-reading integration and final bibliography.

Whether hardware validation is likely expected:

- Often helpful and sometimes expected, especially if the paper sounds like a circuit-performance contribution.
- Less likely to be mandatory if submitted as modelling, design education, or workflow-oriented application work.

Whether SPICE-only validation may be acceptable:

- Possibly acceptable for a modelling/workflow article if the claim is bounded.
- Not enough for claims about final circuit performance, silicon readiness, measurement agreement, or universal stability.

Whether current manuscript should be shortened or expanded:

- Expand modelling assumptions and related-work comparison.
- Shorten source-scope material in the main text by keeping Table 4 in the appendix.
- Consider combining Figures 2 and 3 into a two-panel compensation figure later if page limits matter.

Recommended next action:

- Keep the title and abstract workflow-oriented.
- Add a concise model-equation subsection and a sharper comparison to prior TIA design methods before selecting a specific electronics/circuits venue.

## Category 2. Sensors/Instrumentation Journals

Fit level:

- Medium to low for the current evidence package.

Likely reviewer expectations:

- Clear detector or measurement-chain relevance.
- Practical sensor/instrumentation context, often with experimental or application-facing validation.
- Noise analysis that connects to detector behaviour, measurement bandwidth, or system sensitivity.

Evidence gap:

- No physical detector experiment.
- No measured detector noise or output noise.
- Photodiode assumptions are model parameters rather than a validated sensor readout case.
- First-pass noise is behavioural and not measured or SPICE noise analysis.

Whether hardware validation is likely expected:

- More likely than in a pure modelling/workflow category.

Whether SPICE-only validation may be acceptable:

- Possibly acceptable for a modelling note or design-method article, but reviewers may ask for experimental confirmation or a stronger instrumentation case.

Whether current manuscript should be shortened or expanded:

- Expand detector context and noise assumptions if pursuing this route.
- Shorten generic source-scope discussion.
- Keep limitations prominent.

Recommended next action:

- Do not choose this as the first formal target unless a stronger photodiode/detector use case, SPICE noise analysis, or measured evidence is added.

## Category 3. Engineering Design Workflow Or Modelling Journals

Fit level:

- High.

Likely reviewer expectations:

- Reproducible workflow description.
- Clear model assumptions, input/output artifacts, and traceability.
- Evidence that the workflow organizes design choices better than isolated plots.
- Careful limitation language and source-scope discipline.

Evidence gap:

- Final bibliography not complete.
- Model derivation is still light.
- Figure 4 and Figure 5 need polish to make the design-space story clearer.
- Optional sensitivity analysis could improve the case.

Whether hardware validation is likely expected:

- Less likely if the manuscript is framed as a modelling and workflow paper.
- Still valuable, but not necessarily required for the core claim.

Whether SPICE-only validation may be acceptable:

- More likely to be acceptable if described as vendor macromodel comparison under stated assumptions.
- Should not be called validation unless the target venue explicitly accepts that wording in a simulation-only context.

Whether current manuscript should be shortened or expanded:

- Expand the workflow diagram or method steps if page limits allow.
- Keep Table 4 in the appendix.
- Keep Table 3 in the main text.
- Consider moving Figure 7 to appendix if the main text becomes crowded.

Recommended next action:

- Use this category as the primary target-family direction.
- Prepare a concise "workflow contribution" abstract and add a short model-assumption/evidence-traceability paragraph.

## Category 4. Student / Preprint / Technical-Report Route

Fit level:

- High for rapid sharing.

Likely reviewer expectations:

- Clear scope and reproducibility.
- Honest limitations.
- Less demand for hardware evidence if the document is explicitly labelled as a technical note or prototype.

Evidence gap:

- Final references and figure polish are still needed for public readability.
- Source-scope table should remain appendix-only or supplementary.
- The paper should still avoid any language implying final publication readiness.

Whether hardware validation is likely expected:

- Not necessarily, as long as the scope says modelling/prototype.

Whether SPICE-only validation may be acceptable:

- Yes, if framed as vendor macromodel comparison and not hardware validation.

Whether current manuscript should be shortened or expanded:

- Shorten and simplify.
- Keep the core workflow figures and appendix source-scope documentation.

Recommended next action:

- Keep as fallback for sharing a polished technical note if formal journal targeting stalls or requires evidence beyond the current project.

## Decision

Recommended scope for the next serious draft:

- Primary: engineering design workflow paper.
- Application language: photodiode TIA pre-design methodology.
- Avoid primary positioning as a new electronics circuit paper.
- Avoid sensors/instrumentation submission until the detector/noise evidence is strengthened.
- Keep technical note/preprint as fallback.

Recommended abstract opening:

"Early photodiode transimpedance-amplifier design requires coordinated screening of compensation, bandwidth, peaking, and noise assumptions before detailed circuit implementation. This work presents a reproducible MATLAB- and vendor-macromodel-assisted workflow for early-stage TIA design screening under finite op-amp bandwidth constraints."

Recommended claim boundary:

"The method organizes project-defined screening evidence under stated assumptions; it does not introduce a new TIA topology, provide hardware validation, establish measured-noise agreement, or define a universal TIA design rule."
