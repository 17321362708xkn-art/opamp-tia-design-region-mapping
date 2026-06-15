%RUN_06_COMPARE_WITH_SPICE_EXAMPLE Run OP27 LTspice smoke-test comparison.
%
% This Round 4.5 script imports real LTspice OP27 macromodel AC data and
% compares it against the MATLAB behavioural TIA model on the SPICE
% frequency grid. It does not create or infer SPICE data, and it does not
% claim hardware validation or full Q3 SPICE validation.

scriptDir = fileparts(mfilename('fullpath'));
tiaRoot = fileparts(scriptDir);
functionsDir = fullfile(tiaRoot, 'functions');
spiceDir = fullfile(tiaRoot, 'spice_interface');
spiceDataDir = fullfile(spiceDir, 'imported_ac_data');
resultsDir = fullfile(tiaRoot, 'results');
figuresDir = fullfile(tiaRoot, 'figures');

addpath(functionsDir);
addpath(spiceDir);
ensureDir(resultsDir);
ensureDir(figuresDir);

runId = char(datetime('now', 'TimeZone', 'UTC', ...
    'Format', 'yyyyMMdd_HHmmss''Z'''));

op27Files = [ ...
    "OP27_Cf3p455_Risky.csv"; ...
    "OP27_Cf10p_SafeCandidate.csv"; ...
    "OP27_Cf22p_Safe.csv"];

for iFile = 1:numel(op27Files)
    filePath = fullfile(spiceDataDir, char(op27Files(iFile)));
    if ~exist(filePath, 'file')
        error('run_06_compare_with_spice_example:MissingOP27Data', ...
            'Missing required OP27 LTspice CSV file: %s', filePath);
    end
end

metadataPath = fullfile(spiceDir, 'op27_smoke_test_metadata.csv');
if ~exist(metadataPath, 'file')
    error('run_06_compare_with_spice_example:MissingMetadata', ...
        'Missing OP27 smoke-test metadata file: %s', metadataPath);
end

metadata = readtable(metadataPath, ...
    'TextType', 'string', 'VariableNamingRule', 'preserve');

summaryAll = runOp27SmokeTestComparison( ...
    op27Files, metadata, spiceDataDir, resultsDir, figuresDir, runId);

writetable(summaryAll, fullfile(resultsDir, 'spice_comparison_summary.csv'));
updateValidationStatus(spiceDir, runId);
createSafeWindowFractionMap(resultsDir, figuresDir, runId);

fprintf('Round 4.5 OP27 LTspice smoke-test comparison complete.\n');
fprintf('Compared %d real OP27 macromodel AC cases.\n', height(summaryAll));
fprintf('Q3 SPICE requirement remains pending additional vendor macromodels.\n');

function summaryAll = runOp27SmokeTestComparison(op27Files, metadata, ...
        spiceDataDir, resultsDir, figuresDir, runId)
summaryAll = table();
combined = struct('case_id', {}, ...
    'f_Hz', {}, 'matlab_mag_dBohm', {}, 'spice_mag_dBohm', {});

