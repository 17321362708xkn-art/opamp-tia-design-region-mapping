function response = tia_response(f_Hz, Rf, Cf, Cpd, A0, ft_Hz, options)
%TIA_RESPONSE Behavioural photodiode TIA response with finite op-amp gain.
%
%   response = tia_response(f_Hz, Rf, Cf, Cpd, A0, ft_Hz) returns the
%   ideal and finite-gain transimpedance responses for a first-pass
%   photodiode TIA behavioural model.
%
%   response = tia_response(..., Cin=value, Cstray=value) adds op-amp input
%   capacitance and stray input-node capacitance to the photodiode
%   capacitance. Both default to zero for backward compatibility.
%
%   The model uses:
%       Yf = 1/Rf + s*Cf
%       Zt_ideal = -1/Yf
%       A(s) = A0 / (1 + s/(2*pi*fp))
%       fp = ft_Hz / A0
%       Ctotal = Cpd + Cin + Cstray
%       Zt_nonideal = -A(s) / (s*Ctotal + (1 + A(s))*Yf)
%
%   This is a behavioural model only. It is not SPICE validation or
%   hardware validation.

arguments
    f_Hz (:,1) double {mustBePositive}
    Rf (1,1) double {mustBePositive}
    Cf (1,1) double {mustBePositive}
    Cpd (1,1) double {mustBeNonnegative}
    A0 (1,1) double {mustBePositive}
    ft_Hz (1,1) double {mustBePositive}
    options.Cin (1,1) double {mustBeNonnegative} = 0
    options.Cstray (1,1) double {mustBeNonnegative} = 0
end

s = 1j * 2 * pi * f_Hz;
Cin = options.Cin;
Cstray = options.Cstray;
Ctotal = Cpd + Cin + Cstray;

Yf = 1/Rf + s * Cf;
Zt_ideal = -1 ./ Yf;

fp_Hz = ft_Hz / A0;
A = A0 ./ (1 + s/(2*pi*fp_Hz));

Zt_nonideal = -A ./ (s*Ctotal + (1 + A).*Yf);

fc_ideal_Hz = 1 / (2*pi*Rf*Cf);
capacitive_noise_gain = 1 + Ctotal/Cf;
gbw_margin_index = ft_Hz / (capacitive_noise_gain * fc_ideal_Hz);

response = struct();
response.f_Hz = f_Hz;
response.s = s;
response.Rf = Rf;
response.Cf = Cf;
response.Cpd = Cpd;
response.Cin = Cin;
response.Cstray = Cstray;
response.Ctotal = Ctotal;
response.A0 = A0;
response.ft_Hz = ft_Hz;
response.fp_Hz = fp_Hz;
response.Yf = Yf;
response.A = A;
response.Zt_ideal = Zt_ideal;
response.Zt_nonideal = Zt_nonideal;
response.G_ideal = -Zt_ideal;
response.G_nonideal = -Zt_nonideal;
response.fc_ideal_Hz = fc_ideal_Hz;
response.capacitive_noise_gain = capacitive_noise_gain;
response.gbw_margin_index = gbw_margin_index;
end
