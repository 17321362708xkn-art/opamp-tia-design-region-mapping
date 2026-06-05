%% run_16_day26_safe_marginal_risky_design_map.m
% Week 4 Day 26
% Purpose:
%   Generate the final Safe / Marginal / Risky design map.
%
% Inputs:
%   1. scripts/results/day23_classified_design_regions.mat
%   2. scripts/results/day24_margin_thresholds_by_K.mat
%
% Outputs:
%   1. figures/day26_safe_marginal_risky_design_map.png
%   2. scripts/results/day26_design_map_grid.csv
%   3. scripts/results/day26_design_map_summary.md
%
% Important:
%   M is a GBW margin index, not a stability margin.
%   This design map is a project-defined design aid, not a universal rule.

clear; clc; close all;

%% Project path setup
scriptDir = fileparts(mfilename('fullpath'));
projectRoot = fileparts(scriptDir);
resultsDir = fullfile(scriptDir, 'results');
figuresDir = fullfile(projectRoot, 'figures');

if ~exist(resultsDir, 'dir')
    error('results folder not found: %s', resultsDir);
end

if ~exist(figuresDir, 'dir')
    mkdir(figuresDir);
end

%% Load Day 23 classified design-region data
classMatPath = fullfile(resultsDir, 'day23_classified_design_regions.mat');
classCsvPath = fullfile(resultsDir, 'day23_classified_design_regions.csv');

if exist(classMatPath, 'file')
    Sclass = load(classMatPath, 'Tclass', 'K_list', 'M_list', 'A0', 'fc_target');
    Tclass = Sclass.Tclass;
    K_list_loaded = Sclass.K_list;
    M_list_loaded = Sclass.M_list;
    A0 = Sclass.A0;
    fc_target = Sclass.fc_target;
elseif exist(classCsvPath, 'file')
    warning('Day 23 MAT file not found. Loading CSV instead.');
    Tclass = readtable(classCsvPath);
    K_list_loaded = unique(Tclass.K).';
    M_list_loaded = unique(Tclass.M).';
    A0 = NaN;
    fc_target = NaN;
else
    error('Day 23 classified data not found. Run run_13_day23_classify_design_regions first.');
end

%% Load Day 24 margin threshold table
thresholdMatPath = fullfile(resultsDir, 'day24_margin_thresholds_by_K.mat');
thresholdCsvPath = fullfile(resultsDir, 'day24_margin_thresholds_by_K.csv');

if exist(thresholdMatPath, 'file')
    Sthr = load(thresholdMatPath, 'thresholdTable', 'baseline_M_marginal', 'baseline_M_safe');
    thresholdTable = Sthr.thresholdTable;
    baseline_M_marginal = Sthr.baseline_M_marginal;
    baseline_M_safe = Sthr.baseline_M_safe;
elseif exist(thresholdCsvPath, 'file')
    warning('Day 24 MAT file not found. Loading CSV instead.');
    thresholdTable = readtable(thresholdCsvPath);
    idxBase = thresholdTable.K == 10;
    baseline_M_marginal = thresholdTable.M_marginal(idxBase);
    baseline_M_safe = thresholdTable.M_safe(idxBase);
else
    error('Day 24 threshold data not found. Run run_14_day24_find_margin_thresholds first.');
end

%% Required column checks
requiredClassColumns = {'K', 'M', 'region_code', 'region_label', ...
                        'gain_abs_pct', 'cutoff_abs_pct', 'phase_abs_deg'};

for i = 1:numel(requiredClassColumns)
    if ~ismember(requiredClassColumns{i}, Tclass.Properties.VariableNames)
        error('Tclass is missing required column: %s', requiredClassColumns{i});
    end
end

requiredThresholdColumns = {'K', 'M_marginal', 'M_safe', ...
                            'ft_required_marginal_Hz', 'ft_required_safe_Hz'};

