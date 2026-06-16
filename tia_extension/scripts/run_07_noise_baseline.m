%RUN_07_NOISE_BASELINE Generate first-pass TIA noise baseline outputs.
%
% This script saves CSV source data before plotting. It estimates major
% output-noise contributions from a MATLAB behavioural model only; it does
% not run SPICE, hardware measurement, or experimental noise validation.

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

params = struct();
params.Rf = 100e3;
params.Cf = 1e-12;
params.Cpd = 2e-12;
params.A0 = 1e5;
params.ft_Hz = 100e6;
params.f_Hz = logspace(0, 9, 2500).';

noiseParams = struct();
noiseParams.temperature_K = 300;
noiseParams.opamp_voltage_noise_V_per_sqrtHz = 3e-9;
noiseParams.opamp_current_noise_A_per_sqrtHz = 0.4e-12;
noiseParams.include_photodiode_shot_noise = true;
noiseParams.photodiode_dc_current_A = 1e-9;
noiseParams.reference_frequency_Hz = 1e3;

noise = tia_noise_first_pass( ...
    params.f_Hz, params.Rf, params.Cf, params.Cpd, ...
    params.A0, params.ft_Hz, noiseParams);

caseId = "baseline_Rf100k_Cf1p_Cpd2p";
summary = summarise_noise_contributions(noise, caseId);
summary.source_script(:) = "tia_extension/scripts/run_07_noise_baseline.m";

sourceCsv = fullfile(resultsDir, 'noise_baseline_summary.csv');
writetable(summary, sourceCsv);

componentMask = summary.component ~= "total_quadrature";
plotTable = summary(componentMask, :);
labels = [ ...
    "Rf thermal"; ...
    "Op-amp en"; ...
    "Op-amp in"; ...
    "PD shot"];
noise_uV_rms = plotTable.integrated_output_noise_V_rms * 1e6;

fig = figure('Color', 'w', 'Name', 'TIA first-pass noise contributions');
x = 1:numel(labels);
semilogy(x, noise_uV_rms, 'o', ...
    'LineWidth', 1.5, 'MarkerSize', 8, ...
    'MarkerFaceColor', [0.17 0.42 0.68], ...
    'MarkerEdgeColor', [0.10 0.25 0.40], ...
    'Color', [0.17 0.42 0.68]);
xlim([0.5 numel(labels)+0.5]);
ylim([min(noise_uV_rms)*0.7 max(noise_uV_rms)*1.6]);
xticks(x);
xticklabels(labels);
set(gca, 'YScale', 'log');
grid on;
box on;
ylabel('Integrated output noise (uV rms)');
title('First-pass TIA noise contribution estimate');
styleAxes(gca);
xtickangle(25);
formats = exportFigureSet( ...
    fig, fullfile(figuresDir, 'tia_noise_contribution_baseline'));
close(fig);

keyParameters = sprintf( ...
    ['Rf=%.3g ohm; Cf=%.3g F; Cpd=%.3g F; A0=%.3g; ft=%.3g Hz; ' ...
     'temperature=%.3g K; en=%.3g V/sqrtHz; in=%.3g A/sqrtHz; ' ...
     'photodiode shot enabled at Idc=%.3g A; ENBW approx=(pi/2)*bandwidth'], ...
    params.Rf, params.Cf, params.Cpd, params.A0, params.ft_Hz, ...
    noiseParams.temperature_K, ...
    noiseParams.opamp_voltage_noise_V_per_sqrtHz, ...
    noiseParams.opamp_current_noise_A_per_sqrtHz, ...
    noiseParams.photodiode_dc_current_A);

appendFigureManifest( ...
    fullfile(figuresDir, 'figure_manifest_tia.csv'), ...
    "tia_noise_contribution_baseline.png", ...
    "tia_extension/scripts/run_07_noise_baseline.m", ...
    "tia_extension/results/noise_baseline_summary.csv", ...
    string(keyParameters), ...
    "First-pass MATLAB behavioural TIA estimate of integrated output-noise contributions. This is not measured noise or experimental validation.", ...
    "first-pass MATLAB behavioural noise estimate", ...
    string(strjoin(formats, ';')), ...
    string(runId));

fprintf('Round 5 noise baseline complete.\n');
fprintf('Summary data: %s\n', sourceCsv);
fprintf('Total integrated output noise: %.6g V rms\n', ...
    noise.total_integrated_output_noise_V_rms);
fprintf('Input-referred current noise at %.6g Hz: %.6g A/sqrt(Hz)\n', ...
    noise.reference_frequency_Hz, ...
    noise.input_referred_current_noise_density_reference_A_per_sqrtHz);

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
