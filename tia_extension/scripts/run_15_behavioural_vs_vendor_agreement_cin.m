%RUN_15_BEHAVIOURAL_VS_VENDOR_AGREEMENT_CIN Compare MATLAB TIA model with vendor macromodel summaries.
%
% This script adds a quantitative behavioural-vs-vendor-macromodel agreement
% pass using existing vendor macromodel CSV data only. It does not run SPICE,
% does not modify existing result CSVs, and does not claim hardware validation.

scriptDir = fileparts(mfilename('fullpath'));
tiaRoot = fileparts(scriptDir);
functionsDir = fullfile(tiaRoot, 'functions');
resultsDir = fullfile(tiaRoot, 'results');
figuresDir = fullfile(tiaRoot, 'figures');
datasheetDir = fullfile(tiaRoot, 'datasheets');
spiceDataDir = fullfile(tiaRoot, 'spice_interface', 'imported_ac_data');

addpath(functionsDir);
ensureDir(resultsDir);
ensureDir(figuresDir);

vendorSummaryPath = fullfile(resultsDir, ...
    'spice_comparison_summary_vendor_models.csv');
datasheetPath = fullfile(datasheetDir, ...
    'vendor_opamp_candidate_table_si.csv');

if ~exist(vendorSummaryPath, 'file')
    error('run_15_behavioural_vs_vendor_agreement_cin:MissingVendorSummary', ...
        'Missing vendor summary CSV: %s', vendorSummaryPath);
end

if ~exist(datasheetPath, 'file')
    error('run_15_behavioural_vs_vendor_agreement_cin:MissingDatasheetTable', ...
        'Missing datasheet SI table: %s', datasheetPath);
end

vendorSummary = readtable(vendorSummaryPath, ...
    'TextType', 'string', 'VariableNamingRule', 'preserve');
datasheet = readtable(datasheetPath, ...
    'TextType', 'string', 'VariableNamingRule', 'preserve');

summaryRows = height(vendorSummary);
agreement = table( ...
    strings(summaryRows, 1), strings(summaryRows, 1), ...
    zeros(summaryRows, 1), zeros(summaryRows, 1), zeros(summaryRows, 1), ...
    strings(summaryRows, 1), strings(summaryRows, 1), ...
    zeros(summaryRows, 1), zeros(summaryRows, 1), zeros(summaryRows, 1), ...
    zeros(summaryRows, 1), zeros(summaryRows, 1), zeros(summaryRows, 1), ...
    strings(summaryRows, 1), strings(summaryRows, 1), ...
    strings(summaryRows, 1), strings(summaryRows, 1), ...
    'VariableNames', { ...
        'case_id', 'device', 'Rf', 'Cpd', 'Cf', ...
        'Cin_assumption', 'Cstray_assumption', ...
        'matlab_bandwidth_Hz', 'spice_bandwidth_Hz', ...
        'bandwidth_error_percent', 'matlab_peaking_dB', ...
        'spice_peaking_dB', 'peaking_error_dB', ...
        'matlab_label_or_peaking_class', ...
        'spice_label_or_peaking_class', 'label_agreement', 'notes'});

overlayData = struct();

