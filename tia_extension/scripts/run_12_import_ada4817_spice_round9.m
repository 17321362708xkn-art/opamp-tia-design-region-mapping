%RUN_12_IMPORT_ADA4817_SPICE_ROUND9 Import real ADA4817 LTspice exports.
%
% Round 9 imports manually exported LTspice AC text data generated from
% the official ADI ADA4817 SPICE macromodel. It does not commit vendor model
% files, raw LTspice exports, or screenshots, and it does not claim hardware
% or experimental validation.

scriptDir = fileparts(mfilename('fullpath'));
tiaRoot = fileparts(scriptDir);
repoRoot = fileparts(tiaRoot);
spiceDir = fullfile(tiaRoot, 'spice_interface');
spiceDataDir = fullfile(spiceDir, 'imported_ac_data');
processedDir = fullfile(spiceDataDir, 'round9_ada4817');
rawRoot = fullfile(spiceDir, 'round9_manual_exports', 'ADA4817');
resultsDir = fullfile(tiaRoot, 'results');
figuresDir = fullfile(tiaRoot, 'figures');

addpath(spiceDir);

ensureDir(processedDir);
ensureDir(resultsDir);
ensureDir(figuresDir);

runId = char(datetime('now', 'TimeZone', 'UTC', ...
    'Format', 'yyyyMMdd_HHmmss''Z'''));

expected = table( ...
    ["ADA4817_Rf10k_Cpd10p_Cf0p5"; ...
     "ADA4817_Rf10k_Cpd10p_Cf1p0"; ...
     "ADA4817_Rf10k_Cpd10p_Cf2p2"; ...
     "ADA4817_Rf10k_Cpd10p_Cf4p7"], ...
    ["ADA4817_Rf10k_Cpd10p_Cf0p5_raw.txt"; ...
     "ADA4817_Rf10k_Cpd10p_Cf1p0_raw.txt"; ...
     "ADA4817_Rf10k_Cpd10p_Cf2p2_raw.txt"; ...
     "ADA4817_Rf10k_Cpd10p_Cf4p7_raw.txt"], ...
    'VariableNames', {'case_id', 'raw_filename'});

expected.Cf_F = zeros(height(expected), 1);
expected.legend_label = strings(height(expected), 1);
for iExpected = 1:height(expected)
    [expected.Cf_F(iExpected), expected.legend_label(iExpected)] = ...
        parseCfFromRawFilename(expected.raw_filename(iExpected));
end

checkNoCf4p4Screenshots(rawRoot);

Rf_ohm = 1e4;
Cpd_F = 1e-11;
supplyPositive_V = 5;
supplyNegative_V = -5;

rawRecords = table();
processedTables = cell(height(expected), 1);
processedRelPaths = strings(height(expected), 1);
summary = table();

for iCase = 1:height(expected)
    rawPath = findUniqueRawFile(rawRoot, expected.raw_filename(iCase));
    rawRelPath = makeRepoRelative(rawPath, repoRoot);

    spice = import_spice_ac_data(rawPath);
    processed = makeProcessedTable( ...
        expected.case_id(iCase), expected.raw_filename(iCase), rawRelPath, ...
        spice, Rf_ohm, Cpd_F, expected.Cf_F(iCase));

    processedFilename = expected.case_id(iCase) + "_processed.csv";
    processedPath = fullfile(processedDir, char(processedFilename));
    writetable(processed, processedPath);

    metrics = calculateSummaryMetrics( ...
        processed.frequency_Hz, processed.transimpedance_dBOhm);
    visualLabel = classifyPeaking(metrics.peaking_dB);

    summary = [summary; table( ... %#ok<AGROW>
        expected.case_id(iCase), "ADA4817", Rf_ohm, Cpd_F, ...
        expected.Cf_F(iCase), supplyPositive_V, supplyNegative_V, ...
        metrics.low_frequency_transimpedance_dBOhm, ...
        metrics.peak_transimpedance_dBOhm, metrics.peaking_dB, ...
        metrics.minus3dB_bandwidth_Hz, visualLabel, ...
        "real LTspice AC text export from ADI ADA4817 official SPICE macromodel", ...
        "low-frequency reference is the mean of the first five AC points; no SPICE smoothing or synthetic data", ...
        'VariableNames', { ...
            'case_id', 'op_amp_model', 'Rf_ohm', 'Cpd_F', 'Cf_F', ...
            'supply_positive_V', 'supply_negative_V', ...
            'low_frequency_transimpedance_dBOhm', ...
            'peak_transimpedance_dBOhm', 'peaking_dB', ...
            'minus3dB_bandwidth_Hz', 'visual_region_label', ...
            'data_source', 'notes'})];

    rawRecords = [rawRecords; table( ... %#ok<AGROW>
        expected.case_id(iCase), expected.raw_filename(iCase), rawRelPath, ...
        processedFilename, ...
        'VariableNames', { ...
            'case_id', 'raw_filename', 'raw_relative_path', ...
            'processed_csv_filename'})];

    processedTables{iCase} = processed;
    processedRelPaths(iCase) = makeRepoRelative(processedPath, repoRoot);
