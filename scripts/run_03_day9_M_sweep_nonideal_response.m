clear; clc; close all;

%% Robust project path setup
% This script looks for a folder named "functions" in the current folder,
% parent folder, or grandparent folder. This avoids hard-coded addpath errors.

scriptDir = fileparts(mfilename('fullpath'));

if isempty(scriptDir)
    scriptDir = pwd;
end

candidateRoots = { ...
    scriptDir, ...
    fileparts(scriptDir), ...
    fileparts(fileparts(scriptDir)) ...
};

projectRoot = '';

for k = 1:numel(candidateRoots)
    candidateFunctionsDir = fullfile(candidateRoots{k}, 'functions');
    if isfolder(candidateFunctionsDir)
        projectRoot = candidateRoots{k};
        functionsDir = candidateFunctionsDir;
        break;
    end
end

if isempty(projectRoot)
    error('Cannot find the functions folder. Check the project folder structure.');
end

addpath(functionsDir);

fprintf('Using active_lpf_response from:\n%s\n\n', which('active_lpf_response'));

%% Baseline design parameters
Rin = 10e3;
K = 10;
Rf = K * Rin;

fc_target = 10e3;
Cf = 1 / (2*pi*Rf*fc_target);

A0 = 1e5;

% GBW margin index list, not stability margin
M_list = [0.5 1 2 5 10 20 50];

% Full frequency vector for response plotting
f = logspace(log10(fc_target/1000), log10(fc_target*1000), 3000);

%% First run to obtain ideal response and sorted frequency vector
M_ref = 20;
ft_ref = M_ref * (1 + K) * fc_target;

out_ref = active_lpf_response(f, Rin, Rf, Cf, A0, ft_ref);
f_used = out_ref.f;

G_ideal = out_ref.G_ideal;

mag_ideal_dB = 20*log10(abs(G_ideal));
phase_ideal_deg = unwrap(angle(G_ideal)) * 180/pi;

%% Print project setup
fprintf('Day 9 M-sweep ideal vs non-ideal response check\n');
fprintf('------------------------------------------------\n');
fprintf('K = %.6f\n', K);
fprintf('A0 = %.6e\n', A0);
fprintf('fc_target = %.6f Hz\n', fc_target);
fprintf('Rf = %.6e ohm\n', Rf);
fprintf('Cf = %.6e F\n', Cf);
fprintf('Frequency range = %.3e Hz to %.3e Hz\n', min(f_used), max(f_used));
fprintf('M is used as GBW margin index, not stability margin.\n\n');

%% Prepare figures
figMag = figure;
semilogx(f_used, mag_ideal_dB, 'LineWidth', 1.5, 'DisplayName', 'Ideal');
hold on; grid on;

xlabel('Frequency (Hz)');
ylabel('|G| (dB)');
title('Day 9: Ideal vs Non-Ideal Magnitude Response for Different M');

xline(fc_target, '--', 'f_c', 'HandleVisibility', 'off');
yline(20*log10(K/sqrt(2)), '--', '-3 dB point', 'HandleVisibility', 'off');

figPhase = figure;
semilogx(f_used, phase_ideal_deg, 'LineWidth', 1.5, 'DisplayName', 'Ideal');
hold on; grid on;

xlabel('Frequency (Hz)');
ylabel('Phase of G (degrees)');
title('Day 9: Ideal vs Non-Ideal Phase Response for Different M');

xline(fc_target, '--', 'f_c', 'HandleVisibility', 'off');
yline(-45, '--', '-45 deg', 'HandleVisibility', 'off');

%% Sweep over M values
summary = struct();

fprintf('M-sweep summary at f = fc_target\n');
fprintf('-------------------------------------------------------------------------------------\n');
fprintf('%8s %14s %14s %14s %14s %14s\n', ...
    'M', 'ft_Hz', 'fp_Hz', 'magErr_dB', 'phaseDev_deg', 'M_check');
fprintf('-------------------------------------------------------------------------------------\n');

