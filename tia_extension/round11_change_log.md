# Round 11 Change Log

- Branch: `tia-extension-v1.1-related-work-collection-plan`
- Purpose: create a structured related-work collection and reading plan for the photodiode TIA pre-paper.

## Files Created

- `tia_extension/prepaper/related_work_taxonomy.md`
- `tia_extension/prepaper/literature_search_queries.md`
- `tia_extension/prepaper/paper_screening_criteria.md`
- `tia_extension/prepaper/paper_reading_note_template.md`
- `tia_extension/prepaper/citation_tracking_table_template.csv`
- `tia_extension/prepaper/related_work_to_claims_map.md`
- `tia_extension/prepaper/related_work_section_outline.md`
- `tia_extension/scripts/run_14_check_literature_placeholders_round11.m`

## Files Updated

- `tia_extension/prepaper/manuscript_skeleton.md`
- `tia_extension/prepaper/next_submission_tasks.md`
- `tia_extension/README.md`

## Validation Boundary

- No fabricated citations added.
- No fake paper titles, authors, DOI numbers, journal names, or citation metadata added.
- No new simulation data generated.
- No vendor model files committed.
- No raw LTspice export files committed.
- No core behavioural model functions modified.
- No active LPF validated functions modified.
- No hardware validation claim added.
- No measured-noise validation claim added.
- No experimental-validation claim added.
- No full Q3 submission-readiness claim added.

## Guard Script

Round 11 adds `tia_extension/scripts/run_14_check_literature_placeholders_round11.m`. The script checks that the citation tracking table contains placeholder rows only, flags DOI-like strings in the new planning docs, and flags suspicious author-year placeholder patterns unless they are explicitly marked as placeholders.

## Current Next Step

Collect 15-25 candidate sources, prioritize 8-12 core sources, fill a working copy of the citation tracking table with verified metadata, complete reading notes for the core sources, and then draft the Introduction and Related Work sections.
