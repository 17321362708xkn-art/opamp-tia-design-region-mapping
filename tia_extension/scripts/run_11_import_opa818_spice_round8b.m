%RUN_11_IMPORT_OPA818_SPICE_ROUND8B Import real OPA818 LTspice exports.
%
% Round 8B imports manually exported LTspice AC text data generated from
% the official TI OPA818 PSpice macromodel. It does not commit vendor model
% files, does not fabricate missing data, and does not claim hardware or
% experimental validation.

scriptDir = fileparts(mfilename('fullpath'));
tiaRoot = fileparts(scriptDir);
repoRoot = fileparts(tiaRoot);
spiceDir = fullfile(tiaRoot, 'spice_interface');
spiceDataDir = fullfile(spiceDir, 'imported_ac_data');
processedDir = fullfile(spiceDataDir, 'round8_opa818');
rawRoot = fullfile(spiceDir, 'round8_manual_exports');
resultsDir = fullfile(tiaRoot, 'results');
figuresDir = fullfile(tiaRoot, 'figures');

addpath(spiceDir);

ensureDir(processedDir);
ensureDir(resultsDir);
ensureDir(figuresDir);

runId = char(datetime('now', 'TimeZone', 'UTC', ...
    'Format', 'yyyyMMdd_HHmmss''Z'''));

expected = table( ...
    ["OPA818_Rf10k_Cpd10p_Cf0p5"; ...
     "OPA818_Rf10k_Cpd10p_Cf1p0"; ...
     "OPA818_Rf10k_Cpd10p_Cf1p5"; ...
     "OPA818_Rf10k_Cpd10p_Cf2p2"], ...
    ["OPA818_Rf10k_Cpd10p_Cf0p5_raw.txt"; ...
     "OPA818_Rf10k_Cpd10p_Cf1p0_raw.txt"; ...
     "OPA818_Rf10k_Cpd10p_Cf1p5_raw.txt"; ...
     "OPA818_Rf10k_Cpd10p_Cf2p2_raw.txt"], ...
    'VariableNames', {'case_id', 'raw_filename'});
expected.Cf_F = zeros(height(expected), 1);
expected.legend_label = strings(height(expected), 1);
for iExpected = 1:height(expected)
    [expected.Cf_F(iExpected), expected.legend_label(iExpected)] = ...
        parseCfFromRawFilename(expected.raw_filename(iExpected));
end

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
        expected.case_id(iCase), "OPA818", Rf_ohm, Cpd_F, ...
        expected.Cf_F(iCase), supplyPositive_V, supplyNegative_V, ...
        metrics.low_frequency_transimpedance_dBOhm, ...
        metrics.peak_transimpedance_dBOhm, metrics.peaking_dB, ...
        metrics.minus3dB_bandwidth_Hz, visualLabel, ...
        "real LTspice AC text export from TI OPA818 PSpice macromodel SBOMB74B.ZIP", ...
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

opaSummaryPath = fullfile(resultsDir, ...
    'spice_comparison_summary_opa818_round8.csv');
writetable(summary, opaSummaryPath);

combined = createCombinedVendorSummary( ...
    summary, resultsDir, spiceDataDir, repoRoot);
writetable(combined, fullfile(resultsDir, ...
    'spice_comparison_summary_vendor_models.csv'));

[magFormats, phaseFormats] = createOpa818CfSweepFigures( ...
    processedTables, expected.legend_label, figuresDir);

sourceDataList = strjoin(processedRelPaths, ';');
keyParameters = sprintf(['op amp=OPA818; Rf=%.4g ohm; Cpd=%.4g F; ' ...
    'Cf=[0.5,1.0,1.5,2.2] pF; supply=+%.4g/%.4g V; ' ...
    'AC current=1 A; LTspice export=.ac dec 200 10 10G'], ...
    Rf_ohm, Cpd_F, supplyPositive_V, supplyNegative_V);

appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "spice_opa818_cf_sweep_magnitude.png", ...
    "tia_extension/scripts/run_11_import_opa818_spice_round8b.m", ...
    sourceDataList, string(keyParameters), ...
    "OPA818 vendor LTspice macromodel feedback-capacitance sweep magnitude response; this is not hardware validation.", ...
    "real LTspice vendor PSpice macromodel export", ...
    string(strjoin(magFormats, ';')), string(runId));
appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "spice_opa818_cf_sweep_magnitude.svg", ...
    "tia_extension/scripts/run_11_import_opa818_spice_round8b.m", ...
    sourceDataList, string(keyParameters), ...
    "OPA818 vendor LTspice macromodel feedback-capacitance sweep magnitude response; this is not hardware validation.", ...
    "real LTspice vendor PSpice macromodel export", ...
    string(strjoin(magFormats, ';')), string(runId));
appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "spice_opa818_cf_sweep_phase.png", ...
    "tia_extension/scripts/run_11_import_opa818_spice_round8b.m", ...
    sourceDataList, string(keyParameters), ...
    "OPA818 vendor LTspice macromodel feedback-capacitance sweep phase response; this is not hardware validation.", ...
    "real LTspice vendor PSpice macromodel export", ...
    string(strjoin(phaseFormats, ';')), string(runId));
appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "spice_opa818_cf_sweep_phase.svg", ...
    "tia_extension/scripts/run_11_import_opa818_spice_round8b.m", ...
    sourceDataList, string(keyParameters), ...
    "OPA818 vendor LTspice macromodel feedback-capacitance sweep phase response; this is not hardware validation.", ...
    "real LTspice vendor PSpice macromodel export", ...
    string(strjoin(phaseFormats, ';')), string(runId));

updateSpiceValidationStatus(spiceDir, runId);
writeOpa818Report(spiceDir, summary, rawRecords, runId);
writeRound8bChangeLog(tiaRoot, summary, rawRecords, processedRelPaths, runId);

fprintf('Round 8B OPA818 LTspice import complete.\n');
fprintf('Imported %d real OPA818 vendor macromodel AC cases.\n', height(summary));
fprintf('Wrote %s\n', opaSummaryPath);
fprintf('Q3 SPICE requirement remains pending at least one additional vendor macromodel comparison.\n');

function rawPath = findUniqueRawFile(rawRoot, rawFilename)
if ~exist(rawRoot, 'dir')
    error('run_11_import_opa818_spice_round8b:MissingRawRoot', ...
        'Missing raw export root directory: %s', rawRoot);
end

matches = dir(fullfile(rawRoot, '**', char(rawFilename)));
matches = matches(~[matches.isdir]);
if isempty(matches)
    error('run_11_import_opa818_spice_round8b:MissingRawExport', ...
        'Missing required OPA818 LTspice raw export: %s', rawFilename);
end
if numel(matches) > 1
    paths = string(fullfile({matches.folder}, {matches.name}))';
    error('run_11_import_opa818_spice_round8b:DuplicateRawExport', ...
        'Duplicate raw export filename %s found:\n%s', ...
        rawFilename, strjoin(paths, newline));
end
rawPath = fullfile(matches(1).folder, matches(1).name);
end

function [Cf_F, legendLabel] = parseCfFromRawFilename(rawFilename)
tokens = regexp(char(rawFilename), '_Cf(\d+)p(\d+)_raw\.txt$', ...
    'tokens', 'once');
