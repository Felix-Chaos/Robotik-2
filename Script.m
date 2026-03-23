%% Task 5: IMU Data Processing
% Plot and analyze 3-axis rotation data using multiple sensor fusion methods

clearvars; clc; close all;

useOffsetComp = false;
fprintf('Offset compensation: %s\n', char(string(useOffsetComp)));

files = {'x_axis_rotation_3.mat', 'y_axis_rotation_3.mat', 'z_axis_rotation_3.mat'};
labels = {'X-Axis Movement', 'Y-Axis Movement', 'Z-Axis Movement'};
axisCol = [1, 2, 3];
desired = [0, 45, 90, 45, 0]';

% Sensor parameters
fs = 50;  Ts = 1/fs;  gamma = 0.97;
maxDurationSec = 60;  gyroThreshDeg = 3;  minStaticSec = 1.0;

% Offset calibration from no_motion.mat

[nmAccOffset, nmGyroOffset, hasNoMotionOffsets] = computeNoMotionOffsets('no_motion.mat');

% Compute static phase threshold from no_motion gyro noise profile
if hasNoMotionOffsets
    S_nm = load('no_motion.mat');
    if isfield(S_nm, 'rx_data')
        vals_nm = squeeze(S_nm.rx_data.signals.values)';
        if size(vals_nm, 2) >= 6
            gyro_nm = vals_nm(:, 4:6) - nmGyroOffset;
            gyro_nm_norm_deg = vecnorm(gyro_nm * 180 / pi, 2, 2);
            gyroThreshDeg = max(gyroThreshDeg, mean(gyro_nm_norm_deg) + 3 * std(gyro_nm_norm_deg));
        end
    elseif isfield(S_nm, 'gyro')
        gyro_nm = S_nm.gyro - nmGyroOffset;
        gyro_nm_norm_deg = vecnorm(gyro_nm * 180 / pi, 2, 2);
        gyroThreshDeg = max(gyroThreshDeg, mean(gyro_nm_norm_deg) + 3 * std(gyro_nm_norm_deg));
    end
end

% Plot configuration
axis_colors = [0.00 0.45 0.74; 0.85 0.33 0.10; 0.47 0.67 0.19];
raw_alpha = 0.30;  lw_raw = 0.9;

figure('Name', 'IMU Analysis', 'NumberTitle', 'off', 'Position', [100, 100, 2000, 800]);
t = tiledlayout(3, 6, 'TileSpacing', 'Compact', 'Padding', 'Compact');
title(t, 'Task 5.1-5.6: IMU Analysis')
all_axes = gobjects(0);

