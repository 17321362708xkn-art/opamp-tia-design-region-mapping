function metrics = extract_tia_metrics(f_Hz, Zt, Rf_reference, fc_reference_Hz)
%EXTRACT_TIA_METRICS Extract clean behavioural TIA frequency metrics.
%
%   metrics = extract_tia_metrics(f_Hz, Zt, Rf_reference, fc_reference_Hz)
%   extracts low-frequency transimpedance, -3 dB bandwidth, gain error,
%   peaking, and phase at bandwidth from a clean behavioural response.
%
%   The extraction uses the inversion-removed response G = -Zt so the
%   low-frequency phase is near zero for the baseline inverting TIA.
%   No smoothing or noisy-data handling is applied in this v0.1 baseline.

arguments
    f_Hz (:,1) double {mustBePositive}
    Zt (:,1) double
    Rf_reference (1,1) double {mustBePositive}
    fc_reference_Hz (1,1) double {mustBePositive}
end

if numel(f_Hz) ~= numel(Zt)
    error('extract_tia_metrics:SizeMismatch', ...
        'f_Hz and Zt must have the same number of samples.');
end

G = -Zt;
mag_ohm = abs(G);
phase_deg = unwrap(angle(G)) * 180/pi;

n_low = min(max(5, round(0.02*numel(f_Hz))), numel(f_Hz));
Rf_eff_ohm = median(mag_ohm(1:n_low));
gain_error_pct = 100 * (Rf_eff_ohm - Rf_reference) / Rf_reference;

mag_norm = mag_ohm / Rf_eff_ohm;
mag_norm_dB = 20 * log10(mag_norm);
target_dB = -20 * log10(sqrt(2));

cross_idx = find(mag_norm_dB <= target_dB, 1, 'first');
if isempty(cross_idx)
    bandwidth_Hz = NaN;
elseif cross_idx == 1
    bandwidth_Hz = f_Hz(1);
else
    x = mag_norm_dB(cross_idx-1:cross_idx);
    y = log10(f_Hz(cross_idx-1:cross_idx));
    bandwidth_Hz = 10^interp1(x, y, target_dB, 'linear');
end

[peaking_dB, peak_idx] = max(mag_norm_dB);
peaking_frequency_Hz = f_Hz(peak_idx);

if isnan(bandwidth_Hz)
    phase_at_bandwidth_deg = NaN;
else
    phase_at_bandwidth_deg = interp1( ...
        log10(f_Hz), phase_deg, log10(bandwidth_Hz), 'linear', NaN);
end

metrics = struct();
metrics.Rf_reference_ohm = Rf_reference;
metrics.Rf_eff_ohm = Rf_eff_ohm;
metrics.gain_error_pct = gain_error_pct;
metrics.fc_reference_Hz = fc_reference_Hz;
metrics.bandwidth_Hz = bandwidth_Hz;
metrics.bandwidth_ratio = bandwidth_Hz / fc_reference_Hz;
metrics.peaking_dB = peaking_dB;
metrics.peaking_frequency_Hz = peaking_frequency_Hz;
metrics.phase_at_bandwidth_deg = phase_at_bandwidth_deg;
metrics.low_frequency_samples = n_low;
end