if isempty(tokens)
    error('run_11_import_opa818_spice_round8b:CannotInferCf', ...
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
    repmat(caseId, n, 1), repmat("OPA818", n, 1), ...
    repmat(Rf_ohm, n, 1), repmat(Cpd_F, n, 1), ...
    repmat(Cf_F, n, 1), spice.f_Hz(:), ...
    spice.mag_Zt_dBohm(:), spice.phase_Zt_deg(:), ...
    VninMag_dB(:), VninPhase_deg(:), ...
    repmat(rawFilename, n, 1), repmat(rawRelPath, n, 1), ...
    'VariableNames', { ...
        'case_id', 'op_amp_model', 'Rf_ohm', 'Cpd_F', 'Cf_F', ...
        'frequency_Hz', 'transimpedance_dBOhm', 'phase_deg', ...
        'Vnin_mag_dB', 'Vnin_phase_deg', ...
        'source_raw_export_filename', 'source_raw_export_relative_path'});
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

function combined = createCombinedVendorSummary( ...
        opaSummary, resultsDir, spiceDataDir, repoRoot)
combined = table();
op27SummaryPath = fullfile(resultsDir, 'spice_comparison_summary.csv');

if exist(op27SummaryPath, 'file')
    op27 = readtable(op27SummaryPath, ...
        'TextType', 'string', 'VariableNamingRule', 'preserve');
    for iRow = 1:height(op27)
        caseId = op27.case_id(iRow);
        dataPath = fullfile(spiceDataDir, char(caseId + ".csv"));
        if exist(dataPath, 'file')
            spice = import_spice_ac_data(dataPath);
            metrics = calculateSummaryMetrics( ...
                spice.f_Hz, spice.mag_Zt_dBohm);
        else
            metrics = struct( ...
                'low_frequency_transimpedance_dBOhm', NaN, ...
                'peak_transimpedance_dBOhm', NaN, ...
                'peaking_dB', op27.spice_peaking_dB(iRow), ...
                'minus3dB_bandwidth_Hz', op27.spice_bandwidth_Hz(iRow));
        end

        visualLabel = normaliseRegionLabel( ...
            op27.expected_region_from_filename(iRow));
        combined = [combined; makeCombinedRow( ... %#ok<AGROW>
            "Round 4.5", caseId, op27.vendor_model(iRow), ...
            op27.Rf_ohm(iRow), op27.Cpd_F(iRow), op27.Cf_F(iRow), ...
            15, -15, metrics, visualLabel, ...
            "real LTspice OP27 macromodel smoke-test export", ...
            "OP27 used +15/-15 V; OPA818 used +5/-5 V, so rows are design-evidence comparisons rather than identical operating-point equivalence.")];
    end
end

for iRow = 1:height(opaSummary)
    metrics = struct( ...
        'low_frequency_transimpedance_dBOhm', ...
            opaSummary.low_frequency_transimpedance_dBOhm(iRow), ...
        'peak_transimpedance_dBOhm', ...
            opaSummary.peak_transimpedance_dBOhm(iRow), ...
        'peaking_dB', opaSummary.peaking_dB(iRow), ...
        'minus3dB_bandwidth_Hz', ...
            opaSummary.minus3dB_bandwidth_Hz(iRow));
    combined = [combined; makeCombinedRow( ... %#ok<AGROW>
        "Round 8B", opaSummary.case_id(iRow), ...
        opaSummary.op_amp_model(iRow), opaSummary.Rf_ohm(iRow), ...
        opaSummary.Cpd_F(iRow), opaSummary.Cf_F(iRow), ...
        opaSummary.supply_positive_V(iRow), ...
        opaSummary.supply_negative_V(iRow), metrics, ...
        opaSummary.visual_region_label(iRow), ...
        opaSummary.data_source(iRow), ...
        "OPA818 used +5/-5 V; OP27 used +15/-15 V, so rows are design-evidence comparisons rather than identical operating-point equivalence.")];
end

combined.source_table_relative_path = repmat( ...
    "tia_extension/results/spice_comparison_summary_vendor_models.csv", ...
    height(combined), 1);