end

adaSummaryPath = fullfile(resultsDir, ...
    'spice_comparison_summary_ada4817_round9.csv');
writetable(summary, adaSummaryPath);

combined = updateCombinedVendorSummary(summary, resultsDir);
combinedPath = fullfile(resultsDir, 'spice_comparison_summary_vendor_models.csv');
writetable(combined, combinedPath);

[magFormats, phaseFormats] = createAda4817CfSweepFigures( ...
    processedTables, expected.legend_label, figuresDir);
summaryFormats = createVendorModelSummaryFigure(combined, figuresDir);

sourceDataList = strjoin(processedRelPaths, ';');
keyParameters = sprintf(['op amp=ADA4817; Rf=%.4g ohm; Cpd=%.4g F; ' ...
    'Cf=[0.5,1.0,2.2,4.7] pF; supply=+%.4g/%.4g V; ' ...
    'AC current=1 A; PD tied to +5 V; FB tied to output; ' ...
    'LTspice export=.ac dec 200 10 10G'], ...
    Rf_ohm, Cpd_F, supplyPositive_V, supplyNegative_V);

appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "spice_ada4817_cf_sweep_magnitude.png", ...
    "tia_extension/scripts/run_12_import_ada4817_spice_round9.m", ...
    sourceDataList, string(keyParameters), ...
    "ADA4817 vendor LTspice macromodel feedback-capacitance sweep magnitude response; this is not hardware validation.", ...
    "real LTspice vendor SPICE macromodel export", ...
    string(strjoin(magFormats, ';')), string(runId));
appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "spice_ada4817_cf_sweep_magnitude.svg", ...
    "tia_extension/scripts/run_12_import_ada4817_spice_round9.m", ...
    sourceDataList, string(keyParameters), ...
    "ADA4817 vendor LTspice macromodel feedback-capacitance sweep magnitude response; this is not hardware validation.", ...
    "real LTspice vendor SPICE macromodel export", ...
    string(strjoin(magFormats, ';')), string(runId));
appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "spice_ada4817_cf_sweep_phase.png", ...
    "tia_extension/scripts/run_12_import_ada4817_spice_round9.m", ...
    sourceDataList, string(keyParameters), ...
    "ADA4817 vendor LTspice macromodel feedback-capacitance sweep phase response; this is not hardware validation.", ...
    "real LTspice vendor SPICE macromodel export", ...
    string(strjoin(phaseFormats, ';')), string(runId));
appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "spice_ada4817_cf_sweep_phase.svg", ...
    "tia_extension/scripts/run_12_import_ada4817_spice_round9.m", ...
    sourceDataList, string(keyParameters), ...
    "ADA4817 vendor LTspice macromodel feedback-capacitance sweep phase response; this is not hardware validation.", ...
    "real LTspice vendor SPICE macromodel export", ...
    string(strjoin(phaseFormats, ';')), string(runId));
appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "spice_vendor_model_bandwidth_peaking_summary.png", ...
    "tia_extension/scripts/run_12_import_ada4817_spice_round9.m", ...
    "tia_extension/results/spice_comparison_summary_vendor_models.csv", ...
    "OP27 +15/-15 V; OPA818 and ADA4817 +5/-5 V; design-evidence comparison across vendor macromodels", ...
    "Three-vendor LTspice macromodel summary of extracted peaking and -3 dB bandwidth versus Cf; this is not hardware validation.", ...
    "real LTspice vendor SPICE macromodel export summary", ...
    string(strjoin(summaryFormats, ';')), string(runId));
appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "spice_vendor_model_bandwidth_peaking_summary.svg", ...
    "tia_extension/scripts/run_12_import_ada4817_spice_round9.m", ...
    "tia_extension/results/spice_comparison_summary_vendor_models.csv", ...
    "OP27 +15/-15 V; OPA818 and ADA4817 +5/-5 V; design-evidence comparison across vendor macromodels", ...
    "Three-vendor LTspice macromodel summary of extracted peaking and -3 dB bandwidth versus Cf; this is not hardware validation.", ...
    "real LTspice vendor SPICE macromodel export summary", ...
    string(strjoin(summaryFormats, ';')), string(runId));

updateSpiceValidationStatus(spiceDir, runId);
writeAda4817Report(spiceDir, summary, rawRecords, runId);
writeRound9ChangeLog(tiaRoot, summary, rawRecords, processedRelPaths, runId);

fprintf('Round 9 ADA4817 LTspice import complete.\n');
fprintf('Imported %d real ADA4817 vendor macromodel AC cases.\n', height(summary));
fprintf('Wrote %s\n', adaSummaryPath);
fprintf('Three real vendor macromodel comparison sets are now available.\n');
fprintf('Full Q3 submission readiness still depends on manuscript polish and review.\n');

function rawPath = findUniqueRawFile(rawRoot, rawFilename)
if ~exist(rawRoot, 'dir')
    error('run_12_import_ada4817_spice_round9:MissingRawRoot', ...
        'Missing raw export root directory: %s', rawRoot);
end

matches = dir(fullfile(rawRoot, '**', char(rawFilename)));
matches = matches(~[matches.isdir]);
if isempty(matches)
    error('run_12_import_ada4817_spice_round9:MissingRawExport', ...
        'Missing required ADA4817 LTspice raw export: %s', rawFilename);
end
if numel(matches) > 1
    paths = string(fullfile({matches.folder}, {matches.name}))';
    error('run_12_import_ada4817_spice_round9:DuplicateRawExport', ...
        'Duplicate raw export filename %s found:\n%s', ...
        rawFilename, strjoin(paths, newline));
end
rawPath = fullfile(matches(1).folder, matches(1).name);
end

function checkNoCf4p4Screenshots(rawRoot)
if ~exist(rawRoot, 'dir')
    return;
end
matches = dir(fullfile(rawRoot, '**', '*Cf4p4*'));
matches = matches(~[matches.isdir]);
if ~isempty(matches)
    paths = string(fullfile({matches.folder}, {matches.name}))';
    error('run_12_import_ada4817_spice_round9:Cf4p4NamingError', ...
        'Found Cf4p4 screenshot/raw naming error. Correct value is Cf4p7:\n%s', ...
        strjoin(paths, newline));
end
end

function [Cf_F, legendLabel] = parseCfFromRawFilename(rawFilename)
tokens = regexp(char(rawFilename), '_Cf(\d+)p(\d+)_raw\.txt$', ...
    'tokens', 'once');
if isempty(tokens)
    error('run_12_import_ada4817_spice_round9:CannotInferCf', ...
        'Could not infer Cf value from raw filename: %s', rawFilename);
end
Cf_pF = str2double([tokens{1} '.' tokens{2}]);
Cf_F = Cf_pF * 1e-12;
legendLabel = string(sprintf('Cf = %.1f pF', Cf_pF));
end

function processed = makeProcessedTable(caseId, rawFilename, rawRelPath, ...
        spice, Rf_ohm, Cpd_F, Cf_F)
n = numel(spice.f_Hz);
VninMag_dB = getColumnOrNaN(spice.raw_table, 'Vnin_mag_dB', n);
VninPhase_deg = getColumnOrNaN(spice.raw_table, 'Vnin_phase_deg', n);

