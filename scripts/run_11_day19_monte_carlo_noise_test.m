clear; clc; close all;

%% Path setup
scriptPath = mfilename('fullpath');

if isempty(scriptPath)
    scriptDir = pwd;
else
    scriptDir = fileparts(scriptPath);
end

projectRoot = fileparts(scriptDir);
functionsDir = fullfile(projectRoot, 'functions');
figuresDir = fullfile(projectRoot, 'figures');
resultsDir = fullfile(scriptDir, 'results');

if ~isfolder(functionsDir)
    error('Functions folder not found: %s', functionsDir);
end

if ~isfolder(figuresDir)
    mkdir(figuresDir);
end

if ~isfolder(resultsDir)
    mkdir(resultsDir);
end

addpath(functionsDir);

fprintf('Using active_lpf_response from:\n%s\n\n', which('active_lpf_response'));
fprintf('Using add_measurement_noise from:\n%s\n\n', which('add_measurement_noise'));
fprintf('Using extract_frequency_metrics from:\n%s\n\n', which('extract_frequency_metrics'));

%% Baseline parameters
Rin = 10e3;
K = 10;
Rf = K * Rin;

fc_target = 10e3;
Cf = 1 / (2*pi*Rf*fc_target);

A0 = 1e5;
M = 20;
ft_Hz = M * (1 + K) * fc_target;

f = logspace(log10(fc_target/1000), log10(fc_target*1000), 3000);

%% Clean non-ideal response
out = active_lpf_response(f, Rin, Rf, Cf, A0, ft_Hz);
f_used = out.f;
G_clean = out.G_nonideal;

cleanMetrics = extract_frequency_metrics(f_used, G_clean, K, fc_target, false);

%% Noise settings
magNoise_dB = 0.05;
phaseNoise_deg = 0.5;

N = 20;
seeds = 1:N;

%% Preallocate arrays
K_eff_all = NaN(N,1);
fc_eff_all = NaN(N,1);
gain_err_all = NaN(N,1);
cutoff_err_all = NaN(N,1);
phase_dev_all = NaN(N,1);

failed = false(N,1);

%% Monte Carlo loop
for ii = 1:N
    seed = seeds(ii);

    try
        G_noisy = add_measurement_noise(G_clean, magNoise_dB, phaseNoise_deg, seed);

        % For noisy virtual data, use smoothing and sustained crossing.
        metrics = extract_frequency_metrics(f_used, G_noisy, K, fc_target, true);

        K_eff_all(ii) = metrics.K_eff;
        fc_eff_all(ii) = metrics.fc_eff;
        gain_err_all(ii) = metrics.gain_error_pct;
        cutoff_err_all(ii) = metrics.cutoff_error_pct;
        phase_dev_all(ii) = metrics.phase_deviation_fc_deg;

        if ~isfinite(metrics.K_eff) || ~isfinite(metrics.fc_eff) || ...
           ~isfinite(metrics.gain_error_pct) || ~isfinite(metrics.cutoff_error_pct) || ...
           ~isfinite(metrics.phase_deviation_fc_deg)
            failed(ii) = true;
        end

    catch ME
        failed(ii) = true;
        fprintf('Seed %d failed: %s\n', seed, ME.message);
    end
end

valid = ~failed & isfinite(K_eff_all) & isfinite(fc_eff_all) & ...
        isfinite(gain_err_all) & isfinite(cutoff_err_all) & ...
        isfinite(phase_dev_all);

validCount = sum(valid);
failedCount = N - validCount;

if validCount == 0
    error('All Monte Carlo extraction runs failed. Check noisy extraction settings.');
end

%% Summary statistics
K_eff_mean = mean(K_eff_all(valid));
K_eff_std = std(K_eff_all(valid));

fc_eff_mean = mean(fc_eff_all(valid));
fc_eff_std = std(fc_eff_all(valid));

gain_err_mean = mean(gain_err_all(valid));
gain_err_std = std(gain_err_all(valid));

cutoff_err_mean = mean(cutoff_err_all(valid));
cutoff_err_std = std(cutoff_err_all(valid));

phase_dev_mean = mean(phase_dev_all(valid));
phase_dev_std = std(phase_dev_all(valid));

