%RUN_05_DESIGN_REGION_MAP_TIA Build TIA design map and SPICE candidates.
%
% This script consumes tia_sweep_summary.csv, writes a design-region map,
% selects representative safe/marginal/risky cases for later SPICE
% macromodel comparison, and generates publication-ready figures. It does
% not run SPICE, hardware measurement, or noise analysis.

scriptDir = fileparts(mfilename('fullpath'));
tiaRoot = fileparts(scriptDir);
functionsDir = fullfile(tiaRoot, 'functions');
resultsDir = fullfile(tiaRoot, 'results');
figuresDir = fullfile(tiaRoot, 'figures');

addpath(functionsDir);
ensureDir(resultsDir);
ensureDir(figuresDir);

runId = char(datetime('now', 'TimeZone', 'UTC', ...
    'Format', 'yyyyMMdd_HHmmss''Z'''));

summaryCsv = fullfile(resultsDir, 'tia_sweep_summary.csv');
if ~exist(summaryCsv, 'file')
    error('run_05_design_region_map_tia:MissingSweepSummary', ...
        'Missing %s. Run run_04_sweep_Cpd_and_ft.m first.', summaryCsv);
end

sweep = readtable(summaryCsv, 'TextType', 'string');

Rf_values = unique(sweep.Rf_ohm);
Cpd_values = unique(sweep.Cpd_F);
ft_values = unique(sweep.ft_Hz);

mapRows = numel(Rf_values) * numel(Cpd_values) * numel(ft_values);
designMap = table( ...
    zeros(mapRows, 1), zeros(mapRows, 1), zeros(mapRows, 1), ...
    zeros(mapRows, 1), zeros(mapRows, 1), zeros(mapRows, 1), ...
    zeros(mapRows, 1), strings(mapRows, 1), zeros(mapRows, 1), ...
    'VariableNames', { ...
        'Rf_ohm', 'Cpd_F', 'ft_Hz', 'selected_Cf_F', ...
        'best_peaking_dB', 'bandwidth_Hz', 'phase_at_bandwidth_deg', ...
        'classification', 'classification_code'});

idx = 0;
for iRf = 1:numel(Rf_values)
    for iCpd = 1:numel(Cpd_values)
        for iFt = 1:numel(ft_values)
            idx = idx + 1;

            mask = sweep.Rf_ohm == Rf_values(iRf) & ...
                sweep.Cpd_F == Cpd_values(iCpd) & ...
                sweep.ft_Hz == ft_values(iFt);
            candidates = sweep(mask, :);
            [~, bestIdx] = min(candidates.classification_code*1000 + ...
                max(candidates.peaking_dB, 0));
            selected = candidates(bestIdx, :);

            designMap.Rf_ohm(idx) = selected.Rf_ohm;
            designMap.Cpd_F(idx) = selected.Cpd_F;
            designMap.ft_Hz(idx) = selected.ft_Hz;
            designMap.selected_Cf_F(idx) = selected.Cf_F;
            designMap.best_peaking_dB(idx) = selected.peaking_dB;
            designMap.bandwidth_Hz(idx) = selected.bandwidth_Hz;
            designMap.phase_at_bandwidth_deg(idx) = ...
                selected.phase_at_bandwidth_deg;
            designMap.classification(idx) = selected.classification;
            designMap.classification_code(idx) = selected.classification_code;
        end
    end
end

designMapCsv = fullfile(resultsDir, 'tia_design_region_map.csv');
writetable(designMap, designMapCsv);

spiceCandidates = selectSpiceCandidateCases(sweep);
spiceCandidatesCsv = fullfile(resultsDir, 'spice_candidate_cases.csv');
writetable(spiceCandidates, spiceCandidatesCsv);

mapFig = figure('Color', 'w', 'Name', 'TIA design-region map');
tiledlayout(1, numel(Rf_values), 'Padding', 'compact', 'TileSpacing', 'compact');

for iRf = 1:numel(Rf_values)
    nexttile;
    codeMatrix = NaN(numel(Cpd_values), numel(ft_values));
    for iCpd = 1:numel(Cpd_values)
        for iFt = 1:numel(ft_values)
            mask = designMap.Rf_ohm == Rf_values(iRf) & ...
                designMap.Cpd_F == Cpd_values(iCpd) & ...
                designMap.ft_Hz == ft_values(iFt);
            codeMatrix(iCpd, iFt) = designMap.classification_code(mask);
        end
    end

    imagesc(log10(ft_values), Cpd_values*1e12, codeMatrix);
    set(gca, 'YDir', 'normal');
    caxis([1 3]);
    colormap(gca, [0.20 0.62 0.32; 0.95 0.72 0.24; 0.82 0.25 0.22]);
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

