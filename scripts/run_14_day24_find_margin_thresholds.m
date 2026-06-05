clear; clc; close all;

% -------------------------------------------------------------------------
% Robust project paths
% -------------------------------------------------------------------------
scriptDir = fileparts(mfilename('fullpath'));
projectRoot = fileparts(scriptDir);
functionsDir = fullfile(projectRoot, 'functions');
resultsDir = fullfile(scriptDir, 'results');

if ~exist(functionsDir, 'dir')
    error('Functions directory not found: %s', functionsDir);
end

if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

addpath(functionsDir);

fprintf('Using find_margin_thresholds from:\n%s\n\n', which('find_margin_thresholds'));

% -------------------------------------------------------------------------
% Load Day 23 classified design-region data
% -------------------------------------------------------------------------
classifiedCsv = fullfile(resultsDir, 'day23_classified_design_regions.csv');

if ~exist(classifiedCsv, 'file')
    error('Day 23 classified CSV not found: %s', classifiedCsv);
end

T = readtable(classifiedCsv);

% Column names should come from the Day 23 script. This helper makes the
% script slightly more robust to small naming differences.
K_all = getRequiredColumn(T, {'K', 'K_value', 'KValue'});
M_all = getRequiredColumn(T, {'M', 'M_index', 'MValue'});
region_all = getRequiredColumn(T, {'regionCode', 'region_code', 'RegionCode'});

K_all = K_all(:);
M_all = M_all(:);
region_all = region_all(:);

if any(~ismember(region_all, [1 2 3]))
    error('region codes must contain only 1 = Safe, 2 = Marginal, or 3 = Risky.');
end

K_list = unique(K_all, 'stable');

% Project baseline parameters
fc_target = 10e3;
A0 = 1e5;

% Output arrays
M_marginal_all = NaN(numel(K_list), 1);
M_safe_all = NaN(numel(K_list), 1);
ft_required_marginal_Hz = NaN(numel(K_list), 1);
ft_required_safe_Hz = NaN(numel(K_list), 1);

% -------------------------------------------------------------------------
% Extract M_marginal and M_safe for each K
% -------------------------------------------------------------------------
for kIdx = 1:numel(K_list)
    K_now = K_list(kIdx);
    idxK = K_all == K_now;

    thresholds = find_margin_thresholds(M_all(idxK), region_all(idxK));

    M_marginal_all(kIdx) = thresholds.M_marginal;
    M_safe_all(kIdx) = thresholds.M_safe;

    ft_required_marginal_Hz(kIdx) = M_marginal_all(kIdx) * (1 + K_now) * fc_target;
    ft_required_safe_Hz(kIdx) = M_safe_all(kIdx) * (1 + K_now) * fc_target;
end

thresholdTable = table( ...
    K_list(:), ...
    M_marginal_all, ...
    M_safe_all, ...
    ft_required_marginal_Hz, ...
    ft_required_safe_Hz, ...
    'VariableNames', {'K', 'M_marginal', 'M_safe', ...
                      'ft_required_marginal_Hz', 'ft_required_safe_Hz'});

% -------------------------------------------------------------------------
% Baseline sanity check for K = 10
% -------------------------------------------------------------------------
baselineK = 10;
baselineIdx = find(K_list == baselineK, 1);

if isempty(baselineIdx)
    error('Baseline K = 10 not found in K_list.');
end

baseline_M_marginal = M_marginal_all(baselineIdx);
baseline_M_safe = M_safe_all(baselineIdx);

baseline_marginal_ok = baseline_M_marginal > 6 && baseline_M_marginal < 12;
baseline_safe_ok = baseline_M_safe > 14 && baseline_M_safe < 25;

% -------------------------------------------------------------------------
% General checks
% -------------------------------------------------------------------------
finite_thresholds_ok = all(isfinite(M_marginal_all)) && all(isfinite(M_safe_all));
threshold_order_ok = all(M_safe_all >= M_marginal_all);

% Sustained threshold checks: once the threshold is reached, all larger
% sampled M values should remain in the required region.
sustained_safe_ok = true;
sustained_marginal_ok = true;

for kIdx = 1:numel(K_list)
    K_now = K_list(kIdx);
    idxK = K_all == K_now;
    M_K = M_all(idxK);
    region_K = region_all(idxK);

    [M_sorted, idxSort] = sort(M_K);
    region_sorted = region_K(idxSort);

    idxSafeStart = find(M_sorted >= M_safe_all(kIdx), 1, 'first');
    idxMarginalStart = find(M_sorted >= M_marginal_all(kIdx), 1, 'first');

    if isempty(idxSafeStart) || ~all(region_sorted(idxSafeStart:end) == 1)
        sustained_safe_ok = false;
    end

    if isempty(idxMarginalStart) || ~all(region_sorted(idxMarginalStart:end) <= 2)
        sustained_marginal_ok = false;
    end
end

