%RUN_03_SWEEP_CF_FOR_PEAKING_BANDWIDTH Sweep Cf for bandwidth and peaking.
%
% This script saves source data before plotting and generates publication-
% ready bandwidth-vs-Cf and peaking-vs-Cf figures. It does not run SPICE,
% hardware measurement, or noise analysis.

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

Rf = 100e3;
Cpd = 5e-12;
A0 = 1e5;
Cf_values = logspace(-13, -11, 40).';
ft_values = [1e6; 1e7; 1e8];
f_Hz = logspace(1, 10, 700).';

rows = numel(Cf_values) * numel(ft_values);
sweep = table( ...
    zeros(rows, 1), zeros(rows, 1), zeros(rows, 1), zeros(rows, 1), ...
    zeros(rows, 1), zeros(rows, 1), zeros(rows, 1), zeros(rows, 1), ...
    zeros(rows, 1), zeros(rows, 1), strings(rows, 1), zeros(rows, 1), ...
    'VariableNames', { ...
        'Rf_ohm', 'Cpd_F', 'Cf_F', 'A0', 'ft_Hz', ...
        'fc_ideal_Hz', 'gbw_margin_index', 'bandwidth_Hz', ...
        'peaking_dB', 'peaking_frequency_Hz', ...
        'classification', 'classification_code'});

idx = 0;
for iFt = 1:numel(ft_values)
    for iCf = 1:numel(Cf_values)
        idx = idx + 1;

        response = tia_response( ...
            f_Hz, Rf, Cf_values(iCf), Cpd, A0, ft_values(iFt));
        metrics = extract_tia_metrics( ...
            response.f_Hz, response.Zt_nonideal, Rf, response.fc_ideal_Hz);
        classification = classify_tia_design_region(metrics);

        sweep.Rf_ohm(idx) = Rf;
        sweep.Cpd_F(idx) = Cpd;
        sweep.Cf_F(idx) = Cf_values(iCf);
        sweep.A0(idx) = A0;
        sweep.ft_Hz(idx) = ft_values(iFt);
        sweep.fc_ideal_Hz(idx) = response.fc_ideal_Hz;
        sweep.gbw_margin_index(idx) = response.gbw_margin_index;
        sweep.bandwidth_Hz(idx) = metrics.bandwidth_Hz;
        sweep.peaking_dB(idx) = metrics.peaking_dB;
        sweep.peaking_frequency_Hz(idx) = metrics.peaking_frequency_Hz;
        sweep.classification(idx) = string(classification.region_label);
        sweep.classification_code(idx) = classification.region_code;
    end
end

sourceCsv = fullfile(resultsDir, 'tia_sweep_Cf_peaking_bandwidth.csv');
writetable(sweep, sourceCsv);

bandwidthFig = figure('Color', 'w', 'Name', 'TIA bandwidth vs Cf');
hold on;
for iFt = 1:numel(ft_values)
    mask = sweep.ft_Hz == ft_values(iFt);
    loglog(sweep.Cf_F(mask), sweep.bandwidth_Hz(mask), ...
        'LineWidth', 1.5, 'Marker', 'o', 'MarkerSize', 4, ...
        'DisplayName', sprintf('ft = %.0e Hz', ft_values(iFt)));
end
grid on;
box on;
xlabel('Feedback capacitance Cf (F)');
ylabel('-3 dB bandwidth (Hz)');
title('TIA bandwidth versus feedback capacitance');
legend('Location', 'southwest');
styleAxes(gca);
bandwidthFormats = exportFigureSet( ...
    bandwidthFig, fullfile(figuresDir, 'tia_bandwidth_vs_Cf'));
close(bandwidthFig);

peakingFig = figure('Color', 'w', 'Name', 'TIA peaking vs Cf');
hold on;
for iFt = 1:numel(ft_values)
    mask = sweep.ft_Hz == ft_values(iFt);
    semilogx(sweep.Cf_F(mask), sweep.peaking_dB(mask), ...
        'LineWidth', 1.5, 'Marker', 'o', 'MarkerSize', 4, ...
        'DisplayName', sprintf('ft = %.0e Hz', ft_values(iFt)));
end
yline(1, '--', 'Safe threshold', 'HandleVisibility', 'off');
yline(3, '--', 'Risky threshold', 'HandleVisibility', 'off');
grid on;
box on;
xlabel('Feedback capacitance Cf (F)');
ylabel('Gain peaking (dB)');
title('TIA peaking versus feedback capacitance');
legend('Location', 'northwest');
styleAxes(gca);
peakingFormats = exportFigureSet( ...
    peakingFig, fullfile(figuresDir, 'tia_peaking_vs_Cf'));
close(peakingFig);

keyParameters = sprintf( ...
    'Rf=%.3g ohm; Cpd=%.3g F; A0=%.3g; Cf=logspace(-13,-11,40); ft=[1e6,1e7,1e8] Hz', ...
    Rf, Cpd, A0);

appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "tia_bandwidth_vs_Cf.png", ...
    "tia_extension/scripts/run_03_sweep_Cf_for_peaking_bandwidth.m", ...
    "tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv", ...
    string(keyParameters), ...
    "Clean MATLAB behavioural TIA sweep showing -3 dB bandwidth versus feedback capacitance for selected ft values.", ...
    "clean MATLAB behavioural sweep", ...
    string(strjoin(bandwidthFormats, ';')), ...
    string(runId));

appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "tia_peaking_vs_Cf.png", ...
    "tia_extension/scripts/run_03_sweep_Cf_for_peaking_bandwidth.m", ...
    "tia_extension/results/tia_sweep_Cf_peaking_bandwidth.csv", ...
    string(keyParameters), ...
    "Clean MATLAB behavioural TIA sweep showing gain peaking versus feedback capacitance for selected ft values.", ...
    "clean MATLAB behavioural sweep", ...
    string(strjoin(peakingFormats, ';')), ...
    string(runId));

fprintf('TIA Cf sweep complete: %s\n', sourceCsv);

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
