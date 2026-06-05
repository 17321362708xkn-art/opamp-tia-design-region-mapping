clear; clc; close all;

%% Robust path setup
scriptDir = fileparts(mfilename('fullpath'));

candidatePaths = {
    scriptDir, ...
    fullfile(scriptDir, 'functions'), ...
    fullfile(scriptDir, '..', 'functions')
};

for ii = 1:numel(candidatePaths)
    thisPath = candidatePaths{ii};
    if isfolder(thisPath)
        addpath(thisPath);
    end
end

if exist('active_lpf_response', 'file') ~= 2
    error(['active_lpf_response.m was not found. ', ...
           'Place it in the same folder as this script, ', ...
           'or in a functions folder next to this script.']);
end

fprintf('Using active_lpf_response from:\n%s\n\n', which('active_lpf_response'));

%% Baseline parameters
Rin = 10e3;
K = 10;
Rf = K * Rin;

fc_target = 10e3;
Cf = 1 / (2*pi*Rf*fc_target);

A0 = 1e5;
M_for_call = 1000;
ft_Hz = M_for_call * (1 + K) * fc_target;

f = logspace(log10(fc_target/1000), log10(fc_target*1000), 3000);

%% Compute frequency response
out = active_lpf_response(f, Rin, Rf, Cf, A0, ft_Hz);
f_used = out.f;

%% Exact check at fc
out_fc = active_lpf_response(fc_target, Rin, Rf, Cf, A0, ft_Hz);

G_fc = out_fc.G_ideal;
mag_fc = abs(G_fc);
mag_fc_expected = K / sqrt(2);

mag_ratio_dB = 20*log10(mag_fc / K);
mag_ratio_expected_dB = -20*log10(sqrt(2));

phase_fc_deg = unwrap(angle(G_fc)) * 180/pi;
phase_fc_expected_deg = -45;

%% Low-frequency gain estimate
low_idx = f_used <= fc_target/100;
K_low_est = median(abs(out.G_ideal(low_idx)));

%% Numerical checks
fc_ok = abs(out.fc - fc_target) < 1e-9 * fc_target;
mag_ok = abs(mag_fc - mag_fc_expected) < 1e-6;
phase_ok = abs(phase_fc_deg - phase_fc_expected_deg) < 1e-6;
low_gain_ok = abs(K_low_est - K) < 1e-3;

overall_ok = fc_ok && mag_ok && phase_ok && low_gain_ok;

%% Print results
fprintf('Ideal model verification results:\n');
fprintf('--------------------------------\n');
fprintf('K = %.6f\n', K);
fprintf('fc_target = %.6f Hz\n', fc_target);
fprintf('out.fc = %.6f Hz\n', out.fc);
fprintf('Cf = %.6e F\n\n', Cf);

fprintf('At f = fc:\n');
fprintf('|G_ideal(fc)| = %.8f\n', mag_fc);
fprintf('Expected K/sqrt(2) = %.8f\n', mag_fc_expected);
fprintf('Magnitude ratio relative to K = %.6f dB\n', mag_ratio_dB);
fprintf('Expected magnitude ratio = %.6f dB\n', mag_ratio_expected_dB);
fprintf('Phase(G_ideal(fc)) = %.6f deg\n', phase_fc_deg);
fprintf('Expected phase = %.6f deg\n\n', phase_fc_expected_deg);

fprintf('Low-frequency gain estimate:\n');
fprintf('K_low_est = %.8f\n', K_low_est);
fprintf('Expected K = %.8f\n\n', K);

fprintf('Verification checks:\n');
fprintf('fc formula check: %s\n', passfail(fc_ok));
fprintf('magnitude at fc check: %s\n', passfail(mag_ok));
fprintf('phase at fc check: %s\n', passfail(phase_ok));
fprintf('low-frequency gain check: %s\n\n', passfail(low_gain_ok));

fprintf('Overall result: %s\n', passfail(overall_ok));

%% Plot ideal magnitude response
figDir = fullfile(scriptDir, 'figures');
if ~isfolder(figDir)
    mkdir(figDir);
end

mag_dB = 20*log10(abs(out.G_ideal));
phase_deg = unwrap(angle(out.G_ideal)) * 180/pi;

figure;
semilogx(f_used, mag_dB, 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('|G_{ideal}| (dB)');
title('Ideal Inversion-Removed Magnitude Response');
hold on;
xline(fc_target, '--k', 'f_c');
yline(20*log10(K/sqrt(2)), '--k', '-3 dB point');
hold off;
saveas(gcf, fullfile(figDir, 'figure_02_ideal_magnitude.png'));

%% Plot ideal phase response
figure;
semilogx(f_used, phase_deg, 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase of G_{ideal} (degrees)');
title('Ideal Inversion-Removed Phase Response');
hold on;
xline(fc_target, '--k', 'f_c');
yline(-45, '--k', '-45 deg');
hold off;
saveas(gcf, fullfile(figDir, 'figure_03_ideal_phase.png'));

%% Local helper function
function txt = passfail(flag)
    if flag
        txt = 'PASS';
    else
        txt = 'FAIL';
    end
end