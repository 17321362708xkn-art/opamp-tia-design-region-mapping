%% run_15_day25_error_vs_M_plots.m
% Week 4 Day 25
% Purpose:
%   Create clean error-vs-M plots for the clean non-ideal sweep results.
%
% Outputs:
%   1. day25_abs_cutoff_error_vs_M.png
%   2. day25_abs_phase_deviation_vs_M.png
%   3. day25_abs_gain_error_vs_M.png
%   4. day25_error_vs_M_plot_summary.md
%
% Important:
%   M is a GBW margin index, not a stability margin.
%   Day 25 does not create the final design map.

clear; clc; close all;

%% Project path setup
scriptDir = fileparts(mfilename('fullpath'));
projectRoot = fileparts(scriptDir);
functionsDir = fullfile(projectRoot, 'functions');
resultsDir = fullfile(scriptDir, 'results');
figuresDir = fullfile(projectRoot, 'figures');

if ~exist(functionsDir, 'dir')
    error('functions folder not found: %s', functionsDir);
end

if ~exist(resultsDir, 'dir')
    error('results folder not found: %s', resultsDir);
end

if ~exist(figuresDir, 'dir')
    mkdir(figuresDir);
end

addpath(functionsDir);

%% Load Day 22 sweep metrics
sweepMatPath = fullfile(resultsDir, 'day22_parameter_sweep_metrics.mat');
if ~exist(sweepMatPath, 'file')
    error('Day 22 MAT file not found: %s', sweepMatPath);
end

S = load(sweepMatPath);

if ~isfield(S, 'T')
    error('Day 22 MAT file must contain table T. Re-run Day 22 if needed.');
end

T = S.T;

%% Load Day 24 threshold table
thresholdMatPath = fullfile(resultsDir, 'day24_margin_thresholds_by_K.mat');
if ~exist(thresholdMatPath, 'file')
    error('Day 24 MAT file not found: %s', thresholdMatPath);
end

Sth = load(thresholdMatPath);

if ~isfield(Sth, 'thresholdTable')
    error('Day 24 MAT file must contain thresholdTable. Re-run Day 24 if needed.');
end

thresholdTable = Sth.thresholdTable;

%% Required columns
requiredColumns = {'K', 'M', 'gain_error_pct', 'cutoff_error_pct', 'phase_deviation_fc_deg'};

for i = 1:numel(requiredColumns)
    if ~ismember(requiredColumns{i}, T.Properties.VariableNames)
        error('Day 22 table is missing required column: %s', requiredColumns{i});
    end
end

requiredThresholdColumns = {'K', 'M_marginal', 'M_safe', 'ft_required_marginal_Hz', 'ft_required_safe_Hz'};

for i = 1:numel(requiredThresholdColumns)
    if ~ismember(requiredThresholdColumns{i}, thresholdTable.Properties.VariableNames)
        error('Day 24 threshold table is missing required column: %s', requiredThresholdColumns{i});
    end
end

%% Basic checks
K_list = unique(T.K).';
M_list = unique(T.M).';

allFinite = all(isfinite(T.gain_error_pct)) && ...
            all(isfinite(T.cutoff_error_pct)) && ...
            all(isfinite(T.phase_deviation_fc_deg));

if ~allFinite
    error('Some sweep metrics are not finite. Check Day 22 results.');
end

% Baseline K=10 sanity checks
idxBase = T.K == 10;
Tbase = T(idxBase, :);
[~, idxSort] = sort(Tbase.M);
Tbase = Tbase(idxSort, :);

baseCutoffAbs = abs(Tbase.cutoff_error_pct);
basePhaseAbs = abs(Tbase.phase_deviation_fc_deg);

baselineCutoffTrend = all(diff(baseCutoffAbs) <= 1e-6);
baselinePhaseTrend = all(diff(basePhaseAbs) <= 1e-6);

% Baseline threshold values
idxThresholdBase = thresholdTable.K == 10;
if ~any(idxThresholdBase)
    error('No K=10 row found in thresholdTable.');
end

baseline_M_marginal = thresholdTable.M_marginal(idxThresholdBase);
baseline_M_safe = thresholdTable.M_safe(idxThresholdBase);

baselineThresholdPass = baseline_M_marginal > 8 && baseline_M_marginal < 10 && ...
                        baseline_M_safe > 15 && baseline_M_safe < 20;

%% Print Day 25 header
fprintf('Day 25 error-vs-M plots\n');
fprintf('------------------------\n');
fprintf('Loaded Day 22 cases = %d\n', height(T));
fprintf('K_list = [%s]\n', num2str(K_list));
fprintf('Number of M values = %d\n', numel(M_list));
fprintf('M range = %.4f to %.4f\n', min(M_list), max(M_list));
fprintf('M is used as GBW margin index, not stability margin.\n\n');

