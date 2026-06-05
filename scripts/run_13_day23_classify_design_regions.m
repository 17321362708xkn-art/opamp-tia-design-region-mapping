clear; clc; close all;

%% Robust path setup
thisFile = mfilename('fullpath');
[thisDir, ~, ~] = fileparts(thisFile);
projectRoot = fileparts(thisDir);
functionsDir = fullfile(projectRoot, 'functions');
figuresDir = fullfile(projectRoot, 'figures');
resultsDir = fullfile(thisDir, 'results');

if ~exist(functionsDir, 'dir')
    error('Functions directory not found: %s', functionsDir);
end

if ~exist(figuresDir, 'dir')
    mkdir(figuresDir);
end

if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

addpath(functionsDir);

fprintf('Using classify_design_region from:\n%s\n\n', which('classify_design_region'));

%% Load Day 22 sweep data
matPath = fullfile(resultsDir, 'day22_parameter_sweep_metrics.mat');
csvPath = fullfile(resultsDir, 'day22_parameter_sweep_metrics.csv');

if exist(matPath, 'file')
    S = load(matPath, 'T', 'K_list', 'M_list', 'A0', 'fc_target');
    T = S.T;
    K_list = S.K_list;
    M_list = S.M_list;
    A0 = S.A0;
    fc_target = S.fc_target;
elseif exist(csvPath, 'file')
    warning('MAT file not found. Loading CSV file instead.');
    T = readtable(csvPath);
    K_list = unique(T.K).';
    M_list = unique(T.M).';
    A0 = unique(T.A0);
    fc_target = unique(T.fc_target_Hz);
else
    error('Day 22 sweep data not found. Run run_12_day22_parameter_sweep_metrics first.');
end

requiredColumns = {'K', 'M', 'ft_Hz', 'K_eff', 'fc_eff_Hz', ...
                   'gain_error_pct', 'cutoff_error_pct', 'phase_deviation_fc_deg'};

for k = 1:numel(requiredColumns)
    if ~ismember(requiredColumns{k}, T.Properties.VariableNames)
        error('Day 22 table is missing required column: %s', requiredColumns{k});
    end
end

%% Classify every row
N = height(T);
region_code = NaN(N,1);
region_label = strings(N,1);

gain_abs_pct = abs(T.gain_error_pct);
cutoff_abs_pct = abs(T.cutoff_error_pct);
phase_abs_deg = abs(T.phase_deviation_fc_deg);

for i = 1:N
    metrics.fc_eff = T.fc_eff_Hz(i);
    metrics.gain_error_pct = T.gain_error_pct(i);
    metrics.cutoff_error_pct = T.cutoff_error_pct(i);
    metrics.phase_deviation_fc_deg = T.phase_deviation_fc_deg(i);

    region = classify_design_region(metrics);

    region_code(i) = region.code;
    region_label(i) = region.label;
end

Tclass = T;
Tclass.gain_abs_pct = gain_abs_pct;
Tclass.cutoff_abs_pct = cutoff_abs_pct;
Tclass.phase_abs_deg = phase_abs_deg;
Tclass.region_code = region_code;
Tclass.region_label = region_label;

%% Independent consistency checks
valid = isfinite(Tclass.fc_eff_Hz) & ...
        isfinite(Tclass.gain_error_pct) & ...
        isfinite(Tclass.cutoff_error_pct) & ...
        isfinite(Tclass.phase_deviation_fc_deg);

safe_direct = valid & ...
              Tclass.gain_abs_pct < 1 & ...
              Tclass.cutoff_abs_pct < 5 & ...
              Tclass.phase_abs_deg < 5;

marginal_direct = valid & ~safe_direct & ...
                  Tclass.gain_abs_pct < 2 & ...
                  Tclass.cutoff_abs_pct < 10 & ...
                  Tclass.phase_abs_deg < 10;

expected_code = 3 * ones(N,1);
expected_code(marginal_direct) = 2;
expected_code(safe_direct) = 1;

classificationConsistencyCheck = all(Tclass.region_code == expected_code);

regionCodeCheck = all(ismember(Tclass.region_code, [1 2 3]));

% Critical trap check:
% Any point with |cutoff error| >= 10% must be Risky.
largeCutoffRiskyCheck = ~any(Tclass.cutoff_abs_pct >= 10 & Tclass.region_code ~= 3);

