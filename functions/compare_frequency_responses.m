function err = compare_frequency_responses(G_test, G_ref)
% compare_frequency_responses
% Returns maximum magnitude and phase difference between two complex responses.
%
% Usage:
%   err = compare_frequency_responses(G_test, G_ref)
%
% The input vectors should already be restricted to the frequency band
% of interest, for example 0.01*fc to 10*fc.

    if nargin ~= 2
        error('Usage: err = compare_frequency_responses(G_test, G_ref).');
    end

    if ~isvector(G_test) || ~isvector(G_ref)
        error('G_test and G_ref must be vectors.');
    end

    G_test = G_test(:);
    G_ref = G_ref(:);

    if numel(G_test) ~= numel(G_ref)
        error('G_test and G_ref must have the same length.');
    end

    if any(~isfinite(G_test)) || any(~isfinite(G_ref))
        error('Frequency responses must contain finite values.');
    end

    if any(abs(G_ref) == 0)
        error('Reference response contains zero values, so response ratio is invalid.');
    end

    if any(abs(G_test) == 0)
        error('Test response contains zero values, so dB error calculation may be invalid.');
    end

    ratio = G_test ./ G_ref;

    mag_err_dB = 20*log10(abs(ratio));
    phase_err_deg = unwrap(angle(ratio)) * 180/pi;

    err.max_mag_err_dB = max(abs(mag_err_dB));
    err.max_phase_err_deg = max(abs(phase_err_deg));
end