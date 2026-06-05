clear; clc; close all;

%% Robust project path setup
thisFile = mfilename('fullpath');
if isempty(thisFile)
    scriptsDir = pwd;
else
    scriptsDir = fileparts(thisFile);
end
projectRoot = fileparts(scriptsDir);
functionsDir = fullfile(projectRoot, 'functions');
figuresDir = fullfile(projectRoot, 'figures');
resultsDir = fullfile(scriptsDir, 'results');

if ~exist(functionsDir, 'dir')
    error('Functions folder not found: %s', functionsDir);
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

%% Baseline parameters
Rin = 10e3;
K = 10;
Rf = K * Rin;
fc_target = 10e3;
Cf = 1 / (2*pi*Rf*fc_target);
A0 = 1e5;

M_list = [0.5 1 2 5 10 20 50];

% Full extraction vector: 0.001fc to 1000fc
f = logspace(log10(fc_target/1000), log10(fc_target*1000), 3000);

%% Preallocate arrays
N = numel(M_list);
ft_all = NaN(N,1);
fp_all = NaN(N,1);
M_check_all = NaN(N,1);
K_eff_all = NaN(N,1);
fc_eff_all = NaN(N,1);
gain_err_all = NaN(N,1);
cutoff_err_all = NaN(N,1);
phase_dev_all = NaN(N,1);
phi_fc_all = NaN(N,1);

%% Run clean non-ideal extraction for each M
for i = 1:N
    M = M_list(i);
    ft_Hz = M * (1 + K) * fc_target;

    out = active_lpf_response(f, Rin, Rf, Cf, A0, ft_Hz);
    f_used = out.f;

    % Clean non-ideal data: no smoothing needed
    metrics = extract_frequency_metrics(f_used, out.G_nonideal, K, fc_target, false);

    ft_all(i) = out.ft_Hz;
    fp_all(i) = out.fp;
    M_check_all(i) = out.M_index;
    K_eff_all(i) = metrics.K_eff;
    fc_eff_all(i) = metrics.fc_eff;
    gain_err_all(i) = metrics.gain_error_pct;
    cutoff_err_all(i) = metrics.cutoff_error_pct;
    phase_dev_all(i) = metrics.phase_deviation_fc_deg;
    phi_fc_all(i) = metrics.phi_response_fc_deg;
end

%% Print summary table
fprintf('Day 16 clean non-ideal extraction test\n');
fprintf('--------------------------------------\n');
fprintf('K = %.8f\n', K);
fprintf('A0 = %.6e\n', A0);
fprintf('fc_target = %.8f Hz\n', fc_target);
fprintf('Frequency range = %.3e Hz to %.3e Hz\n', min(f), max(f));
fprintf('M is used as GBW margin index, not stability margin.\n\n');

fprintf('Clean non-ideal extraction summary:\n');
fprintf('-----------------------------------------------------------------------------------------------------------------------------\n');
fprintf('%8s %14s %14s %14s %14s %16s %18s %14s\n', ...
    'M', 'ft_Hz', 'fp_Hz', 'K_eff', 'fc_eff_Hz', 'gainErr_%', 'cutoffErr_%', 'phaseDev_deg');
fprintf('-----------------------------------------------------------------------------------------------------------------------------\n');

for i = 1:N
    fprintf('%8.2f %14.6e %14.6e %14.8f %14.4f %16.6f %18.6f %14.6f\n', ...
        M_list(i), ft_all(i), fp_all(i), K_eff_all(i), fc_eff_all(i), ...
        gain_err_all(i), cutoff_err_all(i), phase_dev_all(i));
end
fprintf('-----------------------------------------------------------------------------------------------------------------------------\n\n');

%% Save results table
T = table(M_list(:), ft_all, fp_all, K_eff_all, fc_eff_all, ...
          gain_err_all, cutoff_err_all, phase_dev_all, phi_fc_all, M_check_all, ...
          'VariableNames', {'M','ft_Hz','fp_Hz','K_eff','fc_eff_Hz', ...
          'gain_error_pct','cutoff_error_pct','phase_deviation_fc_deg', ...
          'phi_response_fc_deg','M_check'});

