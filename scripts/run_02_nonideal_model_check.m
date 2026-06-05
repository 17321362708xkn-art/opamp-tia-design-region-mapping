clear; clc; close all;

%% Robust path setup
scriptDir = fileparts(mfilename('fullpath'));

if isempty(scriptDir)
    scriptDir = pwd;
end

candidate1 = fullfile(scriptDir, 'functions');
candidate2 = fullfile(scriptDir, '..', 'functions');

if isfolder(candidate1)
    functionsDir = candidate1;
elseif isfolder(candidate2)
    functionsDir = candidate2;
else
    error(['Cannot find functions folder. Expected either:' newline ...
           '  %s' newline ...
           'or:' newline ...
           '  %s'], candidate1, candidate2);
end

addpath(functionsDir);

fprintf('Using active_lpf_response from:\n%s\n\n', which('active_lpf_response'));

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

%% Run model
out = active_lpf_response(f, Rin, Rf, Cf, A0, ft_Hz);
f_used = out.f;

%% Expected values
fp_expected = ft_Hz / sqrt(A0^2 - 1);
M_expected = ft_Hz / ((1 + K) * fc_target);

%% Field existence checks
requiredFields = { ...
    'G_ideal', 'G_nonideal', 'G_A0_limit', ...
    'H_ideal', 'H_nonideal', 'H_A0_limit', ...
    'A', 'NG', 'K', 'fc', 'fp', 'ft_Hz', 'M_index', 'f'};

field_pass = true;

for n = 1:numel(requiredFields)
    if ~isfield(out, requiredFields{n})
        fprintf('Missing field: %s\n', requiredFields{n});
        field_pass = false;
    end
end

%% Frequency-domain checks
[~, idx_fc] = min(abs(f_used - fc_target));

Gid_fc = out.G_ideal(idx_fc);
Gni_fc = out.G_nonideal(idx_fc);
GA0_fc = out.G_A0_limit(idx_fc);

mag_id_fc_dB = 20*log10(abs(Gid_fc));
mag_ni_fc_dB = 20*log10(abs(Gni_fc));
mag_A0_fc_dB = 20*log10(abs(GA0_fc));

phase_id_fc_deg = unwrap(angle(out.G_ideal)) * 180/pi;
phase_ni_fc_deg = unwrap(angle(out.G_nonideal)) * 180/pi;
phase_A0_fc_deg = unwrap(angle(out.G_A0_limit)) * 180/pi;

phi_id_fc = phase_id_fc_deg(idx_fc);
phi_ni_fc = phase_ni_fc_deg(idx_fc);
phi_A0_fc = phase_A0_fc_deg(idx_fc);

%% Check finite-A0 DC gain formula using low-frequency point
G_A0_low_numeric = abs(out.G_A0_limit(1));
G_A0_dc_expected = K * A0 / (A0 + 1 + K);

%% Check open-loop gain at ft approximately 1
A_at_ft = A0 / sqrt(1 + (ft_Hz / out.fp)^2);

%% Pass/fail checks
fp_check = abs(out.fp - fp_expected) / fp_expected < 1e-12;
M_check = abs(out.M_index - M_expected) < 1e-12;
fc_check = abs(out.fc - fc_target) / fc_target < 1e-12;
A_ft_check = abs(A_at_ft - 1) < 1e-8;
A0_limit_dc_check = abs(G_A0_low_numeric - G_A0_dc_expected) / G_A0_dc_expected < 1e-3;

overall_pass = field_pass && fp_check && M_check && fc_check && A_ft_check && A0_limit_dc_check;

%% Print results
fprintf('Day 8 finite A0 / finite ft model check\n');
fprintf('----------------------------------------\n');
fprintf('K = %.6f\n', K);
fprintf('A0 = %.6e\n', A0);
fprintf('fc_target = %.6f Hz\n', fc_target);
fprintf('out.fc = %.6f Hz\n', out.fc);
fprintf('ft_Hz = %.6f Hz\n', ft_Hz);
fprintf('out.fp = %.12e Hz\n', out.fp);
fprintf('expected fp = %.12e Hz\n', fp_expected);
fprintf('M index = %.6f\n', out.M_index);
fprintf('Expected M = %.6f\n', M_expected);
fprintf('\n');

fprintf('Open-loop gain check:\n');
fprintf('|A(j2pi ft)| = %.12f\n', A_at_ft);
fprintf('Expected approximately 1\n');
fprintf('\n');

fprintf('At f = fc:\n');
fprintf('|G_ideal(fc)| dB = %.6f dB\n', mag_id_fc_dB);
fprintf('|G_nonideal(fc)| dB = %.6f dB\n', mag_ni_fc_dB);
fprintf('|G_A0_limit(fc)| dB = %.6f dB\n', mag_A0_fc_dB);
fprintf('Phase G_ideal(fc) = %.6f deg\n', phi_id_fc);
fprintf('Phase G_nonideal(fc) = %.6f deg\n', phi_ni_fc);
fprintf('Phase G_A0_limit(fc) = %.6f deg\n', phi_A0_fc);
fprintf('\n');

fprintf('Finite-A0 low-frequency check:\n');
fprintf('Numeric low-frequency |G_A0_limit| = %.10f\n', G_A0_low_numeric);
fprintf('Expected DC finite-A0 gain = %.10f\n', G_A0_dc_expected);
fprintf('\n');

fprintf('Checks:\n');
fprintf('field existence check: %s\n', passfail(field_pass));
fprintf('fp formula check: %s\n', passfail(fp_check));
fprintf('M index check: %s\n', passfail(M_check));
fprintf('fc formula check: %s\n', passfail(fc_check));
fprintf('|A(ft)| check: %s\n', passfail(A_ft_check));
fprintf('finite-A0 low-frequency gain check: %s\n', passfail(A0_limit_dc_check));
fprintf('\n');

fprintf('Overall result: %s\n', passfail(overall_pass));

%% Plot preliminary ideal vs non-ideal comparison
figure;
semilogx(f_used, 20*log10(abs(out.G_ideal)), 'LineWidth', 1.5);
hold on;
semilogx(f_used, 20*log10(abs(out.G_nonideal)), '--', 'LineWidth', 1.5);
semilogx(f_used, 20*log10(abs(out.G_A0_limit)), ':', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('|G| (dB)');
title('Day 8 Preliminary Magnitude Check');
legend('Ideal', 'Non-ideal', 'Finite-A0 high-ft limit', 'Location', 'SouthWest');
xline(fc_target, '--', 'fc');

figure;
semilogx(f_used, unwrap(angle(out.G_ideal))*180/pi, 'LineWidth', 1.5);
hold on;
semilogx(f_used, unwrap(angle(out.G_nonideal))*180/pi, '--', 'LineWidth', 1.5);
semilogx(f_used, unwrap(angle(out.G_A0_limit))*180/pi, ':', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase of G (degrees)');
title('Day 8 Preliminary Phase Check');
legend('Ideal', 'Non-ideal', 'Finite-A0 high-ft limit', 'Location', 'SouthWest');
xline(fc_target, '--', 'fc');

%% Local helper
function txt = passfail(flag)
    if flag
        txt = 'PASS';
    else
        txt = 'FAIL';
    end
end