for iFile = 1:numel(op27Files)
    fileName = char(op27Files(iFile));
    filePath = fullfile(spiceDataDir, fileName);
    spice = import_spice_ac_data(filePath);
    caseId = erase(string(fileName), ".csv");
    metadataRow = metadata(metadata.case_id == caseId, :);

    if height(metadataRow) ~= 1
        error('run_06_compare_with_spice_example:MetadataMatch', ...
            'Expected exactly one metadata row for %s.', caseId);
    end

    matlabCase = makeMatlabCase(spice, metadataRow);
    comparison = compare_tia_matlab_vs_spice(spice, matlabCase);
    comparison.summary_table.spice_source_file = ...
        "tia_extension/spice_interface/imported_ac_data/" + string(fileName);

    responseCsv = fullfile(resultsDir, ...
        ['spice_comparison_response_' char(caseId) '.csv']);
    writetable(comparison.response_table, responseCsv);

    comparison.summary_table.expected_region_from_filename = ...
        metadataRow.expected_region_from_filename;
    comparison.summary_table.spice_tool = metadataRow.spice_tool;
    comparison.summary_table.source_type = metadataRow.source_type;
    comparison.summary_table.interpolation_direction = ...
        "MATLAB behavioural response evaluated directly on LTspice frequency points; no SPICE smoothing or resampling.";
    summaryAll = [summaryAll; comparison.summary_table]; %#ok<AGROW>

    magFormats = createMagnitudeFigure( ...
        comparison.response_table, caseId, figuresDir);
    phaseFormats = createPhaseFigure( ...
        comparison.response_table, caseId, figuresDir);

    keyParameters = sprintf( ...
        'op amp=OP27; Rf=%.3g ohm; Cf=%.4g F; Cpd=%.3g F; supply=+15/-15 V; AC current=1 A; A0=%.3g; ft=%.6g Hz', ...
        matlabCase.Rf_ohm(1), matlabCase.Cf_F(1), matlabCase.Cpd_F(1), ...
        matlabCase.A0(1), matlabCase.ft_Hz(1));

    appendFigureManifest( ...
        fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
        string(['spice_compare_' char(caseId) '_magnitude.png']), ...
        "tia_extension/scripts/run_06_compare_with_spice_example.m", ...
        string(['tia_extension/results/spice_comparison_response_' char(caseId) '.csv']), ...
        string(keyParameters), ...
        "Magnitude comparison between MATLAB behavioural TIA response and real LTspice OP27 macromodel AC smoke-test data.", ...
        "real LTspice OP27 macromodel smoke-test comparison", ...
        string(strjoin(magFormats, ';')), ...
        string(runId));

    appendFigureManifest( ...
        fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
        string(['spice_compare_' char(caseId) '_phase.png']), ...
        "tia_extension/scripts/run_06_compare_with_spice_example.m", ...
        string(['tia_extension/results/spice_comparison_response_' char(caseId) '.csv']), ...
        string(keyParameters), ...
        "Phase comparison between MATLAB behavioural TIA response and real LTspice OP27 macromodel AC smoke-test data.", ...
        "real LTspice OP27 macromodel smoke-test comparison", ...
        string(strjoin(phaseFormats, ';')), ...
        string(runId));

    combined(end+1).case_id = caseId; %#ok<AGROW>
    combined(end).f_Hz = comparison.response_table.f_Hz;
    combined(end).matlab_mag_dBohm = ...
        comparison.response_table.matlab_mag_dBohm;
    combined(end).spice_mag_dBohm = ...
        comparison.response_table.spice_mag_dBohm;
end

combinedFormats = createCombinedMagnitudeFigure(combined, figuresDir);
appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "spice_compare_OP27_Cf_sweep_magnitude.png", ...
    "tia_extension/scripts/run_06_compare_with_spice_example.m", ...
    "tia_extension/results/spice_comparison_summary.csv", ...
    "OP27 LTspice smoke test; Rf=10k ohm; Cpd=10pF; Cf=[3.455,10,22] pF; supply=+15/-15 V; AC current=1 A", ...
    "Combined magnitude comparison showing that increasing Cf reduces OP27 LTspice peaking and bandwidth.", ...
    "real LTspice OP27 macromodel smoke-test comparison", ...
    string(strjoin(combinedFormats, ';')), ...
    string(runId));
end

function matlabCase = makeMatlabCase(spice, metadataRow)
if ~isfield(spice.metadata, 'A0') || ~isfield(spice.metadata, 'ft_Hz')
    error('run_06_compare_with_spice_example:MissingOpAmpMetadata', ...
        'OP27 CSV must include A0 and ft_Hz columns for behavioural comparison.');
end

matlabCase = table( ...
    metadataRow.Rf_ohm(1), metadataRow.Cf_F(1), metadataRow.Cpd_F(1), ...
    spice.metadata.A0, spice.metadata.ft_Hz, ...
    'VariableNames', {'Rf_ohm', 'Cf_F', 'Cpd_F', 'A0', 'ft_Hz'});
end

function formats = createMagnitudeFigure(responseTable, caseId, figuresDir)
fig = figure('Color', 'w', 'Name', ['OP27 magnitude ' char(caseId)]);
semilogx(responseTable.f_Hz, responseTable.matlab_mag_dBohm, ...
    'LineWidth', 1.5, 'DisplayName', 'MATLAB behavioural');
hold on;
semilogx(responseTable.f_Hz, responseTable.spice_mag_dBohm, ...
    'LineWidth', 1.5, 'DisplayName', 'LTspice OP27 macromodel');
