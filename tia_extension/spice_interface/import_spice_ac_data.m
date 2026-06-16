function spice = import_spice_ac_data(filePath)
%IMPORT_SPICE_AC_DATA Import exported SPICE AC transimpedance data.
%
%   spice = import_spice_ac_data(filePath) reads a CSV exported from a
%   SPICE AC analysis. The file must contain a frequency column and either
%   magnitude/phase columns or real/imaginary transimpedance columns.
%
%   This importer does not create or infer SPICE data. It only normalises
%   real exported data into a MATLAB structure for later comparison.

arguments
    filePath (1,:) char
end

if ~exist(filePath, 'file')
    error('import_spice_ac_data:MissingFile', ...
        'SPICE AC export file not found: %s', filePath);
end

firstLine = readFirstLine(filePath);
if isLtspiceTextExport(firstLine)
    spice = importLtspiceTextExport(filePath);
    return;
end

raw = readtable(filePath, 'TextType', 'string', ...
    'VariableNamingRule', 'preserve');
names = string(raw.Properties.VariableNames);
normalised = normaliseNames(names);

fIdx = findFirst(normalised, ...
    ["fhz", "frequencyhz", "freqhz", "frequency", "freq"]);
if isempty(fIdx)
    error('import_spice_ac_data:MissingFrequency', ...
        'Missing frequency column. Expected f_Hz or frequency_Hz.');
end

f_Hz = raw{:, fIdx};

magOhmIdx = findFirst(normalised, ...
    ["magztohm", "ztmagohm", "magnitudeohm", "magohm", "ztmagnitudeohm"]);
magDbIdx = findFirst(normalised, ...
    ["magztdbohm", "ztmagdbohm", "magnitudedbohm", ...
     "transimpedancedbohm", "transimpedancedb", "magdb", "dbohm"]);
phaseIdx = findFirst(normalised, ...
    ["phaseztdeg", "ztphasedeg", "phasedeg", "phase"]);
realIdx = findFirst(normalised, ...
    ["realzt", "ztreal", "realohm", "real"]);
imagIdx = findFirst(normalised, ...
    ["imagzt", "ztimag", "imagohm", "imag"]);

if ~isempty(magOhmIdx) && ~isempty(phaseIdx)
    mag_ohm = raw{:, magOhmIdx};
    phase_deg = raw{:, phaseIdx};
    Zt = mag_ohm .* exp(1j * phase_deg*pi/180);
elseif ~isempty(magDbIdx) && ~isempty(phaseIdx)
    mag_ohm = 10.^(raw{:, magDbIdx}/20);
    phase_deg = raw{:, phaseIdx};
    Zt = mag_ohm .* exp(1j * phase_deg*pi/180);
elseif ~isempty(realIdx) && ~isempty(imagIdx)
    Zt = raw{:, realIdx} + 1j * raw{:, imagIdx};
    mag_ohm = abs(Zt);
    phase_deg = unwrap(angle(Zt)) * 180/pi;
else
    error('import_spice_ac_data:MissingResponse', ...
        ['Missing response columns. Provide mag_Zt_ohm and ' ...
         'phase_Zt_deg, mag_Zt_dBohm and phase_Zt_deg, or ' ...
         'real_Zt and imag_Zt.']);
end

spice = struct();
spice.source_file = string(filePath);
spice.raw_table = raw;
spice.f_Hz = f_Hz(:);
spice.Zt = Zt(:);
spice.mag_Zt_ohm = mag_ohm(:);
spice.mag_Zt_dBohm = 20*log10(mag_ohm(:));
spice.phase_Zt_deg = phase_deg(:);
spice.metadata = extractMetadata(raw, names, normalised);
end

function line = readFirstLine(filePath)
fid = fopen(filePath, 'r');
if fid < 0
    error('import_spice_ac_data:OpenFailed', ...
        'Could not open SPICE AC export file: %s', filePath);
end
cleanup = onCleanup(@() fclose(fid));
line = fgetl(fid);
if isequal(line, -1)
    line = "";
else
    line = string(line);
end
end

function tf = isLtspiceTextExport(firstLine)
tf = contains(firstLine, "Freq.") && contains(firstLine, "V(out)");
end

function spice = importLtspiceTextExport(filePath)
text = fileread(filePath);
lines = regexp(text, '\r\n|\n|\r', 'split');
if numel(lines) < 2
    error('import_spice_ac_data:EmptyLtspiceTextExport', ...
        'LTspice text export is empty or missing data rows: %s', filePath);
end

headerParts = string(regexp(strtrim(lines{1}), '\t+', 'split'));
if numel(headerParts) < 2
    headerParts = string(regexp(strtrim(lines{1}), '\s+', 'split'));
end
signalNames = headerParts(2:end);
voutIdx = find(signalNames == "V(out)", 1, 'first');
vninIdx = find(signalNames == "V(nin)", 1, 'first');

if isempty(voutIdx)
    error('import_spice_ac_data:MissingLtspiceVout', ...
        'LTspice text export is missing V(out): %s', filePath);
end

rowCapacity = max(numel(lines) - 1, 0);
f_Hz = NaN(rowCapacity, 1);
voutMag_dB = NaN(rowCapacity, 1);
voutPhase_deg = NaN(rowCapacity, 1);
vninMag_dB = NaN(rowCapacity, 1);
vninPhase_deg = NaN(rowCapacity, 1);
rowCount = 0;