for i = 1:numel(requiredThresholdColumns)
    if ~ismember(requiredThresholdColumns{i}, thresholdTable.Properties.VariableNames)
        error('thresholdTable is missing required column: %s', requiredThresholdColumns{i});
    end
end

%% Sort unique K and M values
K_sorted = sort(unique(Tclass.K)).';
M_sorted = sort(unique(Tclass.M)).';

nK = numel(K_sorted);
nM = numel(M_sorted);

regionGrid = NaN(nK, nM);
cutoffAbsGrid = NaN(nK, nM);
phaseAbsGrid = NaN(nK, nM);
gainAbsGrid = NaN(nK, nM);

%% Build design-map grid
for iK = 1:nK
    for iM = 1:nM
        idx = find(abs(Tclass.K - K_sorted(iK)) < 1e-12 & ...
                   abs(Tclass.M - M_sorted(iM)) < 1e-12, 1, 'first');

        if ~isempty(idx)
            regionGrid(iK, iM) = Tclass.region_code(idx);
            cutoffAbsGrid(iK, iM) = Tclass.cutoff_abs_pct(idx);
            phaseAbsGrid(iK, iM) = Tclass.phase_abs_deg(idx);
            gainAbsGrid(iK, iM) = Tclass.gain_abs_pct(idx);
        end
    end
end

%% Checks
regionCodeCheck = all(ismember(regionGrid(isfinite(regionGrid)), [1 2 3]));
gridCompleteCheck = all(isfinite(regionGrid(:)));
metricGridFiniteCheck = all(isfinite(cutoffAbsGrid(:))) && ...
                        all(isfinite(phaseAbsGrid(:))) && ...
                        all(isfinite(gainAbsGrid(:)));

thresholdKCoverageCheck = all(ismember(K_sorted, thresholdTable.K));

% Baseline K = 10 checks: M=5 Risky, M=10 Marginal, M=20 Safe.
baselineK = 10;
idxK10 = find(K_sorted == baselineK, 1);

if isempty(idxK10)
    error('Baseline K = 10 not found in design-map grid.');
end

regionAtM5 = lookupRegion(K_sorted, M_sorted, regionGrid, 10, 5);
regionAtM10 = lookupRegion(K_sorted, M_sorted, regionGrid, 10, 10);
regionAtM20 = lookupRegion(K_sorted, M_sorted, regionGrid, 10, 20);

baselineRegionCheck = regionAtM5 == 3 && regionAtM10 == 2 && regionAtM20 == 1;

baselineThresholdCheck = baseline_M_marginal > 8 && baseline_M_marginal < 10 && ...
                         baseline_M_safe > 15 && baseline_M_safe < 20;

%% Prepare threshold overlay positions
thresholdTable = sortrows(thresholdTable, 'K');

thresholdRowIndex = NaN(height(thresholdTable), 1);
for i = 1:height(thresholdTable)
    idx = find(K_sorted == thresholdTable.K(i), 1);
    if ~isempty(idx)
        thresholdRowIndex(i) = idx;
    end
end

validThresholdRows = isfinite(thresholdRowIndex) & ...
                     isfinite(thresholdTable.M_marginal) & ...
                     isfinite(thresholdTable.M_safe);

thresholdRowIndex = thresholdRowIndex(validThresholdRows);
M_marginal_plot = thresholdTable.M_marginal(validThresholdRows);
M_safe_plot = thresholdTable.M_safe(validThresholdRows);
K_threshold_plot = thresholdTable.K(validThresholdRows);

%% Plot design map
fig = figure('Name', 'Day 26 Safe Marginal Risky Design Map', 'Color', 'w');
fig.Position = [100, 100, 1150, 700];

ax = axes(fig);

% Use log10(M) as the x-coordinate so the map has a log-style M axis.
imagesc(ax, log10(M_sorted), 1:nK, regionGrid);
set(ax, 'YDir', 'normal');

