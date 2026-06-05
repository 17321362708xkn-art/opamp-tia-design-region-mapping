clear; clc; close all;

%% Day 27: Required ft plot extracted from safe-region sweep
% This script uses the Day 24 robust M_marginal(K) and M_safe(K) thresholds.
% It converts the dimensionless GBW margin index into absolute required ft.
%
% M = ft / [(1+K) fc]
% ft_required(K) = M_safe(K) * (1+K) * fc
%
% This is a design aid under the assumptions of this behavioural model.
% It is not a universal op-amp selection rule.
%
% Important fix:
% This script only requires K, M_marginal, and M_safe from the Day 24 table.
% It computes ft_marginal_Hz and ft_safe_Hz internally.

%% Robust project path setup
scriptDir = fileparts(mfilename('fullpath'));
if isempty(scriptDir)
    scriptDir = pwd;
end

projectRoot = fileparts(scriptDir);
resultsDir = fullfile(scriptDir, 'results');
figuresDir = fullfile(projectRoot, 'figures');

if ~exist(resultsDir, 'dir')
    error('Results directory does not exist: %s', resultsDir);
end

if ~exist(figuresDir, 'dir')
    mkdir(figuresDir);
end

%% Load Day 24 threshold table
thresholdCsv = fullfile(resultsDir, 'day24_margin_thresholds_by_K.csv');

if ~exist(thresholdCsv, 'file')
    error('Cannot find Day 24 threshold CSV: %s', thresholdCsv);
end

T = readtable(thresholdCsv);

