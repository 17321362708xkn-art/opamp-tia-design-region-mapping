clear; clc; close all;

%% Robust path setup
scriptFullPath = mfilename('fullpath');

if isempty(scriptFullPath)
    scriptDir = pwd;
else
    scriptDir = fileparts(scriptFullPath);
end

projectRoot = fileparts(scriptDir);
functionsDir = fullfile(projectRoot, 'functions');
figuresDir = fullfile(projectRoot, 'figures');
resultsDir = fullfile(scriptDir, 'results');

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
fprintf('Using add_measurement_noise from:\n%s\n\n', which('add_measurement_noise'));
fprintf('Using extract_frequency_metrics from:\n%s\n\n', which('extract_frequency_metrics'));

%% Parameters
Rin = 10e3;
K = 10;
Rf = K * Rin;

fc_target = 10e3;
Cf = 1 / (2*pi*Rf*fc_target);

A0 = 1e5;
M = 20;
ft_Hz = M * (1 + K) * fc_target;

f = logspace(log10(fc_target/1000), log10(fc_target*1000), 3000);

magNoise_dB = 0.05;
phaseNoise_deg = 0.5;
seed = 18;

%% Generate clean and noisy responses
out = active_lpf_response(f, Rin, Rf, Cf, A0, ft_Hz);
f_used = out.f;
G_clean = out.G_nonideal;

G_noisy = add_measurement_noise(G_clean, magNoise_dB, phaseNoise_deg, seed);

%% Extract metrics
metrics_clean = extract_frequency_metrics(f_used, G_clean, K, fc_target, false);
metrics_noisy_raw = extract_frequency_metrics(f_used, G_noisy, K, fc_target, false);
metrics_noisy_smooth = extract_frequency_metrics(f_used, G_noisy, K, fc_target, true);

%% Compute differences relative to clean extraction
gain_diff_raw_pct = metrics_noisy_raw.gain_error_pct - metrics_clean.gain_error_pct;
cutoff_diff_raw_pct = metrics_noisy_raw.cutoff_error_pct - metrics_clean.cutoff_error_pct;
phase_diff_raw_deg = metrics_noisy_raw.phase_deviation_fc_deg - metrics_clean.phase_deviation_fc_deg;

gain_diff_smooth_pct = metrics_noisy_smooth.gain_error_pct - metrics_clean.gain_error_pct;
cutoff_diff_smooth_pct = metrics_noisy_smooth.cutoff_error_pct - metrics_clean.cutoff_error_pct;
phase_diff_smooth_deg = metrics_noisy_smooth.phase_deviation_fc_deg - metrics_clean.phase_deviation_fc_deg;

%% Print results
fprintf('Day 18 noisy extraction with smoothing + sustained crossing\n');
fprintf('----------------------------------------------------------\n');
fprintf('K = %.8f\n', K);
fprintf('A0 = %.6e\n', A0);
fprintf('fc_target = %.8f Hz\n', fc_target);
fprintf('M = %.8f\n', M);
fprintf('ft_Hz = %.6e Hz\n', ft_Hz);
fprintf('Noise settings: mag = %.4f dB, phase = %.4f deg\n', magNoise_dB, phaseNoise_deg);
fprintf('Seed = %d\n\n', seed);

fprintf('Extraction summary:\n');
fprintf('--------------------------------------------------------------------------------------------------------------\n');
fprintf('%-24s %12s %14s %14s %16s %16s\n', ...
        'Data case', 'K_eff', 'fc_eff_Hz', 'gainErr_%', 'cutoffErr_%', 'phaseDev_deg');
fprintf('--------------------------------------------------------------------------------------------------------------\n');

fprintf('%-24s %12.8f %14.4f %14.6f %16.6f %16.6f\n', ...
        'Clean non-ideal', metrics_clean.K_eff, metrics_clean.fc_eff, ...
        metrics_clean.gain_error_pct, metrics_clean.cutoff_error_pct, ...
        metrics_clean.phase_deviation_fc_deg);

fprintf('%-24s %12.8f %14.4f %14.6f %16.6f %16.6f\n', ...
        'Noisy raw', metrics_noisy_raw.K_eff, metrics_noisy_raw.fc_eff, ...
        metrics_noisy_raw.gain_error_pct, metrics_noisy_raw.cutoff_error_pct, ...
        metrics_noisy_raw.phase_deviation_fc_deg);

fprintf('%-24s %12.8f %14.4f %14.6f %16.6f %16.6f\n', ...
        'Noisy smoothed', metrics_noisy_smooth.K_eff, metrics_noisy_smooth.fc_eff, ...
        metrics_noisy_smooth.gain_error_pct, metrics_noisy_smooth.cutoff_error_pct, ...
        metrics_noisy_smooth.phase_deviation_fc_deg);