%% Print results
fprintf('Day 19 Monte Carlo noisy extraction test\n');
fprintf('----------------------------------------\n');
fprintf('K = %.8f\n', K);
fprintf('A0 = %.6e\n', A0);
fprintf('fc_target = %.8f Hz\n', fc_target);
fprintf('M = %.8f\n', M);
fprintf('ft_Hz = %.6e Hz\n', ft_Hz);
fprintf('Noise settings: mag = %.4f dB, phase = %.4f deg\n', magNoise_dB, phaseNoise_deg);
fprintf('Number of seeds = %d\n', N);
fprintf('Valid runs = %d / %d\n', validCount, N);
fprintf('Failed runs = %d / %d\n\n', failedCount, N);

fprintf('Clean non-ideal extraction baseline:\n');
fprintf('  K_eff               = %.10f\n', cleanMetrics.K_eff);
fprintf('  fc_eff              = %.4f Hz\n', cleanMetrics.fc_eff);
fprintf('  gain error          = %.6f %%\n', cleanMetrics.gain_error_pct);
fprintf('  cutoff error        = %.6f %%\n', cleanMetrics.cutoff_error_pct);
fprintf('  phase deviation     = %.6f deg\n\n', cleanMetrics.phase_deviation_fc_deg);

fprintf('Monte Carlo mean ± std over valid runs:\n');
fprintf('  K_eff               = %.10f ± %.10f\n', K_eff_mean, K_eff_std);
fprintf('  fc_eff              = %.4f ± %.4f Hz\n', fc_eff_mean, fc_eff_std);
fprintf('  gain error          = %.6f ± %.6f %%\n', gain_err_mean, gain_err_std);
fprintf('  cutoff error        = %.6f ± %.6f %%\n', cutoff_err_mean, cutoff_err_std);
fprintf('  phase deviation     = %.6f ± %.6f deg\n\n', phase_dev_mean, phase_dev_std);

fprintf('Difference between Monte Carlo mean and clean baseline:\n');
fprintf('  gain error mean difference      = %.6f %%\n', gain_err_mean - cleanMetrics.gain_error_pct);
fprintf('  cutoff error mean difference    = %.6f %%\n', cutoff_err_mean - cleanMetrics.cutoff_error_pct);
fprintf('  phase deviation mean difference = %.6f deg\n\n', phase_dev_mean - cleanMetrics.phase_deviation_fc_deg);

%% Checks
valid_runs_check = (validCount == N);

% These tolerances are project-level robustness checks for the selected
% small virtual measurement noise. They are not universal measurement limits.
gain_std_check = gain_err_std < 0.10;
cutoff_std_check = cutoff_err_std < 1.00;
phase_std_check = phase_dev_std < 1.00;

cutoff_mean_near_clean_check = abs(cutoff_err_mean - cleanMetrics.cutoff_error_pct) < 0.50;
phase_mean_near_clean_check = abs(phase_dev_mean - cleanMetrics.phase_deviation_fc_deg) < 0.50;

fprintf('Day 19 checks:\n');
fprintf('Valid runs check: %s\n', passfail(valid_runs_check));
fprintf('Gain-error std check: %s\n', passfail(gain_std_check));
fprintf('Cutoff-error std check: %s\n', passfail(cutoff_std_check));
fprintf('Phase-deviation std check: %s\n', passfail(phase_std_check));
fprintf('Cutoff mean near clean check: %s\n', passfail(cutoff_mean_near_clean_check));
fprintf('Phase mean near clean check: %s\n', passfail(phase_mean_near_clean_check));

allChecks = valid_runs_check && gain_std_check && cutoff_std_check && ...
            phase_std_check && cutoff_mean_near_clean_check && ...
            phase_mean_near_clean_check;

fprintf('\nOverall result: %s\n', passfail(allChecks));

%% Save per-seed results
perSeedTable = table(seeds(:), valid, K_eff_all, fc_eff_all, gain_err_all, ...
    cutoff_err_all, phase_dev_all, ...
    'VariableNames', {'seed', 'valid', 'K_eff', 'fc_eff_Hz', ...
    'gain_error_pct', 'cutoff_error_pct', 'phase_deviation_fc_deg'});

perSeedCsv = fullfile(resultsDir, 'day19_monte_carlo_per_seed_results.csv');
writetable(perSeedTable, perSeedCsv);