grid on;
box on;
xlabel('Frequency (Hz)');
ylabel('Transimpedance magnitude (dB ohm)');
title(['OP27 SPICE macromodel smoke test: ' char(caseId)], ...
    'Interpreter', 'none');
legend('Location', 'southwest');
styleAxes(gca);
formats = exportFigureSet( ...
    fig, fullfile(figuresDir, ['spice_compare_' char(caseId) '_magnitude']));
close(fig);
end

function formats = createPhaseFigure(responseTable, caseId, figuresDir)
fig = figure('Color', 'w', 'Name', ['OP27 phase ' char(caseId)]);
semilogx(responseTable.f_Hz, responseTable.matlab_phase_deg, ...
    'LineWidth', 1.5, 'DisplayName', 'MATLAB behavioural');
hold on;
semilogx(responseTable.f_Hz, responseTable.spice_phase_deg, ...
    'LineWidth', 1.5, 'DisplayName', 'LTspice OP27 macromodel');
grid on;
box on;
xlabel('Frequency (Hz)');
ylabel('Inversion-removed phase (deg)');
title(['OP27 SPICE macromodel smoke test: ' char(caseId)], ...
    'Interpreter', 'none');
legend('Location', 'southwest');
styleAxes(gca);
formats = exportFigureSet( ...
    fig, fullfile(figuresDir, ['spice_compare_' char(caseId) '_phase']));
close(fig);
end

function formats = createCombinedMagnitudeFigure(combined, figuresDir)
fig = figure('Color', 'w', 'Name', 'OP27 Cf sweep magnitude');
for iCase = 1:numel(combined)
    semilogx(combined(iCase).f_Hz, combined(iCase).spice_mag_dBohm, ...
        'LineWidth', 1.5, ...
        'DisplayName', [char(combined(iCase).case_id) ' LTspice']);
    hold on;
end
grid on;
box on;
xlabel('Frequency (Hz)');
ylabel('Transimpedance magnitude (dB ohm)');
title('OP27 LTspice smoke test Cf sweep');
legend('Location', 'southwest', 'Interpreter', 'none');
styleAxes(gca);
formats = exportFigureSet( ...
    fig, fullfile(figuresDir, 'spice_compare_OP27_Cf_sweep_magnitude'));
close(fig);
end

function createSafeWindowFractionMap(resultsDir, figuresDir, runId)
sourceCsv = fullfile(resultsDir, 'tia_safe_window_fraction_map.csv');
pngPath = fullfile(figuresDir, 'tia_safe_window_fraction_map_Cpd_ft.png');
pdfPath = fullfile(figuresDir, 'tia_safe_window_fraction_map_Cpd_ft.pdf');
svgPath = fullfile(figuresDir, 'tia_safe_window_fraction_map_Cpd_ft.svg');
if exist(sourceCsv, 'file') && exist(pngPath, 'file') && ...
        exist(pdfPath, 'file') && exist(svgPath, 'file')
    fprintf('Leaving existing safe-window fraction map unchanged.\n');
    return;
end

sweepCsv = fullfile(resultsDir, 'tia_sweep_summary.csv');
if ~exist(sweepCsv, 'file')
    fprintf('Skipping safe-window fraction map; missing %s\n', sweepCsv);
    return;
end

sweep = readtable(sweepCsv, 'TextType', 'string');
Rf_values = unique(sweep.Rf_ohm);
Cpd_values = unique(sweep.Cpd_F);
ft_values = unique(sweep.ft_Hz);

rows = numel(Rf_values) * numel(Cpd_values) * numel(ft_values);
fractionMap = table( ...
    zeros(rows, 1), zeros(rows, 1), zeros(rows, 1), ...
    zeros(rows, 1), zeros(rows, 1), zeros(rows, 1), ...
    'VariableNames', { ...
        'Rf_ohm', 'Cpd_F', 'ft_Hz', ...
        'safe_fraction_over_Cf', 'safe_count', 'total_Cf_count'});