processed = table( ...
    repmat(caseId, n, 1), repmat("ADA4817", n, 1), ...
    repmat(Rf_ohm, n, 1), repmat(Cpd_F, n, 1), ...
    repmat(Cf_F, n, 1), spice.f_Hz(:), ...
    spice.mag_Zt_dBohm(:), spice.phase_Zt_deg(:), ...
    VninMag_dB(:), VninPhase_deg(:), ...
    repmat(rawFilename, n, 1), repmat(rawRelPath, n, 1), ...
    'VariableNames', { ...
        'case_id', 'op_amp_model', 'Rf_ohm', 'Cpd_F', 'Cf_F', ...
        'frequency_Hz', 'transimpedance_dBOhm', 'phase_deg', ...
        'Vnin_mag_dB', 'Vnin_phase_deg', ...
        'source_raw_export_filename', 'source_raw_relative_path'});
end

function values = getColumnOrNaN(tbl, columnName, n)
if ismember(columnName, tbl.Properties.VariableNames)
    values = tbl.(columnName);
else
    values = NaN(n, 1);
end
end

function metrics = calculateSummaryMetrics(f_Hz, mag_dB)
lowCount = min(5, numel(mag_dB));
lowFrequency = mean(mag_dB(1:lowCount), 'omitnan');
peak = max(mag_dB, [], 'omitnan');
peaking = peak - lowFrequency;
bandwidthIdx = find(mag_dB <= lowFrequency - 3, 1, 'first');
if isempty(bandwidthIdx)
    bandwidth = NaN;
else
    bandwidth = f_Hz(bandwidthIdx);
end

metrics = struct();
metrics.low_frequency_transimpedance_dBOhm = lowFrequency;
metrics.peak_transimpedance_dBOhm = peak;
metrics.peaking_dB = peaking;
metrics.minus3dB_bandwidth_Hz = bandwidth;
end

function label = classifyPeaking(peaking_dB)
if peaking_dB < 1
    label = "Safe";
elseif peaking_dB < 3
    label = "Marginal";
else
    label = "Risky";
end
end

function combined = updateCombinedVendorSummary(adaSummary, resultsDir)
combinedPath = fullfile(resultsDir, 'spice_comparison_summary_vendor_models.csv');
if exist(combinedPath, 'file')
    combined = readtable(combinedPath, ...
        'TextType', 'string', 'VariableNamingRule', 'preserve');
    keep = ~(combined.comparison_round == "Round 9" | ...
        startsWith(combined.case_id, "ADA4817"));
    combined = combined(keep, :);
else
    combined = table();
end

for iRow = 1:height(adaSummary)
    metrics = struct( ...
        'low_frequency_transimpedance_dBOhm', ...
            adaSummary.low_frequency_transimpedance_dBOhm(iRow), ...
        'peak_transimpedance_dBOhm', ...
            adaSummary.peak_transimpedance_dBOhm(iRow), ...
        'peaking_dB', adaSummary.peaking_dB(iRow), ...
        'minus3dB_bandwidth_Hz', ...
            adaSummary.minus3dB_bandwidth_Hz(iRow));
    combined = [combined; makeCombinedRow( ... %#ok<AGROW>
        "Round 9", adaSummary.case_id(iRow), ...
        adaSummary.op_amp_model(iRow), adaSummary.Rf_ohm(iRow), ...
        adaSummary.Cpd_F(iRow), adaSummary.Cf_F(iRow), ...
        adaSummary.supply_positive_V(iRow), ...
        adaSummary.supply_negative_V(iRow), metrics, ...
        adaSummary.visual_region_label(iRow), ...
        adaSummary.data_source(iRow), standardComparisonNote())];
end

if height(combined) > 0
    combined.notes(:) = standardComparisonNote();
    combined.source_table_relative_path(:) = ...
        "tia_extension/results/spice_comparison_summary_vendor_models.csv";
end
end

function row = makeCombinedRow(roundName, caseId, modelName, Rf_ohm, ...
        Cpd_F, Cf_F, supplyPositive_V, supplyNegative_V, metrics, ...
        visualLabel, dataSource, notes)
