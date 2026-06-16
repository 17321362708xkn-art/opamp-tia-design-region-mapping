%RUN_13_CHECK_PREPAPER_CLAIMS_ROUND10 Check selected Round 10 docs for overclaims.
%
% This lightweight checker scans selected narrative/status files. It
% intentionally excludes claims_vs_evidence_matrix.md because that file
% contains controlled forbidden-wording examples by design.

scriptDir = fileparts(mfilename('fullpath'));
tiaRoot = fileparts(scriptDir);
repoRoot = fileparts(tiaRoot);

filesToScan = [
    "tia_extension/README.md"
    "tia_extension/prepaper/manuscript_skeleton.md"
    "tia_extension/prepaper/results_storyline.md"
    "tia_extension/prepaper/figure_table_plan.md"
    "tia_extension/prepaper/contribution_statement_round10.md"
    "tia_extension/prepaper/abstract_draft_options.md"
    "tia_extension/prepaper/q3_readiness_report.md"
    "tia_extension/prepaper/next_submission_tasks.md"
    "tia_extension/prepaper/required_figures_and_tables.md"
    "tia_extension/prepaper/limitations_and_no_overclaim.md"
    "tia_extension/round10_change_log.md"
    ];

forbiddenPhrases = [
    "hardware validated"
    "experimentally validated"
    "measured noise validated"
    "guaranteed stable"
    "journal-ready"
    "q3 accepted"
    ];

warningCount = 0;

for iFile = 1:numel(filesToScan)
    relPath = filesToScan(iFile);
    filePath = fullfile(repoRoot, strrep(char(relPath), '/', filesep));
    if ~exist(filePath, 'file')
        warning('run_13_check_prepaper_claims_round10:MissingFile', ...
            'Skipping missing file: %s', relPath);
        continue;
    end

    text = lower(string(fileread(filePath)));
    for iPhrase = 1:numel(forbiddenPhrases)
        phrase = forbiddenPhrases(iPhrase);
        if contains(text, phrase)
            warningCount = warningCount + 1;
            fprintf('WARNING: "%s" found in %s\n', phrase, relPath);
        end
    end
end

if warningCount == 0
    fprintf('Round 10 prepaper claim check passed: no forbidden overclaim phrases found in selected narrative files.\n');
else
    fprintf('Round 10 prepaper claim check found %d warning(s). Review before committing.\n', warningCount);
end
