function region = classify_design_region(metrics)
% classify_design_region
% Classifies a design as Safe, Marginal, or Risky.
%
% Safe:
%   |gain error|        < 1%
%   |cutoff error|      < 5%
%   |phase deviation|   < 5 deg
%
% Marginal:
%   |gain error|        < 2%
%   |cutoff error|      < 10%
%   |phase deviation|   < 10 deg
%
% Otherwise:
%   Risky
%
% If fc_eff is NaN or any metric is non-finite, the design is Risky.

    requiredFields = {'fc_eff', 'gain_error_pct', 'cutoff_error_pct', 'phase_deviation_fc_deg'};

    for k = 1:numel(requiredFields)
        if ~isfield(metrics, requiredFields{k})
            error('metrics structure is missing required field: %s', requiredFields{k});
        end
    end

    if isnan(metrics.fc_eff) || ...
       ~isfinite(metrics.fc_eff) || ...
       ~isfinite(metrics.gain_error_pct) || ...
       ~isfinite(metrics.cutoff_error_pct) || ...
       ~isfinite(metrics.phase_deviation_fc_deg)

        region.code = 3;
        region.label = "Risky";
        return;
    end

    gain_abs = abs(metrics.gain_error_pct);
    cutoff_abs = abs(metrics.cutoff_error_pct);
    phase_abs = abs(metrics.phase_deviation_fc_deg);

    safe = gain_abs < 1 && cutoff_abs < 5 && phase_abs < 5;
    marginal = gain_abs < 2 && cutoff_abs < 10 && phase_abs < 10;

    if safe
        region.code = 1;
        region.label = "Safe";
    elseif marginal
        region.code = 2;
        region.label = "Marginal";
    else
        region.code = 3;
        region.label = "Risky";
    end
end