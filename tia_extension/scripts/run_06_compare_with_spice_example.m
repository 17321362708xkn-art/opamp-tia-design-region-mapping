%RUN_06_COMPARE_WITH_SPICE_EXAMPLE Prepare or run SPICE comparison workflow.
%
% If real exported SPICE AC CSV files are present in
% tia_extension/spice_interface/imported_ac_data, this script imports and
% compares them against matching MATLAB behavioural TIA cases.
%
% If no real SPICE data is present, it does not create fake data or fake
% comparison figures. It writes a pending status and generates only an
% auxiliary MATLAB behavioural safe-window fraction map.

scriptDir = fileparts(mfilename('fullpath'));
tiaRoot = fileparts(scriptDir);
functionsDir = fullfile(tiaRoot, 'functions');
spiceDir = fullfile(tiaRoot, 'spice_interface');
spiceDataDir = fullfile(spiceDir, 'imported_ac_data');
resultsDir = fullfile(tiaRoot, 'results');
figuresDir = fullfile(tiaRoot, 'figures');

addpath(functionsDir);
addpath(spiceDir);
ensureDir(spiceDataDir);
ensureDir(resultsDir);
ensureDir(figuresDir);

runId = char(datetime('now', 'TimeZone', 'UTC', ...
    'Format', 'yyyyMMdd_HHmmss''Z'''));

candidateCsv = fullfile(resultsDir, 'spice_candidate_cases.csv');
if ~exist(candidateCsv, 'file')
    error('run_06_compare_with_spice_example:MissingCandidates', ...
        'Missing %s. Run Round 3 sweep workflow first.', candidateCsv);
end

candidates = readtable(candidateCsv, ...
    'TextType', 'string', 'VariableNamingRule', 'preserve');

spiceFiles = dir(fullfile(spiceDataDir, '*.csv'));
usedRealSpiceData = ~isempty(spiceFiles);

if usedRealSpiceData
    runRealSpiceComparison( ...
        spiceFiles, candidates, spiceDataDir, resultsDir, figuresDir, runId);
    updateValidationStatus(spiceDir, true, numel(spiceFiles), runId);
else
    updateValidationStatus(spiceDir, false, 0, runId);
    fprintf('No real exported SPICE CSV files found in %s\n', spiceDataDir);
    fprintf('SPICE comparison status remains pending.\n');
end

createSafeWindowFractionMap(resultsDir, figuresDir, runId);

fprintf('Round 4 SPICE workflow script complete.\n');

function runRealSpiceComparison(spiceFiles, candidates, spiceDataDir, ...
        resultsDir, figuresDir, runId)
summaryAll = table();

