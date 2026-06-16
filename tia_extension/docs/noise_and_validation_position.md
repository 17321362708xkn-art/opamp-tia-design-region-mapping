# Noise And Validation Position

Round 5 introduces a first-pass MATLAB behavioural TIA noise estimate. It estimates major output-noise contributions from configured noise-density assumptions and the existing behavioural TIA transfer functions.

This noise estimate is separate from the Round 4.5 LTspice work. Round 4.5 imported real OP27 LTspice smoke-test AC data and compared one vendor op-amp macromodel against the MATLAB behavioural frequency response for selected feedback capacitance cases.

Current validation position:

- MATLAB behavioural noise estimate: first-pass calculation only.
- Experimental noise validation: not performed.
- Hardware measurement: not performed.
- Real SPICE data imported so far: OP27 LTspice AC smoke-test data.
- Vendor op-amp macromodels compared so far: one, OP27.
- Q3 SPICE requirement: still pending additional vendor macromodel comparisons.

Q3 readiness still requires more real SPICE macromodel comparisons later. The Round 5 noise figures must not be described as measured detector noise, experimental validation, full SPICE validation, or Q3 prototype evidence.