for iRow = 1:summaryRows
    row = vendorSummary(iRow, :);
    caseId = row.case_id(1);
    device = row.op_amp_model(1);

    Rf = row.Rf_ohm(1);
    Cpd = row.Cpd_F(1);
    Cf = row.Cf_F(1);

    [ft_Hz, ftNote] = getFtAssumption(datasheet, device);
    [Cin, CinAssumption, CinNote] = getCinAssumption(datasheet, device);
    Cstray = 0;
    CstrayAssumption = "0 F; manually specified zero-stray assumption";
    A0 = 1e5;

    spicePath = findImportedAcCsv(spiceDataDir, caseId);
    if strlength(spicePath) == 0
        error('run_15_behavioural_vs_vendor_agreement_cin:MissingResponseCsv', ...
            'Missing imported AC CSV for case %s.', caseId);
    end

    spiceCurve = readVendorCurve(spicePath);
    response = tia_response( ...
        spiceCurve.f_Hz, Rf, Cf, Cpd, A0, ft_Hz, ...
        Cin=Cin, Cstray=Cstray);
    matlabMetrics = extract_tia_metrics( ...
        response.f_Hz, response.Zt_nonideal, Rf, response.fc_ideal_Hz);
    matlabClass = classify_tia_design_region(matlabMetrics);

    spiceBandwidth = row.minus3dB_bandwidth_Hz(1);
    spicePeaking = row.peaking_dB(1);
    spiceLabel = row.visual_region_label(1);

    bandwidthErrorPct = 100 * ...
        (matlabMetrics.bandwidth_Hz - spiceBandwidth) / spiceBandwidth;
    peakingError = matlabMetrics.peaking_dB - spicePeaking;
    labelAgreement = string(matlabClass.region_label) == spiceLabel;

    notes = join([ ...
        "A0=1e5 inherited behavioural assumption; needs_manual_check for vendor-specific open-loop gain", ...
        ftNote, CinNote, ...
        "Cstray set to zero; not fitted", ...
        getDeviceRoleNote(device), ...
        "bandwidth_error_percent = 100*(MATLAB - vendor)/vendor"], "; ");

    agreement.case_id(iRow) = caseId;
    agreement.device(iRow) = device;
    agreement.Rf(iRow) = Rf;
    agreement.Cpd(iRow) = Cpd;
    agreement.Cf(iRow) = Cf;
    agreement.Cin_assumption(iRow) = CinAssumption;
    agreement.Cstray_assumption(iRow) = CstrayAssumption;
    agreement.matlab_bandwidth_Hz(iRow) = matlabMetrics.bandwidth_Hz;
    agreement.spice_bandwidth_Hz(iRow) = spiceBandwidth;
    agreement.bandwidth_error_percent(iRow) = bandwidthErrorPct;
    agreement.matlab_peaking_dB(iRow) = matlabMetrics.peaking_dB;
    agreement.spice_peaking_dB(iRow) = spicePeaking;
    agreement.peaking_error_dB(iRow) = peakingError;
    agreement.matlab_label_or_peaking_class(iRow) = ...
        string(matlabClass.region_label);
    agreement.spice_label_or_peaking_class(iRow) = spiceLabel;
    agreement.label_agreement(iRow) = string(labelAgreement);
    agreement.notes(iRow) = notes;

    overlayData.(matlab.lang.makeValidName(caseId)) = struct( ...
        'case_id', caseId, ...
        'device', device, ...
        'f_Hz', spiceCurve.f_Hz, ...
        'matlab_mag_dBohm', 20*log10(abs(response.Zt_nonideal)), ...
        'spice_mag_dBohm', spiceCurve.mag_dBohm, ...
        'matlab_bandwidth_Hz', matlabMetrics.bandwidth_Hz, ...
        'spice_bandwidth_Hz', spiceBandwidth, ...
        'matlab_peaking_dB', matlabMetrics.peaking_dB, ...
        'spice_peaking_dB', spicePeaking, ...
        'notes', notes);
end

summaryPath = fullfile(resultsDir, ...
    'behavioural_vs_vendor_agreement_summary.csv');
writetable(agreement, summaryPath);

createRepresentativeOverlay( ...
    overlayData, "OPA818_Rf10k_Cpd10p_Cf1p0", ...
    fullfile(figuresDir, 'behavioural_vs_vendor_overlay_OPA818.png'), ...
    "OPA818 representative case");
createRepresentativeOverlay( ...
    overlayData, "ADA4817_Rf10k_Cpd10p_Cf1p0", ...
    fullfile(figuresDir, 'behavioural_vs_vendor_overlay_ADA4817.png'), ...
    "ADA4817 representative case");
createRepresentativeOverlay( ...
    overlayData, "OP27_Cf10p_SafeCandidate", ...
    fullfile(figuresDir, ...
        'behavioural_vs_vendor_overlay_OP27_negative_control.png'), ...
    "OP27 negative-control case");
createAgreementErrorSummaryFigure(agreement, ...
    fullfile(figuresDir, 'behavioural_vs_vendor_agreement_error_summary.png'));

fprintf('Behavioural-vs-vendor agreement summary written:\n');
fprintf('  %s\n', summaryPath);
fprintf('Overlay and error-summary figures written to:\n');
fprintf('  %s\n', figuresDir);

function ensureDir(pathName)
if ~exist(pathName, 'dir')
    mkdir(pathName);
end
end

function [ft_Hz, note] = getFtAssumption(datasheet, device)
mask = upper(datasheet.part_number) == upper(device);
if device == "ADA4817"
    mask = startsWith(upper(datasheet.part_number), "ADA4817");
end

if any(mask) && isfinite(datasheet.ft_proxy_Hz(find(mask, 1)))
    ft_Hz = datasheet.ft_proxy_Hz(find(mask, 1));
    note = sprintf("ft=%.6g Hz from local datasheet ft_proxy_Hz table", ft_Hz);
else
    ft_Hz = 100e6;
    note = "ft used fallback 100 MHz; needs_manual_check";
end
note = string(note);
end

function [Cin, assumption, note] = getCinAssumption(datasheet, device)
mask = upper(datasheet.part_number) == upper(device);
if device == "ADA4817"
    mask = startsWith(upper(datasheet.part_number), "ADA4817");
end

if any(mask)
    idx = find(mask, 1);
    CinCandidate = datasheet.input_capacitance_total_F(idx);
    if isfinite(CinCandidate)
        Cin = CinCandidate;
        assumption = sprintf( ...
            "%.6g F; datasheet-derived total input capacitance", Cin);
        note = sprintf("Cin=%.6g F from local datasheet SI table", Cin);
        assumption = string(assumption);
        note = string(note);
        return;
    end
