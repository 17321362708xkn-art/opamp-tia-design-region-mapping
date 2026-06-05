clear; clc; close all;

%% Robust path setup
thisFile = mfilename('fullpath');
[thisDir, ~, ~] = fileparts(thisFile);
projectRoot = fileparts(thisDir);
functionsDir = fullfile(projectRoot, 'functions');
figuresDir = fullfile(projectRoot, 'figures');

if ~exist(functionsDir, 'dir')
    error('Functions folder not found: %s', functionsDir);
end

if ~exist(figuresDir, 'dir')
    mkdir(figuresDir);
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
M = 20;
ft_Hz = M * (1 + K) * fc_target;

% Full extraction frequency vector: 0.001fc to 1000fc.
f = logspace(log10(fc_target/1000), log10(fc_target*1000), 3000);

out = active_lpf_response(f, Rin, Rf, Cf, A0, ft_Hz);
f_used = out.f;

%% Clean ideal extraction
metrics = extract_frequency_metrics(f_used, out.G_ideal, K, fc_target, false);

fprintf('Day 15 clean ideal extraction verification\n');
fprintf('------------------------------------------\n');
fprintf('K = %.8f\n', K);
fprintf('fc_target = %.8f Hz\n', fc_target);
fprintf('out.fc = %.8f Hz\n', out.fc);
fprintf('useSmoothing = false\n\n');

fprintf('Extracted metrics from clean ideal data:\n');
fprintf('K_eff = %.10f\n', metrics.K_eff);
fprintf('gain_error_pct = %.10f %%\n', metrics.gain_error_pct);
fprintf('fc_eff = %.10f Hz\n', metrics.fc_eff);
fprintf('cutoff_error_pct = %.10f %%\n', metrics.cutoff_error_pct);
fprintf('phi_response_fc_deg = %.10f deg\n', metrics.phi_response_fc_deg);
fprintf('phase_deviation_fc_deg = %.10f deg\n\n', metrics.phase_deviation_fc_deg);

%% Pass criteria for clean ideal data
fc_formula_pass = abs(out.fc - fc_target) / fc_target < 1e-12;
gain_error_pass = abs(metrics.gain_error_pct) < 0.01;
cutoff_error_pass = abs(metrics.cutoff_error_pct) < 0.01;
phase_dev_pass = abs(metrics.phase_deviation_fc_deg) < 0.01;

fprintf('Day 15 checks:\n');
fprintf('fc formula check: %s\n', passfail(fc_formula_pass));
fprintf('gain error near zero check: %s\n', passfail(gain_error_pass));
fprintf('cutoff error near zero check: %s\n', passfail(cutoff_error_pass));
fprintf('phase deviation near zero check: %s\n', passfail(phase_dev_pass));

all_pass = fc_formula_pass && gain_error_pass && cutoff_error_pass && phase_dev_pass;

fprintf('\nOverall result: %s\n', passfail(all_pass));

%% Figure: clean ideal extraction marker
mag_dB = 20*log10(abs(out.G_ideal));
phase_deg = unwrap(angle(out.G_ideal)) * 180/pi;

figure;
semilogx(f_used, mag_dB, 'LineWidth', 1.4); hold on;
xline(fc_target, 'k--', 'f_c');
yline(20*log10(metrics.K_eff/sqrt(2)), 'r--', '-3 dB threshold');
plot(metrics.fc_eff, 20*log10(metrics.K_eff/sqrt(2)), 'ro', 'MarkerFaceColor', 'r');
grid on;
xlabel('Frequency (Hz)');
ylabel('|G_{ideal}| (dB)');
title('Day 15 Clean Ideal Extraction: Cutoff Detection');
legend('Ideal response', 'f_c', '-3 dB threshold', 'extracted f_c', 'Location', 'southwest');
saveas(gcf, fullfile(figuresDir, 'day15_clean_ideal_cutoff_extraction.png'));

figure;
semilogx(f_used, phase_deg, 'LineWidth', 1.4); hold on;
xline(fc_target, 'k--', 'f_c');
yline(-45, 'r--', '-45 deg');
plot(fc_target, metrics.phi_response_fc_deg, 'ro', 'MarkerFaceColor', 'r');
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase of G_{ideal} (degrees)');
title('Day 15 Clean Ideal Extraction: Phase at f_c');
legend('Ideal phase', 'f_c', '-45 deg', 'extracted phase', 'Location', 'southwest');
saveas(gcf, fullfile(figuresDir, 'day15_clean_ideal_phase_extraction.png'));

fprintf('\nFigures saved to:\n%s\n', figuresDir);

%% Local helper function
function s = passfail(flag)
    if flag
        s = 'PASS';
    else
        s = 'FAIL';
    end
end