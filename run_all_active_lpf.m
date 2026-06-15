function run_all_active_lpf()
%RUN_ALL_ACTIVE_LPF Run the existing active LPF workflow scripts in order.
%
% This runner does not change the individual script logic. It calls the
% existing scripts in the same staged order documented in README.md.

repoRoot = fileparts(mfilename('fullpath'));
scriptsDir = fullfile(repoRoot, 'scripts');

workflow = {
    'run_01_ideal_model_verification.m'
    'run_02_nonideal_model_check.m'
    'run_03_day9_M_sweep_nonideal_response.m'
    'run_04_day10_high_ft_limit_check.m'
    'run_05_day11_ideal_limit_consistency_check.m'
    'run_06_day12_A0_DC_gain_sensitivity_table.m'
    'run_07_day15_clean_ideal_extraction_verification.m'
    'run_08_day16_clean_nonideal_extraction_test.m'
    'run_09_day17_virtual_measurement_noise_check.m'
    'run_10_day18_noisy_extraction_smoothing_test.m'
    'run_11_day19_monte_carlo_noise_test.m'
    'run_12_day22_parameter_sweep_metrics.m'
    'run_13_day23_classify_design_regions.m'
    'run_14_day24_find_margin_thresholds.m'
    'run_15_day25_error_vs_M_plots.m'
    'run_16_day26_safe_marginal_risky_design_map.m'
    'run_17_day27_required_ft_plot.m'
};

for k = 1:numel(workflow)
    scriptPath = fullfile(scriptsDir, workflow{k});

    if ~isfile(scriptPath)
        error('Workflow script not found: %s', scriptPath);
    end

    fprintf('\n[%02d/%02d] Running %s\n', k, numel(workflow), workflow{k});
    evalin('base', sprintf('run(''%s'')', escapeSingleQuotes(scriptPath)));
end

fprintf('\nActive LPF workflow complete.\n');
end

function out = escapeSingleQuotes(in)
out = strrep(in, '''', '''''');
end
