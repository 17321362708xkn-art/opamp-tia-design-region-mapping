%RUN_ALL_TIA_FIRST_PASS Run the first-pass TIA v0.1 workflow.
%
% This runner preserves the individual baseline script logic and provides a
% single entry point for the current TIA extension workflow.

scriptDir = fileparts(mfilename('fullpath'));
run(fullfile(scriptDir, 'run_01_tia_baseline.m'));