for iLine = 2:numel(lines)
    line = strtrim(lines{iLine});
    if strlength(string(line)) == 0
        continue;
    end

    parts = regexp(line, '\t+', 'split');
    if numel(parts) < numel(headerParts)
        parts = regexp(line, '\s+', 'split');
    end
    if numel(parts) < numel(headerParts)
        error('import_spice_ac_data:LtspiceRowWidth', ...
            'LTspice text export row %d has too few columns in %s.', ...
            iLine, filePath);
    end

    rowCount = rowCount + 1;
    f_Hz(rowCount) = str2double(parts{1});

    [voutMag_dB(rowCount), voutPhase_deg(rowCount)] = ...
        parseLtspiceDbPhaseToken(parts{1 + voutIdx}, iLine, "V(out)");
    if ~isempty(vninIdx)
        [vninMag_dB(rowCount), vninPhase_deg(rowCount)] = ...
            parseLtspiceDbPhaseToken(parts{1 + vninIdx}, iLine, "V(nin)");
    end
end

f_Hz = f_Hz(1:rowCount);
voutMag_dB = voutMag_dB(1:rowCount);
voutPhase_deg = voutPhase_deg(1:rowCount);
vninMag_dB = vninMag_dB(1:rowCount);
vninPhase_deg = vninPhase_deg(1:rowCount);

if rowCount == 0 || any(isnan(f_Hz)) || any(isnan(voutMag_dB)) || ...
        any(isnan(voutPhase_deg))
    error('import_spice_ac_data:LtspiceParseFailed', ...
        'Could not parse required LTspice AC data rows from %s.', filePath);
end

mag_ohm = 10.^(voutMag_dB/20);
Zt = mag_ohm .* exp(1j * voutPhase_deg*pi/180);

if ~isempty(vninIdx)
    raw = table(f_Hz, vninMag_dB, vninPhase_deg, ...
        voutMag_dB, voutPhase_deg, ...
        'VariableNames', { ...
            'frequency_Hz', 'Vnin_mag_dB', 'Vnin_phase_deg', ...
            'Vout_mag_dB', 'Vout_phase_deg'});
else
    raw = table(f_Hz, voutMag_dB, voutPhase_deg, ...
        'VariableNames', { ...
            'frequency_Hz', 'Vout_mag_dB', 'Vout_phase_deg'});
end

spice = struct();
spice.source_file = string(filePath);
spice.raw_table = raw;
spice.f_Hz = f_Hz(:);
spice.Zt = Zt(:);
spice.mag_Zt_ohm = mag_ohm(:);
spice.mag_Zt_dBohm = voutMag_dB(:);
spice.phase_Zt_deg = voutPhase_deg(:);
spice.Vnin_mag_dB = vninMag_dB(:);
spice.Vnin_phase_deg = vninPhase_deg(:);
spice.metadata = struct();
spice.metadata.source_has_case_parameters = false;
spice.metadata.original_columns = headerParts;
spice.metadata.ltspice_text_export = true;
end

function [mag_dB, phase_deg] = parseLtspiceDbPhaseToken(token, lineNumber, signalName)
numberPattern = '([+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?)';
expr = ['^\s*\(\s*' numberPattern '\s*dB\s*,\s*' numberPattern];
tokens = regexp(char(token), expr, 'tokens', 'once');
if isempty(tokens)
    error('import_spice_ac_data:LtspiceComplexToken', ...
        'Could not parse %s complex dB/phase token on row %d: %s', ...
        signalName, lineNumber, string(token));
end
mag_dB = str2double(tokens{1});
phase_deg = str2double(tokens{2});
end

function normalised = normaliseNames(names)
normalised = lower(regexprep(names, '[^A-Za-z0-9]', ''));
end

function idx = findFirst(normalised, candidates)
idx = [];
for iCandidate = 1:numel(candidates)
    hit = find(normalised == candidates(iCandidate), 1, 'first');
    if ~isempty(hit)
        idx = hit;
        return;
    end
end
end

function metadata = extractMetadata(raw, names, normalised)
metadata = struct();
metadata.source_has_case_parameters = false;

fields = { ...
    'case_label', ["caselabel", "caseid", "case"]; ...
    'vendor_model', ["vendormodel", "opampmodel", "model"]; ...
    'Rf_ohm', ["rfohm", "rf"]; ...
    'Cf_F', ["cff", "cf"]; ...
    'Cpd_F', ["cpdf", "cpd"]; ...
    'A0', ["a0", "dcgain"]; ...
    'ft_Hz', ["fthz", "gbwhz", "unitygainfrequencyhz"]};

for iField = 1:size(fields, 1)
    idx = findFirst(normalised, fields{iField, 2});
    if isempty(idx)
        continue;
    end

    values = raw{:, idx};
    if isnumeric(values)
        metadata.(fields{iField, 1}) = values(1);
    else
        metadata.(fields{iField, 1}) = string(values(1));
    end
end

required = ["Rf_ohm", "Cf_F", "Cpd_F", "ft_Hz"];
metadata.source_has_case_parameters = all(isfield(metadata, required));
metadata.original_columns = names;
end
