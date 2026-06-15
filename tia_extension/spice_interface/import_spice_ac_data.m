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
    ["magztdbohm", "ztmagdbohm", "magnitudedbohm", "magdb", "dbohm"]);
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
spice.phase_Zt_deg = phase_deg(:);
spice.metadata = extractMetadata(raw, names, normalised);
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
