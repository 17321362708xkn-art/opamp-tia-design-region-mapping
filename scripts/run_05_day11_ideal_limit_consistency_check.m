clear; clc; close all;

%% Robust project path setup

scriptDir = fileparts(mfilename('fullpath'));

if isempty(scriptDir)
    scriptDir = pwd;
end

candidateRoots = {
    scriptDir
    pwd
    fileparts(scriptDir)
    fileparts(fileparts(scriptDir))
};

projectRoot = '';
functionDir = '';

for i = 1:numel(candidateRoots)
    candidateRoot = candidateRoots{i};
    candidateFunctionDir = fullfile(candidateRoot, 'functions');

    if exist(fullfile(candidateFunctionDir, 'active_lpf_response.m'), 'file')
        projectRoot = candidateRoot;
        functionDir = candidateFunctionDir;
        break;
    end
end

if isempty(projectRoot)
    error('Could not find functions/active_lpf_response.m. Check project folder structure.');
end

addpath(functionDir);

figureDir = fullfile(projectRoot, 'figures');

if ~exist(figureDir, 'dir')
    mkdir(figureDir);
end

fprintf('Using active_lpf_response from:\n%s\n\n', which('active_lpf_response'));

%% Day 11 parameters

Rin = 10e3;
K = 10;
Rf = K * Rin;

fc_target = 10e3;
Cf = 1 / (2*pi*Rf*fc_target);

A0 = 1e9;
M = 1000;

ft_Hz = M * (1 + K) * fc_target;

% Use full extraction vector.
% This full vector is needed for stable cutoff extraction.
f = logspace(log10(fc_target/1000), log10(fc_target*1000), 10000);

out = active_lpf_response(f, Rin, Rf, Cf, A0, ft_Hz);
f_used = out.f;

%% Band-limited response-error comparison

idx_band = f_used >= 0.01*fc_target & f_used <= 10*fc_target;

err_vs_ideal = compare_frequency_responses( ...
    out.G_nonideal(idx_band), out.G_ideal(idx_band));

%% Cutoff extraction using full frequency vector

metrics = extract_frequency_metrics(f_used, out.G_nonideal, K, fc_target, false);

%% Additional direct checks

M_check = out.M_index;
fp_expected = ft_Hz / sqrt(A0^2 - 1);

% Response ratio for plotting over the band of interest
ratio_band = out.G_nonideal(idx_band) ./ out.G_ideal(idx_band);

mag_err_curve_dB = 20*log10(abs(ratio_band));
phase_err_curve_deg = unwrap(angle(ratio_band)) * 180/pi;

f_band = f_used(idx_band);

%% Pass criteria

mag_tol_dB = 0.01;
phase_tol_deg = 0.1;
cutoff_tol_pct = 0.1;
phase_dev_tol_deg = 0.1;

M_pass = abs(M_check - M) < 1e-9;
fp_pass = abs(out.fp - fp_expected) / fp_expected < 1e-12;

mag_pass = err_vs_ideal.max_mag_err_dB < mag_tol_dB;
phase_pass = err_vs_ideal.max_phase_err_deg < phase_tol_deg;
cutoff_pass = abs(metrics.cutoff_error_pct) < cutoff_tol_pct;
phase_dev_pass = abs(metrics.phase_deviation_fc_deg) < phase_dev_tol_deg;

overall_pass = M_pass && fp_pass && mag_pass && phase_pass && cutoff_pass && phase_dev_pass;

%% Print results

fprintf('Day 11 ideal-limit consistency check\n');
fprintf('------------------------------------\n');
fprintf('K = %.6f\n', K);
fprintf('A0 = %.6e\n', A0);
fprintf('fc_target = %.6f Hz\n', fc_target);
fprintf('ft_Hz = %.6e Hz\n', ft_Hz);
fprintf('out.fp = %.12e Hz\n', out.fp);
fprintf('expected fp = %.12e Hz\n', fp_expected);
fprintf('M index = %.6f\n', M_check);
fprintf('Expected M = %.6f\n', M);
fprintf('Full extraction frequency range = %.3e Hz to %.3e Hz\n', min(f_used), max(f_used));
fprintf('Response-error comparison band = %.3e Hz to %.3e Hz\n\n', ...
        min(f_band), max(f_band));

fprintf('Ideal-limit consistency results:\n');
fprintf('------------------------------------------------------------\n');
fprintf('Max magnitude error vs ideal = %.9f dB\n', err_vs_ideal.max_mag_err_dB);
fprintf('Pass criterion               = < %.6f dB\n', mag_tol_dB);
fprintf('Max phase error vs ideal     = %.9f deg\n', err_vs_ideal.max_phase_err_deg);
fprintf('Pass criterion               = < %.6f deg\n', phase_tol_deg);
fprintf('Extracted fc_eff             = %.6f Hz\n', metrics.fc_eff);
fprintf('Cutoff error                 = %.9f %%\n', metrics.cutoff_error_pct);
fprintf('Pass criterion               = |E_fc| < %.6f %%\n', cutoff_tol_pct);
fprintf('Phase deviation at fc        = %.9f deg\n', metrics.phase_deviation_fc_deg);
fprintf('Pass criterion               = < %.6f deg in magnitude\n', phase_dev_tol_deg);
fprintf('------------------------------------------------------------\n\n');

fprintf('Day 11 verification checks:\n');
fprintf('M index check: %s\n', passfail(M_pass));
fprintf('fp formula check: %s\n', passfail(fp_pass));
fprintf('Magnitude error tolerance check: %s\n', passfail(mag_pass));
fprintf('Phase error tolerance check: %s\n', passfail(phase_pass));
fprintf('Cutoff error tolerance check: %s\n', passfail(cutoff_pass));
fprintf('Phase deviation tolerance check: %s\n', passfail(phase_dev_pass));

if overall_pass
    fprintf('\nOverall result: PASS\n');
else
    fprintf('\nOverall result: FAIL\n');
end

%% Plot magnitude error over band

figure;

semilogx(f_band, mag_err_curve_dB, 'LineWidth', 1.4);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude error (dB)');
title('Day 11 Ideal-Limit Check: Magnitude Error vs Ideal');

xline(fc_target, '--k', 'f_c', 'LabelVerticalAlignment', 'bottom');
yline(mag_tol_dB, '--r', '+0.01 dB tolerance');
yline(-mag_tol_dB, '--r', '-0.01 dB tolerance');

saveas(gcf, fullfile(figureDir, 'day11_ideal_limit_magnitude_error.png'));

%% Plot phase error over band

figure;

semilogx(f_band, phase_err_curve_deg, 'LineWidth', 1.4);
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase error (degrees)');
title('Day 11 Ideal-Limit Check: Phase Error vs Ideal');

xline(fc_target, '--k', 'f_c', 'LabelVerticalAlignment', 'bottom');
yline(phase_tol_deg, '--r', '+0.1 deg tolerance');
yline(-phase_tol_deg, '--r', '-0.1 deg tolerance');

saveas(gcf, fullfile(figureDir, 'day11_ideal_limit_phase_error.png'));

fprintf('\nFigures saved to:\n%s\n', figureDir);

%% Local helper function

function txt = passfail(flag)
    if flag
        txt = 'PASS';
    else
        txt = 'FAIL';
    end
end