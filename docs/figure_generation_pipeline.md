# Figure Generation Pipeline

## Purpose

This document defines the publication-oriented figure pipeline for future active LPF and TIA extension work.

The pipeline is designed to keep figures reproducible, traceable, and suitable for portfolio or pre-paper review.

## Required Pipeline

The required figure path is:

```text
CSV source data -> MATLAB plotting script -> publication styling -> PDF/SVG/600 dpi PNG export -> figure_manifest.csv
```

## Step 1: CSV Source Data

Save source data to CSV before plotting.

The CSV should contain the plotted variables and enough metadata columns to identify the case.

Do not plot from hidden workspace-only variables when the figure is intended for reporting.

Do not alter raw data to make a trend look better.

## Step 2: MATLAB Plotting Script

Every figure must have a source MATLAB plotting script.

The script should record or load key parameters.

The script should generate the figure from saved source data or from a documented reproducible upstream script.

## Step 3: Publication Styling

Publication styling may include:

- readable font sizes
- consistent line widths
- consistent marker sizes
- axis labels with units
- concise legends
- clear captions
- colour choices that remain readable in print

Styling must not change the data.

Styling must not hide unfavourable or unexpected cases.

## Step 4: Export Formats

Export figures as:

- PDF
- SVG
- 600 dpi PNG

Use all three formats where practical.

If a format cannot be exported because of tool or platform limits, record the reason in the change log or figure manifest.

## Step 5: Figure Manifest

Every generated figure must have an entry in `figure_manifest.csv`.

Required manifest fields:

- figure file
- source script
- source data
- key parameters
- caption
- data type
- export formats
- generation date or run identifier

## Data Type Labels

Use clear data type labels such as:

- MATLAB behavioural model
- synthetic noisy behavioural response
- Monte Carlo behavioural result
- imported SPICE macromodel AC response
- MATLAB-vs-SPICE comparison

Do not label SPICE macromodel comparison as hardware measurement.

Do not label behavioural-only results as SPICE validated.

## Unexpected Trends

If a trend looks poor or unexpected, keep it visible.

Report the issue in the caption, notes, or change log.

Do not remove unfavourable cases unless there is a documented data-quality reason.
