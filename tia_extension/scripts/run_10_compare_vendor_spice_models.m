%RUN_10_COMPARE_VENDOR_SPICE_MODELS Compare future Round 8 vendor SPICE data.
%
% This Round 8A script prepares the comparison entry point for real OPA818
% and ADA4817-1 LTspice macromodel exports. It does not create, infer, or
% smooth SPICE data. If no real Round 8 vendor export CSV files are present,
% it exits cleanly with a status message.

scriptDir = fileparts(mfilename('fullpath'));
tiaRoot = fileparts(scriptDir);
functionsDir = fullfile(tiaRoot, 'functions');
spiceDir = fullfile(tiaRoot, 'spice_interface');
spiceDataDir = fullfile(spiceDir, 'imported_ac_data');
resultsDir = fullfile(tiaRoot, 'results');
figuresDir = fullfile(tiaRoot, 'figures');
metadataTemplatePath = fullfile(spiceDir, ...
    'round8_vendor_spice_case_metadata_template.csv');

addpath(functionsDir);
addpath(spiceDir);

targetPrefixes = ["OPA818", "ADA4817"];

if ~exist(spiceDataDir, 'dir')
    fprintf(['No Round 8 real vendor SPICE export data found yet. ' ...
        'Run LTspice manually and add exported data before comparison.\n']);
    return;
end

allFiles = dir(fullfile(spiceDataDir, '*.csv'));
fileNames = string({allFiles.name})';
caseIds = erase(fileNames, ".csv");
isRound8VendorCase = startsWith(caseIds, targetPrefixes(1)) | ...
    startsWith(caseIds, targetPrefixes(2));
round8Files = allFiles(isRound8VendorCase);

if isempty(round8Files)
    fprintf(['No Round 8 real vendor SPICE export data found yet. ' ...
        'Run LTspice manually and add exported data before comparison.\n']);
    return;
end

if ~exist(metadataTemplatePath, 'file')
    error('run_10_compare_vendor_spice_models:MissingMetadataTemplate', ...
        'Missing metadata template: %s', metadataTemplatePath);
end

metadata = readtable(metadataTemplatePath, ...
    'TextType', 'string', 'VariableNamingRule', 'preserve');

ensureDir(resultsDir);
ensureDir(figuresDir);

runId = char(datetime('now', 'TimeZone', 'UTC', ...
    'Format', 'yyyyMMdd_HHmmss''Z'''));
summaryAll = table();
successfulComparisons = 0;

for iFile = 1:numel(round8Files)
    fileName = string(round8Files(iFile).name);
    caseId = erase(fileName, ".csv");
    filePath = fullfile(spiceDataDir, char(fileName));

    metadataRow = metadata(metadata.case_id == caseId, :);
    if height(metadataRow) ~= 1
        warning('run_10_compare_vendor_spice_models:MetadataMatch', ...
            'Skipping %s because metadata template has %d matching rows.', ...
            caseId, height(metadataRow));
        continue;
    end

    try
        spice = import_spice_ac_data(filePath);
    catch importErr
        warning('run_10_compare_vendor_spice_models:ImportFailed', ...
            'Skipping %s because import failed: %s', caseId, importErr.message);
        continue;
    end

    [matlabCase, hasComparisonParameters, skipReason] = ...
        makeRound8MatlabCase(spice, metadataRow);
    if ~hasComparisonParameters
        warning('run_10_compare_vendor_spice_models:MissingComparisonParameters', ...
            'Skipping %s: %s', caseId, skipReason);
        continue;
    end

    comparison = compare_tia_matlab_vs_spice(spice, matlabCase);
    comparison.summary_table.spice_source_file = ...
        "tia_extension/spice_interface/imported_ac_data/" + fileName;
    comparison.summary_table.expected_region_from_visual_inspection = ...
        metadataRow.expected_region_from_visual_inspection;
    comparison.summary_table.spice_tool = metadataRow.spice_tool;
    comparison.summary_table.source_type = ...
        "real vendor LTspice macromodel export";
    comparison.summary_table.interpolation_direction = ...
        "MATLAB behavioural response evaluated directly on vendor SPICE frequency points; no SPICE smoothing or resampling.";

    responseCsv = fullfile(resultsDir, ...
        ['spice_comparison_response_' char(caseId) '.csv']);
    writetable(comparison.response_table, responseCsv);

    summaryAll = [summaryAll; comparison.summary_table]; %#ok<AGROW>

    magFormats = createMagnitudeFigure( ...
        comparison.response_table, caseId, metadataRow.op_amp_model, figuresDir);
    phaseFormats = createPhaseFigure( ...
        comparison.response_table, caseId, metadataRow.op_amp_model, figuresDir);

    keyParameters = sprintf( ...
        'op amp=%s; Rf=%.3g ohm; Cf=%.4g F; Cpd=%.3g F; supply=+%.3g/%.3g V; AC current=%.3g A; A0=%.3g; ft=%.6g Hz', ...
        metadataRow.op_amp_model(1), ...
        matlabCase.Rf_ohm(1), matlabCase.Cf_F(1), ...
        matlabCase.Cpd_F(1), metadataRow.supply_positive_V(1), ...
        metadataRow.supply_negative_V(1), metadataRow.ac_current_A(1), ...
        matlabCase.A0(1), matlabCase.ft_Hz(1));

    appendFigureManifest( ...
        fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
        string(['spice_compare_' char(caseId) '_magnitude.png']), ...
        "tia_extension/scripts/run_10_compare_vendor_spice_models.m", ...
        string(['tia_extension/results/spice_comparison_response_' char(caseId) '.csv']), ...
        string(keyParameters), ...
        "Magnitude comparison between MATLAB behavioural TIA response and real vendor LTspice macromodel AC data.", ...
        "real vendor LTspice macromodel comparison", ...
        string(strjoin(magFormats, ';')), ...
        string(runId));

    appendFigureManifest( ...
        fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
        string(['spice_compare_' char(caseId) '_phase.png']), ...
        "tia_extension/scripts/run_10_compare_vendor_spice_models.m", ...
        string(['tia_extension/results/spice_comparison_response_' char(caseId) '.csv']), ...
        string(keyParameters), ...
        "Phase comparison between MATLAB behavioural TIA response and real vendor LTspice macromodel AC data.", ...
        "real vendor LTspice macromodel comparison", ...
        string(strjoin(phaseFormats, ';')), ...
        string(runId));

    successfulComparisons = successfulComparisons + 1;