fprintf('Baseline K=10 thresholds from Day 24:\n');
fprintf('  M_marginal = %.6f\n', baseline_M_marginal);
fprintf('  M_safe     = %.6f\n\n', baseline_M_safe);

%% Figure 1: Absolute cutoff error vs M
fig1 = figure('Name', 'Day 25 Absolute Cutoff Error vs M');
hold on; grid on;

for iK = 1:numel(K_list)
    K = K_list(iK);
    idx = T.K == K;
    Tk = T(idx, :);
    [~, idxSortK] = sort(Tk.M);
    Tk = Tk(idxSortK, :);

    semilogx(Tk.M, abs(Tk.cutoff_error_pct), 'LineWidth', 1.5, ...
        'DisplayName', sprintf('K = %g', K));
end

yline(5, '--', 'Safe cutoff threshold: 5%', 'LabelHorizontalAlignment', 'left');
yline(10, ':', 'Marginal cutoff threshold: 10%', 'LabelHorizontalAlignment', 'left');
xline(baseline_M_safe, '--', 'K=10 M_{safe}', 'LabelOrientation', 'horizontal');

xlabel('M = f_t / [(1+K) f_c]');
ylabel('|Cutoff error| (%)');
title('Day 25: Absolute Cutoff Error vs M');
legend('Location', 'southwest');
set(gca, 'XScale', 'log');
disableAxesToolbar(gca);

cutoffFigPath = fullfile(figuresDir, 'day25_abs_cutoff_error_vs_M.png');
saveFigure(fig1, cutoffFigPath);

%% Figure 2: Absolute phase deviation vs M
fig2 = figure('Name', 'Day 25 Absolute Phase Deviation vs M');
hold on; grid on;

for iK = 1:numel(K_list)
    K = K_list(iK);
    idx = T.K == K;
    Tk = T(idx, :);
    [~, idxSortK] = sort(Tk.M);
    Tk = Tk(idxSortK, :);

    semilogx(Tk.M, abs(Tk.phase_deviation_fc_deg), 'LineWidth', 1.5, ...
        'DisplayName', sprintf('K = %g', K));
end

yline(5, '--', 'Safe phase threshold: 5 deg', 'LabelHorizontalAlignment', 'left');
yline(10, ':', 'Marginal phase threshold: 10 deg', 'LabelHorizontalAlignment', 'left');
xline(baseline_M_safe, '--', 'K=10 M_{safe}', 'LabelOrientation', 'horizontal');

xlabel('M = f_t / [(1+K) f_c]');
ylabel('|Phase deviation at f_c| (degrees)');
title('Day 25: Absolute Phase Deviation vs M');
legend('Location', 'southwest');
set(gca, 'XScale', 'log');
disableAxesToolbar(gca);

phaseFigPath = fullfile(figuresDir, 'day25_abs_phase_deviation_vs_M.png');
saveFigure(fig2, phaseFigPath);

%% Figure 3: Absolute gain error vs M
fig3 = figure('Name', 'Day 25 Absolute Gain Error vs M');
hold on; grid on;

for iK = 1:numel(K_list)
    K = K_list(iK);
    idx = T.K == K;
    Tk = T(idx, :);
    [~, idxSortK] = sort(Tk.M);
    Tk = Tk(idxSortK, :);

    semilogx(Tk.M, abs(Tk.gain_error_pct), 'LineWidth', 1.5, ...
        'DisplayName', sprintf('K = %g', K));
end

yline(1, '--', 'Safe gain threshold: 1%', 'LabelHorizontalAlignment', 'left');
yline(2, ':', 'Marginal gain threshold: 2%', 'LabelHorizontalAlignment', 'left');

xlabel('M = f_t / [(1+K) f_c]');
ylabel('|Gain error| (%)');
title('Day 25: Absolute Gain Error vs M');
legend('Location', 'best');
set(gca, 'XScale', 'log');
disableAxesToolbar(gca);

gainFigPath = fullfile(figuresDir, 'day25_abs_gain_error_vs_M.png');
saveFigure(fig3, gainFigPath);

%% Additional numerical summary for report
baselineSelectedM = [0.5 1 2 5 10 20 50];

fprintf('Selected baseline K=10 values for Day 25 interpretation:\n');
fprintf('-----------------------------------------------------------------------------------\n');
fprintf('%8s %18s %18s %18s\n', 'M', '|cutoffErr|_%', '|phaseDev|_deg', '|gainErr|_%');
fprintf('-----------------------------------------------------------------------------------\n');