row = table( ...
    roundName, caseId, modelName, Rf_ohm, Cpd_F, Cf_F, ...
    supplyPositive_V, supplyNegative_V, ...
    metrics.low_frequency_transimpedance_dBOhm, ...
    metrics.peak_transimpedance_dBOhm, metrics.peaking_dB, ...
    metrics.minus3dB_bandwidth_Hz, visualLabel, dataSource, notes, ...
    "tia_extension/results/spice_comparison_summary_vendor_models.csv", ...
    'VariableNames', { ...
        'comparison_round', 'case_id', 'op_amp_model', ...
        'Rf_ohm', 'Cpd_F', 'Cf_F', ...
        'supply_positive_V', 'supply_negative_V', ...
        'low_frequency_transimpedance_dBOhm', ...
        'peak_transimpedance_dBOhm', 'peaking_dB', ...
        'minus3dB_bandwidth_Hz', 'visual_region_label', ...
        'data_source', 'notes', 'source_table_relative_path'});
end

function note = standardComparisonNote()
note = "OP27 used +15/-15 V; OPA818 and ADA4817 used +5/-5 V; rows are design-evidence comparisons across vendor macromodels, not identical operating-point equivalence.";
end

function [magFormats, phaseFormats] = createAda4817CfSweepFigures( ...
        processedTables, legendLabels, figuresDir)
fig = figure('Color', 'w', 'Name', 'ADA4817 Cf sweep magnitude');
for iCase = 1:numel(processedTables)
    tbl = processedTables{iCase};
    semilogx(tbl.frequency_Hz, tbl.transimpedance_dBOhm, ...
        'LineWidth', 1.5, 'DisplayName', legendLabels(iCase));
    hold on;
end
grid on;
box on;
xlabel('Frequency (Hz)');
ylabel('Transimpedance (dB ohm)');
title('ADA4817 vendor LTspice macromodel Cf sweep magnitude');
legend('Location', 'southwest', 'Interpreter', 'none');
styleAxes(gca);
magFormats = exportFigurePair( ...
    fig, fullfile(figuresDir, 'spice_ada4817_cf_sweep_magnitude'));
close(fig);

fig = figure('Color', 'w', 'Name', 'ADA4817 Cf sweep phase');
for iCase = 1:numel(processedTables)
    tbl = processedTables{iCase};
    semilogx(tbl.frequency_Hz, tbl.phase_deg, ...
        'LineWidth', 1.5, 'DisplayName', legendLabels(iCase));
    hold on;
end
grid on;
box on;
xlabel('Frequency (Hz)');
ylabel('Phase (deg)');
title('ADA4817 vendor LTspice macromodel Cf sweep phase');
legend('Location', 'southwest', 'Interpreter', 'none');
styleAxes(gca);
phaseFormats = exportFigurePair( ...
    fig, fullfile(figuresDir, 'spice_ada4817_cf_sweep_phase'));
close(fig);
end

function formats = createVendorModelSummaryFigure(combined, figuresDir)
fig = figure('Color', 'w', 'Name', 'Vendor macromodel summary');
tiledlayout(1, 2, 'Padding', 'compact', 'TileSpacing', 'compact');
models = unique(combined.op_amp_model, 'stable');
colors = lines(numel(models));

nexttile;
for iModel = 1:numel(models)
    mask = combined.op_amp_model == models(iModel);
    semilogx(combined.Cf_F(mask)*1e12, combined.peaking_dB(mask), ...
        '-o', 'LineWidth', 1.5, 'DisplayName', models(iModel), ...
        'Color', colors(iModel, :));
    hold on;
end
grid on;
box on;
xlabel('Cf (pF)');
ylabel('Peaking (dB)');
title('Extracted peaking');
legend('Location', 'best', 'Interpreter', 'none');
styleAxes(gca);

nexttile;
for iModel = 1:numel(models)
    mask = combined.op_amp_model == models(iModel);
    loglog(combined.Cf_F(mask)*1e12, ...
        combined.minus3dB_bandwidth_Hz(mask), ...
        '-o', 'LineWidth', 1.5, 'DisplayName', models(iModel), ...
        'Color', colors(iModel, :));
    hold on;
end
grid on;
box on;
xlabel('Cf (pF)');
ylabel('-3 dB bandwidth (Hz)');
title('Extracted bandwidth');
styleAxes(gca);
sgtitle('Three-vendor LTspice macromodel summary');

formats = exportFigurePair( ...
    fig, fullfile(figuresDir, ...
    'spice_vendor_model_bandwidth_peaking_summary'));
close(fig);
end

