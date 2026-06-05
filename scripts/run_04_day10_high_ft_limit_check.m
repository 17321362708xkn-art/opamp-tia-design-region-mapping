clear; clc; close all;

%% Robust project path setup
scriptDir = fileparts(mfilename('fullpath'));

candidateRoots = {
    scriptDir
    fileparts(scriptDir)
    fileparts(fileparts(scriptDir))
};

projectRoot = '';
functionsDir = '';

for i = 1:numel(candidateRoots)
    testFunctionsDir = fullfile(candidateRoots{i}, 'functions');
    testFunctionFile = fullfile(testFunctionsDir, 'active_lpf_response.m');

    if exist(testFunctionFile, 'file') == 2
        projectRoot = candidateRoots{i};
        functionsDir = testFunctionsDir;
        break;
    end
end

if isempty(projectRoot)
    error('Could not locate the project root folder containing the functions folder.');
end

addpath(functionsDir);

figuresDir = fullfile(projectRoot, 'figures');
if exist(figuresDir, 'dir') ~= 7
    mkdir(figuresDir);
end

fprintf('Using active_lpf_response from:\n%s\n\n', which('active_lpf_response'));

%% Baseline parameters
Rin = 10e3;
K = 10;
Rf = K * Rin;

fc_target = 10e3;
Cf = 1 / (2*pi*Rf*fc_target);

A0 = 1e5;
M_list = [50 500 1000];

f = logspace(log10(fc_target/1000), log10(fc_target*1000), 3000);

%% Storage
maxMagErrVsIdeal_dB = NaN(size(M_list));
maxPhaseErrVsIdeal_deg = NaN(size(M_list));
maxMagErrVsA0Limit_dB = NaN(size(M_list));
maxPhaseErrVsA0Limit_deg = NaN(size(M_list));
ft_all = NaN(size(M_list));
fp_all = NaN(size(M_list));
M_check_all = NaN(size(M_list));

%% Loop over high M values
for n = 1:numel(M_list)
    M = M_list(n);
    ft_Hz = M * (1 + K) * fc_target;

    out = active_lpf_response(f, Rin, Rf, Cf, A0, ft_Hz);
    f_used = out.f;

    idx_band = f_used >= 0.01*fc_target & f_used <= 10*fc_target;

    err_vs_ideal = compare_frequency_responses( ...
        out.G_nonideal(idx_band), out.G_ideal(idx_band));

    err_vs_A0_limit = compare_frequency_responses( ...
        out.G_nonideal(idx_band), out.G_A0_limit(idx_band));

    maxMagErrVsIdeal_dB(n) = err_vs_ideal.max_mag_err_dB;
    maxPhaseErrVsIdeal_deg(n) = err_vs_ideal.max_phase_err_deg;

    maxMagErrVsA0Limit_dB(n) = err_vs_A0_limit.max_mag_err_dB;
    maxPhaseErrVsA0Limit_deg(n) = err_vs_A0_limit.max_phase_err_deg;

    ft_all(n) = out.ft_Hz;
    fp_all(n) = out.fp;
    M_check_all(n) = out.M_index;
end

%% Compare finite-A0 limit itself with ideal response
M_ref = M_list(end);
ft_ref = M_ref * (1 + K) * fc_target;
out_ref = active_lpf_response(f, Rin, Rf, Cf, A0, ft_ref);
f_used = out_ref.f;

idx_band = f_used >= 0.01*fc_target & f_used <= 10*fc_target;

err_A0_limit_vs_ideal = compare_frequency_responses( ...
    out_ref.G_A0_limit(idx_band), out_ref.G_ideal(idx_band));

%% Print summary
fprintf('Day 10 high-ft limit check, fixed A0\n');
fprintf('------------------------------------\n');
fprintf('K = %.6f\n', K);
fprintf('A0 = %.6e\n', A0);
fprintf('fc_target = %.6f Hz\n', fc_target);
fprintf('Comparison band = %.3e Hz to %.3e Hz\n', 0.01*fc_target, 10*fc_target);
fprintf('M is used as GBW margin index, not stability margin.\n\n');

