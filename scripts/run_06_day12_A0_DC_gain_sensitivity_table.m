clear; clc;

% run_06_day12_A0_DC_gain_sensitivity_table.m
% Day 12: finite A0 DC gain sensitivity table.
%
% This script isolates the low-frequency/DC gain effect of finite
% open-loop gain A0. It does not analyse finite ft, cutoff shift,
% phase deviation, noise, Monte Carlo, or safe/risky design maps.

%% Robust project-root detection
scriptDir = fileparts(mfilename('fullpath'));

if isempty(scriptDir)
    scriptDir = pwd;
end

candidateRoot1 = scriptDir;
candidateRoot2 = fileparts(scriptDir);

if exist(fullfile(candidateRoot1, 'functions'), 'dir') || ...
   exist(fullfile(candidateRoot1, 'figures'), 'dir') || ...
   exist(fullfile(candidateRoot1, 'results'), 'dir')
    projectRoot = candidateRoot1;
elseif exist(fullfile(candidateRoot2, 'functions'), 'dir') || ...
       exist(fullfile(candidateRoot2, 'figures'), 'dir') || ...
       exist(fullfile(candidateRoot2, 'results'), 'dir')
    projectRoot = candidateRoot2;
else
    projectRoot = scriptDir;
end

resultsDir = fullfile(projectRoot, 'results');

if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

%% Parameter definitions
A0_list = [1e3, 1e4, 1e5];
K_list = [1, 10, 20];

A0_dB = 20 * log10(A0_list(:));

dc_error_pct = zeros(numel(A0_list), numel(K_list));
Gdc_eff = zeros(numel(A0_list), numel(K_list));

%% Compute DC gain error
for i = 1:numel(A0_list)
    A0 = A0_list(i);

    for j = 1:numel(K_list)
        K = K_list(j);

        Gdc_eff(i,j) = (K * A0) / (A0 + 1 + K);
        dc_error_pct(i,j) = 100 * (Gdc_eff(i,j) - K) / K;

        % Equivalent compact expression:
        % dc_error_pct(i,j) = -100 * (1 + K) / (A0 + 1 + K);
    end
end

%% Print results
fprintf('\nDay 12 finite A0 DC gain sensitivity table\n');
fprintf('------------------------------------------------------------\n');
fprintf('This table isolates the low-frequency/DC gain effect of finite A0.\n');
fprintf('Frequency-dependent deviations are analysed separately through finite-ft sweeps.\n\n');

fprintf('%12s %10s %18s %18s %18s\n', ...
        'A0', 'A0_dB', 'K=1 error (%)', 'K=10 error (%)', 'K=20 error (%)');
fprintf('%12s %10s %18s %18s %18s\n', ...
        '------------', '----------', '------------------', '------------------', '------------------');

for i = 1:numel(A0_list)
    fprintf('%12.0e %10.1f %18.6f %18.6f %18.6f\n', ...
            A0_list(i), A0_dB(i), ...
            dc_error_pct(i,1), dc_error_pct(i,2), dc_error_pct(i,3));
end

fprintf('\nExpected qualitative trend:\n');
fprintf('  Lower A0 gives larger DC gain error.\n');
fprintf('  Higher K gives larger DC gain error.\n');
fprintf('  The error is negative because finite A0 lowers the effective closed-loop gain.\n');

%% Save CSV table
resultTable = table( ...
    A0_list(:), ...
    A0_dB(:), ...
    dc_error_pct(:,1), ...
    dc_error_pct(:,2), ...
    dc_error_pct(:,3), ...
    'VariableNames', { ...
        'A0_linear', ...
        'A0_dB', ...
        'K1_DC_gain_error_pct', ...
        'K10_DC_gain_error_pct', ...
        'K20_DC_gain_error_pct'});

csvPath = fullfile(resultsDir, 'day12_A0_DC_gain_sensitivity_table.csv');
writetable(resultTable, csvPath);

%% Save Markdown table for report drafting
mdPath = fullfile(resultsDir, 'day12_A0_DC_gain_sensitivity_table.md');
fid = fopen(mdPath, 'w');

if fid == -1
    error('Could not create Markdown output file.');
end

fprintf(fid, '# DC gain error caused by finite open-loop gain A0\n\n');
fprintf(fid, 'This table isolates the low-frequency/DC gain effect of finite A0. ');
fprintf(fid, 'Frequency-dependent deviations are analysed separately through the finite-ft sweep.\n\n');
fprintf(fid, '| A0 | A0_dB | K=1 DC gain error | K=10 DC gain error | K=20 DC gain error |\n');
fprintf(fid, '|---:|---:|---:|---:|---:|\n');

for i = 1:numel(A0_list)
    fprintf(fid, '| 10^%d | %.0f dB | %.6f%% | %.6f%% | %.6f%% |\n', ...
            round(log10(A0_list(i))), A0_dB(i), ...
            dc_error_pct(i,1), dc_error_pct(i,2), dc_error_pct(i,3));
end

fclose(fid);

fprintf('\nSaved CSV table to:\n%s\n', csvPath);
fprintf('Saved Markdown table to:\n%s\n', mdPath);

%% Basic checks
expected_K10_A0_1e5 = -100 * (1 + 10) / (1e5 + 1 + 10);
actual_K10_A0_1e5 = dc_error_pct(A0_list == 1e5, K_list == 10);

check_formula = abs(actual_K10_A0_1e5 - expected_K10_A0_1e5) < 1e-12;
check_negative = all(dc_error_pct(:) < 0);
check_trend_A0 = abs(dc_error_pct(1,2)) > abs(dc_error_pct(2,2)) && ...
                 abs(dc_error_pct(2,2)) > abs(dc_error_pct(3,2));
check_trend_K = abs(dc_error_pct(3,3)) > abs(dc_error_pct(3,2)) && ...
                abs(dc_error_pct(3,2)) > abs(dc_error_pct(3,1));

fprintf('\nDay 12 checks:\n');
fprintf('Formula consistency check: %s\n', passfail(check_formula));
fprintf('All errors are negative: %s\n', passfail(check_negative));
fprintf('Error magnitude decreases as A0 increases: %s\n', passfail(check_trend_A0));
fprintf('Error magnitude increases as K increases: %s\n', passfail(check_trend_K));

if check_formula && check_negative && check_trend_A0 && check_trend_K
    fprintf('\nOverall result: PASS\n');
else
    fprintf('\nOverall result: CHECK REQUIRED\n');
end

%% Local helper function
function out = passfail(condition)
    if condition
        out = 'PASS';
    else
        out = 'FAIL';
    end
end