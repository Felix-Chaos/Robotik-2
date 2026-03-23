%% Task 5: IMU Data Processing
% Plot and analyze 3-axis rotation data using multiple sensor fusion methods

clearvars; clc; close all;

useOffsetComp = true;
compareOffsetComp = true;
fprintf('Offset compensation: %s\n', char(string(useOffsetComp)));

files = {'x_axis_rotation_3.mat', 'y_axis_rotation_3.mat', 'z_axis_rotation_3.mat'};
labels = {'X-Axis Movement', 'Y-Axis Movement', 'Z-Axis Movement'};
axisCol = [1, 2, 3];
desired = [0, 45, 90, 45, 0]';

% Desired angle sign per axis [X Y Z]
% X and Z inverted, Y unchanged.
desiredAxisSign = [-1, 1, -1];

% Static desired-phase timing (manual, easy to edit)
% Tuned to the provided plot timing.
desiredPhaseStartSec = [0, 10, 20, 30, 40];
desiredPhaseEndSec = [3, 15, 25, 35, 45];

% Per-axis desired timing shift [X Y Z] in seconds
% Use this when one axis starts with an extra delay.
desiredAxisStartDelaySec = [0.0, 0.0, 0.0];

% Sensor parameters
fs = 50;  Ts = 1/fs;  gamma = 0.97;
maxDurationSec = 60;  gyroThreshDeg = 3;  minStaticSec = 3.0;

% Offset calibration follows the same approach as the axis scripts:
% mean over first 100 samples and subtract that bias.
nCalibOffset = 100;

% Plot configuration
axis_colors = [0.00 0.45 0.74; 0.85 0.33 0.10; 0.47 0.67 0.19];
raw_alpha = 0.30;  lw_raw = 0.9;

% Create figure for IMU Analysis with all 3 axes side-by-side (3 rows x 6 cols)
figure('Name', 'IMU Analysis', 'NumberTitle', 'off', 'Position', [100, 100, 2000, 1200]);
t = tiledlayout(3, 6, 'TileSpacing', 'Compact', 'Padding', 'Compact');
title(t, 'Task 5.1-5.6: IMU Analysis (All Axes)')

% Create figure for Method Comparison with all 3 axes (3 rows x 1 col)
figure('Name', 'Method Comparison', 'NumberTitle', 'off', 'Position', [120, 120, 1200, 900]);
t_cmp = tiledlayout(3, 1, 'TileSpacing', 'Compact', 'Padding', 'Compact');
title(t_cmp, 'Method Comparison (All Axes)')

% Compare complementary filter with and without offset compensation
if compareOffsetComp
    figure('Name', 'Offset Compensation Comparison', 'NumberTitle', 'off', 'Position', [140, 140, 1200, 900]);
    t_off = tiledlayout(3, 1, 'TileSpacing', 'Compact', 'Padding', 'Compact');
    title(t_off, 'Complementary Filter: With vs Without Offset Compensation')
end

all_axes = gobjects(0);
cmp_axes = gobjects(0);
off_axes = gobjects(0);