% Region colours: 1 Safe, 2 Marginal, 3 Risky.
% These are only for visual clarity.
colormap(ax, [0.35 0.75 0.35; 0.95 0.80 0.25; 0.90 0.35 0.30]);
caxis(ax, [1 3]);

cb = colorbar(ax);
cb.Ticks = [1 2 3];
cb.TickLabels = {'Safe', 'Marginal', 'Risky'};
cb.Label.String = 'Design region';

hold(ax, 'on');

hMarginal = plot(ax, log10(M_marginal_plot), thresholdRowIndex, 'k:', ...
    'LineWidth', 2.0, 'DisplayName', 'M_{marginal}(K)');

hSafe = plot(ax, log10(M_safe_plot), thresholdRowIndex, 'k--', ...
    'LineWidth', 2.0, 'DisplayName', 'M_{safe}(K)');

% Mark baseline K=10 threshold points.
idxK10Thr = find(K_threshold_plot == 10, 1);
if ~isempty(idxK10Thr)
    plot(ax, log10(M_marginal_plot(idxK10Thr)), thresholdRowIndex(idxK10Thr), ...
        'ko', 'MarkerFaceColor', 'w', 'HandleVisibility', 'off');
    plot(ax, log10(M_safe_plot(idxK10Thr)), thresholdRowIndex(idxK10Thr), ...
        'ks', 'MarkerFaceColor', 'w', 'HandleVisibility', 'off');
end

xlabel(ax, 'M = f_t / [(1+K) f_c]');
ylabel(ax, 'Closed-loop gain magnitude K');
title(ax, 'Day 26: Safe / Marginal / Risky Design Map');

set(ax, 'YTick', 1:nK, 'YTickLabel', string(K_sorted));

xtickVals = [0.3 0.5 1 2 5 10 20 50 100];
xtickVals = xtickVals(xtickVals >= min(M_sorted) & xtickVals <= max(M_sorted));
set(ax, 'XTick', log10(xtickVals));
set(ax, 'XTickLabel', compose('%g', xtickVals));
xlim(ax, log10([min(M_sorted), max(M_sorted)]));

grid(ax, 'on');
legend(ax, [hMarginal, hSafe], 'Location', 'southoutside', 'Orientation', 'horizontal');

% Hide MATLAB axes toolbar during export to avoid toolbar warnings.
if isprop(ax, 'Toolbar')
    ax.Toolbar.Visible = 'off';
end

figPath = fullfile(figuresDir, 'day26_safe_marginal_risky_design_map.png');
exportgraphics(fig, figPath, 'Resolution', 300);

%% Save grid table
nRows = nK * nM;
K_col = NaN(nRows,1);
M_col = NaN(nRows,1);
region_col = NaN(nRows,1);
cutoff_abs_col = NaN(nRows,1);
phase_abs_col = NaN(nRows,1);
gain_abs_col = NaN(nRows,1);

row = 0;
for iK = 1:nK
    for iM = 1:nM
        row = row + 1;
        K_col(row) = K_sorted(iK);
        M_col(row) = M_sorted(iM);
        region_col(row) = regionGrid(iK, iM);
        cutoff_abs_col(row) = cutoffAbsGrid(iK, iM);
        phase_abs_col(row) = phaseAbsGrid(iK, iM);
        gain_abs_col(row) = gainAbsGrid(iK, iM);
    end
end

region_label_col = strings(nRows,1);
region_label_col(region_col == 1) = "Safe";
region_label_col(region_col == 2) = "Marginal";
region_label_col(region_col == 3) = "Risky";

Tgrid = table(K_col, M_col, region_col, region_label_col, ...
              gain_abs_col, cutoff_abs_col, phase_abs_col, ...
              'VariableNames', {'K', 'M', 'region_code', 'region_label', ...
                                'gain_abs_pct', 'cutoff_abs_pct', 'phase_abs_deg'});