fprintf('--------------------------------------------------------------------------------------------------------------\n\n');

fprintf('Difference from clean extraction:\n');
fprintf('  Raw noisy gain error difference      = %.6f %%\n', gain_diff_raw_pct);
fprintf('  Raw noisy cutoff error difference    = %.6f %%\n', cutoff_diff_raw_pct);
fprintf('  Raw noisy phase deviation difference = %.6f deg\n', phase_diff_raw_deg);
fprintf('  Smoothed gain error difference       = %.6f %%\n', gain_diff_smooth_pct);
fprintf('  Smoothed cutoff error difference     = %.6f %%\n', cutoff_diff_smooth_pct);
fprintf('  Smoothed phase deviation difference  = %.6f deg\n\n', phase_diff_smooth_deg);

%% Checks
finite_clean = isfinite(metrics_clean.K_eff) && isfinite(metrics_clean.fc_eff) && ...
               isfinite(metrics_clean.gain_error_pct) && isfinite(metrics_clean.cutoff_error_pct) && ...
               isfinite(metrics_clean.phase_deviation_fc_deg);

finite_noisy_raw = isfinite(metrics_noisy_raw.K_eff) && isfinite(metrics_noisy_raw.fc_eff) && ...
                   isfinite(metrics_noisy_raw.gain_error_pct) && isfinite(metrics_noisy_raw.cutoff_error_pct) && ...
                   isfinite(metrics_noisy_raw.phase_deviation_fc_deg);

finite_noisy_smooth = isfinite(metrics_noisy_smooth.K_eff) && isfinite(metrics_noisy_smooth.fc_eff) && ...
                      isfinite(metrics_noisy_smooth.gain_error_pct) && isfinite(metrics_noisy_smooth.cutoff_error_pct) && ...
                      isfinite(metrics_noisy_smooth.phase_deviation_fc_deg);

% Tolerances are intentionally not too tight because this is a noisy virtual data test.
gain_close_check = abs(gain_diff_smooth_pct) < 0.20;
cutoff_close_check = abs(cutoff_diff_smooth_pct) < 2.00;
phase_close_check = abs(phase_diff_smooth_deg) < 2.00;

% The smoothed extraction should not be dramatically worse than raw extraction.
cutoff_not_worse_check = abs(cutoff_diff_smooth_pct) <= abs(cutoff_diff_raw_pct) + 0.50;
phase_not_worse_check = abs(phase_diff_smooth_deg) <= abs(phase_diff_raw_deg) + 0.50;

fprintf('Day 18 checks:\n');
fprintf('Clean extraction finite check: %s\n', passfail(finite_clean));
fprintf('Noisy raw extraction finite check: %s\n', passfail(finite_noisy_raw));
fprintf('Noisy smoothed extraction finite check: %s\n', passfail(finite_noisy_smooth));
fprintf('Smoothed gain difference tolerance check: %s\n', passfail(gain_close_check));
fprintf('Smoothed cutoff difference tolerance check: %s\n', passfail(cutoff_close_check));
fprintf('Smoothed phase difference tolerance check: %s\n', passfail(phase_close_check));
fprintf('Smoothed cutoff not dramatically worse check: %s\n', passfail(cutoff_not_worse_check));
fprintf('Smoothed phase not dramatically worse check: %s\n', passfail(phase_not_worse_check));

overall_pass = finite_clean && finite_noisy_raw && finite_noisy_smooth && ...
               gain_close_check && cutoff_close_check && phase_close_check && ...
               cutoff_not_worse_check && phase_not_worse_check;

fprintf('\nOverall result: %s\n', passfail(overall_pass));

%% Save result tables
summaryTable = table( ...
    {'Clean non-ideal'; 'Noisy raw'; 'Noisy smoothed'}, ...
    [metrics_clean.K_eff; metrics_noisy_raw.K_eff; metrics_noisy_smooth.K_eff], ...
    [metrics_clean.fc_eff; metrics_noisy_raw.fc_eff; metrics_noisy_smooth.fc_eff], ...
    [metrics_clean.gain_error_pct; metrics_noisy_raw.gain_error_pct; metrics_noisy_smooth.gain_error_pct], ...
    [metrics_clean.cutoff_error_pct; metrics_noisy_raw.cutoff_error_pct; metrics_noisy_smooth.cutoff_error_pct], ...
    [metrics_clean.phase_deviation_fc_deg; metrics_noisy_raw.phase_deviation_fc_deg; metrics_noisy_smooth.phase_deviation_fc_deg], ...
    'VariableNames', {'DataCase','K_eff','fc_eff_Hz','gainErr_pct','cutoffErr_pct','phaseDev_deg'});