% Any point with |cutoff error| >= 5% must not be Safe.
largeCutoffNotSafeCheck = ~any(Tclass.cutoff_abs_pct >= 5 & Tclass.region_code == 1);

% Specific severe-negative-error trap.
severeNegativeCutoffRiskyCheck = ~any(Tclass.cutoff_error_pct <= -50 & Tclass.region_code ~= 3);

allFiniteClassificationCheck = all(isfinite(Tclass.region_code));

%% Count classifications
nSafe = sum(Tclass.region_code == 1);
nMarginal = sum(Tclass.region_code == 2);
nRisky = sum(Tclass.region_code == 3);

K_unique = unique(Tclass.K).';
nK = numel(K_unique);

nSafeByK = zeros(nK,1);
nMarginalByK = zeros(nK,1);
nRiskyByK = zeros(nK,1);

for iK = 1:nK
    idxK = Tclass.K == K_unique(iK);
    nSafeByK(iK) = sum(Tclass.region_code(idxK) == 1);
    nMarginalByK(iK) = sum(Tclass.region_code(idxK) == 2);
    nRiskyByK(iK) = sum(Tclass.region_code(idxK) == 3);
end

TcountByK = table(K_unique(:), nSafeByK, nMarginalByK, nRiskyByK, ...
    'VariableNames', {'K', 'nSafe', 'nMarginal', 'nRisky'});

%% Baseline selected rows for K = 10
selected_M = [0.5 1 2 5 10 20 50];

fprintf('Day 23 design-region classification\n');
fprintf('-----------------------------------\n');
fprintf('Loaded Day 22 sweep cases = %d\n', N);
fprintf('K_list = [%s]\n', num2str(K_list));
fprintf('Number of M values = %d\n', numel(M_list));
fprintf('A0 = %.6e\n', A0(1));
fprintf('fc_target = %.6f Hz\n', fc_target(1));
fprintf('Classification uses absolute errors.\n');
fprintf('M is used as GBW margin index, not stability margin.\n\n');

fprintf('Classification thresholds:\n');
fprintf('  Safe:     |gain error| < 1%%, |cutoff error| < 5%%, |phase deviation| < 5 deg\n');
fprintf('  Marginal: |gain error| < 2%%, |cutoff error| < 10%%, |phase deviation| < 10 deg\n');
fprintf('  Risky:    otherwise, or invalid extraction\n\n');

fprintf('Overall classification counts:\n');
fprintf('  Safe     = %d\n', nSafe);
fprintf('  Marginal = %d\n', nMarginal);
fprintf('  Risky    = %d\n\n', nRisky);

fprintf('Classification counts by K:\n');
disp(TcountByK);

fprintf('Selected baseline rows for K = 10:\n');
fprintf('-----------------------------------------------------------------------------------------------------------------------------\n');
fprintf('%8s %14s %14s %14s %14s %14s\n', ...
    'M', 'gainErr_%', 'cutoffErr_%', 'phaseDev_deg', 'regionCode', 'regionLabel');
fprintf('-----------------------------------------------------------------------------------------------------------------------------\n');

for ii = 1:numel(selected_M)
    m0 = selected_M(ii);
    idx = find(abs(Tclass.K - 10) < eps & abs(Tclass.M - m0) < 1e-12, 1, 'first');

    if ~isempty(idx)
        fprintf('%8.2f %14.6f %14.6f %14.6f %14d %14s\n', ...
            Tclass.M(idx), Tclass.gain_error_pct(idx), Tclass.cutoff_error_pct(idx), ...
            Tclass.phase_deviation_fc_deg(idx), Tclass.region_code(idx), Tclass.region_label(idx));
    end
end
fprintf('-----------------------------------------------------------------------------------------------------------------------------\n\n');

fprintf('Day 23 checks:\n');
fprintf('Region code check: %s\n', passFail(regionCodeCheck));
fprintf('All finite classification check: %s\n', passFail(allFiniteClassificationCheck));
fprintf('Classification consistency check: %s\n', passFail(classificationConsistencyCheck));
fprintf('Large cutoff error not Safe check: %s\n', passFail(largeCutoffNotSafeCheck));
fprintf('Large cutoff error Risky check: %s\n', passFail(largeCutoffRiskyCheck));
fprintf('Severe negative cutoff error Risky check: %s\n', passFail(severeNegativeCutoffRiskyCheck));

allPass = regionCodeCheck && allFiniteClassificationCheck && ...
          classificationConsistencyCheck && largeCutoffNotSafeCheck && ...
          largeCutoffRiskyCheck && severeNegativeCutoffRiskyCheck;

