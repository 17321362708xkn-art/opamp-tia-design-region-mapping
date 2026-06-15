function classification = classify_tia_design_region(metrics)
%CLASSIFY_TIA_DESIGN_REGION Initial TIA behavioural region classification.
%
%   classification = classify_tia_design_region(metrics) assigns a
%   first-pass Safe / Marginal / Risky label from clean behavioural TIA
%   metrics. The thresholds are initial guardrails for later design-region
%   mapping and are not validated design rules.

arguments
    metrics (1,1) struct
end

safe_gain_error_pct = 1;
safe_peaking_dB = 1;
safe_bandwidth_ratio = 0.8;

marginal_gain_error_pct = 3;
marginal_peaking_dB = 3;
marginal_bandwidth_ratio = 0.5;

gain_error_abs = abs(metrics.gain_error_pct);
peaking_dB = metrics.peaking_dB;
bandwidth_ratio = metrics.bandwidth_ratio;

if isnan(bandwidth_ratio)
    region_label = "Risky";
    region_code = 3;
elseif gain_error_abs <= safe_gain_error_pct && ...
        peaking_dB <= safe_peaking_dB && ...
        bandwidth_ratio >= safe_bandwidth_ratio
    region_label = "Safe";
    region_code = 1;
elseif gain_error_abs <= marginal_gain_error_pct && ...
        peaking_dB <= marginal_peaking_dB && ...
        bandwidth_ratio >= marginal_bandwidth_ratio
    region_label = "Marginal";
    region_code = 2;
else
    region_label = "Risky";
    region_code = 3;
end

classification = struct();
classification.region_label = region_label;
classification.region_code = region_code;
classification.gain_error_abs_pct = gain_error_abs;
classification.peaking_dB = peaking_dB;
classification.bandwidth_ratio = bandwidth_ratio;
classification.safe_gain_error_pct = safe_gain_error_pct;
classification.safe_peaking_dB = safe_peaking_dB;
classification.safe_bandwidth_ratio = safe_bandwidth_ratio;
classification.marginal_gain_error_pct = marginal_gain_error_pct;
classification.marginal_peaking_dB = marginal_peaking_dB;
classification.marginal_bandwidth_ratio = marginal_bandwidth_ratio;
end
