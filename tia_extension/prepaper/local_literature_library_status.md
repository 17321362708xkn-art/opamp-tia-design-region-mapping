# Local Literature Library Status

Round 12 creates a local-only literature cache for TIA and CMOS optical receiver reading candidates. The local cache is intentionally ignored by Git and is not part of the committed repository.

## Local Folder Structure

```text
tia_extension/literature_local/
  00_index/
  01_core_tia_compensation/
  02_cmos_optical_receiver_tia/
  03_inductorless_cmos_tia/
  04_regulated_cascode_tia_manual_check/
  05_cherry_hooper_tia_manual_check/
  06_noise_and_photodetector_tia/
  07_wideband_sensor_readout_tia/
  08_integrated_photonic_detector_readout/
  09_vendor_app_notes/
  99_unclassified_manual_review/
```

## Local Index

The local index is:

```text
tia_extension/literature_local/00_index/literature_library_index.csv
```

This index is local-only and ignored by Git. It tracks candidate IDs, user-provided title/author/year fields, arXiv IDs or manual search targets, folder placement, recommended filenames, download status, access status, and manual notes.

## Current Counts

- Open PDFs downloaded locally: **10**
- Manual database verification targets: **10**
- Metadata-only candidate entries requiring manual review: **1**
- Manual-download-required rows in the local index: **11** total, consisting of 10 manual search targets plus the withdrawn/no-PDF arXiv candidate.

## Local Download Notes

- The successful downloads came from legal arXiv PDF endpoints.
- `TIA_CF_NOH_2020` was not downloaded because the arXiv landing page indicates the current submission is withdrawn and no PDF is available from arXiv.
- No alternate source was used for the withdrawn/no-PDF candidate.
- No source is marked as fully read.
- Metadata still needs manual verification before citation use.

## Repository Boundary

- `tia_extension/literature_local/` is ignored and must remain local.
- `*.pdf` is ignored and must not be committed.
- No literature PDF files from this workflow are committed.
- No full-text papers are committed.
- No final bibliography has been created.
- No fabricated DOI, journal, publication status, or citation metadata has been added.

## Next Manual Step

Use the local index and `tia_extension/prepaper/cmos_optical_receiver_tia_candidate_addendum.md` to decide which PDFs and manual search targets should be read first. Only after reading and verifying sources should a working citation table or bibliography draft be created.
