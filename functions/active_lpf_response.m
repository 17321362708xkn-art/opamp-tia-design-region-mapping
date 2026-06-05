function out = active_lpf_response(f, Rin, Rf, Cf, A0, ft_Hz)
% active_lpf_response
% Computes ideal, non-ideal, and finite-A0 high-ft limit responses
% for an inverting op-amp active low-pass filter.
%
% Usage:
%   out = active_lpf_response(f, Rin, Rf, Cf, A0, ft_Hz)
%
% In this project, ft_Hz is treated as the GBW-equivalent unity-gain
% frequency of the single-pole open-loop op-amp model.
%
% Core implementation uses direct complex evaluation at s = j*2*pi*f.
% No SPICE, Control System Toolbox, or System Identification Toolbox is required.

    if nargin ~= 6
        error(['Usage: out = active_lpf_response(f, Rin, Rf, Cf, A0, ft_Hz). ', ...
               'Do not run this function without inputs.']);
    end

    if ~isscalar(Rin) || ~isscalar(Rf) || ~isscalar(Cf) || ...
       ~isscalar(A0) || ~isscalar(ft_Hz)
        error('Rin, Rf, Cf, A0, and ft_Hz must be scalar values.');
    end

    if ~isreal([Rin, Rf, Cf, A0, ft_Hz])
        error('Rin, Rf, Cf, A0, and ft_Hz must be real values.');
    end

    if any(~isfinite([Rin, Rf, Cf, A0, ft_Hz]))
        error('Rin, Rf, Cf, A0, and ft_Hz must be finite values.');
    end

    if Rin <= 0 || Rf <= 0 || Cf <= 0 || ft_Hz <= 0
        error('Rin, Rf, Cf, and ft_Hz must be positive.');
    end

    if A0 <= 1
        error('A0 must be greater than 1 when using the exact unity-gain relationship.');
    end

    if isempty(f) || ~isvector(f)
        error('f must be a non-empty frequency vector or scalar.');
    end

    f = f(:);

    if ~isreal(f) || any(~isfinite(f)) || any(f <= 0)
        error('Frequency vector must contain positive finite real frequencies only.');
    end

    f = sort(f);

    s = 1j * 2*pi*f;

    K = Rf / Rin;
    tau = Rf * Cf;
    fc = 1 / (2*pi*tau);

    Zratio = K ./ (1 + s*tau);  % Zf/Rin

    % Exact single-pole relationship:
    % ft = fp * sqrt(A0^2 - 1)
    fp = ft_Hz / sqrt(A0^2 - 1);
    wp = 2*pi*fp;

    A = A0 ./ (1 + s/wp);

    % Ideal response
    H_ideal = -Zratio;
    G_ideal = -H_ideal;

    % Full non-ideal response
    H_nonideal = -Zratio ./ (1 + (1 + Zratio)./A);
    G_nonideal = -H_nonideal;

    % Finite-A0, high-ft limit
    H_A0_limit = -Zratio ./ (1 + (1 + Zratio)./A0);
    G_A0_limit = -H_A0_limit;

    % Noise gain
    NG = 1 + Zratio;

    out.f = f;

    out.H_ideal = H_ideal;
    out.G_ideal = G_ideal;

    out.H_nonideal = H_nonideal;
    out.G_nonideal = G_nonideal;

    out.H_A0_limit = H_A0_limit;
    out.G_A0_limit = G_A0_limit;

    out.A = A;
    out.NG = NG;

    out.K = K;
    out.fc = fc;
    out.fp = fp;
    out.ft_Hz = ft_Hz;
    out.M_index = ft_Hz / ((1 + K) * fc);
end