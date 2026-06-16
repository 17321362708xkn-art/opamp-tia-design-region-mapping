# Related-Work Taxonomy

This taxonomy defines what to search for before writing the final related-work section. It does not contain a bibliography and does not claim that any external paper has been read.

## A. Photodiode TIA Fundamentals

Why it matters: The manuscript needs a clear foundation for transimpedance gain, photodiode capacitance, feedback resistance, feedback capacitance compensation, and the bandwidth/stability trade-off.

Sources to search for:
- Textbook or tutorial-level photodiode TIA design explanations with equations.
- Peer-reviewed photodiode TIA design papers with explicit circuit assumptions.
- Manufacturer application notes from reputable op-amp vendors.

Questions the literature should answer:
- How do `Rf`, `Cpd`, and `Cf` shape closed-loop transimpedance response?
- What compensation methods are commonly used for photodiode TIAs?
- How are bandwidth and peaking/stability commonly discussed in TIA design?

Repository connections:
- `tia_extension/figures/tia_baseline_magnitude.png`
- `tia_extension/figures/tia_baseline_phase.png`
- `tia_extension/figures/tia_bandwidth_vs_Cf.png`
- `tia_extension/figures/tia_peaking_vs_Cf.png`
- `tia_extension/prepaper/manuscript_skeleton.md`

Do not overclaim:
- Do not present the repository model as a complete photodiode TIA design method.
- Do not treat project-defined labels as universal stability criteria.

## B. Op-Amp Finite Bandwidth and Noise-Gain Theory

Why it matters: The project centers on finite op-amp bandwidth constraints and uses bandwidth/peaking as screening metrics.

Sources to search for:
- Papers, books, and application notes covering finite GBW, unity-gain bandwidth, loop gain, noise gain, phase margin, closed-loop bandwidth, and gain peaking.
- TIA-specific noise-gain compensation explanations.

Questions the literature should answer:
- How does finite GBW limit closed-loop TIA bandwidth?
- How is noise gain used to reason about TIA stability?
- How do peaking and phase margin relate as practical design indicators?

Repository connections:
- `tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv`
- `tia_extension/figures/tia_peaking_vs_Cf.png`
- `tia_extension/figures/tia_design_region_map_Cpd_ft.png`
- `tia_extension/prepaper/claims_vs_evidence_matrix.md`

Do not overclaim:
- Do not call gain peaking alone a complete stability proof.
- Do not imply the single-pole behavioural op-amp model captures all vendor macromodel dynamics.

## C. TIA Noise Analysis

Why it matters: The current package includes first-pass behavioural noise estimates, so the paper needs sources that justify the included noise terms and define their limits.

Sources to search for:
- Photodiode TIA noise analysis papers.
- Op-amp application notes on feedback resistor Johnson noise, op-amp input voltage noise, op-amp input current noise, photodiode shot noise, and integrated output noise.
- Sources explaining noise-bandwidth trade-offs.

Questions the literature should answer:
- Which noise terms are standard in first-pass photodiode TIA analysis?
- How are these terms transferred to output noise?
- How should integrated noise be interpreted relative to bandwidth?

Repository connections:
- `tia_extension/figures/tia_noise_contribution_baseline.png`
- `tia_extension/figures/tia_noise_bandwidth_tradeoff.png`
- `tia_extension/results/noise_baseline_summary.csv`
- `tia_extension/results/noise_tradeoff_summary.csv`

Do not overclaim:
- Do not claim measured noise validation.
- Do not present first-pass behavioural noise as detector-complete or device-validated.

## D. SPICE Macromodel Validation and Limitations

Why it matters: The project uses real vendor SPICE macromodel data for OP27, OPA818, and ADA4817, while explicitly avoiding hardware-validation claims.

Sources to search for:
- Vendor notes or technical articles explaining op-amp SPICE macromodel scope and limitations.
- Papers discussing behavioural model versus SPICE macromodel comparison.
- Sources distinguishing simulation evidence from hardware validation.

Questions the literature should answer:
- What can vendor op-amp macromodels reasonably support?
- What behaviours may be missing from macromodels?
- How should SPICE results be framed relative to hardware validation?

Repository connections:
- `tia_extension/spice_interface/spice_validation_status.md`
- `tia_extension/results/spice_comparison_summary_vendor_models.csv`
- `tia_extension/figures/spice_vendor_model_bandwidth_peaking_summary.png`
- `tia_extension/prepaper/limitations_and_no_overclaim.md`

Do not overclaim:
- Do not call vendor macromodel evidence experimental validation.
- Do not claim complete SPICE coverage.

## E. Op-Amp Selection for Photodiode/TIA Applications

Why it matters: The project includes datasheet-driven candidate screening and selected vendor macromodel comparisons.

Sources to search for:
- FET-input and high-speed op-amp selection guides.
- Photodiode preamplifier application notes.
- Datasheets and application notes discussing input capacitance, input bias current, voltage noise, current noise, and GBW.

Questions the literature should answer:
- Which op-amp parameters matter most for photodiode TIA design?
- Why are FET-input, low-bias, low-capacitance, high-speed op-amps often considered?
- How should datasheet screening be used without turning it into a final selection rule?

Repository connections:
- `tia_extension/datasheets/vendor_opamp_candidate_table.csv`
- `tia_extension/datasheets/vendor_opamp_candidate_table_si.csv`
- `tia_extension/datasheets/vendor_opamp_candidate_selection_summary.md`
- `tia_extension/results/spice_comparison_summary_vendor_models.csv`

Do not overclaim:
- Do not claim the datasheet table proves a best op-amp.
- Do not claim OP27, OPA818, or ADA4817 is universally preferred.

## F. Design Automation / Design-Space Mapping

Why it matters: The manuscript contribution is a reproducible workflow for design-space exploration, not a new circuit topology.

Sources to search for:
- Design-space exploration and parameter-sweep methods in analog design.
- MATLAB/SPICE-assisted modelling workflows.
- Reproducible modelling or simulation workflow papers.

Questions the literature should answer:
- How do parameter sweeps support early-stage design decisions?
- How can design-region visualization help organize trade-offs?
- What is an appropriate claim boundary for automated screening?

Repository connections:
- `tia_extension/figures/tia_design_region_map_Cpd_ft.png`
- `tia_extension/figures/tia_safe_window_fraction_map_Cpd_ft.png`
- `tia_extension/prepaper/results_storyline.md`
- `tia_extension/prepaper/figure_table_plan.md`

Do not overclaim:
- Do not present the workflow as automatic circuit synthesis.
- Do not imply screening labels guarantee hardware outcomes.
