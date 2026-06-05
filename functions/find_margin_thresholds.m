function thresholds = find_margin_thresholds(M_list, region_codes)
% find_margin_thresholds
% Finds robust M_safe and M_marginal thresholds.
%
% region code:
%   1 = Safe
%   2 = Marginal
%   3 = Risky
%
% M_safe:
%   Smallest sampled M such that all sampled points from that M onward
%   are classified as Safe.
%
% M_marginal:
%   Smallest sampled M such that all sampled points from that M onward
%   are classified as at least Marginal, meaning Safe or Marginal.
%
% This function deliberately does not use:
%   min(M_list(region_codes == 1))
% because isolated Safe points should not define the safe threshold.

    if nargin ~= 2
        error('find_margin_thresholds requires two inputs: M_list and region_codes.');
    end

    M_list = M_list(:);
    region_codes = region_codes(:);

    if numel(M_list) ~= numel(region_codes)
        error('M_list and region_codes must have the same length.');
    end

    if isempty(M_list)
        error('M_list and region_codes must not be empty.');
    end

    if any(~isfinite(M_list)) || any(M_list <= 0)
        error('M_list must contain positive finite values.');
    end

    if any(~isfinite(region_codes)) || any(~ismember(region_codes, [1 2 3]))
        error('region_codes must contain only 1 = Safe, 2 = Marginal, or 3 = Risky.');
    end

    [M_sorted, idx] = sort(M_list);
    codes = region_codes(idx);

    safe_flags = codes == 1;
    at_least_marginal_flags = codes <= 2;

    M_safe = NaN;
    M_marginal = NaN;

    for i = 1:numel(M_sorted)
        if all(safe_flags(i:end))
            M_safe = M_sorted(i);
            break;
        end
    end

    for i = 1:numel(M_sorted)
        if all(at_least_marginal_flags(i:end))
            M_marginal = M_sorted(i);
            break;
        end
    end

    thresholds.M_safe = M_safe;
    thresholds.M_marginal = M_marginal;
    thresholds.M_sorted = M_sorted;
    thresholds.region_codes_sorted = codes;
    thresholds.safe_flags_sorted = safe_flags;
    thresholds.at_least_marginal_flags_sorted = at_least_marginal_flags;
end