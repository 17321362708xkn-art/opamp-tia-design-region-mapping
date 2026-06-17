%RUN_16_CIN_ABLATION_AGREEMENT_ANALYSIS Quantify Cin effect on vendor agreement.
%
% This script compares MATLAB behavioural predictions against existing
% vendor macromodel export summaries twice for each case:
%   1) Cin = 0
%   2) Cin = documented/vendor-specific value where available
%
% It uses existing CSV exports only. It does not run SPICE, does not modify
% existing result CSVs, and does not claim hardware or measured validation.

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
    error('run_16_cin_ablation_agreement_analysis:MissingVendorSummary', ...
        'Missing vendor summary CSV: %s', vendorSummaryPath);
end

if ~exist(datasheetPath, 'file')
    error('run_16_cin_ablation_agreement_analysis:MissingDatasheetTable', ...
        'Missing datasheet SI table: %s', datasheetPath);
end

vendorSummary = readtable(vendorSummaryPath, ...
    'TextType', 'string', 'VariableNamingRule', 'preserve');
datasheet = readtable(datasheetPath, ...
    'TextType', 'string', 'VariableNamingRule', 'preserve');

summaryRows = height(vendorSummary);
ablation = table( ...
    strings(summaryRows, 1), strings(summaryRows, 1), zeros(summaryRows, 1), ...
    zeros(summaryRows, 1), zeros(summaryRows, 1), zeros(summaryRows, 1), ...
    zeros(summaryRows, 1), zeros(summaryRows, 1), zeros(summaryRows, 1), ...
    zeros(summaryRows, 1), zeros(summaryRows, 1), zeros(summaryRows, 1), ...
    zeros(summaryRows, 1), zeros(summaryRows, 1), ...
    strings(summaryRows, 1), strings(summaryRows, 1), strings(summaryRows, 1), ...
    strings(summaryRows, 1), strings(summaryRows, 1), strings(summaryRows, 1), ...
    'VariableNames', { ...
        'case_id', 'device', 'Cf', ...
        'spice_bandwidth_Hz', 'matlab_bw_noCin_Hz', ...
        'matlab_bw_withCin_Hz', 'bw_error_noCin_percent', ...
        'bw_error_withCin_percent', 'spice_peaking_dB', ...
        'matlab_peak_noCin_dB', 'matlab_peak_withCin_dB', ...
        'peak_error_noCin_dB', 'peak_error_withCin_dB', ...
        'documented_Cin_F', 'label_noCin', 'label_withCin', ...
        'spice_label', 'label_agree_noCin', ...
        'label_agree_withCin', 'notes'});

overlayData = struct();