fprintf('High-ft limit check table:\n');
fprintf('-------------------------------------------------------------------------------------------------------------\n');
fprintf('%8s %14s %14s %18s %18s %22s %22s\n', ...
    'M', 'ft_Hz', 'fp_Hz', ...
    'magErrIdeal_dB', 'phErrIdeal_deg', ...
    'magErrA0Lim_dB', 'phErrA0Lim_deg');
fprintf('-------------------------------------------------------------------------------------------------------------\n');

for n = 1:numel(M_list)
    fprintf('%8.0f %14.6e %14.6e %18.6f %18.6f %22.6f %22.6f\n', ...
        M_list(n), ft_all(n), fp_all(n), ...
        maxMagErrVsIdeal_dB(n), maxPhaseErrVsIdeal_deg(n), ...
        maxMagErrVsA0Limit_dB(n), maxPhaseErrVsA0Limit_deg(n));
end

fprintf('-------------------------------------------------------------------------------------------------------------\n\n');

fprintf('Finite-A0 high-ft limit vs ideal response over the same band:\n');
fprintf('  max magnitude error = %.6f dB\n', err_A0_limit_vs_ideal.max_mag_err_dB);
fprintf('  max phase error     = %.6f deg\n\n', err_A0_limit_vs_ideal.max_phase_err_deg);

%% Trend checks
M_check_ok = all(abs(M_check_all - M_list) < 1e-9);
mag_A0_limit_decreasing = all(diff(maxMagErrVsA0Limit_dB) < 0);
phase_A0_limit_decreasing = all(diff(maxPhaseErrVsA0Limit_deg) < 0);

fprintf('Day 10 verification checks:\n');
fprintf('M index check: %s\n', passfail(M_check_ok));
fprintf('Magnitude error vs finite-A0 limit decreases as M increases: %s\n', passfail(mag_A0_limit_decreasing));
fprintf('Phase error vs finite-A0 limit decreases as M increases: %s\n', passfail(phase_A0_limit_decreasing));

if M_check_ok && mag_A0_limit_decreasing && phase_A0_limit_decreasing
    fprintf('\nOverall result: PASS\n');
else
    fprintf('\nOverall result: CHECK REQUIRED\n');
end

%% Plot magnitude error trend
figure;
semilogx(M_list, maxMagErrVsIdeal_dB, '-o', 'LineWidth', 1.2); hold on;
semilogx(M_list, maxMagErrVsA0Limit_dB, '-s', 'LineWidth', 1.2);
grid on;
xlabel('M = f_t / [(1+K) f_c]');
ylabel('Maximum magnitude error (dB)');
title('Day 10 High-ft Limit Check: Magnitude Error');
legend('Non-ideal vs Ideal', 'Non-ideal vs finite-A0 high-ft limit', ...
       'Location', 'southwest');
saveas(gcf, fullfile(figuresDir, 'day10_high_ft_limit_magnitude_error.png'));

%% Plot phase error trend
figure;
semilogx(M_list, maxPhaseErrVsIdeal_deg, '-o', 'LineWidth', 1.2); hold on;
semilogx(M_list, maxPhaseErrVsA0Limit_deg, '-s', 'LineWidth', 1.2);
grid on;
xlabel('M = f_t / [(1+K) f_c]');
ylabel('Maximum phase error (degrees)');
title('Day 10 High-ft Limit Check: Phase Error');
legend('Non-ideal vs Ideal', 'Non-ideal vs finite-A0 high-ft limit', ...
       'Location', 'southwest');
saveas(gcf, fullfile(figuresDir, 'day10_high_ft_limit_phase_error.png'));

fprintf('\nFigures saved to:\n%s\n', figuresDir);

%% Local helper
function txt = passfail(condition)
    if condition
        txt = 'PASS';
    else
        txt = 'FAIL';
    end
end