end

if successfulComparisons == 0
    fprintf(['Round 8 vendor SPICE CSV files were found, but none had ' ...
        'enough real import and comparison metadata to run.\n']);
    fprintf(['Processed CSV files must include importable response data ' ...
        'and A0 / ft_Hz metadata for behavioural comparison.\n']);
    return;
end

summaryPath = fullfile(resultsDir, ...
    'spice_comparison_summary_vendor_round8.csv');
writetable(summaryAll, summaryPath);

fprintf('Round 8 vendor SPICE comparison complete for %d real exported cases.\n', ...
    successfulComparisons);
fprintf('Wrote %s\n', summaryPath);
fprintf('Q3 SPICE requirement remains pending until the added real vendor comparison set is reviewed.\n');

function [matlabCase, ok, reason] = makeRound8MatlabCase(spice, metadataRow)
ok = false;
reason = "";
matlabCase = table();

[A0, hasA0] = getNumericMetadata(spice.metadata, 'A0');
[ft_Hz, hasFt] = getNumericMetadata(spice.metadata, 'ft_Hz');

if ~hasA0
    reason = "processed CSV is missing A0 metadata";
    return;
end

if ~hasFt
    reason = "processed CSV is missing ft_Hz metadata";
    return;
end

matlabCase = table( ...
    metadataRow.Rf_ohm(1), metadataRow.Cf_F(1), metadataRow.Cpd_F(1), ...
    A0, ft_Hz, ...
    'VariableNames', {'Rf_ohm', 'Cf_F', 'Cpd_F', 'A0', 'ft_Hz'});
ok = true;
end

function [value, ok] = getNumericMetadata(metadata, fieldName)
ok = false;
value = NaN;
if ~isfield(metadata, fieldName)
    return;
end

rawValue = metadata.(fieldName);
if isnumeric(rawValue)
    value = rawValue(1);
else
    value = str2double(string(rawValue(1)));
end
ok = ~isnan(value);
end

function formats = createMagnitudeFigure(responseTable, caseId, modelName, figuresDir)
fig = figure('Color', 'w', 'Name', ['Round 8 magnitude ' char(caseId)]);
semilogx(responseTable.f_Hz, responseTable.matlab_mag_dBohm, ...
    'LineWidth', 1.5, 'DisplayName', 'MATLAB behavioural');
hold on;
semilogx(responseTable.f_Hz, responseTable.spice_mag_dBohm, ...
    'LineWidth', 1.5, 'DisplayName', ['LTspice ' char(modelName)]);
grid on;
box on;
xlabel('Frequency (Hz)');
ylabel('Transimpedance magnitude (dB ohm)');
title(['Round 8 vendor SPICE comparison: ' char(caseId)], ...
    'Interpreter', 'none');
legend('Location', 'southwest', 'Interpreter', 'none');
styleAxes(gca);
formats = exportFigureSet( ...
    fig, fullfile(figuresDir, ['spice_compare_' char(caseId) '_magnitude']));
close(fig);
end

function formats = createPhaseFigure(responseTable, caseId, modelName, figuresDir)
fig = figure('Color', 'w', 'Name', ['Round 8 phase ' char(caseId)]);
semilogx(responseTable.f_Hz, responseTable.matlab_phase_deg, ...
    'LineWidth', 1.5, 'DisplayName', 'MATLAB behavioural');
hold on;
semilogx(responseTable.f_Hz, responseTable.spice_phase_deg, ...
    'LineWidth', 1.5, 'DisplayName', ['LTspice ' char(modelName)]);
grid on;
box on;
xlabel('Frequency (Hz)');
ylabel('Inversion-removed phase (deg)');
title(['Round 8 vendor SPICE comparison: ' char(caseId)], ...
    'Interpreter', 'none');
legend('Location', 'southwest', 'Interpreter', 'none');
styleAxes(gca);
formats = exportFigureSet( ...
    fig, fullfile(figuresDir, ['spice_compare_' char(caseId) '_phase']));
close(fig);
end

function ensureDir(pathName)
if ~exist(pathName, 'dir')
    mkdir(pathName);
end
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

function formats = exportFigureSet(figHandle, basePath)
formats = {};
try
    exportgraphics(figHandle, [basePath '.pdf'], 'ContentType', 'vector');
    formats{end+1} = 'pdf'; %#ok<AGROW>
catch
end
try
    exportgraphics(figHandle, [basePath '.svg'], 'ContentType', 'vector');
    formats{end+1} = 'svg'; %#ok<AGROW>
catch
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
            lines{iLine} = [lines{iLine} ',round8-vendor'];
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
