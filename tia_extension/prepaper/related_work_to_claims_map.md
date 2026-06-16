# Related Work To Claims Map

This map links the existing claims matrix to external literature needs. It does not contain citations and should be filled only after sources are verified.

## Finite Op-Amp Bandwidth Affects TIA Bandwidth And Peaking

- Literature support needed: TIA feedback theory, finite GBW, loop gain, phase margin, noise-gain discussion.
- Repository evidence already available: behavioural sweeps, baseline response, design-region maps.
- External citation type needed: textbook chapter, peer-reviewed TIA paper, or manufacturer application note with equations.
- Risk if no citation is found: the method may look ad hoc even if repository evidence is reproducible.
- Suggested query groups: `transimpedance amplifier photodiode capacitance bandwidth op amp GBW`; `op amp finite gain bandwidth transimpedance amplifier peaking`.

## Feedback Capacitance Trades Bandwidth For Improved Peaking/Stability Proxy

- Literature support needed: compensation-capacitor design, noise-gain shaping, and phase-margin/peaking relationship.
- Repository evidence already available: `tia_bandwidth_vs_Cf.png`, `tia_peaking_vs_Cf.png`, and `tia_sweep_Cf_peaking_bandwidth.csv`.
- External citation type needed: photodiode TIA design note or paper with feedback capacitance equations.
- Risk if no citation is found: the `Cf` storyline may appear unsupported beyond local sweeps.
- Suggested query groups: `photodiode transimpedance amplifier feedback capacitance stability`; `photodiode TIA noise gain compensation`.

## Photodiode Capacitance Affects TIA Bandwidth And Noise/Stability Design

- Literature support needed: detector capacitance effect on bandwidth, stability, and noise gain.
- Repository evidence already available: design-region mapping over `Cpd` and `ft_Hz`.
- External citation type needed: photodiode TIA fundamentals source or application note.
- Risk if no citation is found: Introduction may under-motivate the design-region map.
- Suggested query groups: `transimpedance amplifier photodiode capacitance bandwidth op amp GBW`; `photodiode transimpedance amplifier phase margin capacitance compensation`.

## Noise Analysis Requires Feedback Resistor And Op-Amp Noise Terms

- Literature support needed: feedback resistor Johnson noise, op-amp input voltage noise, op-amp input current noise, photodiode shot noise, and integrated output noise.
- Repository evidence already available: first-pass behavioural noise scripts, summaries, and figures.
- External citation type needed: TIA noise analysis paper or vendor application note.
- Risk if no citation is found: the noise model may appear arbitrary.
- Suggested query groups: `photodiode TIA noise analysis feedback resistor op amp voltage noise current noise`.

## Vendor SPICE Macromodels Are Useful But Not Hardware Validation

- Literature support needed: SPICE macromodel scope, limitations, and simulation-versus-measurement boundary.
- Repository evidence already available: OP27, OPA818, and ADA4817 processed macromodel comparisons plus validation-status docs.
- External citation type needed: vendor model documentation, application note, or modelling-limitations discussion.
- Risk if no citation is found: reviewers may question why simulation evidence is framed conservatively.
- Suggested query groups: `vendor SPICE macromodel limitations op amp`; manufacturer model documentation searches.

## Design-Space Mapping Is Useful For Early-Stage Screening

- Literature support needed: parameter sweeps, design-space visualization, reproducible modelling workflow, or analog design automation context.
- Repository evidence already available: design-region maps, safe-window fraction map, results storyline, manuscript skeleton.
- External citation type needed: analog design-space exploration paper, modelling workflow paper, or MATLAB/SPICE-assisted design source.
- Risk if no citation is found: the workflow contribution may appear as internal tooling rather than manuscript-worthy method organization.
- Suggested query groups: `transimpedance amplifier design automation MATLAB SPICE`; broader analog design-space exploration queries.
