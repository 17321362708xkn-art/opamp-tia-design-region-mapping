%RUN_04_SWEEP_CPD_AND_FT Run the full Round 3 TIA parameter sweep.
%
% The sweep covers Rf, Cpd, Cf, and ft ranges requested for the TIA
% extension. It saves CSV results for downstream mapping and SPICE case
% selection. It does not run SPICE, hardware measurement, or noise analysis.

scriptDir = fileparts(mfilename('fullpath'));
tiaRoot = fileparts(scriptDir);
functionsDir = fullfile(tiaRoot, 'functions');
resultsDir = fullfile(tiaRoot, 'results');

addpath(functionsDir);
if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

Rf_values = [10e3; 100e3; 1e6];
Cpd_values = [1e-12; 5e-12; 10e-12; 20e-12];
Cf_values = logspace(-13, -11, 40).';
ft_values = logspace(6, 8, 40).';
A0 = 1e5;
f_Hz = logspace(1, 10, 700).';

rows = numel(Rf_values) * numel(Cpd_values) * ...
    numel(Cf_values) * numel(ft_values);

sweep = table( ...
    zeros(rows, 1), zeros(rows, 1), zeros(rows, 1), zeros(rows, 1), ...
    zeros(rows, 1), zeros(rows, 1), zeros(rows, 1), zeros(rows, 1), ...
    zeros(rows, 1), zeros(rows, 1), zeros(rows, 1), zeros(rows, 1), ...
    zeros(rows, 1), zeros(rows, 1), zeros(rows, 1), false(rows, 1), ...
    strings(rows, 1), zeros(rows, 1), ...
    'VariableNames', { ...
        'Rf_ohm', 'Cpd_F', 'Cf_F', 'A0', 'ft_Hz', ...
        'fc_ideal_Hz', 'capacitive_noise_gain', 'gbw_margin_index', ...
        'Rf_eff_ohm', 'gain_error_pct', 'bandwidth_Hz', ...
        'bandwidth_ratio', 'peaking_dB', 'peaking_frequency_Hz', ...
        'phase_at_bandwidth_deg', 'valid_bandwidth', ...
        'classification', 'classification_code'});

idx = 0;
for iRf = 1:numel(Rf_values)
    for iCpd = 1:numel(Cpd_values)
        for iCf = 1:numel(Cf_values)
            for iFt = 1:numel(ft_values)
                idx = idx + 1;

                response = tia_response( ...
                    f_Hz, Rf_values(iRf), Cf_values(iCf), ...
                    Cpd_values(iCpd), A0, ft_values(iFt));
                metrics = extract_tia_metrics( ...
                    response.f_Hz, response.Zt_nonideal, ...
                    Rf_values(iRf), response.fc_ideal_Hz);
                classification = classify_tia_design_region(metrics);

                sweep.Rf_ohm(idx) = Rf_values(iRf);
                sweep.Cpd_F(idx) = Cpd_values(iCpd);
                sweep.Cf_F(idx) = Cf_values(iCf);
                sweep.A0(idx) = A0;
                sweep.ft_Hz(idx) = ft_values(iFt);
                sweep.fc_ideal_Hz(idx) = response.fc_ideal_Hz;
                sweep.capacitive_noise_gain(idx) = response.capacitive_noise_gain;
                sweep.gbw_margin_index(idx) = response.gbw_margin_index;
                sweep.Rf_eff_ohm(idx) = metrics.Rf_eff_ohm;
                sweep.gain_error_pct(idx) = metrics.gain_error_pct;
                sweep.bandwidth_Hz(idx) = metrics.bandwidth_Hz;
                sweep.bandwidth_ratio(idx) = metrics.bandwidth_ratio;
                sweep.peaking_dB(idx) = metrics.peaking_dB;
                sweep.peaking_frequency_Hz(idx) = metrics.peaking_frequency_Hz;
                sweep.phase_at_bandwidth_deg(idx) = metrics.phase_at_bandwidth_deg;
                sweep.valid_bandwidth(idx) = classification.valid_bandwidth;
                sweep.classification(idx) = string(classification.region_label);
                sweep.classification_code(idx) = classification.region_code;
            end
        end
    end
end

summaryCsv = fullfile(resultsDir, 'tia_sweep_summary.csv');
writetable(sweep, summaryCsv);

fprintf('TIA full parameter sweep complete: %s\n', summaryCsv);