figure('Name', 'Method Comparison', 'NumberTitle', 'off', 'Position', [120, 120, 1200, 900]);
t_cmp = tiledlayout(3, 1, 'TileSpacing', 'Compact', 'Padding', 'Compact');
title(t_cmp, 'Method Comparison')
cmp_axes = gobjects(0);

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

    % Apply optional offset compensation
    accel = accel_raw;
    gyro = gyro_raw;
    if useOffsetComp && hasNoMotionOffsets
        accel = accel_raw - nmAccOffset;
        gyro = gyro_raw - nmGyroOffset;
    end

    % SUBTASK 5.2 equation: accelerometer angles
    calc_rotation_accel = EulerAnglesFromAccData(accel);
    % SUBTASK 5.3 equation: gyroscope integration
    calc_rotation_gyro = EulerAnglesFromGyroData(gyro, Ts);
    % SUBTASK 5.4 equation: quaternion integration
    [~, calc_rotation_gyro_quat] = QuaternionFromGyroData(gyro, Ts);
    % SUBTASK 5.5 equation: complementary filter fusion
    calc_rotation_fused = ComplementaryFilter(gyro, calc_rotation_accel, Ts, gamma);

    % TASK 6.1: Static phase angles from complementary filter

    angleSig = calc_rotation_fused(:, axisCol(i));
    angleSig = angleSig - angleSig(1);
    angleSigInv = -angleSig;

    % TASK 6.2: Detect static phases (no end-effector movement)
    gyroNormDeg = vecnorm(gyro * 180 / pi, 2, 2);
    isStatic = gyroNormDeg < gyroThreshDeg;
    d = diff([false; isStatic; false]);
    starts = find(d == 1);
    ends = find(d == -1) - 1;

    minLen = round(minStaticSec * fs);
    keep = (ends - starts + 1) >= minLen;
    starts = starts(keep);
    ends = ends(keep);

    if ~isempty(starts)
        n = min(5, numel(starts));
        starts = starts(1:n);
        ends = ends(1:n);
        desiredNow = desired(1:n);

        % TASK 6.3: Compare static angles to desired sequence
        % Desired sequence from end-effector rotations: 0 -> 45 -> 90 -> 45 -> 0
        % Sign check: normal vs inverted
        meanNormal = zeros(n, 1);
        meanInverted = zeros(n, 1);
        for p = 1:n
            valsNormal = angleSig(starts(p):ends(p));
            valsInverted = angleSigInv(starts(p):ends(p));
            meanNormal(p) = mean(valsNormal);
            meanInverted(p) = mean(valsInverted);
        end

        scoreNormal = mean(abs(meanNormal - desiredNow));
        scoreInverted = mean(abs(meanInverted - desiredNow));

        if scoreInverted < scoreNormal
            signLabel = 'inverted sign is closer';
        else
            signLabel = 'normal sign is closer';
        end
        fprintf('Sign check (%s): %s\n', labels{i}, signLabel);

        % TASK 6.4: Per-phase means and errors
        meanDeg = zeros(n,1);
        stdDeg = zeros(n,1);
        meanErrDeg = zeros(n,1);
        meanDegInv = zeros(n,1);
        stdDegInv = zeros(n,1);
        meanErrDegInv = zeros(n,1);
        for p = 1:n
            vals = angleSig(starts(p):ends(p));
            valsInv = angleSigInv(starts(p):ends(p));
            meanDeg(p) = mean(vals);
            stdDeg(p) = std(vals);
            meanErrDeg(p) = meanDeg(p) - desiredNow(p);
            meanDegInv(p) = mean(valsInv);
            stdDegInv(p) = std(valsInv);
            meanErrDegInv(p) = meanDegInv(p) - desiredNow(p);
        end

        Tphase = table((1:n)', desiredNow, ...
            meanDeg, stdDeg, meanErrDeg, ...
            meanDegInv, stdDegInv, meanErrDegInv, ...
            'VariableNames', {'Phase', 'DesiredDeg', ...
            'MeanDegNormal', 'StdDegNormal', 'MeanErrorDegNormal', ...
            'MeanDegInverted', 'StdDegInverted', 'MeanErrorDegInverted'});

        % TASK 6.5: For each target angle compute mean error and standard deviation
        targets = unique(desiredNow);
        targetDeg = zeros(numel(targets),1);
        errMean = zeros(numel(targets),1);
        errStd = zeros(numel(targets),1);
        errMeanInv = zeros(numel(targets),1);
        errStdInv = zeros(numel(targets),1);

        for k = 1:numel(targets)
            tgt = targets(k);
            allErr = [];
            allErrInv = [];
            for p = 1:n
                if desiredNow(p) == tgt
                    vals = angleSig(starts(p):ends(p));
                    valsInv = angleSigInv(starts(p):ends(p));
                    allErr = [allErr; vals - tgt]; 
                    allErrInv = [allErrInv; valsInv - tgt]; 
                end
            end
            targetDeg(k) = tgt;
            errMean(k) = mean(allErr);
            errStd(k) = std(allErr);
            errMeanInv(k) = mean(allErrInv);
            errStdInv(k) = std(allErrInv);
        end

        Ttarget = table(targetDeg, errMean, errStd, errMeanInv, errStdInv, ...
            'VariableNames', {'TargetDeg', ...
            'MeanErrorDegNormal', 'StdErrorDegNormal', ...
            'MeanErrorDegInverted', 'StdErrorDegInverted'});

        % Visualize static phases
        desiredTrace = nan(size(angleSig));
        for p = 1:n
            desiredTrace(starts(p):ends(p)) = desiredNow(p);
        end

        figure('Name', ['Step 6 - ' labels{i}], 'NumberTitle', 'off');
        plot(plot_t, angleSig, 'b', 'LineWidth', 1.2); hold on;
        plot(plot_t, angleSigInv, 'm', 'LineWidth', 1.2);
        plot(plot_t, desiredTrace, 'r--', 'LineWidth', 1.5);
        grid on;
        xlabel('Time [s]');
        ylabel('Angle [deg]');
        title(['Static comparison - ' labels{i}]);
        legend('Calculated angle (normal)', 'Calculated angle (inverted)', ...
            'Desired angle in static phases', 'Location', 'best');
    else
        warning('No static phases found in %s', files{i});
    end

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

    cmp_axes = [cmp_axes, ax_cmp];
    all_axes = [all_axes, ax1, ax2, ax3, ax4, ax5, ax6];
end

xlabel(t, 'Time (seconds)')
linkaxes(all_axes, 'x')
xlim(all_axes, [plot_t(1) plot_t(end)])

xlabel(t_cmp, 'Time (seconds)')
linkaxes(cmp_axes, 'x')
xlim(cmp_axes, [plot_t(1) plot_t(end)])

% === Equation methods ===

function [euler_acc] = EulerAnglesFromAccData(acc)
    % Subtask 5.2 equation: accelerometer-based angles
    for k=1:length(acc)

NormedX=acc(k,1)./norm(acc(k,:));
NormedY=acc(k,2)./norm(acc(k,:));
NormedZ=acc(k,3)./norm(acc(k,:));

phi(k,:)=-atan2(NormedY,-NormedZ);
theta(k,:)=-atan2(-NormedX,sqrt(NormedY^2+NormedZ^2));
 end

 phi=phi*180/pi;
 theta=theta*180/pi;

    euler_acc=[phi theta];

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


function [accOffset, gyroOffset, ok] = computeNoMotionOffsets(filePath)
    accOffset = [0 0 0];
    gyroOffset = [0 0 0];
    ok = false;

    if ~isfile(filePath)
        return;
    end

    S = load(filePath);
    if isfield(S, 'rx_data')
        vals = squeeze(S.rx_data.signals.values)';
        if size(vals, 2) < 6
            return;
        end
        accRef = vals(:, 1:3);
        gyroRef = vals(:, 4:6);
    elseif isfield(S, 'acc') && isfield(S, 'gyro')
        accRef = S.acc;
        gyroRef = S.gyro;
    else
        return;
    end

    nCalib = min(100, size(accRef, 1));
    if nCalib < 1
        return;
    end

    accOffset = mean(accRef(1:nCalib, :), 1);
    accOffset(3) = accOffset(3) + 9.81;
    gyroOffset = mean(gyroRef(1:nCalib, :), 1);
    ok = true;
end


