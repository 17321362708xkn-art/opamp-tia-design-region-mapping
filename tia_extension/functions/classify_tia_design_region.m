function classification = classify_tia_design_region(metrics)
%CLASSIFY_TIA_DESIGN_REGION Initial TIA behavioural region classification.
%
%   classification = classify_tia_design_region(metrics) assigns a
%   project-defined Safe / Marginal / Risky label from clean behavioural
%   TIA metrics. These criteria are not universal design rules.

arguments
    metrics (1,1) struct
end

safe_peaking_dB = 1;
marginal_peaking_dB = 3;

peaking_dB = metrics.peaking_dB;
valid_bandwidth = isfinite(metrics.bandwidth_Hz) && metrics.bandwidth_Hz > 0;

if ~valid_bandwidth || ~isfinite(peaking_dB)
    region_label = "Risky";
    region_code = 3;
elseif peaking_dB < safe_peaking_dB
    region_label = "Safe";
    region_code = 1;
elseif peaking_dB <= marginal_peaking_dB
    region_label = "Marginal";
    region_code = 2;
else
    region_label = "Risky";
    region_code = 3;
end

classification = struct();
classification.region_label = region_label;
classification.region_code = region_code;
classification.peaking_dB = peaking_dB;
classification.valid_bandwidth = valid_bandwidth;
classification.safe_peaking_dB = safe_peaking_dB;
classification.marginal_peaking_dB = marginal_peaking_dB;
classification.criteria = "Safe: valid bandwidth and peaking < 1 dB; " + ...
    "Marginal: valid bandwidth and peaking from 1 dB to 3 dB; " + ...
    "Risky: peaking > 3 dB or invalid extraction.";
end