csvPath = fullfile(resultsDir, 'day18_noisy_extraction_summary.csv');
writetable(summaryTable, csvPath);

mdPath = fullfile(resultsDir, 'day18_noisy_extraction_summary.md');
fid = fopen(mdPath, 'w');
fprintf(fid, '# Day 18 Noisy Extraction Summary\n\n');
fprintf(fid, '| Data case | K_eff | fc_eff_Hz | gainErr_pct | cutoffErr_pct | phaseDev_deg |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|\n');
for i = 1:height(summaryTable)
    fprintf(fid, '| %s | %.8f | %.4f | %.6f | %.6f | %.6f |\n', ...
        summaryTable.DataCase{i}, summaryTable.K_eff(i), summaryTable.fc_eff_Hz(i), ...
        summaryTable.gainErr_pct(i), summaryTable.cutoffErr_pct(i), summaryTable.phaseDev_deg(i));
end
fclose(fid);

%% Prepare smoothed curves for plots
mag_clean_dB = 20*log10(abs(G_clean));
mag_noisy_dB = 20*log10(abs(G_noisy));
mag_noisy_smooth_dB = movmedian(mag_noisy_dB, 9);

phase_clean_deg = unwrap(angle(G_clean)) * 180/pi;
phase_noisy_deg = unwrap(angle(G_noisy)) * 180/pi;
phase_noisy_smooth_deg = movmedian(phase_noisy_deg, 9);

K_eff_smooth = metrics_noisy_smooth.K_eff;
target_dB_smooth = 20*log10(K_eff_smooth / sqrt(2));

%% Figure 1: magnitude extraction
fig1 = figure('Name', 'Day 18 noisy extraction magnitude');
semilogx(f_used, mag_clean_dB, 'LineWidth', 1.5); hold on;
semilogx(f_used, mag_noisy_dB, '.', 'MarkerSize', 4);
semilogx(f_used, mag_noisy_smooth_dB, '--', 'LineWidth', 1.2);
yline(target_dB_smooth, 'r--', '-3 dB threshold');
xline(fc_target, 'k--', 'f_c');

if isfinite(metrics_noisy_smooth.fc_eff)
    plot(metrics_noisy_smooth.fc_eff, target_dB_smooth, 'ro', 'MarkerFaceColor', 'r');
end

grid on;
xlabel('Frequency (Hz)');
ylabel('|G| (dB)');
title('Day 18 Noisy Extraction: Magnitude and Cutoff Detection');
legend('Clean non-ideal', 'Noisy virtual data', 'Smoothed noisy data', ...
       '-3 dB threshold', 'Location', 'SouthWest');
try
    ax = gca;
    ax.Toolbar.Visible = 'off';
catch
end
exportgraphics(fig1, fullfile(figuresDir, 'day18_noisy_extraction_magnitude.png'), 'Resolution', 200);

%% Figure 2: phase extraction
fig2 = figure('Name', 'Day 18 noisy extraction phase');
semilogx(f_used, phase_clean_deg, 'LineWidth', 1.5); hold on;
semilogx(f_used, phase_noisy_deg, '.', 'MarkerSize', 4);
semilogx(f_used, phase_noisy_smooth_deg, '--', 'LineWidth', 1.2);
xline(fc_target, 'k--', 'f_c');
yline(-45, 'r--', '-45 deg reference');

phi_smooth_fc = interp1(log10(f_used), phase_noisy_smooth_deg, log10(fc_target), 'linear', 'extrap');
plot(fc_target, phi_smooth_fc, 'ro', 'MarkerFaceColor', 'r');

grid on;
xlabel('Frequency (Hz)');
ylabel('Phase of G (degrees)');
title('Day 18 Noisy Extraction: Phase at f_c');
legend('Clean non-ideal', 'Noisy virtual data', 'Smoothed noisy data', ...
       '-45 deg reference', 'Location', 'SouthWest');
try
    ax = gca;
    ax.Toolbar.Visible = 'off';
catch
end
exportgraphics(fig2, fullfile(figuresDir, 'day18_noisy_extraction_phase.png'), 'Resolution', 200);

fprintf('\nSaved CSV table to:\n%s\n', csvPath);
fprintf('Saved Markdown table to:\n%s\n', mdPath);
fprintf('Figures saved to:\n%s\n', figuresDir);

%% Local helper
function txt = passfail(cond)
    if cond
        txt = 'PASS';
    else
        txt = 'FAIL';
    end
end