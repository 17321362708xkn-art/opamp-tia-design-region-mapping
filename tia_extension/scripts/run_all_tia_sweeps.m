%RUN_ALL_TIA_SWEEPS Run the Round 3 TIA sweep and design-map workflow.
%
% This runner executes the clean behavioural MATLAB sweep pipeline. It does
% not run SPICE, hardware measurement, or noise analysis.

scriptDir = fileparts(mfilename('fullpath'));

run(fullfile(scriptDir, 'run_03_sweep_Cf_for_peaking_bandwidth.m'));
run(fullfile(scriptDir, 'run_04_sweep_Cpd_and_ft.m'));
run(fullfile(scriptDir, 'run_05_design_region_map_tia.m'));