unused = repoRoot; %#ok<NASGU>
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
    'VariableNames', { ...
        'comparison_round', 'case_id', 'op_amp_model', ...
        'Rf_ohm', 'Cpd_F', 'Cf_F', ...
        'supply_positive_V', 'supply_negative_V', ...
        'low_frequency_transimpedance_dBOhm', ...
        'peak_transimpedance_dBOhm', 'peaking_dB', ...
        'minus3dB_bandwidth_Hz', 'visual_region_label', ...
        'data_source', 'notes'});
end

function label = normaliseRegionLabel(label)
label = string(label);
if startsWith(label, "Safe")
    label = "Safe";
elseif startsWith(label, "Risky")
    label = "Risky";
elseif startsWith(label, "Marginal")
    label = "Marginal";
end
end

function [magFormats, phaseFormats] = createOpa818CfSweepFigures( ...
        processedTables, legendLabels, figuresDir)
fig = figure('Color', 'w', 'Name', 'OPA818 Cf sweep magnitude');
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
title('OPA818 vendor LTspice macromodel Cf sweep magnitude');
legend('Location', 'southwest', 'Interpreter', 'none');
styleAxes(gca);
magFormats = exportFigurePair( ...
    fig, fullfile(figuresDir, 'spice_opa818_cf_sweep_magnitude'));
close(fig);

fig = figure('Color', 'w', 'Name', 'OPA818 Cf sweep phase');
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
title('OPA818 vendor LTspice macromodel Cf sweep phase');
legend('Location', 'southwest', 'Interpreter', 'none');
styleAxes(gca);
phaseFormats = exportFigurePair( ...
    fig, fullfile(figuresDir, 'spice_opa818_cf_sweep_phase'));
close(fig);
end

function updateSpiceValidationStatus(spiceDir, runId)
statusPath = fullfile(spiceDir, 'spice_validation_status.md');
fid = fopen(statusPath, 'w');
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, '# SPICE Validation Status\n\n');
fprintf(fid, 'Last Round 8B OPA818 import run: `%s`\n\n', runId);
fprintf(fid, '- Real SPICE data used: **YES**\n');
fprintf(fid, '- Vendor op-amp macromodels compared: **2**\n');
fprintf(fid, '  - OP27\n');
fprintf(fid, '  - OPA818\n');
fprintf(fid, '- OP27 cases: **3 feedback capacitor values**\n');
fprintf(fid, '- OPA818 cases imported: **4 feedback capacitor values**\n');
fprintf(fid, '- OPA818 model source: **TI OPA818 PSpice model SBOMB74B.ZIP; vendor model file not committed**\n');
fprintf(fid, '- Q3 SPICE requirement: **still pending at least one additional vendor macromodel comparison, preferably ADA4817-1 or LTC6268-10**\n');
fprintf(fid, '- Hardware measurement performed: **NO**\n');
fprintf(fid, '- Measured noise data used: **NO**\n\n');
fprintf(fid, 'This is a SPICE macromodel comparison, not hardware or experimental validation.\n\n');
fprintf(fid, 'Correct status: OP27 and OPA818 provide two real vendor macromodel comparison sets; Q3 SPICE requirement is still pending at least one more vendor macromodel comparison before a final submission-readiness claim.\n');
end

function writeOpa818Report(spiceDir, summary, rawRecords, runId)
reportPath = fullfile(spiceDir, 'opa818_spice_import_report.md');
fid = fopen(reportPath, 'w');
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, '# OPA818 SPICE Import Report\n\n');
fprintf(fid, 'Round 8B run identifier: `%s`\n\n', runId);
fprintf(fid, '## Model Source\n\n');
fprintf(fid, '- Source: TI OPA818 official PSpice model, `SBOMB74B.ZIP`.\n');
fprintf(fid, '- Subcircuit used locally: `.subckt OPA818 IN+ IN- OUT VCC VEE`.\n');
fprintf(fid, '- Vendor model files are kept under the local ignored `vendor_models_local/` tree and are not committed or redistributed.\n\n');

