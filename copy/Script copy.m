
files = {'x_axis_rotation_3.mat', 'y_axis_rotation_3.mat', 'z_axis_rotation_3.mat'};
labels = {'X-Axis Movement', 'Y-Axis Movement', 'Z-Axis Movement'};

% Plot style (visual improvements only)
axis_colors = [0.00 0.45 0.74; 0.85 0.33 0.10; 0.47 0.67 0.19]; % X, Y, Z
raw_alpha = 0.30;
lw_raw = 0.9;

figure('Name', 'IMU 3-Axis Movement Analysis', 'NumberTitle', 'off', 'Position', [100, 100, 2000, 800]);
t = tiledlayout(3, 6, 'TileSpacing', 'Compact', 'Padding', 'Compact');
title(t, 'IMU 3-Axis Movement Analysis')

all_axes = gobjects(0);

figure('Name', 'Rotation Comparison (Accel vs Gyro vs Complementary)', 'NumberTitle', 'off', 'Position', [120, 120, 1200, 900]);
t_cmp = tiledlayout(3, 1, 'TileSpacing', 'Compact', 'Padding', 'Compact');
title(t_cmp, 'Rotation Angles Comparison')
cmp_axes = gobjects(0);

for i = 1:3
    % Load the specific file
    data_struct = load(files{i});
    % Access the nested signals (adjusting for the structure found in your file)
    % Using rx_data.signals.values and squeezing 6x1x2001 to 6x2001
    all_data = squeeze(data_struct.rx_data.signals.values)'; 
    
    % Hardcoded sampling frequency
    fs = 50;
    num_samples = size(all_data, 1);
    time = (0:num_samples-1)' / fs;
    
    % Limit to first 40 seconds
    idx = time <= 60; % Adjusted to 60 seconds to ensure we have enough data for all plots
    plot_t = time(idx); % Time vector for plotting
    accel = all_data(idx, 1:3); % Accelerometer data (Columns 1-3)
    gyro  = all_data(idx, 4:6); % Gyroscope data (Columns 4-6)

    % =========================================================================
    %                 YOUR CALCULATIONS GO HERE
    % =========================================================================
    % Add your processing code here (e.g., filtering, sensor fusion, integration)

    % Accelerometer-only tilt angles (valid for roll/pitch, not yaw)
    % Normalize each sample vector [ax ay az] before angle computation
    a_norm = vecnorm(accel, 2, 2);
    a_norm(a_norm < eps) = eps;
    accel_unit = accel ./ a_norm;

    ax = accel_unit(:, 1);
    ay = accel_unit(:, 2);
    az = accel_unit(:, 3);

    accel_angles_rad = [atan2(ay, az), atan2(-ax, sqrt(ay.^2 + az.^2))];
    calc_rotation_accel = unwrap(accel_angles_rad, [], 1) * 180 / pi;

    % Gyroscope-only orientation (discrete integration):
    % theta(k) = theta(k-1) + Ts * omega(k), with theta(1) = 0
    Ts = 1 / fs;
    omega_deg = gyro * 180 / pi; % gyro in rad/s -> deg/s
    calc_rotation_gyro = zeros(size(omega_deg));
    for k = 2:size(omega_deg, 1)
        calc_rotation_gyro(k, :) = calc_rotation_gyro(k-1, :) + Ts * omega_deg(k, :);
    end

    % Gyro -> quaternion integration (no drift compensation), then Euler.
    N = size(gyro, 1);
    q_gyro = quaternion.zeros(N, 1);
    q_gyro(1) = quaternion(1, 0, 0, 0);
    for k = 2:N
        dtheta = gyro(k-1, :) * Ts;
        dq = quaternion([1, 0.5 * dtheta(1), 0.5 * dtheta(2), 0.5 * dtheta(3)]);
        q_gyro(k) = normalize(q_gyro(k-1) * dq);
    end
    calc_rotation_gyro_quat = eulerd(q_gyro, 'XYZ', 'frame');  % Convert to Euler angles (degrees)

    % MATLAB complementary filter (kept as additional orientation estimate)
    fuse = complementaryFilter('SampleRate', fs, 'HasMagnetometer', false);
    accel_gyro_combined = fuse(accel, gyro);
    if isa(accel_gyro_combined, 'quaternion')
        accel_gyro_combined = eulerd(accel_gyro_combined, 'XYZ', 'frame');
    end
    if size(accel_gyro_combined, 2) == 2
        accel_gyro_combined(:, 3) = 0;
    end
    calc_rotation_fused = accel_gyro_combined(:, 1:3);

    % =========================================================================
    
    % Plot Accelerometer (Column 1)
    ax1 = nexttile(t);
    hold(ax1, 'on')
    for k = 1:3
        plot(ax1, plot_t, accel(:, k), 'LineWidth', lw_raw, 'Color', [axis_colors(k, :) raw_alpha]);
    end
    hold(ax1, 'off')
    title(ax1, [labels{i} ' - Accelerometer'])
    ylabel(ax1, 'm/s^2')
    grid(ax1, 'on')
    box(ax1, 'on')
    if i == 1
        legend(ax1, {'X', 'Y', 'Z'}, 'Location', 'eastoutside');
    end

  %  a_min = prctile(accel(:), 1);
  %  a_max = prctile(accel(:), 99);
  %  if a_max > a_min
  %      pad = 0.15 * (a_max - a_min + eps);
  %      ylim(ax1, [a_min - pad, a_max + pad]);
  %  end
    
    % Plot Gyroscope (Column 2)
    ax2 = nexttile(t);
    hold(ax2, 'on')
    for k = 1:3
        plot(ax2, plot_t, gyro(:, k), 'LineWidth', lw_raw, 'Color', [axis_colors(k, :) raw_alpha]);
    end
    hold(ax2, 'off')
    title(ax2, [labels{i} ' - Gyroscope'])
    ylabel(ax2, 'rad/s')
    grid(ax2, 'on')
    box(ax2, 'on')
    if i == 1
        legend(ax2, {'X', 'Y', 'Z'}, 'Location', 'eastoutside');
    end

  %  g_min = prctile(gyro(:), 1);
  %  g_max = prctile(gyro(:), 99);
  %  if g_max > g_min
  %     pad = 0.15 * (g_max - g_min + eps);
  %      ylim(ax2, [g_min - pad, g_max + pad]);
    %end
    
    % Plot Orientation (Column 3)
    ax3 = nexttile(t);
    plot(ax3, plot_t, calc_rotation_accel, 'LineWidth', 1.5)
    title(ax3, [labels{i} ' - Orientation from Accelerometer'])
    ylabel(ax3, 'Degrees')
    grid(ax3, 'on')
    box(ax3, 'on')
    yline(ax3, 0, ':', 'Color', [0.50 0.50 0.50]);
    if i == 1, legend(ax3, 'Roll', 'Pitch', 'Location', 'eastoutside'); end
    
    % Plot Orientation from Gyroscope (Column 4)
    ax4 = nexttile(t);
    plot(ax4, plot_t, calc_rotation_gyro, 'LineWidth', 1.2)
    title(ax4, [labels{i} ' - Orientation from Gyroscope'])
    ylabel(ax4, 'Degrees')
    grid(ax4, 'on')
    box(ax4, 'on')
    yline(ax4, 0, ':', 'Color', [0.50 0.50 0.50]);
    if i == 1, legend(ax4, 'Roll_g', 'Pitch_g', 'Yaw_g', 'Location', 'eastoutside'); end

    % Plot Orientation from Gyro Quaternion -> Euler (Column 5)
    ax5 = nexttile(t);
    plot(ax5, plot_t, calc_rotation_gyro_quat, 'LineWidth', 1.2)
    title(ax5, [labels{i} ' - Orientation from Gyro Quaternion'])
    ylabel(ax5, 'Degrees')
    grid(ax5, 'on')
    box(ax5, 'on')
    yline(ax5, 0, ':', 'Color', [0.50 0.50 0.50]);
    if i == 1, legend(ax5, 'Roll_q', 'Pitch_q', 'Yaw_q', 'Location', 'eastoutside'); end

    % Plot Orientation from Complementary Filter (Column 6)
    ax6 = nexttile(t);
    plot(ax6, plot_t, calc_rotation_fused, 'LineWidth', 1.2)
    title(ax6, [labels{i} ' - Orientation from Complementary Filter'])
    ylabel(ax6, 'Degrees')
    grid(ax6, 'on')
    box(ax6, 'on')
    yline(ax6, 0, ':', 'Color', [0.50 0.50 0.50]);
    if i == 1, legend(ax6, 'Roll_c', 'Pitch_c', 'Yaw_c', 'Location', 'eastoutside'); end

    % Separate window: method comparison in 3 stacked subplots.
    ax_cmp = nexttile(t_cmp);
    hold(ax_cmp, 'on')
    if i == 1
        accel_trace = calc_rotation_accel(:, 1);
        gyro_trace  = calc_rotation_gyro(:, 1);
        fused_trace = calc_rotation_fused(:, 1);
        angle_name = 'Roll';
    elseif i == 2
        accel_trace = calc_rotation_accel(:, 2);
        gyro_trace  = calc_rotation_gyro(:, 2);
        fused_trace = calc_rotation_fused(:, 2);
        angle_name = 'Pitch';
    else
        accel_trace = nan(size(plot_t)); % accelerometer-only cannot estimate yaw
        gyro_trace  = calc_rotation_gyro(:, 3);
        fused_trace = calc_rotation_fused(:, 3);
        angle_name = 'Yaw';
    end

    plot(ax_cmp, plot_t, accel_trace, 'LineWidth', 1.3, 'Color', [0.00 0.45 0.74]);
    plot(ax_cmp, plot_t, gyro_trace,  'LineWidth', 1.3, 'Color', [0.85 0.33 0.10]);
    plot(ax_cmp, plot_t, fused_trace, 'LineWidth', 1.3, 'Color', [0.47 0.67 0.19]);
    hold(ax_cmp, 'off')

    title(ax_cmp, [labels{i} ' - ' angle_name ' (Method Comparison)'])
    ylabel(ax_cmp, 'Degrees')
    grid(ax_cmp, 'on')
    box(ax_cmp, 'on')
    yline(ax_cmp, 0, ':', 'Color', [0.50 0.50 0.50]);
    legend(ax_cmp, {'Accel only', 'Gyro only', 'Complementary Filter'}, 'Location', 'eastoutside');

    cmp_axes = [cmp_axes, ax_cmp]; 

    all_axes = [all_axes, ax1, ax2, ax3, ax4, ax5, ax6]; 
end

xlabel(t, 'Time (seconds)')
linkaxes(all_axes, 'x')
xlim(all_axes, [plot_t(1) plot_t(end)])

xlabel(t_cmp, 'Time (seconds)')
linkaxes(cmp_axes, 'x')
xlim(cmp_axes, [plot_t(1) plot_t(end)])