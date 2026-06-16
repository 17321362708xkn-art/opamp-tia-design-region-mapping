# Limitations And No-Overclaim Notes

- No hardware measurement was performed.
- Only one real SPICE macromodel has been compared so far: OP27.
- OP27 is not necessarily optimized for photodiode TIA use; it is used here as the first available real LTspice smoke-test macromodel.
- The MATLAB op-amp model is a simplified single-pole finite-A0 / finite-GBW representation.
- The noise model is first-pass only and uses configured density assumptions rather than measured detector data.
- Safe, Marginal, and Risky thresholds are project-defined engineering criteria, not universal rules.
- Results should be framed as simulation-assisted design exploration, not universal TIA design laws.
- The current package should be described as **research prototype / Q3 pre-paper prototype, not yet fully Q3 submission-ready**.
- Additional real vendor SPICE macromodel comparisons remain required before submission.