for i = 1:numel(baselineSelectedM)
    m0 = baselineSelectedM(i);
    idx = find(T.K == 10 & abs(T.M - m0) < 1e-12, 1, 'first');

    if ~isempty(idx)
        fprintf('%8.2f %18.6f %18.6f %18.6f\n', ...
            T.M(idx), abs(T.cutoff_error_pct(idx)), ...
            abs(T.phase_deviation_fc_deg(idx)), abs(T.gain_error_pct(idx)));
    end
end
fprintf('-----------------------------------------------------------------------------------\n\n');

%% Day 25 checks
fprintf('Day 25 checks:\n');
printPassFail('All plotted metrics finite', allFinite);
printPassFail('Baseline cutoff-error magnitude decreases with M', baselineCutoffTrend);
printPassFail('Baseline phase-deviation magnitude decreases with M', baselinePhaseTrend);
printPassFail('Baseline M-threshold sanity check', baselineThresholdPass);

allPass = allFinite && baselineCutoffTrend && baselinePhaseTrend && baselineThresholdPass;

fprintf('\nDay 25 status:\n');
if allPass
    fprintf('Overall result: PASS\n');
else
    fprintf('Overall result: CHECK REQUIRED\n');
end

%% Save Markdown summary
summaryMdPath = fullfile(resultsDir, 'day25_error_vs_M_plot_summary.md');
fid = fopen(summaryMdPath, 'w');
if fid == -1
    error('Could not open Day 25 Markdown summary file.');
end

fprintf(fid, '# Day 25 Error-vs-M Plot Summary\n\n');
fprintf(fid, 'Day 25 uses the Day 22 clean non-ideal sweep metrics and the Day 24 robust threshold table.\n\n');
fprintf(fid, 'M is used as a project-defined GBW margin index, not a formal stability margin.\n\n');

fprintf(fid, '## Baseline K = 10 thresholds\n\n');
fprintf(fid, '| Quantity | Value |\n');
fprintf(fid, '|---|---:|\n');
fprintf(fid, '| M_marginal | %.6f |\n', baseline_M_marginal);
fprintf(fid, '| M_safe | %.6f |\n\n', baseline_M_safe);

fprintf(fid, '## Selected baseline K = 10 values\n\n');
fprintf(fid, '| M | abs_cutoff_error_pct | abs_phase_deviation_deg | abs_gain_error_pct |\n');
fprintf(fid, '|---:|---:|---:|---:|\n');

for i = 1:numel(baselineSelectedM)
    m0 = baselineSelectedM(i);
    idx = find(T.K == 10 & abs(T.M - m0) < 1e-12, 1, 'first');

    if ~isempty(idx)
        fprintf(fid, '| %.2f | %.6f | %.6f | %.6f |\n', ...
            T.M(idx), abs(T.cutoff_error_pct(idx)), ...
            abs(T.phase_deviation_fc_deg(idx)), abs(T.gain_error_pct(idx)));
    end
end

fprintf(fid, '\n## Figure files\n\n');
fprintf(fid, '- `%s`\n', cutoffFigPath);
fprintf(fid, '- `%s`\n', phaseFigPath);
fprintf(fid, '- `%s`\n\n', gainFigPath);

fprintf(fid, '## Checks\n\n');
fprintf(fid, '| Check | Result |\n');
fprintf(fid, '|---|---|\n');
fprintf(fid, '| All plotted metrics finite | %s |\n', passFail(allFinite));
fprintf(fid, '| Baseline cutoff-error magnitude decreases with M | %s |\n', passFail(baselineCutoffTrend));
fprintf(fid, '| Baseline phase-deviation magnitude decreases with M | %s |\n', passFail(baselinePhaseTrend));
fprintf(fid, '| Baseline threshold sanity check | %s |\n', passFail(baselineThresholdPass));
fprintf(fid, '| Overall result | %s |\n', passFail(allPass));

fclose(fid);

fprintf('\nSaved figures to:\n%s\n', figuresDir);
fprintf('Saved Markdown summary to:\n%s\n', summaryMdPath);

%% Local helper functions
function printPassFail(name, condition)
    fprintf('%s: %s\n', name, passFail(condition));
end

function result = passFail(condition)
    if condition
        result = 'PASS';
    else
        result = 'FAIL';
    end
end

function disableAxesToolbar(ax)
    % Hide the axes toolbar before exporting figures.
    % This avoids MATLAB export warnings about the toolbar appearing in images.
    try
        if isprop(ax, 'Toolbar') && ~isempty(ax.Toolbar)
            ax.Toolbar.Visible = 'off';
        end
    catch
        % Do nothing for older MATLAB versions.
    end
end

function saveFigure(fig, outPath)
    % Export a figure robustly. exportgraphics is preferred when available.
    try
        exportgraphics(fig, outPath, 'Resolution', 200);
    catch
        print(fig, outPath, '-dpng', '-r200');
    end
end