for iRow = 1:summaryRows
    row = vendorSummary(iRow, :);
    caseId = row.case_id(1);
    device = row.op_amp_model(1);

    Rf = row.Rf_ohm(1);
    Cpd = row.Cpd_F(1);
    Cf = row.Cf_F(1);

    [ft_Hz, ftNote] = getFtAssumption(datasheet, device);
    [CinWith, CinAssumption, CinNote] = getCinAssumption(datasheet, device);
    Cstray = 0;
    A0 = 1e5;

    spicePath = findImportedAcCsv(spiceDataDir, caseId);
    if strlength(spicePath) == 0
        error('run_16_cin_ablation_agreement_analysis:MissingResponseCsv', ...
            'Missing imported AC CSV for case %s.', caseId);
    end

    spiceCurve = readVendorCurve(spicePath);

    responseNoCin = tia_response( ...
        spiceCurve.f_Hz, Rf, Cf, Cpd, A0, ft_Hz, ...
        Cin=0, Cstray=Cstray);
    metricsNoCin = extract_tia_metrics( ...
        responseNoCin.f_Hz, responseNoCin.Zt_nonideal, ...
        Rf, responseNoCin.fc_ideal_Hz);
    classNoCin = classify_tia_design_region(metricsNoCin);

    responseWithCin = tia_response( ...
        spiceCurve.f_Hz, Rf, Cf, Cpd, A0, ft_Hz, ...
        Cin=CinWith, Cstray=Cstray);
    metricsWithCin = extract_tia_metrics( ...
        responseWithCin.f_Hz, responseWithCin.Zt_nonideal, ...
        Rf, responseWithCin.fc_ideal_Hz);
    classWithCin = classify_tia_design_region(metricsWithCin);

    spiceBandwidth = row.minus3dB_bandwidth_Hz(1);
    spicePeaking = row.peaking_dB(1);
    spiceLabel = row.visual_region_label(1);

    bwErrorNoCin = 100 * ...
        (metricsNoCin.bandwidth_Hz - spiceBandwidth) / spiceBandwidth;
    bwErrorWithCin = 100 * ...
        (metricsWithCin.bandwidth_Hz - spiceBandwidth) / spiceBandwidth;
    peakErrorNoCin = metricsNoCin.peaking_dB - spicePeaking;
    peakErrorWithCin = metricsWithCin.peaking_dB - spicePeaking;
    labelAgreeNoCin = string(classNoCin.region_label) == spiceLabel;
    labelAgreeWithCin = string(classWithCin.region_label) == spiceLabel;

    notes = join([ ...
        "A0=1e5 inherited behavioural assumption; needs_manual_check for vendor-specific open-loop gain", ...
        ftNote, CinNote, CinAssumption, ...
        "Cstray set to zero; not fitted", ...
        getDeviceRoleNote(device), ...
        getCinImpactNote(device, Cpd, CinWith, bwErrorNoCin, bwErrorWithCin), ...
        "bandwidth_error_percent = 100*(MATLAB - vendor)/vendor"], "; ");

    ablation.case_id(iRow) = caseId;
    ablation.device(iRow) = device;
    ablation.Cf(iRow) = Cf;
    ablation.spice_bandwidth_Hz(iRow) = spiceBandwidth;
    ablation.matlab_bw_noCin_Hz(iRow) = metricsNoCin.bandwidth_Hz;
    ablation.matlab_bw_withCin_Hz(iRow) = metricsWithCin.bandwidth_Hz;
    ablation.bw_error_noCin_percent(iRow) = bwErrorNoCin;
    ablation.bw_error_withCin_percent(iRow) = bwErrorWithCin;
    ablation.spice_peaking_dB(iRow) = spicePeaking;
    ablation.matlab_peak_noCin_dB(iRow) = metricsNoCin.peaking_dB;
    ablation.matlab_peak_withCin_dB(iRow) = metricsWithCin.peaking_dB;
    ablation.peak_error_noCin_dB(iRow) = peakErrorNoCin;
    ablation.peak_error_withCin_dB(iRow) = peakErrorWithCin;
    ablation.documented_Cin_F(iRow) = CinWith;
    ablation.label_noCin(iRow) = string(classNoCin.region_label);
    ablation.label_withCin(iRow) = string(classWithCin.region_label);
    ablation.spice_label(iRow) = spiceLabel;
    ablation.label_agree_noCin(iRow) = string(labelAgreeNoCin);
    ablation.label_agree_withCin(iRow) = string(labelAgreeWithCin);
    ablation.notes(iRow) = notes;

    overlayData.(matlab.lang.makeValidName(caseId)) = struct( ...
        'case_id', caseId, ...
        'device', device, ...
        'f_Hz', spiceCurve.f_Hz, ...
        'spice_mag_dBohm', spiceCurve.mag_dBohm, ...
        'matlab_noCin_mag_dBohm', 20*log10(abs(responseNoCin.Zt_nonideal)), ...
        'matlab_withCin_mag_dBohm', 20*log10(abs(responseWithCin.Zt_nonideal)), ...
        'CinWith', CinWith, ...
        'notes', notes);
end

ablationPath = fullfile(resultsDir, ...
    'cin_ablation_agreement_summary.csv');
writetable(ablation, ablationPath);

compact = createCompactSummary(ablation);
compactPath = fullfile(resultsDir, ...
    'cin_ablation_compact_metrics.csv');
writetable(compact, compactPath);

createWorstCaseOverlay( ...
    overlayData, "OPA818_Rf10k_Cpd10p_Cf0p5", ...
    fullfile(figuresDir, ...
        'behavioural_vs_vendor_overlay_OPA818_Cf0p5_worstcase.png'), ...
    "OPA818 small-Cf boundary case");
createWorstCaseOverlay( ...
    overlayData, "ADA4817_Rf10k_Cpd10p_Cf0p5", ...
    fullfile(figuresDir, ...
        'behavioural_vs_vendor_overlay_ADA4817_Cf0p5_worstcase.png'), ...
    "ADA4817 small-Cf boundary case");
createWorstCaseOverlay( ...
    overlayData, "OP27_Cf3p455_Risky", ...
    fullfile(figuresDir, ...
        'behavioural_vs_vendor_overlay_OP27_Cf3p455_negative_control.png'), ...
    "OP27 low-GBW negative-control case");

fprintf('Cin ablation summary written:\n');
fprintf('  %s\n', ablationPath);
fprintf('Compact Cin ablation metrics written:\n');
fprintf('  %s\n', compactPath);
fprintf('Worst-case overlay figures written to:\n');
fprintf('  %s\n', figuresDir);

function ensureDir(pathName)
if ~exist(pathName, 'dir')
    mkdir(pathName);
end
end