gridCsvPath = fullfile(resultsDir, 'day26_design_map_grid.csv');
writetable(Tgrid, gridCsvPath);

%% Count region labels by K
nSafe = zeros(nK,1);
nMarginal = zeros(nK,1);
nRisky = zeros(nK,1);

for iK = 1:nK
    codes = regionGrid(iK, :);
    nSafe(iK) = sum(codes == 1);
    nMarginal(iK) = sum(codes == 2);
    nRisky(iK) = sum(codes == 3);
end

Tcounts = table(K_sorted(:), nSafe, nMarginal, nRisky, ...
    'VariableNames', {'K', 'nSafe', 'nMarginal', 'nRisky'});

%% Print output
fprintf('Day 26 safe / marginal / risky design map\n');
fprintf('------------------------------------------\n');
fprintf('Loaded classified grid cases = %d\n', height(Tclass));
fprintf('K_list = [%s]\n', num2str(K_sorted));
fprintf('Number of M values = %d\n', nM);
fprintf('M range = %.4f to %.4f\n', min(M_sorted), max(M_sorted));

if isfinite(A0)
    fprintf('A0 = %.6e\n', A0(1));
end

if isfinite(fc_target)
    fprintf('fc_target = %.6f Hz\n', fc_target(1));
end

fprintf('M is used as GBW margin index, not stability margin.\n\n');

fprintf('Design-region counts by K:\n');
disp(Tcounts);

fprintf('Baseline K=10 interpretation:\n');
fprintf('  M = 5  -> region code %d\n', regionAtM5);
fprintf('  M = 10 -> region code %d\n', regionAtM10);
fprintf('  M = 20 -> region code %d\n', regionAtM20);
fprintf('  Expected: 3 = Risky, 2 = Marginal, 1 = Safe.\n\n');

fprintf('Baseline K=10 thresholds:\n');
fprintf('  M_marginal = %.6f\n', baseline_M_marginal);
fprintf('  M_safe     = %.6f\n\n', baseline_M_safe);

fprintf('Day 26 checks:\n');
printPassFail('Region code grid check', regionCodeCheck);
printPassFail('Grid complete check', gridCompleteCheck);
printPassFail('Metric grid finite check', metricGridFiniteCheck);
printPassFail('Threshold K coverage check', thresholdKCoverageCheck);
printPassFail('Baseline region check', baselineRegionCheck);
printPassFail('Baseline threshold sanity check', baselineThresholdCheck);

allPass = regionCodeCheck && gridCompleteCheck && metricGridFiniteCheck && ...
          thresholdKCoverageCheck && baselineRegionCheck && baselineThresholdCheck;

fprintf('\nDay 26 status:\n');
if allPass
    fprintf('Overall result: PASS\n');
else
    fprintf('Overall result: CHECK REQUIRED\n');
end

fprintf('\nSaved design map figure to:\n%s\n', figPath);
fprintf('Saved design map grid CSV to:\n%s\n', gridCsvPath);

%% Save Markdown summary
mdPath = fullfile(resultsDir, 'day26_design_map_summary.md');
fid = fopen(mdPath, 'w');
if fid == -1
    error('Could not open Markdown summary file: %s', mdPath);
end

fprintf(fid, '# Day 26 Safe / Marginal / Risky Design Map Summary\n\n');
fprintf(fid, 'M is used as a project-defined GBW margin index, not a formal stability margin or phase margin.\n\n');

fprintf(fid, '## Classification Criteria\n\n');
fprintf(fid, '| Region | Gain error | Cutoff error | Phase deviation |\n');
fprintf(fid, '|---|---:|---:|---:|\n');
fprintf(fid, '| Safe | < 1%% | < 5%% | < 5 deg |\n');
fprintf(fid, '| Marginal | < 2%% | < 10%% | < 10 deg |\n');
fprintf(fid, '| Risky | otherwise | otherwise | otherwise |\n\n');

