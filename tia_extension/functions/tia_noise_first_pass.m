function noise = tia_noise_first_pass(f_Hz, Rf, Cf, Cpd, A0, ft_Hz, noiseParams)
%TIA_NOISE_FIRST_PASS First-pass behavioural TIA output noise estimate.
%
%   noise = tia_noise_first_pass(f_Hz, Rf, Cf, Cpd, A0, ft_Hz, noiseParams)
%   estimates major TIA noise contributions using the existing behavioural
%   finite-A0/finite-ft TIA response. It includes feedback resistor thermal
%   noise, op-amp input voltage noise, op-amp input current noise, and an
%   optional photodiode shot-noise term.
%
%   This is a first-pass MATLAB behavioural estimate. It is not hardware
%   measurement, experimental noise validation, or SPICE noise validation.

arguments
    f_Hz (:,1) double {mustBePositive}
    Rf (1,1) double {mustBePositive}
    Cf (1,1) double {mustBePositive}
    Cpd (1,1) double {mustBeNonnegative}
    A0 (1,1) double {mustBePositive}
    ft_Hz (1,1) double {mustBePositive}
    noiseParams (1,1) struct = struct()
end

params = applyNoiseDefaults(noiseParams);

k_B = 1.380649e-23;
q_e = 1.602176634e-19;

response = tia_response(f_Hz, Rf, Cf, Cpd, A0, ft_Hz);

currentNoiseTransfer_V_per_A = abs(response.Zt_nonideal);

% Finite-gain transfer from an equivalent op-amp differential input voltage
% noise source to output. In the A -> infinity limit this becomes the usual
% ideal TIA noise gain: 1 + s*Cpd/Yf.
voltageNoiseTransfer = response.A .* (response.s*Cpd + response.Yf) ./ ...
    (response.s*Cpd + (1 + response.A).*response.Yf);
voltageNoiseTransfer_V_per_V = abs(voltageNoiseTransfer);

feedbackCurrentNoise_A_per_sqrtHz = sqrt(4*k_B*params.temperature_K/Rf);
opampVoltageNoise_V_per_sqrtHz = params.opamp_voltage_noise_V_per_sqrtHz;
opampCurrentNoise_A_per_sqrtHz = params.opamp_current_noise_A_per_sqrtHz;

if params.include_photodiode_shot_noise
    photodiodeShotCurrentNoise_A_per_sqrtHz = ...
        sqrt(2*q_e*params.photodiode_dc_current_A);
else
    photodiodeShotCurrentNoise_A_per_sqrtHz = 0;
end

feedbackOutput_V_per_sqrtHz = ...
    feedbackCurrentNoise_A_per_sqrtHz .* currentNoiseTransfer_V_per_A;
opampVoltageOutput_V_per_sqrtHz = ...
    opampVoltageNoise_V_per_sqrtHz .* voltageNoiseTransfer_V_per_V;
opampCurrentOutput_V_per_sqrtHz = ...
    opampCurrentNoise_A_per_sqrtHz .* currentNoiseTransfer_V_per_A;
photodiodeShotOutput_V_per_sqrtHz = ...
    photodiodeShotCurrentNoise_A_per_sqrtHz .* currentNoiseTransfer_V_per_A;

componentOutput_V_per_sqrtHz = [ ...
    feedbackOutput_V_per_sqrtHz, ...
    opampVoltageOutput_V_per_sqrtHz, ...
    opampCurrentOutput_V_per_sqrtHz, ...
    photodiodeShotOutput_V_per_sqrtHz];
totalOutput_V_per_sqrtHz = sqrt(sum(componentOutput_V_per_sqrtHz.^2, 2));

componentIntegratedOutput_V_rms = sqrt(trapz( ...
    f_Hz, componentOutput_V_per_sqrtHz.^2, 1));
totalIntegratedOutput_V_rms = sqrt(trapz(f_Hz, totalOutput_V_per_sqrtHz.^2));

metrics = extract_tia_metrics( ...
    response.f_Hz, response.Zt_nonideal, Rf, response.fc_ideal_Hz);
effectiveNoiseBandwidthApprox_Hz = (pi/2) * metrics.bandwidth_Hz;

referenceIndex = findClosestIndex(f_Hz, params.reference_frequency_Hz);
ZtReference_ohm = currentNoiseTransfer_V_per_A(referenceIndex);
inputReferredCurrentNoise_A_per_sqrtHz = ...
    totalOutput_V_per_sqrtHz ./ max(currentNoiseTransfer_V_per_A, realmin);
componentInputReferredReference_A_per_sqrtHz = ...
    componentOutput_V_per_sqrtHz(referenceIndex, :) ./ max(ZtReference_ohm, realmin);

componentNames = [ ...
    "feedback_resistor_thermal"; ...
    "op_amp_input_voltage"; ...
    "op_amp_input_current"; ...
    "photodiode_shot"];

