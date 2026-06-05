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

fprintf('Using active_lpf_response from:\n%s\n\n', which('active_lpf_response'));
fprintf('Using extract_frequency_metrics from:\n%s\n\n', which('extract_frequency_metrics'));

%% Baseline and sweep settings
Rin = 10e3;
fc_target = 10e3;
A0 = 1e5;

K_list = [1 2 5 10 20];

% Dense M sweep. Include important reference M values exactly.
M_dense = logspace(log10(0.3), log10(100), 100);
M_reference = [0.5 1 2 5 10 20 50];
M_list = unique(sort([M_dense, M_reference]));

% Full frequency vector for extraction.
% Do not use a band-limited vector for cutoff extraction.
f = logspace(log10(fc_target/1000), log10(fc_target*1000), 3000);

useSmoothing = false;  % clean non-ideal data only

%% Preallocate result arrays
nK = numel(K_list);
nM = numel(M_list);
N = nK * nM;

K_col = NaN(N,1);
Rin_col = NaN(N,1);
Rf_col = NaN(N,1);
Cf_col = NaN(N,1);
A0_col = NaN(N,1);
fc_target_col = NaN(N,1);
M_col = NaN(N,1);
ft_Hz_col = NaN(N,1);
fp_Hz_col = NaN(N,1);
M_check_col = NaN(N,1);

K_eff_col = NaN(N,1);
fc_eff_Hz_col = NaN(N,1);
gain_error_pct_col = NaN(N,1);
cutoff_error_pct_col = NaN(N,1);
phase_deviation_fc_deg_col = NaN(N,1);

row = 0;

%% Main sweep
for iK = 1:nK
    K = K_list(iK);
    Rf = K * Rin;
    Cf = 1 / (2*pi*Rf*fc_target);

    for iM = 1:nM
        M = M_list(iM);
        ft_Hz = M * (1 + K) * fc_target;

        out = active_lpf_response(f, Rin, Rf, Cf, A0, ft_Hz);
        f_used = out.f;

        metrics = extract_frequency_metrics(f_used, out.G_nonideal, K, fc_target, useSmoothing);

        row = row + 1;

        K_col(row) = K;
        Rin_col(row) = Rin;
        Rf_col(row) = Rf;
        Cf_col(row) = Cf;
        A0_col(row) = A0;
        fc_target_col(row) = fc_target;
        M_col(row) = M;
        ft_Hz_col(row) = ft_Hz;
        fp_Hz_col(row) = out.fp;
        M_check_col(row) = out.M_index;

        K_eff_col(row) = metrics.K_eff;
        fc_eff_Hz_col(row) = metrics.fc_eff;
        gain_error_pct_col(row) = metrics.gain_error_pct;
        cutoff_error_pct_col(row) = metrics.cutoff_error_pct;
        phase_deviation_fc_deg_col(row) = metrics.phase_deviation_fc_deg;
    end
end

%% Build table
T = table( ...
    K_col, Rin_col, Rf_col, Cf_col, A0_col, fc_target_col, ...
    M_col, ft_Hz_col, fp_Hz_col, M_check_col, ...
    K_eff_col, fc_eff_Hz_col, gain_error_pct_col, cutoff_error_pct_col, phase_deviation_fc_deg_col, ...
    'VariableNames', { ...
    'K', 'Rin_ohm', 'Rf_ohm', 'Cf_F', 'A0', 'fc_target_Hz', ...
    'M', 'ft_Hz', 'fp_Hz', 'M_check', ...
    'K_eff', 'fc_eff_Hz', 'gain_error_pct', 'cutoff_error_pct', 'phase_deviation_fc_deg'});

%% Checks
finiteMetrics = all(isfinite(T.K_eff)) && ...
                all(isfinite(T.fc_eff_Hz)) && ...
                all(isfinite(T.gain_error_pct)) && ...
                all(isfinite(T.cutoff_error_pct)) && ...
                all(isfinite(T.phase_deviation_fc_deg));

MCheckMaxAbs = max(abs(T.M_check - T.M));
MCheckPass = MCheckMaxAbs < 1e-10;

% Baseline trend check for K = 10.
idxBase = T.K == 10;
Tbase = T(idxBase, :);
[~, idxSortBase] = sort(Tbase.M);
Tbase = Tbase(idxSortBase, :);

cutoffAbsBase = abs(Tbase.cutoff_error_pct);
phaseAbsBase = abs(Tbase.phase_deviation_fc_deg);

% Because the sweep is dense, allow a small numerical tolerance.
cutoffTrendPass = all(diff(cutoffAbsBase) <= 1e-6);
phaseTrendPass = all(diff(phaseAbsBase) <= 1e-6);

%% Print summary
fprintf('Day 22 parameter sweep metrics\n');
fprintf('-------------------------------\n');
fprintf('K_list = [%s]\n', num2str(K_list));
fprintf('Number of M values = %d\n', numel(M_list));
fprintf('M range = %.4f to %.4f\n', min(M_list), max(M_list));
fprintf('Total sweep cases = %d\n', height(T));
fprintf('A0 = %.6e\n', A0);
fprintf('fc_target = %.6f Hz\n', fc_target);
fprintf('Frequency range = %.3e Hz to %.3e Hz\n', min(f), max(f));
fprintf('M is used as GBW margin index, not stability margin.\n\n');