for i = 1:3
    
    % Load data
    data_struct = load(files{i});
    all_data = squeeze(data_struct.rx_data.signals.values)';
    num_samples = size(all_data, 1);
    time = (0:num_samples - 1)' / fs;
    idx = time <= maxDurationSec;
    plot_t = time(idx);
    accel_raw = all_data(idx, 1:3);
    gyro_raw = all_data(idx, 4:6);

    % Compute axis-specific offsets using the first calibration samples.
    nCalib = min(nCalibOffset, size(accel_raw, 1));
    accOffset = mean(accel_raw(1:nCalib, :), 1);
    accOffset(3) = accOffset(3) + 9.81;
    gyroOffset = mean(gyro_raw(1:nCalib, :), 1);
    fprintf('%s offsets (first %d samples): acc=[%.4f %.4f %.4f], gyro=[%.6f %.6f %.6f]\n', ...
        labels{i}, nCalib, accOffset(1), accOffset(2), accOffset(3), gyroOffset(1), gyroOffset(2), gyroOffset(3));

    % Compute both branches: without offset and with offset
    offsetModes = [false true];
    accelBranch = cell(1, 2);
    gyroBranch = cell(1, 2);
    accAnglesBranch = cell(1, 2);
    gyroAnglesBranch = cell(1, 2);
    quatAnglesBranch = cell(1, 2);
    fusedAnglesBranch = cell(1, 2);

    for m = 1:2
        useOffsetNow = offsetModes(m);
        accelNow = accel_raw;
        gyroNow = gyro_raw;
        if useOffsetNow
            accelNow = accel_raw - accOffset;
            gyroNow = gyro_raw - gyroOffset;
        end

        accelBranch{m} = accelNow;
        gyroBranch{m} = gyroNow;

        % SUBTASK 5.2 equation: accelerometer angles
        accAnglesBranch{m} = EulerAnglesFromAccData(accelNow);
        % SUBTASK 5.3 equation: gyroscope integration
        gyroAnglesBranch{m} = EulerAnglesFromGyroData(gyroNow, Ts);
        % SUBTASK 5.4 equation: quaternion integration
        [~, quatAnglesBranch{m}] = QuaternionFromGyroData(gyroNow, Ts);
        % SUBTASK 5.5 equation: complementary filter fusion
        fusedAnglesBranch{m} = ComplementaryFilter(gyroNow, accAnglesBranch{m}, Ts, gamma);
    end

    % Select branch used by the existing analysis/plots
    primaryBranchIdx = 1 + double(useOffsetComp);

    accel = accelBranch{primaryBranchIdx};
    gyro = gyroBranch{primaryBranchIdx};
    calc_rotation_accel = accAnglesBranch{primaryBranchIdx};
    calc_rotation_gyro = gyroAnglesBranch{primaryBranchIdx};
    calc_rotation_gyro_quat = quatAnglesBranch{primaryBranchIdx};
    calc_rotation_fused = fusedAnglesBranch{primaryBranchIdx};

    desiredAxis = desired * desiredAxisSign(i);
    phaseStartSec = desiredPhaseStartSec + desiredAxisStartDelaySec(i);
    phaseEndSec = desiredPhaseEndSec + desiredAxisStartDelaySec(i);
    desiredTraceStatic = buildStaticDesiredTrace(plot_t, desiredAxis, phaseStartSec, phaseEndSec);

    angleSig = calc_rotation_fused(:, axisCol(i)) - calc_rotation_fused(1, axisCol(i));
    mask = ~isnan(desiredTraceStatic);

    staticResult = struct();
    staticResult.angleSig = angleSig;
    staticResult.desiredTrace = desiredTraceStatic;

    if any(mask)
        err = angleSig(mask) - desiredTraceStatic(mask);
        staticResult.meanErrorDeg = mean(err);
        staticResult.stdErrorDeg = std(err);
    else
        staticResult.meanErrorDeg = NaN;
        staticResult.stdErrorDeg = NaN;
    end

    staticResult.rmseDeg = computeRMSError(calc_rotation_fused, axisCol(i), desiredAxis);
    fprintf('RMS Error (%s): %.4f deg\n', labels{i}, staticResult.rmseDeg);
    plotStaticComparison(plot_t, labels{i}, staticResult);

    % Plot raw accelerometer
    ax1 = nexttile(t);
    hold(ax1, 'on')
    for k = 1:3
        plot(ax1, plot_t, accel_raw(:, k), 'LineWidth', lw_raw, 'Color', [axis_colors(k, :) raw_alpha]);
    end
    hold(ax1, 'off')
    title(ax1, [labels{i} ' - Accelerometer'])
    ylabel(ax1, 'm/s^2')
    grid(ax1, 'on')
    box(ax1, 'on')
    if i == 1
        legend(ax1, {'X', 'Y', 'Z'}, 'Location', 'eastoutside');
    end

    % Plot raw gyroscope
    ax2 = nexttile(t);
    hold(ax2, 'on')
    for k = 1:3
        plot(ax2, plot_t, gyro_raw(:, k), 'LineWidth', lw_raw, 'Color', [axis_colors(k, :) raw_alpha]);
    end
    hold(ax2, 'off')
    title(ax2, [labels{i} ' - Gyroscope'])
    ylabel(ax2, 'rad/s')
    grid(ax2, 'on')
    box(ax2, 'on')
    if i == 1
        legend(ax2, {'X', 'Y', 'Z'}, 'Location', 'eastoutside');
    end

    % Accelerometer angles
    ax3 = nexttile(t);
    plot(ax3, plot_t, calc_rotation_accel, 'LineWidth', 1.5)
    title(ax3, [labels{i} ' - Orientation from Accelerometer'])
    ylabel(ax3, 'Degrees')
    grid(ax3, 'on')
    box(ax3, 'on')
    yline(ax3, 0, ':', 'Color', [0.50 0.50 0.50]);
    if i == 1, legend(ax3, 'Roll', 'Pitch', 'Location', 'eastoutside'); end

    % Gyroscope angles
    ax4 = nexttile(t);
    plot(ax4, plot_t, calc_rotation_gyro, 'LineWidth', 1.2)
    title(ax4, [labels{i} ' - Orientation from Gyroscope'])
    ylabel(ax4, 'Degrees')
    grid(ax4, 'on')
    box(ax4, 'on')
    yline(ax4, 0, ':', 'Color', [0.50 0.50 0.50]);
    if i == 1, legend(ax4, 'Roll_g', 'Pitch_g', 'Yaw_g', 'Location', 'eastoutside'); end

    % Quaternion angles
    ax5 = nexttile(t);
    plot(ax5, plot_t, calc_rotation_gyro_quat, 'LineWidth', 1.2)
    title(ax5, [labels{i} ' - Orientation from Gyro Quaternion'])
    ylabel(ax5, 'Degrees')
    grid(ax5, 'on')
    box(ax5, 'on')
    yline(ax5, 0, ':', 'Color', [0.50 0.50 0.50]);
    if i == 1, legend(ax5, 'Roll_q', 'Pitch_q', 'Yaw_q', 'Location', 'eastoutside'); end

    % Complementary filter
    ax6 = nexttile(t);
    plot(ax6, plot_t, calc_rotation_fused, 'LineWidth', 1.2)
    title(ax6, [labels{i} ' - Orientation from Complementary Filter'])
    ylabel(ax6, 'Degrees')
    grid(ax6, 'on')
    box(ax6, 'on')
    yline(ax6, 0, ':', 'Color', [0.50 0.50 0.50]);
    if i == 1, legend(ax6, 'Roll_c', 'Pitch_c', 'Yaw_c', 'Location', 'eastoutside'); end

    % Method comparison
    ax_cmp = nexttile(t_cmp);
    hold(ax_cmp, 'on')
    if i == 1
        accel_trace = calc_rotation_accel(:, 1);
        gyro_trace = calc_rotation_gyro(:, 1);
        fused_trace = calc_rotation_fused(:, 1);
        angle_name = 'Roll';
    elseif i == 2
        accel_trace = calc_rotation_accel(:, 2);
        gyro_trace = calc_rotation_gyro(:, 2);
        fused_trace = calc_rotation_fused(:, 2);
        angle_name = 'Pitch';
    else
        % Direct accelerometer yaw value in this model (fixed at 0).
        accel_trace = zeros(size(plot_t));
        gyro_trace = calc_rotation_gyro(:, 3);
        fused_trace = calc_rotation_fused(:, 3);
        angle_name = 'Yaw';
    end

    plot(ax_cmp, plot_t, accel_trace, 'LineWidth', 1.3, 'Color', [0.00 0.45 0.74]);
    plot(ax_cmp, plot_t, fused_trace, 'LineWidth', 1.3, 'Color', [0.47 0.67 0.19]);
    plot(ax_cmp, plot_t, gyro_trace, 'LineWidth', 1.8, 'Color', [0.95 0.45 0.00]);
    hold(ax_cmp, 'off')

    title(ax_cmp, [labels{i} ' - ' angle_name ' (Method Comparison)'])
    ylabel(ax_cmp, 'Degrees')
    grid(ax_cmp, 'on')
    box(ax_cmp, 'on')
    yline(ax_cmp, 0, ':', 'Color', [0.50 0.50 0.50]);
    if i < 3
        legend(ax_cmp, {'Accel only', 'Complementary Filter', 'Gyro only'}, 'Location', 'eastoutside');
    else
        legend(ax_cmp, {'Accel yaw (accel-only)', 'Complementary Filter', 'Gyro only'}, 'Location', 'eastoutside');
    end

    % Offset compensation comparison (complementary filter only)
    if compareOffsetComp
        ax_off = nexttile(t_off);
        hold(ax_off, 'on')
        fused_no_offset = fusedAnglesBranch{1}(:, axisCol(i));
        fused_with_offset = fusedAnglesBranch{2}(:, axisCol(i));
        plot(ax_off, plot_t, fused_no_offset, 'LineWidth', 1.6, 'Color', [0.00 0.45 0.74]);
        plot(ax_off, plot_t, fused_with_offset, 'LineWidth', 1.6, 'Color', [0.85 0.33 0.10]);
        hold(ax_off, 'off')

        d = fused_with_offset - fused_no_offset;
        dMax = max(abs(d));
        dMean = mean(abs(d));
        fprintf('Offset delta %s: max|Δ|=%.4f deg, mean|Δ|=%.4f deg\n', labels{i}, dMax, dMean);

        title(ax_off, sprintf('%s - Complementary Filter Offset Comparison (max|\\Delta|=%.3f deg)', labels{i}, dMax))
        ylabel(ax_off, 'Degrees')
        grid(ax_off, 'on')
        box(ax_off, 'on')
        yline(ax_off, 0, ':', 'Color', [0.50 0.50 0.50]);
        legend(ax_off, {'Without offset compensation', 'With offset compensation'}, 'Location', 'eastoutside');
    end

    cmp_axes = [cmp_axes, ax_cmp];
    if compareOffsetComp
        off_axes = [off_axes, ax_off];
    end
    all_axes = [all_axes, ax1, ax2, ax3, ax4, ax5, ax6];
    
    % Link axes within this tab
    xlabel(t, 'Time (seconds)')
    linkaxes(all_axes, 'x')
    xlim(all_axes, [plot_t(1) plot_t(end)])
    all_axes = gobjects(0);
    
    xlabel(t_cmp, 'Time (seconds)')
    linkaxes(cmp_axes, 'x')
    xlim(cmp_axes, [plot_t(1) plot_t(end)])
    cmp_axes = gobjects(0);

    if compareOffsetComp
        xlabel(t_off, 'Time (seconds)')
        linkaxes(off_axes, 'x')
        xlim(off_axes, [plot_t(1) plot_t(end)])
        off_axes = gobjects(0);
    end