end

Cin = 0;
assumption = "0 F; no scalar datasheet Cin available locally; needs_manual_check";
note = "Cin unavailable in local SI table; zero-Cin fallback used; needs_manual_check";
end

function note = getDeviceRoleNote(device)
if device == "OP27"
    note = "OP27 treated as negative-control / low-GBW illustrative case";
elseif device == "OPA818" || device == "ADA4817"
    note = device + " treated as high-speed vendor macromodel comparison case";
else
    note = device + " role not separately classified";
end
end

function spicePath = findImportedAcCsv(spiceDataDir, caseId)
patterns = [caseId + ".csv", caseId + "_processed.csv"];
spicePath = "";
for iPattern = 1:numel(patterns)
    files = dir(fullfile(spiceDataDir, '**', char(patterns(iPattern))));
    if ~isempty(files)
        spicePath = string(fullfile(files(1).folder, files(1).name));
        return;
    end
end
end

function curve = readVendorCurve(spicePath)
data = readtable(spicePath, 'TextType', 'string', ...
    'VariableNamingRule', 'preserve');
names = string(data.Properties.VariableNames);

if any(names == "frequency_Hz")
    f_Hz = data.frequency_Hz;
    mag_dBohm = data.transimpedance_dBOhm;
    phase_deg = data.phase_deg;
elseif any(names == "f_Hz")
    f_Hz = data.f_Hz;
    mag_dBohm = data.mag_Zt_dBohm;
    phase_deg = data.phase_Zt_deg;
else
    error('run_15_behavioural_vs_vendor_agreement_cin:UnknownCurveSchema', ...
        'Unknown imported vendor AC CSV schema: %s', spicePath);
end

mag_ohm = 10.^(mag_dBohm/20);
Zt = mag_ohm .* exp(1j * deg2rad(phase_deg));

curve = struct();
curve.f_Hz = f_Hz;
curve.mag_dBohm = mag_dBohm;
curve.phase_deg = phase_deg;
curve.Zt = Zt;
end

function createRepresentativeOverlay(overlayData, caseId, outputPath, titleText)
fieldName = matlab.lang.makeValidName(caseId);
if ~isfield(overlayData, fieldName)
    warning('run_15_behavioural_vs_vendor_agreement_cin:MissingOverlayCase', ...
        'Skipping overlay for %s because no matched curve exists.', caseId);
    return;
end

item = overlayData.(fieldName);
fig = figure('Color', 'w', 'Name', char(titleText));
semilogx(item.f_Hz, item.matlab_mag_dBohm, ...
    'LineWidth', 1.8, 'DisplayName', 'MATLAB behavioural + Cin');
hold on;
semilogx(item.f_Hz, item.spice_mag_dBohm, ...
    '--', 'LineWidth', 1.6, ...
    'DisplayName', 'Vendor macromodel export');
grid on;
box on;
xlabel('Frequency (Hz)');
ylabel('Transimpedance magnitude (dB ohm)');
title(char(titleText), 'Interpreter', 'none');
subtitle(char(item.case_id), 'Interpreter', 'none');
legend('Location', 'southwest', 'Interpreter', 'none');
styleAxes(gca);
exportPng(fig, outputPath);
close(fig);
end

function createAgreementErrorSummaryFigure(agreement, outputPath)
fig = figure('Color', 'w', 'Name', 'Behavioural agreement error summary');
tiledlayout(2, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

nexttile;
bar(categorical(agreement.case_id), agreement.bandwidth_error_percent);
grid on;
box on;
ylabel('Bandwidth error (%)');
title('MATLAB behavioural prediction error vs vendor macromodel summary');
xtickangle(35);

nexttile;
bar(categorical(agreement.case_id), agreement.peaking_error_dB);
grid on;
box on;
ylabel('Peaking error (dB)');
xlabel('Case ID');
xtickangle(35);

styleAxes(findall(fig, 'Type', 'axes'));
exportPng(fig, outputPath);
close(fig);
end

function styleAxes(ax)
set(ax, 'FontName', 'Arial', 'FontSize', 10, 'LineWidth', 1);
for iAx = 1:numel(ax)
    try
        disableDefaultInteractivity(ax(iAx));
    catch
    end
    try
        ax(iAx).Toolbar.Visible = 'off';
    catch
    end
    try
        axtoolbar(ax(iAx), {});
    catch
    end
end
end

function exportPng(figHandle, outputPath)
try
    set(figHandle, 'Visible', 'off');
    exportgraphics(figHandle, outputPath, 'Resolution', 600);
catch
    print(figHandle, outputPath, '-dpng', '-r600');
end
end
