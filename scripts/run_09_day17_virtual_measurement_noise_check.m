clear; clc; close all;

% Robust project path setup
script_dir = fileparts(mfilename('fullpath'));
project_root = fileparts(script_dir);
functions_dir = fullfile(project_root, 'functions');
figures_dir = fullfile(project_root, 'figures');
results_dir = fullfile(script_dir, 'results');

if ~isfolder(functions_dir)
    error('Functions folder does not exist: %s', functions_dir);
end

if ~isfolder(figures_dir)
    mkdir(figures_dir);
end

if ~isfolder(results_dir)
    mkdir(results_dir);
end

addpath(functions_dir);

fprintf('Using active_lpf_response from:\n%s\n\n', which('active_lpf_response'));
fprintf('Using add_measurement_noise from:\n%s\n\n', which('add_measurement_noise'));

% Baseline parameters
Rin = 10e3;
K = 10;
Rf = K * Rin;

fc_target = 10e3;
Cf = 1 / (2*pi*Rf*fc_target);

A0 = 1e5;
M = 20;
ft_Hz = M * (1 + K) * fc_target;

% Full frequency vector
f = logspace(log10(fc_target/1000), log10(fc_target*1000), 3000);

out = active_lpf_response(f, Rin, Rf, Cf, A0, ft_Hz);
f_used = out.f;
G_clean = out.G_nonideal;

% Noise settings
magNoise_dB = 0.05;
phaseNoise_deg = 0.5;
seed_main = 17;

% 1) Zero-noise check
G_zero_noise = add_measurement_noise(G_clean, 0, 0, seed_main);
zero_noise_max_abs_diff = max(abs(G_zero_noise - G_clean));

% 2) Same-seed reproducibility check
G_noisy_1 = add_measurement_noise(G_clean, magNoise_dB, phaseNoise_deg, seed_main);
G_noisy_2 = add_measurement_noise(G_clean, magNoise_dB, phaseNoise_deg, seed_main);
same_seed_max_abs_diff = max(abs(G_noisy_1 - G_noisy_2));

% 3) Different-seed check
G_noisy_3 = add_measurement_noise(G_clean, magNoise_dB, phaseNoise_deg, seed_main + 1);
different_seed_max_abs_diff = max(abs(G_noisy_1 - G_noisy_3));

% 4) Noise statistics check
clean_mag_dB = 20*log10(abs(G_clean));
noisy_mag_dB = 20*log10(abs(G_noisy_1));
mag_noise_actual_dB = noisy_mag_dB - clean_mag_dB;

clean_phase_deg = unwrap(angle(G_clean)) * 180/pi;
noisy_phase_deg = unwrap(angle(G_noisy_1)) * 180/pi;
phase_noise_actual_deg = noisy_phase_deg - clean_phase_deg;

mag_noise_mean = mean(mag_noise_actual_dB);
mag_noise_std = std(mag_noise_actual_dB);
phase_noise_mean = mean(phase_noise_actual_deg);
phase_noise_std = std(phase_noise_actual_deg);

finite_check = all(isfinite(G_noisy_1));
zero_noise_check = zero_noise_max_abs_diff < 1e-12;
same_seed_check = same_seed_max_abs_diff < 1e-12;
different_seed_check = different_seed_max_abs_diff > 1e-8;
mag_noise_std_check = mag_noise_std > 0.035 && mag_noise_std < 0.065;
phase_noise_std_check = phase_noise_std > 0.35 && phase_noise_std < 0.65;

% Print summary
fprintf('Day 17 virtual measurement-style noise check\n');
fprintf('---------------------------------------------\n');
fprintf('K = %.8f\n', K);
fprintf('A0 = %.6e\n', A0);
fprintf('fc_target = %.8f Hz\n', fc_target);
fprintf('M = %.8f\n', M);
fprintf('ft_Hz = %.6e Hz\n', ft_Hz);
fprintf('Noise settings: mag = %.4f dB, phase = %.4f deg\n', magNoise_dB, phaseNoise_deg);
fprintf('Seed = %d\n\n', seed_main);