fprintf('\nDay 23 status:\n');
if allPass
    fprintf('Overall result: PASS\n');
else
    fprintf('Overall result: CHECK REQUIRED\n');
end

%% Save outputs
csvOutPath = fullfile(resultsDir, 'day23_classified_design_regions.csv');
matOutPath = fullfile(resultsDir, 'day23_classified_design_regions.mat');
mdOutPath = fullfile(resultsDir, 'day23_classification_summary.md');

writetable(Tclass, csvOutPath);
save(matOutPath, 'Tclass', 'TcountByK', 'K_list', 'M_list', 'A0', 'fc_target');

fid = fopen(mdOutPath, 'w');
if fid == -1
    error('Could not open Markdown output file.');
end

fprintf(fid, '# Day 23 Classification Summary\n\n');
fprintf(fid, 'Classification uses absolute errors. The quantity M is a GBW margin index, not a stability margin.\n\n');

fprintf(fid, '## Thresholds\n\n');
fprintf(fid, '| Region | Gain error | Cutoff error | Phase deviation |\n');
fprintf(fid, '|---|---:|---:|---:|\n');
fprintf(fid, '| Safe | < 1%% | < 5%% | < 5 deg |\n');
fprintf(fid, '| Marginal | < 2%% | < 10%% | < 10 deg |\n');
fprintf(fid, '| Risky | otherwise | otherwise | otherwise |\n\n');

fprintf(fid, '## Overall Counts\n\n');
fprintf(fid, '| Region | Count |\n');
fprintf(fid, '|---|---:|\n');
fprintf(fid, '| Safe | %d |\n', nSafe);
fprintf(fid, '| Marginal | %d |\n', nMarginal);
fprintf(fid, '| Risky | %d |\n\n', nRisky);

fprintf(fid, '## Counts by K\n\n');
fprintf(fid, '| K | Safe | Marginal | Risky |\n');
fprintf(fid, '|---:|---:|---:|---:|\n');
for iK = 1:height(TcountByK)
    fprintf(fid, '| %.0f | %d | %d | %d |\n', ...
        TcountByK.K(iK), TcountByK.nSafe(iK), TcountByK.nMarginal(iK), TcountByK.nRisky(iK));
end

fprintf(fid, '\n## Selected Baseline Rows, K = 10\n\n');
fprintf(fid, '| M | gain_error_pct | cutoff_error_pct | phase_deviation_fc_deg | region_code | region_label |\n');
fprintf(fid, '|---:|---:|---:|---:|---:|---|\n');

for ii = 1:numel(selected_M)
    m0 = selected_M(ii);
    idx = find(abs(Tclass.K - 10) < eps & abs(Tclass.M - m0) < 1e-12, 1, 'first');

    if ~isempty(idx)
        fprintf(fid, '| %.2f | %.6f | %.6f | %.6f | %d | %s |\n', ...
            Tclass.M(idx), Tclass.gain_error_pct(idx), Tclass.cutoff_error_pct(idx), ...
            Tclass.phase_deviation_fc_deg(idx), Tclass.region_code(idx), Tclass.region_label(idx));
    end
end

fprintf(fid, '\n## Checks\n\n');
fprintf(fid, '| Check | Result |\n');
fprintf(fid, '|---|---|\n');
fprintf(fid, '| Region code check | %s |\n', passFail(regionCodeCheck));
fprintf(fid, '| All finite classification check | %s |\n', passFail(allFiniteClassificationCheck));
fprintf(fid, '| Classification consistency check | %s |\n', passFail(classificationConsistencyCheck));
fprintf(fid, '| Large cutoff error not Safe check | %s |\n', passFail(largeCutoffNotSafeCheck));
fprintf(fid, '| Large cutoff error Risky check | %s |\n', passFail(largeCutoffRiskyCheck));
fprintf(fid, '| Severe negative cutoff error Risky check | %s |\n', passFail(severeNegativeCutoffRiskyCheck));

fclose(fid);

fprintf('\nSaved classified CSV to:\n%s\n', csvOutPath);
fprintf('Saved classified MAT file to:\n%s\n', matOutPath);
fprintf('Saved Markdown summary to:\n%s\n', mdOutPath);

%% Helper function
function txt = passFail(flag)
    if flag
        txt = 'PASS';
    else
        txt = 'FAIL';
    end
end