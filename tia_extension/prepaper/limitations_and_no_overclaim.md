# Limitations And No-Overclaim Notes

- No hardware measurement was performed.
- Two real SPICE macromodel comparison sets have been imported so far: OP27 and OPA818.
- OP27 is not necessarily optimized for photodiode TIA use; it is used here as the first available real LTspice smoke-test macromodel. OPA818 adds high-speed vendor macromodel evidence, but it remains simulation-only evidence.
- The MATLAB op-amp model is a simplified single-pole finite-A0 / finite-GBW representation.
- The noise model is first-pass only and uses configured density assumptions rather than measured detector data.
- Safe, Marginal, and Risky thresholds are project-defined engineering criteria, not universal rules.
- Results should be framed as simulation-assisted design exploration, not universal TIA design laws.
- The current package should be described as **research prototype / Q3 pre-paper prototype, not yet fully Q3 submission-ready**.
- At least one additional real vendor SPICE macromodel comparison remains required before a final submission-readiness claim.
