%RUN_14_CHECK_LITERATURE_PLACEHOLDERS_ROUND11 Guard Round 11 literature docs.
%
% This script does not validate real citations. It only checks that the
% Round 11 planning package did not accidentally introduce fabricated-looking
% citation metadata.

scriptDir = fileparts(mfilename('fullpath'));
tiaRoot = fileparts(scriptDir);
repoRoot = fileparts(tiaRoot);

trackingPath = fullfile(repoRoot, 'tia_extension', 'prepaper', ...
    'citation_tracking_table_template.csv');
if ~exist(trackingPath, 'file')
    error('run_14_check_literature_placeholders_round11:MissingTrackingTable', ...
        'Missing citation tracking template: %s', trackingPath);
end

tracking = readtable(trackingPath, 'Delimiter', ',', 'TextType', 'string', ...
    'VariableNamingRule', 'preserve');
if height(tracking) > 0
    citationId = getColumn(tracking, "citation_id");
    fullCitation = getColumn(tracking, "full_citation");
    status = getColumn(tracking, "status");
    isPlaceholder = contains(lower(citationId), "placeholder") | ...
        contains(lower(fullCitation), "placeholder") | ...
        lower(status) == "placeholder";
    if any(~isPlaceholder)
        error('run_14_check_literature_placeholders_round11:NonPlaceholderRows', ...
            'citation_tracking_table_template.csv contains non-placeholder rows.');
    end
end

docsToScan = [
    "tia_extension/prepaper/related_work_taxonomy.md"
    "tia_extension/prepaper/literature_search_queries.md"
    "tia_extension/prepaper/paper_screening_criteria.md"
    "tia_extension/prepaper/paper_reading_note_template.md"
    "tia_extension/prepaper/related_work_to_claims_map.md"
    "tia_extension/prepaper/related_work_section_outline.md"
    "tia_extension/round11_change_log.md"
    ];

doiPattern = '10\.\d{4,9}/[-._;()/:A-Z0-9]+';
authorYearPattern = '\<[A-Z][a-z]+ et al\. \((19|20)\d{2}\)';
warningCount = 0;

for iDoc = 1:numel(docsToScan)
    relPath = docsToScan(iDoc);
    docPath = fullfile(repoRoot, strrep(char(relPath), '/', filesep));
    if ~exist(docPath, 'file')
        warning('run_14_check_literature_placeholders_round11:MissingDoc', ...
            'Skipping missing document: %s', relPath);
        continue;
    end

    text = string(fileread(docPath));
    upperText = upper(text);
    doiMatches = regexp(upperText, doiPattern, 'match');
    if ~isempty(doiMatches)
        warningCount = warningCount + numel(doiMatches);
        fprintf('WARNING: DOI-like string found in %s\n', relPath);
    end

    authorMatches = regexp(text, authorYearPattern, 'match');
    if ~isempty(authorMatches) && ~contains(lower(text), "placeholder")
        warningCount = warningCount + numel(authorMatches);
        fprintf('WARNING: author-year pattern found in %s\n', relPath);
    end
end

if warningCount == 0
    fprintf('Round 11 literature placeholder check passed: no fabricated-looking citation metadata found.\n');
else
    error('run_14_check_literature_placeholders_round11:SuspiciousCitationMetadata', ...
        'Round 11 literature placeholder check found %d warning(s).', warningCount);
end

function values = getColumn(tbl, expectedName)
varNames = string(tbl.Properties.VariableNames);
normalised = lower(regexprep(varNames, '[^a-zA-Z0-9]', ''));
expected = lower(regexprep(expectedName, '[^a-zA-Z0-9]', ''));
idx = find(normalised == expected, 1);
if isempty(idx)
    error('run_14_check_literature_placeholders_round11:MissingColumn', ...
        'Missing expected column: %s', expectedName);
end
values = string(tbl.(varNames(idx)));
end