idx = 0;
for iRf = 1:numel(Rf_values)
    for iCpd = 1:numel(Cpd_values)
        for iFt = 1:numel(ft_values)
            idx = idx + 1;
            mask = sweep.Rf_ohm == Rf_values(iRf) & ...
                sweep.Cpd_F == Cpd_values(iCpd) & ...
                sweep.ft_Hz == ft_values(iFt);
            totalCount = sum(mask);
            safeCount = sum(sweep.classification(mask) == "Safe");

            fractionMap.Rf_ohm(idx) = Rf_values(iRf);
            fractionMap.Cpd_F(idx) = Cpd_values(iCpd);
            fractionMap.ft_Hz(idx) = ft_values(iFt);
            fractionMap.safe_fraction_over_Cf(idx) = safeCount / totalCount;
            fractionMap.safe_count(idx) = safeCount;
            fractionMap.total_Cf_count(idx) = totalCount;
        end
    end
end

writetable(fractionMap, sourceCsv);

fig = figure('Color', 'w', 'Name', 'TIA safe-window fraction map');
tiledlayout(1, numel(Rf_values), 'Padding', 'compact', ...
    'TileSpacing', 'compact');

for iRf = 1:numel(Rf_values)
    nexttile;
    mapMatrix = NaN(numel(Cpd_values), numel(ft_values));
    for iCpd = 1:numel(Cpd_values)
        for iFt = 1:numel(ft_values)
            mask = fractionMap.Rf_ohm == Rf_values(iRf) & ...
                fractionMap.Cpd_F == Cpd_values(iCpd) & ...
                fractionMap.ft_Hz == ft_values(iFt);
            mapMatrix(iCpd, iFt) = fractionMap.safe_fraction_over_Cf(mask);
        end
    end

    imagesc(log10(ft_values), Cpd_values*1e12, mapMatrix);
    set(gca, 'YDir', 'normal');
    caxis([0 1]);
    xticks(log10([1e6 1e7 1e8]));
    xticklabels({'10^6', '10^7', '10^8'});
    yticks(Cpd_values*1e12);
    xlabel('ft (Hz)');
    if iRf == 1
        ylabel('Cpd (pF)');
    end
    title(sprintf('Rf = %.0g ohm', Rf_values(iRf)));
    styleAxes(gca);
end

colormap(parula);
cb = colorbar;
cb.Layout.Tile = 'east';
cb.Label.String = 'Safe fraction over Cf sweep';
sgtitle('TIA safe-window fraction over Cf values');
formats = exportFigureSet( ...
    fig, fullfile(figuresDir, 'tia_safe_window_fraction_map_Cpd_ft'));
close(fig);

appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "tia_safe_window_fraction_map_Cpd_ft.png", ...
    "tia_extension/scripts/run_06_compare_with_spice_example.m", ...
    "tia_extension/results/tia_safe_window_fraction_map.csv", ...
    "Rf=[10e3,100e3,1e6] ohm; Cpd=[1,5,10,20] pF; Cf=logspace(-13,-11,40) F; ft=logspace(6,8,40) Hz; A0=1e5", ...
    "MATLAB behavioural design-map evidence showing the fraction of Cf values classified as Safe for each Rf, Cpd, and ft point. This is not SPICE validation.", ...
    "clean MATLAB behavioural sweep", ...
    string(strjoin(formats, ';')), ...
    string(runId));
end

function updateValidationStatus(spiceDir, runId)
statusPath = fullfile(spiceDir, 'spice_validation_status.md');
fid = fopen(statusPath, 'w');
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, '# SPICE Validation Status\n\n');
fprintf(fid, 'Last Round 4.5 workflow run: `%s`\n\n', runId);
fprintf(fid, '- Real SPICE data used: **YES**\n');
fprintf(fid, '- Vendor op-amp macromodels compared: **1**\n');
fprintf(fid, '- Op-amp model: **OP27**\n');
fprintf(fid, '- Number of cases: **3 feedback capacitor values**\n');
fprintf(fid, '- Status: **single-model real SPICE smoke test completed**\n');
fprintf(fid, '- Q3 SPICE requirement: **still pending**\n');
fprintf(fid, '- Reason: Q3 prototype requires additional vendor op-amp macromodels, ideally at least 2-3 total models.\n');
fprintf(fid, '- Hardware measurement performed: **NO**\n\n');
fprintf(fid, 'This is a SPICE macromodel comparison, not hardware validation.\n\n');
fprintf(fid, 'Correct status: Single-model real SPICE smoke test completed; Q3 SPICE requirement still pending additional vendor macromodels.\n');
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
            lines{iLine} = [lines{iLine} ',round2-baseline'];
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
