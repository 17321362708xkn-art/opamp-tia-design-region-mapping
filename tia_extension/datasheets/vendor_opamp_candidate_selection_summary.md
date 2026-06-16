# Vendor Op-Amp Candidate Selection Summary

## Purpose

This summary turns the Round 7 datasheet candidate table into a practical shortlist for future vendor SPICE macromodel work. It is a planning aid for choosing the first additional op-amp macromodels after the existing OP27 smoke-test reference.

The summary uses the datasheet screening data in `vendor_opamp_datasheet_sources.csv` and the generated tables:

- `vendor_opamp_candidate_table.csv`
- `vendor_opamp_candidate_table_si.csv`

It does not add SPICE simulation results, does not replace SPICE validation, and does not provide hardware evidence.

## Recommended First Additional SPICE Candidates

### 1. OPA818

OPA818 is the strongest first additional candidate because it is a modern high-speed FET-input voltage-feedback amplifier aimed at wideband transimpedance work. Its datasheet screening values combine low voltage noise, very low current noise, moderate input capacitance, and 2.7 GHz GBWP.

Usefulness for TIA comparison:

- Provides a direct modern contrast to the older OPA657 family.
- Good fit for moderate-to-high photodiode transimpedance gains where current noise matters.
- Official TI product information lists TINA-TI and PSpice model resources, making it practical for Round 8 macromodel comparison.

Risks and cautions:

- It is decompensated and specified as stable for gain >= 7 V/V.
- TIA loop stability must be checked with the actual feedback capacitance and photodiode capacitance.
- The datasheet table is only a screening input; real macromodel AC response still needs to be imported and compared.

### 2. LTC6268-10

LTC6268-10 is the second recommended candidate because it has extremely low input capacitance and fA-level current noise, which are both important for high-impedance photodiode TIA cases. Its 4 GHz GBWP makes it a valuable high-speed comparison to OPA818.

Usefulness for TIA comparison:

- Strong candidate for high-Rf and low-photodiode-capacitance cases.
- Very low C_IN helps reduce the capacitance term at the summing node.
- ADI product information indicates LTspice model availability for LTC6268-10.

Risks and cautions:

- It is gain-of-10 stable, so low-noise-gain operating points require careful compensation.
- Supply range is lower than the wider-supply TI FET candidates.
- Very small parasitic capacitances can dominate practical layouts, so the macromodel comparison should keep board and feedback-capacitance assumptions explicit.

### 3. ADA4817-1 Or OPA858

ADA4817-1 and OPA858 are the shared third priority. Choose between them based on macromodel availability, convergence, and how aggressive the Round 8 comparison should be.

ADA4817-1 is useful because it is unity-gain stable, FET-input, and explicitly positioned for photodiode preamps. It offers a less aggressive 1 GHz-class comparison that may be easier to simulate and interpret than the decompensated GHz-class parts.

OPA858 is useful because it offers 5.5 GHz GBWP and very low input capacitance, making it attractive for very wideband optical front-end exploration. TI product information lists PSpice and TINA-TI model resources.

Risks and cautions:

- ADA4817-1 has lower bandwidth than OPA818, OPA858, and LTC6268-10, but this can be useful as a stable mid-band comparison.
- OPA858 is decompensated and stable for gain >= 7 V/V.
- OPA858 current noise is graph-only or not scalar-tabulated in the current source table, so it should not be ranked quantitatively for high-Rf noise until that value is confirmed.

## Lower-Priority Or Comparison Candidates

OPA657 remains useful as an older high-speed FET-input comparison and as context for OPA818, which is listed as an upgrade path. It has higher voltage noise and higher input capacitance than OPA818.

OPA847 is a strong ultra-low-voltage-noise wideband bipolar candidate, but its pA-level current noise and gain >= 12 stability requirement make it less attractive for high-Rf photodiode TIA work. It is useful as a comparison case for low source impedance or lower transimpedance gains.

LMH6629 has excellent voltage noise and high bandwidth, but it is a bipolar-input part with pA-level current noise and relatively high input capacitance. These traits can be risky for high-Rf photodiode TIAs even when voltage noise is very low.

OP27 remains the existing smoke-test reference because it already has imported LTspice comparison data in the repository. It is not a preferred new high-speed photodiode TIA choice because its GBWP is much lower than the Round 7 high-speed candidates and the product page marks it not recommended for new designs.

## Noise-Risk Note For Bipolar Parts

Bipolar ultra-low-voltage-noise op-amps can look attractive from an `e_n` perspective, but high input current noise can dominate high-feedback-resistance photodiode TIA noise. For high-Rf detector front ends, FET-input parts with low current noise should generally be evaluated before bipolar low-voltage-noise parts, unless the target impedance and detector capacitance justify the trade.

## Boundary Statement

This datasheet selection summary supports future vendor SPICE macromodel selection; it does not itself provide additional SPICE validation.
