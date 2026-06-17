# Abstract-Only Sources Policy

This policy covers DOI-only or publisher-landing-page-only candidates in the local literature index. These sources are not fully read and must not be used for detailed methods, equations, measured values, table comparisons, or conclusions unless full text is later obtained and read.

## General Rule

- Abstract-visible sources may support high-level motivation if the statement is explicitly visible in the official abstract or DOI metadata.
- Metadata-only sources may support only existence, title-level topic placement, venue, year, and "worth obtaining" status.
- No abstract-only or metadata-only source should be included in a final detailed comparison table.
- No DOI-only source should be marked as read.

## Source-Specific Policy

| Citation ID | Current access | Safe to cite now | Not safe without full text | Full text worth obtaining later? |
|---|---|---|---|---|
| VAZQUEZ_2021_OPTICAL_DETECTION_TIA | abstract_visible_no_full_text | At abstract level: optical detection systems based on TIAs involve coupled noise, frequency response, and stability constraints; feedback-network component search and phase margin are mentioned in the official abstract metadata. | Do not cite the procedure, equations, merit function details, component-selection algorithm, or numeric examples without full text. | Yes, high priority for compensation/stability framing. |
| LI_2021_LOW_NOISE_OPTICAL_RX_TIA | abstract_visible_no_full_text | At abstract level: the paper concerns a low-noise optical receiver TIA using RGC and shunt-feedback ideas; noise optimization, photodetector capacitance, gain, and bandwidth are visible at abstract level. | Do not cite measured values, detailed circuit sizing, matching network details, or conclusions without full text. | Yes, high priority for shunt-feedback/RGC optical receiver and noise context. |
| HERMANS_2006_850NM_RX | publisher_landing_page_only | Metadata only: title, authors, venue, year, DOI, and topic as an 850-nm CMOS optical receiver front-end. | Do not claim modified Cherry-Hooper details, measured performance, photodetector implementation, or TIA architecture until full text is obtained. | Yes, high priority for CMOS optical receiver and Cherry-Hooper context. |
| ZHOU_2021_CHERRY_HOOPER_AFE | publisher_landing_page_only | Metadata only: title, authors, venue, year, DOI, and topic as a 25 Gbps inductorless optical receiver AFE based on modified Cherry-Hooper amplifier. | Do not claim topology details, shunt-feedback details, measured bandwidth, power, or BER without full text. | Yes, high priority for Cherry-Hooper and inductorless AFE positioning. |
| CHEN_2005_10GBPS_CMOS_RX_AFE | publisher_landing_page_only | Metadata only: title, authors, venue, year, DOI, and topic as a 10-Gb/s fully integrated CMOS optical receiver analog front-end. | Do not cite architecture, sensitivity, gain, bandwidth, transformers, or measurement details without full text. | Yes, high priority as classic high-speed CMOS optical receiver AFE literature. |
| PARK_2015_40GBPS_INVERTER_RX | publisher_landing_page_only | Metadata only: title, authors, venue, year, DOI, and topic as a 40-Gb/s inverter-based CMOS optical receiver front-end. | Do not cite energy efficiency, bandwidth, noise, topology details, or measured results without full text. | Yes, useful for 40-Gb/s high-speed CMOS optical receiver context. |
| LI_2014_LOW_NOISE_CMOS_RX | publisher_landing_page_only | Metadata only: title, authors, venue, year, DOI, and topic as low-noise high-speed CMOS optical receivers. | Do not cite topology comparison, noise-reduction claims, receiver implementation, or measured performance without full text. | Yes, high priority for noise-bandwidth trade-off framing. |

## Allowed Manuscript Language

- "Several DOI-identified candidates remain high-priority for manual full-text acquisition, especially for Cherry-Hooper, 10/40 Gb/s CMOS optical receiver, and low-noise receiver context."
- "Two DOI-only sources expose abstracts that support high-level motivation around TIA noise, bandwidth, frequency response, and stability, but detailed claims are deferred until full text is available."

## Forbidden Manuscript Language

- "Hermans 2006 demonstrates..." unless the specific statement has been verified from full text.
- "Zhou 2021 achieves..." unless full text has been obtained and read.
- "Li 2014 proves..." without full text.
- Any table of numeric literature performance using DOI-only sources.

## Next Manual Download Priority

1. LI_2014_LOW_NOISE_CMOS_RX
2. HERMANS_2006_850NM_RX
3. CHEN_2005_10GBPS_CMOS_RX_AFE
4. ZHOU_2021_CHERRY_HOOPER_AFE
5. LI_2021_LOW_NOISE_OPTICAL_RX_TIA
6. VAZQUEZ_2021_OPTICAL_DETECTION_TIA
7. PARK_2015_40GBPS_INVERTER_RX