function updateSpiceValidationStatus(spiceDir, runId)
statusPath = fullfile(spiceDir, 'spice_validation_status.md');
fid = fopen(statusPath, 'w');
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, '# SPICE Validation Status\n\n');
fprintf(fid, 'Last Round 9 ADA4817 import run: `%s`\n\n', runId);
fprintf(fid, '- Real SPICE data used: **YES**\n');
fprintf(fid, '- Vendor op-amp macromodels compared: **3**\n');
fprintf(fid, '  - OP27\n');
fprintf(fid, '  - OPA818\n');
fprintf(fid, '  - ADA4817\n');
fprintf(fid, '- OP27 cases: **3 feedback capacitor values**\n');
fprintf(fid, '- OPA818 cases: **4 feedback capacitor values**\n');
fprintf(fid, '- ADA4817 cases: **4 feedback capacitor values**\n');
fprintf(fid, '- Vendor model files committed: **NO**\n');
fprintf(fid, '- Hardware measurement performed: **NO**\n');
fprintf(fid, '- Measured noise data used: **NO**\n\n');
fprintf(fid, 'Three real vendor macromodel comparison sets are now available. The previous one-more-vendor SPICE evidence gap is substantially addressed.\n\n');
fprintf(fid, 'This remains a SPICE macromodel comparison package, not hardware or experimental validation. Do not claim full Q3 submission readiness yet; final Q3 readiness still depends on final manuscript writing, related-work positioning, figure and caption polish, and supervisor or domain review.\n');
end

function writeAda4817Report(spiceDir, summary, rawRecords, runId)
reportPath = fullfile(spiceDir, 'ada4817_spice_import_report.md');
fid = fopen(reportPath, 'w');
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, '# ADA4817 SPICE Import Report\n\n');
fprintf(fid, 'Round 9 run identifier: `%s`\n\n', runId);
fprintf(fid, '## Model Source\n\n');
fprintf(fid, '- Source: ADI ADA4817 official SPICE Macro Model from the ADA4817-1 product page.\n');
fprintf(fid, '- Local ignored model file: `tia_extension/spice_interface/vendor_models_local/ADA4817/ada4817.cir`.\n');
fprintf(fid, '- Vendor model files are not committed or redistributed.\n\n');

fprintf(fid, '## Subcircuit Pin Order\n\n');
fprintf(fid, '`.Subckt ADA4817 100 101 102 103 104 105 106`\n\n');
fprintf(fid, '- `100`: non-inverting input\n');
fprintf(fid, '- `101`: inverting input\n');
fprintf(fid, '- `102`: positive supply\n');
fprintf(fid, '- `103`: negative supply\n');
fprintf(fid, '- `104`: output\n');
fprintf(fid, '- `105`: FB\n');
fprintf(fid, '- `106`: PD\n\n');

fprintf(fid, '## LTspice Setup Summary\n\n');
fprintf(fid, '- Tool: LTspice manual AC simulation export.\n');
fprintf(fid, '- Parameters: `Rf = 10 kOhm`, `Cpd = 10 pF`, `AC current = 1 A`, supply `+5 V / -5 V`.\n');
fprintf(fid, '- ADA4817 wiring: `+IN` tied to ground, `-IN` tied to `nin`, `OUT` tied to `out`, `FB` tied to output, and `PD` tied to `+5 V`.\n');
fprintf(fid, '- Sweep: `.ac dec 200 10 10G`.\n');
fprintf(fid, '- Saved signals: `V(out)`, `V(nin)`.\n\n');

fprintf(fid, '## Raw Files Imported\n\n');
for iRow = 1:height(rawRecords)
    fprintf(fid, '- `%s` from `%s`\n', ...
        rawRecords.raw_filename(iRow), rawRecords.raw_relative_path(iRow));
end
fprintf(fid, '\n');

fprintf(fid, '## Summary Metrics\n\n');
writeSummaryMarkdownTable(fid, summary);