for iFile = 1:numel(spiceFiles)
    filePath = fullfile(spiceDataDir, spiceFiles(iFile).name);
    spice = import_spice_ac_data(filePath);
    caseRow = matchCandidateCase(spice, candidates);

    comparison = compare_tia_matlab_vs_spice(spice, caseRow);

    safeName = matlab.lang.makeValidName( ...
        erase(spiceFiles(iFile).name, ".csv"));
    responseCsv = fullfile(resultsDir, ...
        ['spice_comparison_response_' safeName '.csv']);
    writetable(comparison.response_table, responseCsv);

    summaryAll = [summaryAll; comparison.summary_table]; %#ok<AGROW>

    magFig = figure('Color', 'w', 'Name', ['SPICE magnitude ' safeName]);
    semilogx(comparison.response_table.f_Hz, ...
        comparison.response_table.matlab_mag_dBohm, ...
        'LineWidth', 1.5, 'DisplayName', 'MATLAB behavioural');
    hold on;
    semilogx(comparison.response_table.f_Hz, ...
        comparison.response_table.spice_mag_dBohm, ...
        'LineWidth', 1.5, 'DisplayName', 'SPICE macromodel');
    grid on;
    box on;
    xlabel('Frequency (Hz)');
    ylabel('Transimpedance magnitude (dB ohm)');
    title('MATLAB behavioural vs SPICE macromodel magnitude');
    legend('Location', 'southwest');
    styleAxes(gca);
    magBase = fullfile(figuresDir, ['spice_compare_' safeName '_magnitude']);
    magFormats = exportFigureSet(magFig, magBase);
    close(magFig);

    phaseFig = figure('Color', 'w', 'Name', ['SPICE phase ' safeName]);
    semilogx(comparison.response_table.f_Hz, ...
        comparison.response_table.matlab_phase_deg, ...
        'LineWidth', 1.5, 'DisplayName', 'MATLAB behavioural');
    hold on;
    semilogx(comparison.response_table.f_Hz, ...
        comparison.response_table.spice_phase_deg, ...
        'LineWidth', 1.5, 'DisplayName', 'SPICE macromodel');
    grid on;
    box on;
    xlabel('Frequency (Hz)');
    ylabel('Inversion-removed phase (deg)');
    title('MATLAB behavioural vs SPICE macromodel phase');
    legend('Location', 'southwest');
    styleAxes(gca);
    phaseBase = fullfile(figuresDir, ['spice_compare_' safeName '_phase']);
    phaseFormats = exportFigureSet(phaseFig, phaseBase);
    close(phaseFig);

    keyParameters = sprintf( ...
        'Rf=%.3g ohm; Cf=%.3g F; Cpd=%.3g F; A0=%.3g; ft=%.3g Hz; source=%s', ...
        caseRow.Rf_ohm(1), caseRow.Cf_F(1), caseRow.Cpd_F(1), ...
        caseRow.A0(1), caseRow.ft_Hz(1), spiceFiles(iFile).name);

    appendFigureManifest( ...
        fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
        string(['spice_compare_' safeName '_magnitude.png']), ...
        "tia_extension/scripts/run_06_compare_with_spice_example.m", ...
        string(['tia_extension/results/spice_comparison_response_' safeName '.csv']), ...
        string(keyParameters), ...
        "MATLAB behavioural TIA magnitude response compared with real exported SPICE macromodel AC data.", ...
        "SPICE macromodel comparison", ...
        string(strjoin(magFormats, ';')), ...
        string(runId));

    appendFigureManifest( ...
        fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
        string(['spice_compare_' safeName '_phase.png']), ...
        "tia_extension/scripts/run_06_compare_with_spice_example.m", ...
        string(['tia_extension/results/spice_comparison_response_' safeName '.csv']), ...
        string(keyParameters), ...
        "MATLAB behavioural TIA phase response compared with real exported SPICE macromodel AC data.", ...
        "SPICE macromodel comparison", ...
        string(strjoin(phaseFormats, ';')), ...
        string(runId));
end

writetable(summaryAll, fullfile(resultsDir, 'spice_comparison_summary.csv'));
end

function caseRow = matchCandidateCase(spice, candidates)
if ~isfield(spice.metadata, 'source_has_case_parameters') || ...
        ~spice.metadata.source_has_case_parameters
    error('run_06_compare_with_spice_example:MissingCaseMetadata', ...
        ['SPICE export must include Rf_ohm, Cf_F, Cpd_F, and ft_Hz ' ...
         'metadata columns to match a MATLAB behavioural candidate.']);
end

score = abs(log(candidates.Rf_ohm / spice.metadata.Rf_ohm)) + ...
    abs(log(candidates.Cf_F / spice.metadata.Cf_F)) + ...
    abs(log(candidates.Cpd_F / spice.metadata.Cpd_F)) + ...
    abs(log(candidates.ft_Hz / spice.metadata.ft_Hz));
[~, idx] = min(score);
caseRow = candidates(idx, :);
end

function createSafeWindowFractionMap(resultsDir, figuresDir, runId)
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

sourceCsv = fullfile(resultsDir, 'tia_safe_window_fraction_map.csv');
writetable(fractionMap, sourceCsv);

fig = figure('Color', 'w', 'Name', 'TIA safe-window fraction map');
tiledlayout(1, numel(Rf_values), 'Padding', 'compact', 'TileSpacing', 'compact');

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

function updateValidationStatus(spiceDir, usedRealData, modelCount, runId)
statusPath = fullfile(spiceDir, 'spice_validation_status.md');
fid = fopen(statusPath, 'w');
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, '# SPICE Validation Status\n\n');
fprintf(fid, 'Last Round 4 workflow run: `%s`\n\n', runId);

if usedRealData
    fprintf(fid, 'Status: **SPICE MACROMODEL DATA IMPORTED**\n\n');
    fprintf(fid, 'Imported SPICE CSV files: `%d`\n\n', modelCount);
    fprintf(fid, 'This is model-level SPICE macromodel comparison, not hardware validation.\n');
else
    fprintf(fid, 'Status: **PENDING REAL EXPORTED SPICE DATA**\n\n');
    fprintf(fid, 'No real vendor op-amp SPICE macromodel AC export was found in `tia_extension/spice_interface/imported_ac_data/`.\n\n');
    fprintf(fid, 'The Q3 SPICE comparison requirement is therefore **pending**, not satisfied.\n\n');
    fprintf(fid, 'No SPICE validation claim is made.\n\n');
    fprintf(fid, 'No hardware measurement claim is made.\n');
end
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