cb = colorbar;
cb.Layout.Tile = 'east';
cb.Ticks = [1 2 3];
cb.TickLabels = {'Safe', 'Marginal', 'Risky'};
sgtitle('TIA project-defined design-region map');
mapFormats = exportFigureSet( ...
    mapFig, fullfile(figuresDir, 'tia_design_region_map_Cpd_ft'));
close(mapFig);

responseSourceCsv = fullfile(resultsDir, 'tia_representative_responses.csv');
representativeFormats = createRepresentativeResponseFigure( ...
    spiceCandidates, responseSourceCsv, figuresDir);

mapKeyParameters = ...
    "Rf=[10e3,100e3,1e6] ohm; Cpd=[1,5,10,20] pF; Cf=logspace(-13,-11,40) F; ft=logspace(6,8,40) Hz; A0=1e5; map selects best available Cf by project-defined classification then peaking";

appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "tia_design_region_map_Cpd_ft.png", ...
    "tia_extension/scripts/run_05_design_region_map_tia.m", ...
    "tia_extension/results/tia_design_region_map.csv", ...
    mapKeyParameters, ...
    "Project-defined TIA design-region map over photodiode capacitance and op-amp ft. Each tile selects the best available Cf from the behavioural sweep; full sweep data remains in tia_sweep_summary.csv.", ...
    "clean MATLAB behavioural sweep", ...
    string(strjoin(mapFormats, ';')), ...
    string(runId));

appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "tia_representative_region_responses.png", ...
    "tia_extension/scripts/run_05_design_region_map_tia.m", ...
    "tia_extension/results/tia_representative_responses.csv", ...
    "Representative cases selected from spice_candidate_cases.csv", ...
    "Representative clean MATLAB behavioural TIA responses for selected safe, marginal, and risky cases where available.", ...
    "clean MATLAB behavioural sweep", ...
    string(strjoin(representativeFormats, ';')), ...
    string(runId));

writeSweepSummary( ...
    fullfile(tiaRoot, 'sweep_summary.md'), ...
    sweep, designMap, spiceCandidates, runId);

fprintf('TIA design-region map complete: %s\n', designMapCsv);
fprintf('SPICE candidate cases: %s\n', spiceCandidatesCsv);

function ensureDir(pathName)
if ~exist(pathName, 'dir')
    mkdir(pathName);
end
end

function candidates = selectSpiceCandidateCases(sweep)
regions = ["Safe"; "Marginal"; "Risky"];
targets = [0.5; 2.0; 4.0];
candidates = table();

for iRegion = 1:numel(regions)
    mask = sweep.classification == regions(iRegion);
    regionRows = sweep(mask, :);
    if isempty(regionRows)
        continue;
    end

    [~, idx] = min(abs(regionRows.peaking_dB - targets(iRegion)));
    selected = regionRows(idx, :);
    selected.selection_reason = ...
        "Representative " + lower(regions(iRegion)) + ...
        " behavioural case for later SPICE macromodel comparison.";
    candidates = [candidates; selected]; %#ok<AGROW>
end
end

function formats = createRepresentativeResponseFigure(cases, sourceCsv, figuresDir)
f_Hz = logspace(1, 10, 700).';
responseRows = table();

fig = figure('Color', 'w', 'Name', 'Representative TIA responses');
hold on;

for iCase = 1:height(cases)
    response = tia_response( ...
        f_Hz, cases.Rf_ohm(iCase), cases.Cf_F(iCase), ...
        cases.Cpd_F(iCase), cases.A0(iCase), cases.ft_Hz(iCase));

    magNorm_dB = 20*log10(abs(response.G_nonideal) / cases.Rf_ohm(iCase));
    caseLabel = sprintf('%s: Rf=%.0g, Cpd=%.0g pF, Cf=%.2g F, ft=%.0e Hz', ...
        cases.classification(iCase), cases.Rf_ohm(iCase), ...
        cases.Cpd_F(iCase)*1e12, cases.Cf_F(iCase), ...
        cases.ft_Hz(iCase));

    semilogx(f_Hz, magNorm_dB, 'LineWidth', 1.5, ...
        'DisplayName', caseLabel);

    responseRows = [responseRows; table( ... %#ok<AGROW>
        repmat(cases.classification(iCase), numel(f_Hz), 1), ...
        repmat(cases.Rf_ohm(iCase), numel(f_Hz), 1), ...
        repmat(cases.Cpd_F(iCase), numel(f_Hz), 1), ...
        repmat(cases.Cf_F(iCase), numel(f_Hz), 1), ...
        repmat(cases.ft_Hz(iCase), numel(f_Hz), 1), ...
        f_Hz, magNorm_dB, ...
        'VariableNames', {'classification', 'Rf_ohm', 'Cpd_F', ...
        'Cf_F', 'ft_Hz', 'f_Hz', 'magnitude_normalized_dB'})];