fprintf(fid, '\n## Interpretation\n\n');
fprintf(fid, '- Low-frequency transimpedance is approximately 80 dBOhm, consistent with a 10 kOhm transimpedance when the AC current source amplitude is 1 A.\n');
fprintf(fid, '- Increasing `Cf` generally reduces extracted -3 dB bandwidth.\n');
fprintf(fid, '- The `Cf = 0.5 pF` case is borderline because peaking is near the Marginal/Risky threshold.\n');
fprintf(fid, '- Larger `Cf` values are safer in peaking terms but reduce bandwidth.\n');
fprintf(fid, '- Compared with OP27 and OPA818, ADA4817 strengthens the vendor-model-dependent design-boundary argument.\n\n');

fprintf(fid, '## Limitations\n\n');
fprintf(fid, '- SPICE macromodel comparison only.\n');
fprintf(fid, '- No hardware validation.\n');
fprintf(fid, '- No measured noise.\n');
fprintf(fid, '- No vendor model redistribution.\n');
fprintf(fid, '- Final submission readiness still needs manuscript review, related-work positioning, figure/caption polish, and supervisor or domain review.\n');
end

function writeRound9ChangeLog(tiaRoot, summary, rawRecords, ...
        processedRelPaths, runId)
changeLogPath = fullfile(tiaRoot, 'round9_change_log.md');
fid = fopen(changeLogPath, 'w');
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, '# Round 9 Change Log\n\n');
fprintf(fid, '- Branch: `tia-extension-v0.9-real-ada4817-spice-import`\n');
fprintf(fid, '- Run identifier: `%s`\n', runId);
fprintf(fid, '- Commit scope: import real ADA4817 LTspice AC text exports, create processed CSVs, summary tables, Cf sweep figures, a three-vendor summary figure, and conservative validation-status documentation.\n\n');

fprintf(fid, '## Raw Input Files Used\n\n');
for iRow = 1:height(rawRecords)
    fprintf(fid, '- `%s`\n', rawRecords.raw_relative_path(iRow));
end

fprintf(fid, '\n## Generated Processed CSV Files\n\n');
for iPath = 1:numel(processedRelPaths)
    fprintf(fid, '- `%s`\n', processedRelPaths(iPath));
end

fprintf(fid, '\n## Generated Summary CSV Files\n\n');
fprintf(fid, '- `tia_extension/results/spice_comparison_summary_ada4817_round9.csv`\n');
fprintf(fid, '- `tia_extension/results/spice_comparison_summary_vendor_models.csv`\n');

fprintf(fid, '\n## Generated Figures\n\n');
fprintf(fid, '- `tia_extension/figures/spice_ada4817_cf_sweep_magnitude.png`\n');
fprintf(fid, '- `tia_extension/figures/spice_ada4817_cf_sweep_magnitude.svg`\n');
fprintf(fid, '- `tia_extension/figures/spice_ada4817_cf_sweep_phase.png`\n');
fprintf(fid, '- `tia_extension/figures/spice_ada4817_cf_sweep_phase.svg`\n');
fprintf(fid, '- `tia_extension/figures/spice_vendor_model_bandwidth_peaking_summary.png`\n');
fprintf(fid, '- `tia_extension/figures/spice_vendor_model_bandwidth_peaking_summary.svg`\n');

fprintf(fid, '\n## Status Updates\n\n');
fprintf(fid, '- Real SPICE data used: YES.\n');
fprintf(fid, '- Vendor op-amp macromodels compared: 3 (`OP27`, `OPA818`, `ADA4817`).\n');
fprintf(fid, '- ADA4817 cases imported: %d.\n', height(summary));
fprintf(fid, '- No vendor model files committed.\n');
fprintf(fid, '- No raw LTspice export text files committed.\n');
fprintf(fid, '- No fake SPICE, noise, or hardware validation data added.\n');
fprintf(fid, '- No measured noise claim added.\n');
fprintf(fid, '- No active LPF validated functions modified.\n');
fprintf(fid, '- Full Q3 submission readiness is not claimed; final manuscript polish and review remain required.\n');
end

function writeSummaryMarkdownTable(fid, summary)
fprintf(fid, '| Case | Cf (pF) | Low-frequency Zt (dBOhm) | Peak Zt (dBOhm) | Peaking (dB) | -3 dB bandwidth (Hz) | Region |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|---|\n');
for iRow = 1:height(summary)
    fprintf(fid, '| `%s` | %.3g | %.6g | %.6g | %.6g | %.6g | %s |\n', ...
        summary.case_id(iRow), summary.Cf_F(iRow)*1e12, ...
        summary.low_frequency_transimpedance_dBOhm(iRow), ...
        summary.peak_transimpedance_dBOhm(iRow), ...
        summary.peaking_dB(iRow), ...
        summary.minus3dB_bandwidth_Hz(iRow), ...
        summary.visual_region_label(iRow));