for i = 1:numel(M_list)
    M = M_list(i);
    ft_Hz = M * (1 + K) * fc_target;

    out = active_lpf_response(f, Rin, Rf, Cf, A0, ft_Hz);
    f_used_i = out.f;

    if max(abs(f_used_i - f_used)) > 0
        error('Frequency vectors are inconsistent. Always use out.f.');
    end

    G_nonideal = out.G_nonideal;

    mag_nonideal_dB = 20*log10(abs(G_nonideal));
    phase_nonideal_deg = unwrap(angle(G_nonideal)) * 180/pi;

    % Plot curves
    figure(figMag);
    semilogx(f_used, mag_nonideal_dB, 'LineWidth', 1.0, ...
        'DisplayName', sprintf('Non-ideal, M = %.1f', M));

    figure(figPhase);
    semilogx(f_used, phase_nonideal_deg, 'LineWidth', 1.0, ...
        'DisplayName', sprintf('Non-ideal, M = %.1f', M));

    % Interpolate values at fc_target for summary
    mag_ideal_fc_dB = interp1(log10(f_used), mag_ideal_dB, log10(fc_target), 'linear', 'extrap');
    mag_nonideal_fc_dB = interp1(log10(f_used), mag_nonideal_dB, log10(fc_target), 'linear', 'extrap');

    phase_ideal_fc_deg = interp1(log10(f_used), phase_ideal_deg, log10(fc_target), 'linear', 'extrap');
    phase_nonideal_fc_deg = interp1(log10(f_used), phase_nonideal_deg, log10(fc_target), 'linear', 'extrap');

    magErr_dB = mag_nonideal_fc_dB - mag_ideal_fc_dB;

    % Signed metric: positive value means additional phase lag
    phaseDev_deg = phase_ideal_fc_deg - phase_nonideal_fc_deg;

    M_check = out.M_index;

    fprintf('%8.2f %14.6e %14.6e %14.6f %14.6f %14.6f\n', ...
        M, ft_Hz, out.fp, magErr_dB, phaseDev_deg, M_check);

    summary(i).M = M;
    summary(i).ft_Hz = ft_Hz;
    summary(i).fp_Hz = out.fp;
    summary(i).magErr_dB_at_fc = magErr_dB;
    summary(i).phaseDev_deg_at_fc = phaseDev_deg;
    summary(i).M_check = M_check;
end

fprintf('-------------------------------------------------------------------------------------\n');
fprintf('\nExpected qualitative trend:\n');
fprintf('  Lower M values should show stronger deviation from the ideal response.\n');
fprintf('  Higher M values should move the non-ideal response closer to the ideal response.\n');
fprintf('  M is a GBW margin index, not a formal stability margin.\n\n');

%% Finish figure formatting
figure(figMag);
legend('Location', 'southwest');
xlim([min(f_used), max(f_used)]);

figure(figPhase);
legend('Location', 'southwest');
xlim([min(f_used), max(f_used)]);

%% Optional save figures
figuresDir = fullfile(projectRoot, 'figures');

if ~isfolder(figuresDir)
    mkdir(figuresDir);
end

try
    exportgraphics(figMag, fullfile(figuresDir, 'day9_M_sweep_magnitude.png'), 'Resolution', 200);
    exportgraphics(figPhase, fullfile(figuresDir, 'day9_M_sweep_phase.png'), 'Resolution', 200);
catch
    saveas(figMag, fullfile(figuresDir, 'day9_M_sweep_magnitude.png'));
    saveas(figPhase, fullfile(figuresDir, 'day9_M_sweep_phase.png'));
end

fprintf('Figures saved to:\n%s\n\n', figuresDir);

%% Day 9 completion message
fprintf('Day 9 status check:\n');
fprintf('  If low M curves deviate more and high M curves approach the ideal curve, Day 9 is PASS.\n');
fprintf('  Do not classify Safe/Risky today. That belongs to the later design-map step.\n');