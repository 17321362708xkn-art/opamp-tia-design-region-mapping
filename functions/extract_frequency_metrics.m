function metrics = extract_frequency_metrics(f, G, K_ideal, fc_ideal, useSmoothing)
% extract_frequency_metrics
% Extracts effective gain, cutoff frequency, gain error,
% cutoff error, and signed phase deviation at the ideal cutoff frequency.
%
% G should be the inversion-removed response:
%   G = -H
%
% useSmoothing:
%   false for clean simulated data
%   true  for noisy virtual measurement-style data
%
% Positive phase_deviation_fc_deg means additional phase lag relative
% to the ideal first-order response at fc_ideal.
%
% If the cutoff cannot be reliably detected after 0.1*fc_ideal,
% fc_eff is returned as NaN. Later classification will treat this as Risky.

    if nargin < 5
        useSmoothing = false;
    end

    if ~isscalar(K_ideal) || ~isscalar(fc_ideal) || ...
       ~isreal(K_ideal) || ~isreal(fc_ideal) || ...
       ~isfinite(K_ideal) || ~isfinite(fc_ideal) || ...
       K_ideal <= 0 || fc_ideal <= 0
        error('K_ideal and fc_ideal must be positive finite real scalar values.');
    end

    if ~isscalar(useSmoothing) || ~(islogical(useSmoothing) || isnumeric(useSmoothing))
        error('useSmoothing must be a scalar logical or numeric value.');
    end

    useSmoothing = logical(useSmoothing);

    f = f(:);
    G = G(:);

    if numel(f) ~= numel(G)
        error('f and G must have the same number of points.');
    end

    if numel(f) < 10
        error('Frequency vector must contain at least 10 points.');
    end

    if any(~isfinite(f)) || any(f <= 0)
        error('Frequency vector must contain positive finite values.');
    end

    if any(~isfinite(G))
        error('Frequency response contains non-finite values.');
    end

    [f, idxSort] = sort(f);
    G = G(idxSort);

    if fc_ideal < min(f) || fc_ideal > max(f)
        error('fc_ideal must lie within the frequency vector range.');
    end

    mag = abs(G);

    if any(mag <= 0)
        error('Magnitude contains zero or negative values, so dB conversion is invalid.');
    end

    mag_dB = 20*log10(mag);

    % Correct order: unwrap first, then smooth if needed.
    % This avoids discontinuity artefacts in wrapped phase.
    phase_deg = unwrap(angle(G)) * 180/pi;

    % Low-frequency gain estimate.
    % Use f <= fc/100 when possible. If not enough points exist, relax to fc/10.
    low_idx = f <= fc_ideal/100;

    if sum(low_idx) < 3
        low_idx = f <= fc_ideal/10;
    end

    if sum(low_idx) < 3
        error('Not enough low-frequency points for gain extraction.');
    end

    K_eff = median(mag(low_idx));

    % Smoothing is used only for noisy virtual measurement-style data.
    if useSmoothing
        mag_dB_for_cross = movmedian(mag_dB, 9);
        phase_deg_for_interp = movmedian(phase_deg, 9);
    else
        mag_dB_for_cross = mag_dB;
        phase_deg_for_interp = phase_deg;
    end

    mag_for_cross = 10.^(mag_dB_for_cross/20);

    target_mag = K_eff / sqrt(2);
    target_dB = 20*log10(target_mag);

    % Sustained crossing:
    % Require at least 3 consecutive points below the -3 dB threshold.
    below = mag_for_cross <= target_mag;

    % Avoid false low-frequency crossing far below the intended cutoff.
    valid_start = f > fc_ideal/10;
    below = below & valid_start;

    idx_sustained = NaN;

    for n = 2:(numel(f)-2)
        if below(n) && below(n+1) && below(n+2)
            idx_sustained = n;
            break;
        end
    end

    if isnan(idx_sustained)
        fc_eff = NaN;
    else
        % Find the last point before sustained crossing that is still above threshold.
        idx_prev = find(mag_for_cross(1:idx_sustained) > target_mag, 1, 'last');

        if isempty(idx_prev) || idx_prev >= numel(f)
            fc_eff = NaN;
        else
            x1 = log10(f(idx_prev));
            x2 = log10(f(idx_prev+1));

            y1 = mag_dB_for_cross(idx_prev);
            y2 = mag_dB_for_cross(idx_prev+1);

            if abs(y2 - y1) < 1e-12
                fc_eff = NaN;
            else
                x_fc = x1 + (target_dB - y1) * (x2 - x1) / (y2 - y1);
                fc_eff = 10^x_fc;
            end
        end
    end

    % Phase at ideal cutoff frequency.
    phi_response_fc = interp1(log10(f), phase_deg_for_interp, ...
                              log10(fc_ideal), 'linear', 'extrap');

    phi_ideal_fc = -45;

    % Signed metric:
    % Positive value = additional phase lag.
    % Negative value = less phase lag than the ideal first-order response.
    phase_deviation_fc_deg = phi_ideal_fc - phi_response_fc;

    gain_error_pct = 100 * (K_eff - K_ideal) / K_ideal;
    cutoff_error_pct = 100 * (fc_eff - fc_ideal) / fc_ideal;

    metrics.K_eff = K_eff;
    metrics.fc_eff = fc_eff;

    metrics.gain_error_pct = gain_error_pct;
    metrics.cutoff_error_pct = cutoff_error_pct;

    metrics.phi_response_fc_deg = phi_response_fc;
    metrics.phase_deviation_fc_deg = phase_deviation_fc_deg;
end