end
end

function ensureDir(pathName)
if ~exist(pathName, 'dir')
    mkdir(pathName);
end
end

function relPath = makeRepoRelative(absPath, repoRoot)
repoPrefix = [char(repoRoot) filesep];
rel = strrep(char(absPath), repoPrefix, '');
relPath = string(strrep(rel, filesep, '/'));
end

function styleAxes(ax)
set(ax, 'FontName', 'Arial', 'FontSize', 11, 'LineWidth', 1);
try
    disableDefaultInteractivity(ax);
catch
end
try
    axtoolbar(ax, {});
catch
end
end

function formats = exportFigurePair(figHandle, basePath)
formats = {};
try
    exportgraphics(figHandle, [basePath '.svg'], 'ContentType', 'vector');
    formats{end+1} = 'svg'; %#ok<AGROW>
catch
    print(figHandle, [basePath '.svg'], '-dsvg');
    formats{end+1} = 'svg'; %#ok<AGROW>
end
try
    exportgraphics(figHandle, [basePath '.png'], 'Resolution', 600);
    formats{end+1} = 'png'; %#ok<AGROW>
catch
    print(figHandle, [basePath '.png'], '-dpng', '-r600');
    formats{end+1} = 'png'; %#ok<AGROW>
end
end

function appendFigureManifest(manifestPath, filename, script, sourceData, ...
        keyParameters, caption, dataType, exportFormats, runId)
header = "figure_filename,source_script,source_data,key_parameters," + ...
    "caption,data_type,export_formats,run_identifier";
ensureManifestHeader(manifestPath, header);
removeFigureEntry(manifestPath, filename);

fields = [filename, script, sourceData, keyParameters, caption, ...
    dataType, exportFormats, runId];
fid = fopen(manifestPath, 'a');
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '%s\n', csvJoin(fields));
end

function ensureManifestHeader(manifestPath, header)
if ~exist(manifestPath, 'file')
    fid = fopen(manifestPath, 'w');
    cleanup = onCleanup(@() fclose(fid));
    fprintf(fid, '%s\n', header);
    return;
end

text = fileread(manifestPath);
lines = regexp(text, '\r\n|\n|\r', 'split');
if ~isempty(lines) && strlength(string(lines{end})) == 0
    lines(end) = [];
end

if isempty(lines)
    lines = {char(header)};
elseif ~contains(string(lines{1}), "run_identifier")
    lines{1} = char(header);
    for iLine = 2:numel(lines)
        if strlength(string(lines{iLine})) > 0
            lines{iLine} = [lines{iLine} ',round9-ada4817'];
        end
    end
end

fid = fopen(manifestPath, 'w');
cleanup = onCleanup(@() fclose(fid));
for iLine = 1:numel(lines)
    fprintf(fid, '%s\n', lines{iLine});
end
end

function removeFigureEntry(manifestPath, filename)
text = fileread(manifestPath);
lines = regexp(text, '\r\n|\n|\r', 'split');
keep = true(size(lines));
for iLine = 2:numel(lines)
    keep(iLine) = ~startsWith(string(lines{iLine}), filename + ",");
end
lines = lines(keep);

fid = fopen(manifestPath, 'w');
cleanup = onCleanup(@() fclose(fid));
for iLine = 1:numel(lines)
    if strlength(string(lines{iLine})) > 0
        fprintf(fid, '%s\n', lines{iLine});
    end
end
end

function row = csvJoin(fields)
parts = strings(1, numel(fields));
for iField = 1:numel(fields)
    parts(iField) = csvField(fields(iField));
end
row = char(strjoin(parts, ','));
end

function field = csvField(value)
field = string(value);
field = replace(field, """", """""");
if contains(field, ",") || contains(field, """") || ...
        contains(field, newline) || contains(field, sprintf('\r'))
    field = """" + field + """";
end
end