%% Save summary table
metricNames = {'K_eff'; 'fc_eff'; 'gain_error'; 'cutoff_error'; 'phase_deviation'};
units = {'linear'; 'Hz'; 'percent'; 'percent'; 'degrees'};
cleanVals = [cleanMetrics.K_eff; cleanMetrics.fc_eff; cleanMetrics.gain_error_pct; ...
             cleanMetrics.cutoff_error_pct; cleanMetrics.phase_deviation_fc_deg];
meanVals = [K_eff_mean; fc_eff_mean; gain_err_mean; cutoff_err_mean; phase_dev_mean];
stdVals = [K_eff_std; fc_eff_std; gain_err_std; cutoff_err_std; phase_dev_std];
meanMinusClean = meanVals - cleanVals;

summaryTable = table(metricNames, units, cleanVals, meanVals, stdVals, meanMinusClean, ...
    'VariableNames', {'metric', 'unit', 'clean_value', 'mc_mean', 'mc_std', 'mean_minus_clean'});

summaryCsv = fullfile(resultsDir, 'day19_monte_carlo_summary.csv');
writetable(summaryTable, summaryCsv);

%% Save Markdown summary
summaryMd = fullfile(resultsDir, 'day19_monte_carlo_summary.md');
fid = fopen(summaryMd, 'w');

fprintf(fid, '# Day 19 Monte Carlo Noisy Extraction Summary\n\n');
fprintf(fid, 'This is a virtual measurement-style noisy extraction test. It is not experimental measurement.\n\n');
fprintf(fid, '- Number of seeds: %d\n', N);
fprintf(fid, '- Valid runs: %d / %d\n', validCount, N);
fprintf(fid, '- Failed runs: %d / %d\n', failedCount, N);
fprintf(fid, '- Magnitude noise: %.4f dB\n', magNoise_dB);
fprintf(fid, '- Phase noise: %.4f deg\n\n', phaseNoise_deg);

fprintf(fid, '| Metric | Unit | Clean value | MC mean | MC std | Mean - clean |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|\n');

for ii = 1:numel(metricNames)
    fprintf(fid, '| %s | %s | %.10g | %.10g | %.10g | %.10g |\n', ...
        metricNames{ii}, units{ii}, cleanVals(ii), meanVals(ii), stdVals(ii), meanMinusClean(ii));
end

fprintf(fid, '\n## Interpretation\n\n');
fprintf(fid, 'The Monte Carlo results show whether the noisy extraction method remains stable across multiple random seeds. ');
fprintf(fid, 'The reported values are mean ± standard deviation over valid runs. Failed extraction cases, if any, are counted explicitly.\n');

fclose(fid);

%% Figures
fig1 = figure('Name', 'Day 19 Monte Carlo Cutoff Error');
semilogx(seeds(valid), cutoff_err_all(valid), 'o-', 'LineWidth', 1.5);
hold on;
yline(cleanMetrics.cutoff_error_pct, '--', 'Clean baseline');
grid on;
xlabel('Seed');
ylabel('Cutoff error (%)');
title('Day 19 Monte Carlo: Cutoff Error Across Seeds');
legend('Noisy smoothed extraction', 'Clean baseline', 'Location', 'best');
ax1 = gca;
exportgraphics(ax1, fullfile(figuresDir, 'day19_monte_carlo_cutoff_error.png'), 'Resolution', 300);

fig2 = figure('Name', 'Day 19 Monte Carlo Phase Deviation');
semilogx(seeds(valid), phase_dev_all(valid), 'o-', 'LineWidth', 1.5);
hold on;
yline(cleanMetrics.phase_deviation_fc_deg, '--', 'Clean baseline');
grid on;
xlabel('Seed');
ylabel('Phase deviation at fc (degrees)');
title('Day 19 Monte Carlo: Phase Deviation Across Seeds');
legend('Noisy smoothed extraction', 'Clean baseline', 'Location', 'best');
ax2 = gca;
exportgraphics(ax2, fullfile(figuresDir, 'day19_monte_carlo_phase_deviation.png'), 'Resolution', 300);

fprintf('\nSaved per-seed results to:\n%s\n', perSeedCsv);
fprintf('Saved summary CSV to:\n%s\n', summaryCsv);
fprintf('Saved summary Markdown to:\n%s\n', summaryMd);
fprintf('Figures saved to:\n%s\n', figuresDir);

%% Local helper function
function s = passfail(condition)
    if condition
        s = 'PASS';
    else
        s = 'FAIL';
    end
end