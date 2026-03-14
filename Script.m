% List of your 3 files in order: X, Y, Z
files = {'x_axis_rotation_2', 'y_axis_rotation_2.mat', 'z_axis_rotation_2.mat'};
labels = {'X-Axis Movement', 'Y-Axis Movement', 'Z-Axis Movement'};

figure('Name', 'IMU 3-Axis Movement Analysis', 'NumberTitle', 'off');
t = tiledlayout(3, 2, 'TileSpacing', 'Compact', 'Padding', 'Compact');

for i = 1:3
    % Load the specific file
    data_struct = load(files{i});
    penis
    % Access the nested signals (adjusting for the structure found in your file)
    % Using rx_data.signals.values and squeezing 6x1x2001 to 6x2001
    all_data = squeeze(data_struct.rx_data.signals.values)'; 
    
    % Constants
    fs = 50;
    num_samples = size(all_data, 1);
    time = (0:num_samples-1) * (1/fs);
    
    % Limit to first 40 seconds
    idx = time <= 40;
    plot_t = time(idx);
    accel = all_data(idx, 1:3);
    gyro  = all_data(idx, 4:6);
    
    % Plot Accelerometer (Left Column)
    nexttile
    plot(plot_t, accel)
    title([labels{i} ' - Accelerometer'])
    ylabel('m/s^2')
    grid on
    if i == 1, legend('X', 'Y', 'Z'); end % Show legend only on top plot
    
    % Plot Gyroscope (Right Column)
    nexttile
    plot(plot_t, gyro)
    title([labels{i} ' - Gyroscope'])
    ylabel('rad/s')
    grid on
    if i == 1, legend('X', 'Y', 'Z'); end
end

xlabel(t, 'Time (seconds)')