fprintf('Sweep checks:\n');
fprintf('All extracted metrics finite: %s\n', passFail(finiteMetrics));
fprintf('M index consistency check: %s\n', passFail(MCheckPass));
fprintf('Baseline K=10 cutoff-error magnitude decreases with M: %s\n', passFail(cutoffTrendPass));
fprintf('Baseline K=10 phase-deviation magnitude decreases with M: %s\n', passFail(phaseTrendPass));
fprintf('\n');

% Print selected baseline rows for K=10.
selected_M = [0.5 1 2 5 10 20 50];
fprintf('Selected baseline rows for K = 10:\n');
fprintf('------------------------------------------------------------------------------------------------------------\n');
fprintf('%8s %14s %14s %14s %14s %14s\n', ...
    'M', 'ft_Hz', 'K_eff', 'fc_eff_Hz', 'cutoffErr_%', 'phaseDev_deg');
fprintf('------------------------------------------------------------------------------------------------------------\n');

for ii = 1:numel(selected_M)
    m0 = selected_M(ii);
    idx = find(abs(T.K - 10) < eps & abs(T.M - m0) < 1e-12, 1, 'first');

    if ~isempty(idx)
        fprintf('%8.2f %14.6e %14.8f %14.4f %14.6f %14.6f\n', ...
            T.M(idx), T.ft_Hz(idx), T.K_eff(idx), T.fc_eff_Hz(idx), ...
            T.cutoff_error_pct(idx), T.phase_deviation_fc_deg(idx));
    end
end
fprintf('------------------------------------------------------------------------------------------------------------\n\n');

fprintf('Day 22 status:\n');
if finiteMetrics && MCheckPass && cutoffTrendPass && phaseTrendPass
    fprintf('Overall result: PASS\n');
else
    fprintf('Overall result: CHECK REQUIRED\n');
end

%% Save results
csvPath = fullfile(resultsDir, 'day22_parameter_sweep_metrics.csv');
matPath = fullfile(resultsDir, 'day22_parameter_sweep_metrics.mat');
mdPath = fullfile(resultsDir, 'day22_parameter_sweep_metrics_summary.md');

writetable(T, csvPath);
save(matPath, 'T', 'K_list', 'M_list', 'Rin', 'A0', 'fc_target', 'f');

fid = fopen(mdPath, 'w');
if fid == -1
    error('Could not open Markdown output file.');
end

fprintf(fid, '# Day 22 Parameter Sweep Metrics Summary\n\n');
fprintf(fid, 'This table contains clean non-ideal performance extraction results. Classification is not performed on Day 22.\n\n');
fprintf(fid, '- A0 = %.6e\n', A0);
fprintf(fid, '- fc_target = %.6f Hz\n', fc_target);
fprintf(fid, '- K_list = [%s]\n', num2str(K_list));
fprintf(fid, '- Number of M values = %d\n', numel(M_list));
fprintf(fid, '- Total cases = %d\n\n', height(T));

fprintf(fid, '## Checks\n\n');
fprintf(fid, '| Check | Result |\n');
fprintf(fid, '|---|---|\n');
fprintf(fid, '| All extracted metrics finite | %s |\n', passFail(finiteMetrics));
fprintf(fid, '| M index consistency | %s |\n', passFail(MCheckPass));
fprintf(fid, '| Baseline K=10 cutoff-error magnitude decreases with M | %s |\n', passFail(cutoffTrendPass));
fprintf(fid, '| Baseline K=10 phase-deviation magnitude decreases with M | %s |\n\n', passFail(phaseTrendPass));

fprintf(fid, '## Selected baseline rows, K = 10\n\n');
fprintf(fid, '| M | ft_Hz | K_eff | fc_eff_Hz | cutoff_error_pct | phase_deviation_fc_deg |\n');
fprintf(fid, '|---:|---:|---:|---:|---:|---:|\n');

for ii = 1:numel(selected_M)
    m0 = selected_M(ii);
    idx = find(abs(T.K - 10) < eps & abs(T.M - m0) < 1e-12, 1, 'first');

    if ~isempty(idx)
        fprintf(fid, '| %.2f | %.6e | %.8f | %.4f | %.6f | %.6f |\n', ...
            T.M(idx), T.ft_Hz(idx), T.K_eff(idx), T.fc_eff_Hz(idx), ...
            T.cutoff_error_pct(idx), T.phase_deviation_fc_deg(idx));
    end
end

fclose(fid);

fprintf('\nSaved full sweep CSV to:\n%s\n', csvPath);
fprintf('Saved MAT file to:\n%s\n', matPath);
fprintf('Saved Markdown summary to:\n%s\n', mdPath);

%% Helper function
function txt = passFail(flag)
    if flag
        txt = 'PASS';
    else
        txt = 'FAIL';
    end
end