function compact = createCompactSummary(ablation)
groups = ["all_cases"; "high_speed_OPA818_ADA4817"; "OPA818"; "ADA4817"; "OP27"];
compact = table( ...
    strings(numel(groups), 1), zeros(numel(groups), 1), ...
    zeros(numel(groups), 1), zeros(numel(groups), 1), ...
    zeros(numel(groups), 1), zeros(numel(groups), 1), ...
    zeros(numel(groups), 1), zeros(numel(groups), 1), ...
    strings(numel(groups), 1), ...
    'VariableNames', { ...
        'device_group', ...
        'mean_abs_bandwidth_error_noCin_percent', ...
        'mean_abs_bandwidth_error_withCin_percent', ...
        'max_abs_bandwidth_error_noCin_percent', ...
        'max_abs_bandwidth_error_withCin_percent', ...
        'label_agreement_count_noCin', ...
        'label_agreement_count_withCin', ...
        'case_count', 'notes'});

for iGroup = 1:numel(groups)
    groupName = groups(iGroup);
    if groupName == "all_cases"
        mask = true(height(ablation), 1);
        notes = "All selected OP27, OPA818, and ADA4817 vendor-export cases.";
    elseif groupName == "high_speed_OPA818_ADA4817"
        mask = ablation.device == "OPA818" | ablation.device == "ADA4817";
        notes = "Primary high-speed comparison cases; excludes OP27 negative control.";
    else
        mask = ablation.device == groupName;
        notes = groupName + " rows only.";
    end

    compact.device_group(iGroup) = groupName;
    compact.mean_abs_bandwidth_error_noCin_percent(iGroup) = ...
        mean(abs(ablation.bw_error_noCin_percent(mask)), 'omitnan');
    compact.mean_abs_bandwidth_error_withCin_percent(iGroup) = ...
        mean(abs(ablation.bw_error_withCin_percent(mask)), 'omitnan');
    compact.max_abs_bandwidth_error_noCin_percent(iGroup) = ...
        max(abs(ablation.bw_error_noCin_percent(mask)), [], 'omitnan');
    compact.max_abs_bandwidth_error_withCin_percent(iGroup) = ...
        max(abs(ablation.bw_error_withCin_percent(mask)), [], 'omitnan');
    compact.label_agreement_count_noCin(iGroup) = ...
        sum(ablation.label_agree_noCin(mask) == "true");
    compact.label_agreement_count_withCin(iGroup) = ...
        sum(ablation.label_agree_withCin(mask) == "true");
    compact.case_count(iGroup) = sum(mask);
    compact.notes(iGroup) = notes + " Cin effect should be interpreted with Cpd=10 pF dominance and A0/open-loop assumptions.";
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
            "withCin uses %.6g F documented input capacitance", Cin);
        note = sprintf("Cin=%.6g F from local datasheet SI table", Cin);
        assumption = string(assumption);
        note = string(note);
        return;
    end
end

Cin = 0;
assumption = "withCin equals noCin because no scalar datasheet Cin is available locally; needs_manual_check";
note = "Cin unavailable in local SI table; zero-Cin fallback used; needs_manual_check";
end

function note = getCinImpactNote(device, Cpd, Cin, errNoCin, errWithCin)
if Cin == 0
    note = device + " has no documented scalar Cin in this local table, so no Cin-improvement claim is made";
    return;
end

ratio = Cin / Cpd;
deltaAbsError = abs(errNoCin) - abs(errWithCin);
if deltaAbsError > 0
    direction = "reduced";
elseif deltaAbsError < 0
    direction = "increased";
else
    direction = "unchanged";
end

note = sprintf( ...
    "Cin/Cpd=%.3g; withCin %s absolute bandwidth error by %.3g percentage points", ...
    ratio, direction, abs(deltaAbsError));
note = string(note);
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
    error('run_16_cin_ablation_agreement_analysis:UnknownCurveSchema', ...
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

function createWorstCaseOverlay(overlayData, caseId, outputPath, titleText)
fieldName = matlab.lang.makeValidName(caseId);
if ~isfield(overlayData, fieldName)
    warning('run_16_cin_ablation_agreement_analysis:MissingOverlayCase', ...
        'Skipping overlay for %s because no matched curve exists.', caseId);
    return;
end

item = overlayData.(fieldName);
fig = figure('Color', 'w', 'Name', char(titleText), 'Visible', 'off');
semilogx(item.f_Hz, item.matlab_noCin_mag_dBohm, ...
    ':', 'LineWidth', 1.8, 'DisplayName', 'MATLAB behavioural, Cin=0');
hold on;
semilogx(item.f_Hz, item.matlab_withCin_mag_dBohm, ...
    'LineWidth', 1.9, 'DisplayName', 'MATLAB behavioural, documented Cin');
semilogx(item.f_Hz, item.spice_mag_dBohm, ...
    '--', 'LineWidth', 1.7, ...
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
    exportgraphics(figHandle, outputPath, 'Resolution', 600);
catch
    print(figHandle, outputPath, '-dpng', '-r600');
end
end