fprintf('Noise verification results:\n');
fprintf('zero_noise_max_abs_diff      = %.12e\n', zero_noise_max_abs_diff);
fprintf('same_seed_max_abs_diff       = %.12e\n', same_seed_max_abs_diff);
fprintf('different_seed_max_abs_diff  = %.12e\n', different_seed_max_abs_diff);
fprintf('mag noise mean               = %.6f dB\n', mag_noise_mean);
fprintf('mag noise std                = %.6f dB\n', mag_noise_std);
fprintf('phase noise mean             = %.6f deg\n', phase_noise_mean);
fprintf('phase noise std              = %.6f deg\n\n', phase_noise_std);

fprintf('Day 17 checks:\n');
fprintf('Finite noisy response check: %s\n', passfail(finite_check));
fprintf('Zero-noise identity check: %s\n', passfail(zero_noise_check));
fprintf('Same-seed reproducibility check: %s\n', passfail(same_seed_check));
fprintf('Different-seed variation check: %s\n', passfail(different_seed_check));
fprintf('Magnitude-noise std check: %s\n', passfail(mag_noise_std_check));
fprintf('Phase-noise std check: %s\n', passfail(phase_noise_std_check));

overall_pass = finite_check && zero_noise_check && same_seed_check && ...
               different_seed_check && mag_noise_std_check && phase_noise_std_check;

fprintf('\nOverall result: %s\n', passfail(overall_pass));

% Save summary table
summary = table(K, A0, fc_target, M, ft_Hz, magNoise_dB, phaseNoise_deg, seed_main, ...
    zero_noise_max_abs_diff, same_seed_max_abs_diff, different_seed_max_abs_diff, ...
    mag_noise_mean, mag_noise_std, phase_noise_mean, phase_noise_std, overall_pass);

writetable(summary, fullfile(results_dir, 'day17_virtual_noise_check_summary.csv'));

% Save virtual response data
T = table(f_used, clean_mag_dB, noisy_mag_dB, clean_phase_deg, noisy_phase_deg, ...
    mag_noise_actual_dB, phase_noise_actual_deg, ...
    'VariableNames', {'frequency_Hz', 'clean_mag_dB', 'noisy_mag_dB', ...
    'clean_phase_deg', 'noisy_phase_deg', 'actual_mag_noise_dB', 'actual_phase_noise_deg'});

writetable(T, fullfile(results_dir, 'day17_virtual_noisy_response_data.csv'));

% Plot magnitude clean vs noisy
idx_plot = 1:10:numel(f_used);

figure;
semilogx(f_used, clean_mag_dB, 'LineWidth', 1.5); hold on;
semilogx(f_used(idx_plot), noisy_mag_dB(idx_plot), '.', 'MarkerSize', 6);
grid on;
xlabel('Frequency (Hz)');
ylabel('|G| (dB)');
title('Day 17 Virtual Measurement-Style Magnitude Data');
legend('Clean non-ideal response', 'Noisy virtual data', 'Location', 'southwest');

ax = gca;
try
    ax.Toolbar.Visible = 'off';
catch
end

exportgraphics(gcf, fullfile(figures_dir, 'day17_virtual_noisy_magnitude.png'), 'Resolution', 300);

% Plot phase clean vs noisy
figure;
semilogx(f_used, clean_phase_deg, 'LineWidth', 1.5); hold on;
semilogx(f_used(idx_plot), noisy_phase_deg(idx_plot), '.', 'MarkerSize', 6);
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase of G (degrees)');
title('Day 17 Virtual Measurement-Style Phase Data');
legend('Clean non-ideal response', 'Noisy virtual data', 'Location', 'southwest');

ax = gca;
try
    ax.Toolbar.Visible = 'off';
catch
end

exportgraphics(gcf, fullfile(figures_dir, 'day17_virtual_noisy_phase.png'), 'Resolution', 300);

fprintf('\nSaved CSV summary to:\n%s\n', fullfile(results_dir, 'day17_virtual_noise_check_summary.csv'));
fprintf('Saved noisy response data to:\n%s\n', fullfile(results_dir, 'day17_virtual_noisy_response_data.csv'));
fprintf('Figures saved to:\n%s\n', figures_dir);

function s = passfail(tf)
    if tf
        s = 'PASS';
    else
        s = 'FAIL';
    end
end