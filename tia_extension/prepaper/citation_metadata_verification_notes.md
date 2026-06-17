# Citation Metadata Verification Notes

This note records how `citation_metadata_verification_table_v0_1.md` was prepared. The table is a verification aid for future bibliography construction, not a final bibliography.

## Inputs Used

- `tia_extension/prepaper/manuscript_draft_v0_4_audit_fixed.md`
- `tia_extension/prepaper/first_reading_notes_summary.md`
- `tia_extension/prepaper/abstract_only_sources_policy.md`
- `tia_extension/prepaper/writing_evidence_map.md`
- `tia_extension/prepaper/manuscript_table_drafts_v0_1.md`
- Local, untracked `tia_extension/literature_local/00_index/literature_library_index.csv`
- DOI registration metadata resolved through DOI content negotiation for the 18 DOI URLs already present in the local index

## Citation IDs Checked

The v0.4 manuscript contains 18 unique placeholder citation IDs:

- `ABDOLLAHI_2025_MDFRGC_TIA`
- `ANALUI_2004_BW_ENHANCEMENT`
- `CHEN_2005_10GBPS_CMOS_RX_AFE`
- `HERMANS_2006_850NM_RX`
- `LEE_2021_4GHZ_SDT_VG_TIA`
- `LI_2014_LOW_NOISE_CMOS_RX`
- `LI_2021_LOW_NOISE_OPTICAL_RX_TIA`
- `LU_2007_BROADBAND_TIA`
- `MESGARI_2024_MULTI_DOT_PIN_RX`
- `NOH_2020_CF_TIA_DC_LOOP`
- `PAN_2022_26GBPS_RX`
- `PAN_LUO_2022_20GBPS_TIA`
- `PARK_2015_40GBPS_INVERTER_RX`
- `PARK_YOO_2004_RGC_TIA`
- `TAKAHASHI_2022_LOCAL_FEEDBACK_RGC`
- `VAZQUEZ_2021_OPTICAL_DETECTION_TIA`
- `XU_2011_INDUCTORLESS_TIA`
- `ZHOU_2021_CHERRY_HOOPER_AFE`

All 18 IDs were found in the local literature index. DOI metadata resolved for all 18 DOI URLs.

## Classification Rules Applied

- `full_text_available`: the local index reports full text available for reading through a legal open, author-posted, or user-provided full-text source.
- `abstract_only`: the local index reports official abstract/DOI metadata visible but no full text.
- `metadata_only`: the local index reports DOI/publisher landing page metadata only and no official abstract/full text available to the local workflow.
- `final_bibliography_ready = yes`: metadata fields are complete, DOI metadata resolved, and full text is available for reading. This does not mean the source has been fully read and does not create a final bibliography entry.
- `final_bibliography_ready = needs_manual_check`: full text is missing or access is abstract-only/metadata-only. These rows require manual check before final bibliography use.

## Missing Or Incomplete Metadata

- No placeholder citation ID used in v0.4 is missing from the local index.
- No DOI URL failed to resolve through DOI registration metadata in this round.
- No row has an empty author, title, year, or venue field in the verification table.
- The seven abstract-only or metadata-only rows still need manual checks before final bibliography use because source access, not basic DOI metadata, is the limiting factor.

## Sources To Hold Out Of Detailed Claims

The following rows should be removed from the final bibliography or kept as appendix/future-review items unless they are needed for a broad-background citation and their official metadata is checked again during final formatting:

- `HERMANS_2006_850NM_RX`
- `ZHOU_2021_CHERRY_HOOPER_AFE`
- `CHEN_2005_10GBPS_CMOS_RX_AFE`
- `PARK_2015_40GBPS_INVERTER_RX`
- `LI_2014_LOW_NOISE_CMOS_RX`

The following abstract-only rows may support broad background only:

- `VAZQUEZ_2021_OPTICAL_DETECTION_TIA`
- `LI_2021_LOW_NOISE_OPTICAL_RX_TIA`

## What Was Not Changed

- No final bibliography was created.
- Placeholder citations in the manuscript were not converted to formatted references.
- No manuscript text was modified.
- No result CSVs were modified.
- No MATLAB functions were modified.
- No simulations were run.
- No PDFs were added or modified.
- No `tia_extension/literature_local/` files were added to git.
- No source was marked fully read.

## Remaining Steps Before Final Bibliography

- Recheck all `needs_manual_check` rows against official publisher pages or full text.
- Decide whether abstract-only sources remain in the final manuscript or are replaced by full-text alternatives.
- Remove metadata-only future-review placeholders from the final bibliography unless they remain explicitly cited as metadata-level context.
- Apply target-journal reference style only after metadata and citation-scope review are complete.
- Do a final source-access audit before replacing placeholder IDs with formatted references.