spectrumTable = table( ...
    f_Hz, ...
    currentNoiseTransfer_V_per_A, ...
    voltageNoiseTransfer_V_per_V, ...
    feedbackOutput_V_per_sqrtHz, ...
    opampVoltageOutput_V_per_sqrtHz, ...
    opampCurrentOutput_V_per_sqrtHz, ...
    photodiodeShotOutput_V_per_sqrtHz, ...
    totalOutput_V_per_sqrtHz, ...
    inputReferredCurrentNoise_A_per_sqrtHz, ...
    'VariableNames', { ...
        'f_Hz', ...
        'Zt_mag_ohm', ...
        'opamp_voltage_noise_transfer_mag_V_per_V', ...
        'feedback_resistor_output_noise_density_V_per_sqrtHz', ...
        'opamp_voltage_output_noise_density_V_per_sqrtHz', ...
        'opamp_current_output_noise_density_V_per_sqrtHz', ...
        'photodiode_shot_output_noise_density_V_per_sqrtHz', ...
        'total_output_noise_density_V_per_sqrtHz', ...
        'input_referred_current_noise_density_A_per_sqrtHz'});

noise = struct();
noise.params = params;
noise.f_Hz = f_Hz;
noise.Rf = Rf;
noise.Cf = Cf;
noise.Cpd = Cpd;
noise.A0 = A0;
noise.ft_Hz = ft_Hz;
noise.response = response;
noise.metrics = metrics;
noise.effective_noise_bandwidth_approx_Hz = ...
    effectiveNoiseBandwidthApprox_Hz;
noise.component_names = componentNames;
noise.component_output_noise_density_V_per_sqrtHz = ...
    componentOutput_V_per_sqrtHz;
noise.total_output_noise_density_V_per_sqrtHz = ...
    totalOutput_V_per_sqrtHz;
noise.component_integrated_output_noise_V_rms = ...
    componentIntegratedOutput_V_rms(:);
noise.total_integrated_output_noise_V_rms = totalIntegratedOutput_V_rms;
noise.feedback_current_noise_A_per_sqrtHz = ...
    feedbackCurrentNoise_A_per_sqrtHz;
noise.opamp_voltage_noise_V_per_sqrtHz = opampVoltageNoise_V_per_sqrtHz;
noise.opamp_current_noise_A_per_sqrtHz = opampCurrentNoise_A_per_sqrtHz;
noise.photodiode_shot_current_noise_A_per_sqrtHz = ...
    photodiodeShotCurrentNoise_A_per_sqrtHz;
noise.voltage_noise_transfer_V_per_V = voltageNoiseTransfer;
noise.voltage_noise_transfer_mag_V_per_V = voltageNoiseTransfer_V_per_V;
noise.reference_frequency_Hz = f_Hz(referenceIndex);
noise.reference_index = referenceIndex;
noise.output_noise_density_reference_V_per_sqrtHz = ...
    totalOutput_V_per_sqrtHz(referenceIndex);
noise.component_output_noise_density_reference_V_per_sqrtHz = ...
    componentOutput_V_per_sqrtHz(referenceIndex, :).';
noise.input_referred_current_noise_density_reference_A_per_sqrtHz = ...
    inputReferredCurrentNoise_A_per_sqrtHz(referenceIndex);
noise.component_input_referred_current_noise_density_reference_A_per_sqrtHz = ...
    componentInputReferredReference_A_per_sqrtHz(:);
noise.spectrum_table = spectrumTable;
noise.model_scope = ...
    "first-pass MATLAB behavioural noise estimate; not measured or experimentally validated";
end

function params = applyNoiseDefaults(params)
defaults = struct();
defaults.temperature_K = 300;
defaults.opamp_voltage_noise_V_per_sqrtHz = 3e-9;
defaults.opamp_current_noise_A_per_sqrtHz = 0.4e-12;
defaults.include_photodiode_shot_noise = false;
defaults.photodiode_dc_current_A = 0;
defaults.reference_frequency_Hz = 1e3;

names = fieldnames(defaults);
for iName = 1:numel(names)
    name = names{iName};
    if ~isfield(params, name) || isempty(params.(name))
        params.(name) = defaults.(name);
    end
end

validateattributes(params.temperature_K, {'double'}, ...
    {'scalar', 'positive'}, mfilename, 'temperature_K');
validateattributes(params.opamp_voltage_noise_V_per_sqrtHz, {'double'}, ...
    {'scalar', 'nonnegative'}, mfilename, ...
    'opamp_voltage_noise_V_per_sqrtHz');
validateattributes(params.opamp_current_noise_A_per_sqrtHz, {'double'}, ...
    {'scalar', 'nonnegative'}, mfilename, ...
    'opamp_current_noise_A_per_sqrtHz');
validateattributes(params.photodiode_dc_current_A, {'double'}, ...
    {'scalar', 'nonnegative'}, mfilename, 'photodiode_dc_current_A');
validateattributes(params.reference_frequency_Hz, {'double'}, ...
    {'scalar', 'positive'}, mfilename, 'reference_frequency_Hz');

params.include_photodiode_shot_noise = ...
    logical(params.include_photodiode_shot_noise);
end

function idx = findClosestIndex(values, target)
[~, idx] = min(abs(log10(values) - log10(target)));
end