end

% === Equation methods ===

function [euler_acc] = EulerAnglesFromAccData(acc)
    % Subtask 5.2 equation: accelerometer-based angles
    n = size(acc, 1);
    phi = zeros(n, 1);
    theta = zeros(n, 1);

    for k = 1:n
        accNorm = norm(acc(k, :));
        if accNorm == 0
            continue;
        end

        normedX = acc(k, 1) / accNorm;
        normedY = acc(k, 2) / accNorm;
        normedZ = acc(k, 3) / accNorm;

        phi(k) = -atan2(normedY, -normedZ);
        theta(k) = -atan2(-normedX, sqrt(normedY^2 + normedZ^2));
    end

    phi = phi * 180 / pi;
    theta = theta * 180 / pi;

    euler_acc = [phi theta];

end


function [euler_gyro] = EulerAnglesFromGyroData(gyro_data, Ts)
    % Subtask 5.3 equation: gyroscope integration
    euler_gyro=[0 0 0];
    euler_gyro(1,:)=gyro_data(1,:).*Ts;
    for k=2:1:length(gyro_data)
        euler_gyro(k,:)=euler_gyro((k-1),:)+gyro_data(k,:).*Ts;
    end
    euler_gyro = euler_gyro.*180/pi;
end


function [theta] = ComplementaryFilter(omega, a, Ts, gamma)
    % Subtask 5.5 equation: complementary filter fusion
    theta = a;
    zeroVector=zeros(length(a),1);
    theta=[theta zeroVector];
    
    for k = 2:size(omega,1)
        theta_g(k,:) = (omega(k,:)*Ts+(theta(k-1,:)))*gamma;
        theta_a(k,:)  = a(k,1:2)*(1-gamma); 
        theta(k,1:2) = theta_g(k,1:2)+theta_a(k,1:2); 
        theta(k,3) = theta(k-1,3) + Ts * omega(k,3).*180/pi; 
    end