% Day 27 only requires K, M_marginal, and M_safe.
% Required ft values are computed inside this script.
requiredVars = {'K', 'M_marginal', 'M_safe'};
for n = 1:numel(requiredVars)
    if ~ismember(requiredVars{n}, T.Properties.VariableNames)
        fprintf('\nAvailable variables in Day 24 table are:\n');
        disp(T.Properties.VariableNames');
        error('Missing required variable in Day 24 table: %s', requiredVars{n});
    end
end

%% Sort by K
T = sortrows(T, 'K');

K_list = T.K;
M_marginal = T.M_marginal;
M_safe = T.M_safe;

%% Fixed project parameter
fc_target = 10e3;

%% Compute required ft values from M thresholds
ft_marginal_Hz = M_marginal .* (1 + K_list) .* fc_target;
ft_safe_Hz = M_safe .* (1 + K_list) .* fc_target;

%% Optional consistency check if Day 24 table already contains ft columns
hasDay24FtMarginal = ismember('ft_marginal_Hz', T.Properties.VariableNames);
hasDay24FtSafe = ismember('ft_safe_Hz', T.Properties.VariableNames);

if hasDay24FtMarginal && hasDay24FtSafe
    day24_ft_marginal_Hz = T.ft_marginal_Hz;
    day24_ft_safe_Hz = T.ft_safe_Hz;

    day24_ft_marginal_diff = max(abs(day24_ft_marginal_Hz - ft_marginal_Hz));
    day24_ft_safe_diff = max(abs(day24_ft_safe_Hz - ft_safe_Hz));
else
    day24_ft_marginal_diff = NaN;
    day24_ft_safe_diff = NaN;
end

%% Input checks
if any(~isfinite(K_list)) || any(K_list <= 0)
    error('K values must be positive and finite.');
end

if any(~isfinite(M_marginal)) || any(~isfinite(M_safe))
    error('M thresholds must be finite.');
end

if any(M_marginal <= 0) || any(M_safe <= 0)
    error('M thresholds must be positive.');
end

if any(M_safe < M_marginal)
    error('Each M_safe must be greater than or equal to M_marginal.');
end

if any(~isfinite(ft_marginal_Hz)) || any(~isfinite(ft_safe_Hz))
    error('Computed ft values must be finite.');
end

if any(ft_marginal_Hz <= 0) || any(ft_safe_Hz <= 0)
    error('Computed ft values must be positive.');
end

%% Formula consistency check
ft_marginal_check = M_marginal .* (1 + K_list) .* fc_target;
ft_safe_check = M_safe .* (1 + K_list) .* fc_target;

ft_marginal_formula_error = max(abs(ft_marginal_check - ft_marginal_Hz));
ft_safe_formula_error = max(abs(ft_safe_check - ft_safe_Hz));

formulaTol_Hz = 1e-9;
formulaCheckPass = ft_marginal_formula_error < formulaTol_Hz && ...
                   ft_safe_formula_error < formulaTol_Hz;

ft_safe_increases = all(diff(ft_safe_Hz) > 0);
ft_marginal_increases = all(diff(ft_marginal_Hz) > 0);
threshold_order_pass = all(M_safe >= M_marginal);

if hasDay24FtMarginal && hasDay24FtSafe
    day24FtConsistencyPass = day24_ft_marginal_diff < 1e-6 && ...
                             day24_ft_safe_diff < 1e-6;
else
    day24FtConsistencyPass = true;
end

%% Prepare summary table in MHz
T_out = table();
T_out.K = K_list;
T_out.M_marginal = M_marginal;
T_out.M_safe = M_safe;
T_out.ft_marginal_Hz = ft_marginal_Hz;
T_out.ft_safe_Hz = ft_safe_Hz;
T_out.ft_marginal_MHz = ft_marginal_Hz / 1e6;
T_out.ft_safe_MHz = ft_safe_Hz / 1e6;

%% Print output
fprintf('\nDay 27 required ft plot extracted from safe-region sweep\n');
fprintf('--------------------------------------------------------\n');
fprintf('Loaded threshold rows = %d\n', height(T));
fprintf('K_list = [%s]\n', strtrim(sprintf('%g ', K_list)));
fprintf('fc_target = %.6f Hz\n', fc_target);
fprintf('M is used as GBW margin index, not stability margin.\n');
fprintf('Required ft values are computed from M thresholds using ft = M(1+K)fc.\n');
fprintf('This script does not require ft_marginal_Hz or ft_safe_Hz columns in the Day 24 CSV.\n\n');

if hasDay24FtMarginal && hasDay24FtSafe
    fprintf('Optional Day 24 ft-column consistency check:\n');
    fprintf('  max |Day24 ft_marginal - computed ft_marginal| = %.6e Hz\n', day24_ft_marginal_diff);
    fprintf('  max |Day24 ft_safe - computed ft_safe|         = %.6e Hz\n\n', day24_ft_safe_diff);
else
    fprintf('Day 24 CSV does not contain ft columns. This is acceptable because Day 27 computes ft internally.\n\n');
end

fprintf('Required ft summary:\n');
fprintf('------------------------------------------------------------------------------------------------------\n');
fprintf('%8s %14s %14s %20s %20s\n', ...
        'K', 'M_marginal', 'M_safe', 'ft_marginal_MHz', 'ft_safe_MHz');
fprintf('------------------------------------------------------------------------------------------------------\n');

for i = 1:numel(K_list)
    fprintf('%8.0f %14.6f %14.6f %20.6f %20.6f\n', ...
        K_list(i), M_marginal(i), M_safe(i), ...
        ft_marginal_Hz(i)/1e6, ft_safe_Hz(i)/1e6);
end

fprintf('------------------------------------------------------------------------------------------------------\n\n');

fprintf('Day 27 checks:\n');
fprintf('Formula consistency check: %s\n', passfail(formulaCheckPass));
fprintf('Optional Day 24 ft-column consistency check: %s\n', passfail(day24FtConsistencyPass));
fprintf('ft_safe increases with K check: %s\n', passfail(ft_safe_increases));
fprintf('ft_marginal increases with K check: %s\n', passfail(ft_marginal_increases));
fprintf('M_safe >= M_marginal check: %s\n', passfail(threshold_order_pass));

allPass = formulaCheckPass && day24FtConsistencyPass && ...
          ft_safe_increases && ft_marginal_increases && threshold_order_pass;

fprintf('\nDay 27 status:\n');
fprintf('Overall result: %s\n', passfail(allPass));

%% Plot required ft vs K
fig1 = figure('Name', 'Day 27 Required ft vs K');
ax1 = axes(fig1);
hold(ax1, 'on');
grid(ax1, 'on');
box(ax1, 'on');

hMarginal = plot(ax1, K_list, ft_marginal_Hz/1e6, 'o--', ...
    'LineWidth', 1.8, 'MarkerSize', 7, 'DisplayName', 'Marginal threshold');
hSafe = plot(ax1, K_list, ft_safe_Hz/1e6, 's-', ...
    'LineWidth', 1.8, 'MarkerSize', 7, 'DisplayName', 'Safe threshold');

xlabel(ax1, 'Closed-loop gain magnitude K');
ylabel(ax1, 'Required f_t (MHz)');
title(ax1, 'Day 27: Required f_t Extracted from Safe-Region Sweep');
legend(ax1, [hMarginal, hSafe], 'Location', 'northwest');

set(ax1, 'XTick', K_list);

for i = 1:numel(K_list)
    text(ax1, K_list(i), ft_safe_Hz(i)/1e6, ...
        sprintf('  %.2f MHz', ft_safe_Hz(i)/1e6), ...
        'FontSize', 9, 'VerticalAlignment', 'bottom');
end

figPath1 = fullfile(figuresDir, 'day27_required_ft_vs_K.png');
exportgraphics(ax1, figPath1, 'Resolution', 300);

%% Optional log-y plot for appendix
fig2 = figure('Name', 'Day 27 Required ft vs K Log Y');
ax2 = axes(fig2);
hold(ax2, 'on');
grid(ax2, 'on');
box(ax2, 'on');

hMarginal2 = semilogy(ax2, K_list, ft_marginal_Hz/1e6, 'o--', ...
    'LineWidth', 1.8, 'MarkerSize', 7, 'DisplayName', 'Marginal threshold');
hSafe2 = semilogy(ax2, K_list, ft_safe_Hz/1e6, 's-', ...
    'LineWidth', 1.8, 'MarkerSize', 7, 'DisplayName', 'Safe threshold');

xlabel(ax2, 'Closed-loop gain magnitude K');
ylabel(ax2, 'Required f_t (MHz), log scale');
title(ax2, 'Day 27: Required f_t Extracted from Safe-Region Sweep');
legend(ax2, [hMarginal2, hSafe2], 'Location', 'northwest');
set(ax2, 'XTick', K_list);

figPath2 = fullfile(figuresDir, 'day27_required_ft_vs_K_logy.png');
exportgraphics(ax2, figPath2, 'Resolution', 300);

%% Save summary tables
csvPath = fullfile(resultsDir, 'day27_required_ft_summary.csv');
writetable(T_out, csvPath);

mdPath = fullfile(resultsDir, 'day27_required_ft_summary.md');
fid = fopen(mdPath, 'w');
if fid == -1
    error('Cannot write Markdown summary file.');
end

fprintf(fid, '# Day 27 Required ft Summary\n\n');
fprintf(fid, 'This table converts the robust per-K M thresholds into absolute required unity-gain-frequency values.\n\n');
fprintf(fid, 'The conversion uses: ft = M(1+K)fc.\n\n');
fprintf(fid, 'The result is a project-defined design aid, not a universal op-amp selection rule.\n\n');
fprintf(fid, '| K | M_marginal | M_safe | ft_marginal (MHz) | ft_safe (MHz) |\n');
fprintf(fid, '|---:|---:|---:|---:|---:|\n');

for i = 1:numel(K_list)
    fprintf(fid, '| %.0f | %.6f | %.6f | %.6f | %.6f |\n', ...
        K_list(i), M_marginal(i), M_safe(i), ...
        ft_marginal_Hz(i)/1e6, ft_safe_Hz(i)/1e6);
end

fprintf(fid, '\n## Interpretation\n\n');
fprintf(fid, 'Higher closed-loop gain magnitude K requires higher absolute ft to meet the same project-defined safe criteria.\n\n');
fprintf(fid, 'This conclusion follows from the behavioural model and the selected thresholds. It should not be interpreted as a universal op-amp selection rule.\n');
fclose(fid);

fprintf('\nSaved required ft figure to:\n%s\n', figPath1);
fprintf('Saved optional log-y figure to:\n%s\n', figPath2);
fprintf('Saved CSV summary to:\n%s\n', csvPath);
fprintf('Saved Markdown summary to:\n%s\n', mdPath);

%% Local helper
function s = passfail(tf)
    if tf
        s = 'PASS';
    else
        s = 'FAIL';
    end
end