end

writetable(responseRows, sourceCsv);

grid on;
box on;
xlabel('Frequency (Hz)');
ylabel('Magnitude relative to Rf (dB)');
title('Representative TIA behavioural responses');
legend('Location', 'southwest', 'Interpreter', 'none');
styleAxes(gca);
formats = exportFigureSet( ...
    fig, fullfile(figuresDir, 'tia_representative_region_responses'));
close(fig);
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

function writeSweepSummary(summaryPath, sweep, designMap, spiceCandidates, runId)
regionCounts = groupsummary(sweep, 'classification');
mapCounts = groupsummary(designMap, 'classification');
invalidCount = sum(~sweep.valid_bandwidth);
maxPeaking = max(sweep.peaking_dB);

fid = fopen(summaryPath, 'w');
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, '# TIA Sweep Summary\n\n');
fprintf(fid, 'Run identifier: `%s`\n\n', runId);
fprintf(fid, 'This summary reports clean MATLAB behavioural sweep results only. ');
fprintf(fid, 'No SPICE comparison, noise analysis, or hardware measurement is included.\n\n');
fprintf(fid, 'The safe / marginal / risky labels use project-defined engineering criteria, not universal design rules.\n\n');

fprintf(fid, '## Sweep Ranges\n\n');
fprintf(fid, '- `Rf = [10e3, 100e3, 1e6]` ohm\n');
fprintf(fid, '- `Cpd = [1e-12, 5e-12, 10e-12, 20e-12]` F\n');
fprintf(fid, '- `Cf = logspace(-13, -11, 40)` F\n');
fprintf(fid, '- `ft = logspace(6, 8, 40)` Hz\n');
fprintf(fid, '- `A0 = 1e5`\n\n');

fprintf(fid, '## Full Sweep Classification Counts\n\n');
writeCountList(fid, regionCounts);

fprintf(fid, '\n## Design Map Classification Counts\n\n');
writeCountList(fid, mapCounts);

fprintf(fid, '\n## Data Integrity Notes\n\n');
fprintf(fid, '- Invalid bandwidth extractions in full sweep: `%d`.\n', invalidCount);
fprintf(fid, '- Maximum extracted peaking in full sweep: `%.3f dB`.\n', maxPeaking);
fprintf(fid, '- The design-region map selects the best available `Cf` for each `Rf`, `Cpd`, and `ft` point by project-defined class and then peaking.\n');
fprintf(fid, '- Poor and unexpected cases are retained in `tia_extension/results/tia_sweep_summary.csv`.\n');

if maxPeaking > 3
    fprintf(fid, '- Risky high-peaking cases are present and retained for later review.\n');
else
    fprintf(fid, '- No cases exceeded the 3 dB peaking threshold in this sweep.\n');
end

fprintf(fid, '\n## SPICE Candidate Cases\n\n');
fprintf(fid, 'Representative cases were written to `tia_extension/results/spice_candidate_cases.csv` for later SPICE macromodel comparison planning.\n\n');
for iCase = 1:height(spiceCandidates)
    fprintf(fid, '- `%s`: Rf = %.3g ohm, Cpd = %.3g F, Cf = %.3g F, ft = %.3g Hz, peaking = %.3f dB.\n', ...
        spiceCandidates.classification(iCase), ...
        spiceCandidates.Rf_ohm(iCase), ...
        spiceCandidates.Cpd_F(iCase), ...
        spiceCandidates.Cf_F(iCase), ...
        spiceCandidates.ft_Hz(iCase), ...
        spiceCandidates.peaking_dB(iCase));
end

fprintf(fid, '\n## Generated Figures\n\n');
fprintf(fid, '- `tia_extension/figures/tia_bandwidth_vs_Cf.*`\n');
fprintf(fid, '- `tia_extension/figures/tia_peaking_vs_Cf.*`\n');
fprintf(fid, '- `tia_extension/figures/tia_design_region_map_Cpd_ft.*`\n');
fprintf(fid, '- `tia_extension/figures/tia_representative_region_responses.*`\n');
end

function writeCountList(fid, counts)
for iRow = 1:height(counts)
    fprintf(fid, '- `%s`: `%d`\n', counts.classification(iRow), counts.GroupCount(iRow));
end
end