end


function [q, eulerQuat] = QuaternionFromGyroData(gyro_data, Ts)
    % Subtask 5.4 equation: quaternion integration
    n = size(gyro_data, 1);
    q = quaternion.zeros(n, 1);
    eulerQuat = zeros(n, 3);
    
    if n == 0
        return;
    end
    
    q(1) = quaternion([1, 0, 0, 0]);
    eulerQuat(1,:) = eulerd(q(1), 'XYZ', 'frame');
    
    for k = 2:n
        omega = quaternion([0, gyro_data(k-1,1), gyro_data(k-1,2), gyro_data(k-1,3)]);
        q_dot = 0.5 * q(k-1) * omega;
        q(k) = normalize(q(k-1) + q_dot * Ts);
        eulerQuat(k,:) = eulerd(q(k), 'XYZ', 'frame');
    end
end


function plotStaticComparison(plot_t, axisLabel, staticResult)
    figure('Name', ['Step 6 - ' axisLabel], 'NumberTitle', 'off');
    hold on;
    plot(plot_t, staticResult.angleSig, 'b', 'LineWidth', 1.2);
    plot(plot_t, staticResult.desiredTrace, 'r--', 'LineWidth', 1.5);
    grid on;
    xlabel('Time [s]');
    ylabel('Angle [deg]');
    title(['Static comparison - ' axisLabel]);
    legend('Calculated angle (normal)', 'Desired angle in static phases', 'Location', 'best');

    statsText = sprintf('Mean error: %.2f deg\nStd dev: %.2f deg\nRMSE: %.2f deg', ...
        staticResult.meanErrorDeg, staticResult.stdErrorDeg, staticResult.rmseDeg);
    annotation('textbox', [0.67 0.72 0.30 0.20], 'String', statsText, ...
        'FitBoxToText', 'on', 'BackgroundColor', 'white', 'EdgeColor', [0.7 0.7 0.7]);
end


function rms_error = computeRMSError(data, column, expected_values)
    sections = [50 100; 500 550; 900 950; 1300 1350; 1700 1750];

    squared_error_sum = 0;
    total_count = 0;

    for i = 1:size(sections, 1)
        rangeStart = sections(i, 1);
        rangeEnd = min(sections(i, 2), size(data, 1));
        if rangeStart > size(data, 1) || i > numel(expected_values)
            continue;
        end

        range = rangeStart:rangeEnd;
        actual_values = data(range, column);

        squared_error_sum = squared_error_sum + sum((actual_values - expected_values(i)).^2);
        total_count = total_count + numel(actual_values);
    end

    if total_count == 0
        rms_error = NaN;
    else
        rms_error = sqrt(squared_error_sum / total_count);
    end
end


function desiredTrace = buildStaticDesiredTrace(plot_t, desired, phaseStartSec, phaseEndSec)
    desiredTrace = nan(size(plot_t));

    n = min([numel(desired), numel(phaseStartSec), numel(phaseEndSec)]);
    for p = 1:n
        idx = (plot_t >= phaseStartSec(p)) & (plot_t <= phaseEndSec(p));
        desiredTrace(idx) = desired(p);
    end
end