fprintf(fid, '## LTspice Setup Summary\n\n');
fprintf(fid, '- Tool: LTspice manual AC simulation export.\n');
fprintf(fid, '- Circuit: photodiode TIA test case using the OPA818 vendor PSpice macromodel.\n');
fprintf(fid, '- Parameters: `Rf = 10 kOhm`, `Cpd = 10 pF`, `AC current = 1 A`, supply `+5 V / -5 V`.\n');
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
fprintf(fid, '- Increasing `Cf` reduces the extracted -3 dB bandwidth across the four OPA818 cases.\n');
fprintf(fid, '- The imported OPA818 cases show little or no peaking in this `Rf = 10 kOhm`, `Cpd = 10 pF` setup.\n');
fprintf(fid, '- Compared with OP27, the OPA818 result strengthens the evidence that stability and bandwidth boundaries depend on the vendor macromodel and operating assumptions.\n\n');

fprintf(fid, '## Limitations\n\n');
fprintf(fid, '- SPICE macromodel comparison only.\n');
fprintf(fid, '- No hardware validation.\n');
fprintf(fid, '- No measured noise.\n');
fprintf(fid, '- No vendor model redistribution.\n');
fprintf(fid, '- Q3 final readiness still needs at least one more vendor macromodel comparison, preferably ADA4817-1 or LTC6268-10, plus final manuscript review.\n');
end

function writeRound8bChangeLog(tiaRoot, summary, rawRecords, ...
        processedRelPaths, runId)
changeLogPath = fullfile(tiaRoot, 'round8b_change_log.md');
fid = fopen(changeLogPath, 'w');
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, '# Round 8B Change Log\n\n');
fprintf(fid, '- Branch: `tia-extension-v0.8-real-opa818-spice-import`\n');
fprintf(fid, '- Run identifier: `%s`\n', runId);
fprintf(fid, '- Commit scope: import real OPA818 LTspice AC text exports, create processed CSVs, summary tables, Cf sweep figures, and conservative validation-status documentation.\n\n');

fprintf(fid, '## Raw Input Files Used\n\n');
for iRow = 1:height(rawRecords)
    fprintf(fid, '- `%s`\n', rawRecords.raw_relative_path(iRow));
end

fprintf(fid, '\n## Generated Processed CSV Files\n\n');
for iPath = 1:numel(processedRelPaths)
    fprintf(fid, '- `%s`\n', processedRelPaths(iPath));
end

fprintf(fid, '\n## Generated Summary CSV Files\n\n');
fprintf(fid, '- `tia_extension/results/spice_comparison_summary_opa818_round8.csv`\n');
fprintf(fid, '- `tia_extension/results/spice_comparison_summary_vendor_models.csv`\n');

fprintf(fid, '\n## Generated Figures\n\n');
fprintf(fid, '- `tia_extension/figures/spice_opa818_cf_sweep_magnitude.png`\n');
fprintf(fid, '- `tia_extension/figures/spice_opa818_cf_sweep_magnitude.svg`\n');
fprintf(fid, '- `tia_extension/figures/spice_opa818_cf_sweep_phase.png`\n');
fprintf(fid, '- `tia_extension/figures/spice_opa818_cf_sweep_phase.svg`\n');

fprintf(fid, '\n## Status Updates\n\n');
fprintf(fid, '- Real SPICE data used: YES.\n');
fprintf(fid, '- Vendor op-amp macromodels compared: 2 (`OP27`, `OPA818`).\n');
fprintf(fid, '- OPA818 cases imported: %d.\n', height(summary));
fprintf(fid, '- No vendor model files committed.\n');
fprintf(fid, '- No raw LTspice export text files committed.\n');
fprintf(fid, '- No fake SPICE, noise, or hardware validation data added.\n');
fprintf(fid, '- Q3 remains pending at least one additional vendor macromodel comparison before any final submission-readiness claim.\n');
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
            lines{iLine} = [lines{iLine} ',round8b-opa818'];
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