csvPath = fullfile(resultsDir, 'day16_clean_nonideal_extraction_summary.csv');
writetable(T, csvPath);

mdPath = fullfile(resultsDir, 'day16_clean_nonideal_extraction_summary.md');
fid = fopen(mdPath, 'w');
if fid == -1
    error('Could not create Markdown result file.');
end
fprintf(fid, '# Day 16 Clean Non-Ideal Extraction Summary\n\n');
fprintf(fid, '| M | ft_Hz | fp_Hz | K_eff | fc_eff_Hz | gain_error_pct | cutoff_error_pct | phase_deviation_fc_deg |\n');
fprintf(fid, '|---:|---:|---:|---:|---:|---:|---:|---:|\n');
for i = 1:N
    fprintf(fid, '| %.2f | %.6e | %.6e | %.8f | %.4f | %.6f | %.6f | %.6f |\n', ...
        M_list(i), ft_all(i), fp_all(i), K_eff_all(i), fc_eff_all(i), ...
        gain_err_all(i), cutoff_err_all(i), phase_dev_all(i));
end
fclose(fid);

%% Plot cutoff error vs M
figure;
semilogx(M_list, cutoff_err_all, '-o', 'LineWidth', 1.5);
grid on;
xlabel('M = f_t / [(1+K) f_c]');
ylabel('Cutoff error (%)');
title('Day 16 Clean Non-Ideal Extraction: Cutoff Error vs M');
yline(0, '--');
saveas(gcf, fullfile(figuresDir, 'day16_cutoff_error_vs_M.png'));

%% Plot phase deviation vs M
figure;
semilogx(M_list, phase_dev_all, '-o', 'LineWidth', 1.5);
grid on;
xlabel('M = f_t / [(1+K) f_c]');
ylabel('Phase deviation at f_c (degrees)');
title('Day 16 Clean Non-Ideal Extraction: Phase Deviation vs M');
yline(0, '--');
saveas(gcf, fullfile(figuresDir, 'day16_phase_deviation_vs_M.png'));

%% Plot gain error vs M
figure;
semilogx(M_list, gain_err_all, '-o', 'LineWidth', 1.5);
grid on;
xlabel('M = f_t / [(1+K) f_c]');
ylabel('Gain error (%)');
title('Day 16 Clean Non-Ideal Extraction: Gain Error vs M');
yline(0, '--');
saveas(gcf, fullfile(figuresDir, 'day16_gain_error_vs_M.png'));

%% Verification checks
finite_check = all(isfinite(K_eff_all)) && all(isfinite(fc_eff_all)) && ...
               all(isfinite(gain_err_all)) && all(isfinite(cutoff_err_all)) && ...
               all(isfinite(phase_dev_all));

M_check_pass = max(abs(M_check_all(:) - M_list(:))) < 1e-9;

% For this clean model, the absolute cutoff error and phase deviation
% should decrease as M increases.
cutoff_trend_pass = all(diff(abs(cutoff_err_all)) < 0);
phase_trend_pass = all(diff(abs(phase_dev_all)) < 0);

% Gain error should remain small. It mainly reflects finite A0.
gain_small_pass = max(abs(gain_err_all)) < 0.1;

fprintf('Day 16 verification checks:\n');
fprintf('Finite extracted metrics check: %s\n', passfail(finite_check));
fprintf('M index check: %s\n', passfail(M_check_pass));
fprintf('Cutoff error magnitude decreases as M increases: %s\n', passfail(cutoff_trend_pass));
fprintf('Phase deviation magnitude decreases as M increases: %s\n', passfail(phase_trend_pass));
fprintf('Gain error remains small: %s\n', passfail(gain_small_pass));

if finite_check && M_check_pass && cutoff_trend_pass && phase_trend_pass && gain_small_pass
    fprintf('\nOverall result: PASS\n');
else
    fprintf('\nOverall result: CHECK REQUIRED\n');
end

fprintf('\nSaved CSV table to:\n%s\n', csvPath);
fprintf('Saved Markdown table to:\n%s\n', mdPath);
fprintf('Figures saved to:\n%s\n', figuresDir);

%% Local helper function
function s = passfail(condition)
    if condition
        s = 'PASS';
    else
        s = 'FAIL';
    end
end