fprintf(fid, '## Region Counts by K\n\n');
fprintf(fid, '| K | Safe | Marginal | Risky |\n');
fprintf(fid, '|---:|---:|---:|---:|\n');
for iK = 1:nK
    fprintf(fid, '| %.0f | %d | %d | %d |\n', K_sorted(iK), nSafe(iK), nMarginal(iK), nRisky(iK));
end

fprintf(fid, '\n## Robust Thresholds from Day 24\n\n');
fprintf(fid, '| K | M_marginal | M_safe | ft_required_marginal_Hz | ft_required_safe_Hz |\n');
fprintf(fid, '|---:|---:|---:|---:|---:|\n');
for i = 1:height(thresholdTable)
    fprintf(fid, '| %.0f | %.6f | %.6f | %.6e | %.6e |\n', ...
        thresholdTable.K(i), thresholdTable.M_marginal(i), thresholdTable.M_safe(i), ...
        thresholdTable.ft_required_marginal_Hz(i), thresholdTable.ft_required_safe_Hz(i));
end

fprintf(fid, '\n## Baseline K = 10 Interpretation\n\n');
fprintf(fid, '| M | Region code | Region label |\n');
fprintf(fid, '|---:|---:|---|\n');
fprintf(fid, '| 5 | %d | %s |\n', regionAtM5, regionLabel(regionAtM5));
fprintf(fid, '| 10 | %d | %s |\n', regionAtM10, regionLabel(regionAtM10));
fprintf(fid, '| 20 | %d | %s |\n', regionAtM20, regionLabel(regionAtM20));

fprintf(fid, '\nFor the baseline case K = 10, the extracted thresholds are M_marginal = %.6f and M_safe = %.6f.\n', ...
    baseline_M_marginal, baseline_M_safe);

fprintf(fid, '\n## Report Wording\n\n');
fprintf(fid, 'The design map shows that low M values lead to large cutoff-frequency and phase deviations, while sufficiently high M values allow the non-ideal response to remain within the selected safe thresholds. The map should be interpreted as a design aid under the assumptions of this behavioural model, not as a universal op-amp selection rule.\n\n');

fprintf(fid, '## Checks\n\n');
fprintf(fid, '| Check | Result |\n');
fprintf(fid, '|---|---|\n');
fprintf(fid, '| Region code grid check | %s |\n', passFail(regionCodeCheck));
fprintf(fid, '| Grid complete check | %s |\n', passFail(gridCompleteCheck));
fprintf(fid, '| Metric grid finite check | %s |\n', passFail(metricGridFiniteCheck));
fprintf(fid, '| Threshold K coverage check | %s |\n', passFail(thresholdKCoverageCheck));
fprintf(fid, '| Baseline region check | %s |\n', passFail(baselineRegionCheck));
fprintf(fid, '| Baseline threshold sanity check | %s |\n', passFail(baselineThresholdCheck));

fclose(fid);

fprintf('Saved Markdown summary to:\n%s\n', mdPath);

%% Local helper functions
function code = lookupRegion(K_sorted, M_sorted, regionGrid, K_target, M_target)
    iK = find(abs(K_sorted - K_target) < 1e-12, 1, 'first');
    iM = find(abs(M_sorted - M_target) < 1e-12, 1, 'first');

    if isempty(iK) || isempty(iM)
        code = NaN;
    else
        code = regionGrid(iK, iM);
    end
end

function label = regionLabel(code)
    if code == 1
        label = 'Safe';
    elseif code == 2
        label = 'Marginal';
    elseif code == 3
        label = 'Risky';
    else
        label = 'Unknown';
    end
end

function printPassFail(label, condition)
    if condition
        fprintf('%s: PASS\n', label);
    else
        fprintf('%s: FAIL\n', label);
    end
end

function out = passFail(condition)
    if condition
        out = 'PASS';
    else
        out = 'FAIL';
    end
end