% -------------------------------------------------------------------------
% Print results
% -------------------------------------------------------------------------
fprintf('Day 24 robust M-threshold extraction\n');
fprintf('-------------------------------------\n');
fprintf('Loaded classified cases = %d\n', height(T));
fprintf('K_list = [%s]\n', num2str(K_list.'));
fprintf('fc_target = %.6f Hz\n', fc_target);
fprintf('A0 = %.6e\n', A0);
fprintf('M is used as GBW margin index, not stability margin.\n\n');

fprintf('Robust threshold table:\n');
fprintf('-------------------------------------------------------------------------------------------------------------\n');
fprintf('%8s %14s %14s %24s %24s\n', ...
        'K', 'M_marginal', 'M_safe', 'ft_marginal_Hz', 'ft_safe_Hz');
fprintf('-------------------------------------------------------------------------------------------------------------\n');

for i = 1:height(thresholdTable)
    fprintf('%8.0f %14.6f %14.6f %24.6e %24.6e\n', ...
        thresholdTable.K(i), ...
        thresholdTable.M_marginal(i), ...
        thresholdTable.M_safe(i), ...
        thresholdTable.ft_required_marginal_Hz(i), ...
        thresholdTable.ft_required_safe_Hz(i));
end

fprintf('-------------------------------------------------------------------------------------------------------------\n\n');

fprintf('Baseline K = 10 sanity check:\n');
fprintf('  M_marginal = %.6f\n', baseline_M_marginal);
fprintf('  M_safe     = %.6f\n', baseline_M_safe);
fprintf('  Expected rough range: M_marginal around 8 to 10, M_safe around 15 to 20.\n\n');

fprintf('Day 24 checks:\n');
printPassFail('Finite thresholds check', finite_thresholds_ok);
printPassFail('M_safe >= M_marginal check', threshold_order_ok);
printPassFail('Sustained-safe definition check', sustained_safe_ok);
printPassFail('Sustained-marginal definition check', sustained_marginal_ok);
printPassFail('Baseline M_marginal sanity check', baseline_marginal_ok);
printPassFail('Baseline M_safe sanity check', baseline_safe_ok);

if finite_thresholds_ok && threshold_order_ok && sustained_safe_ok && ...
   sustained_marginal_ok && baseline_marginal_ok && baseline_safe_ok
    overallPass = true;
else
    overallPass = false;
end

fprintf('\nDay 24 status:\n');
if overallPass
    fprintf('Overall result: PASS\n');
else
    fprintf('Overall result: CHECK REQUIRED\n');
end

% -------------------------------------------------------------------------
% Save results
% -------------------------------------------------------------------------
outCsv = fullfile(resultsDir, 'day24_margin_thresholds_by_K.csv');
outMd = fullfile(resultsDir, 'day24_margin_thresholds_by_K.md');
outMat = fullfile(resultsDir, 'day24_margin_thresholds_by_K.mat');

writetable(thresholdTable, outCsv);
save(outMat, 'thresholdTable', 'baseline_M_marginal', 'baseline_M_safe', ...
             'fc_target', 'A0');

writeMarkdownTable(outMd, thresholdTable);

fprintf('\nSaved threshold CSV to:\n%s\n', outCsv);
fprintf('Saved threshold MAT file to:\n%s\n', outMat);
fprintf('Saved threshold Markdown table to:\n%s\n', outMd);

% -------------------------------------------------------------------------
% Local helper functions
% -------------------------------------------------------------------------
function col = getRequiredColumn(T, possibleNames)
    names = T.Properties.VariableNames;

    for n = 1:numel(possibleNames)
        idx = strcmp(names, possibleNames{n});
        if any(idx)
            col = T.(names{idx});
            return;
        end
    end

    fprintf('Available table variable names:\n');
    disp(names.');
    error('Required column not found. Tried: %s', strjoin(possibleNames, ', '));
end

function printPassFail(label, condition)
    if condition
        fprintf('%s: PASS\n', label);
    else
        fprintf('%s: FAIL\n', label);
    end
end

function writeMarkdownTable(filename, T)
    fid = fopen(filename, 'w');
    if fid == -1
        error('Could not open Markdown output file: %s', filename);
    end

    fprintf(fid, '# Day 24 Margin Thresholds by K\n\n');
    fprintf(fid, 'M is used as a project-defined GBW margin index, not a stability margin.\n\n');
    fprintf(fid, '| K | M_marginal | M_safe | ft_required_marginal_Hz | ft_required_safe_Hz |\n');
    fprintf(fid, '|---:|---:|---:|---:|---:|\n');

    for i = 1:height(T)
        fprintf(fid, '| %.0f | %.6f | %.6f | %.6e | %.6e |\n', ...
            T.K(i), T.M_marginal(i), T.M_safe(i), ...
            T.ft_required_marginal_Hz(i), T.ft_required_safe_Hz(i));
    end

    fclose(fid);
end