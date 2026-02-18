%% Robot Visualization Examples
% This script demonstrates various robot visualization techniques using
% Peter Corke's Robotics Toolbox.
%
% Topics covered:
%   - Basic robot plotting
%   - Animation
%   - Workspace visualization
%   - Trajectory traces
%   - Custom visualization options

%% Clear workspace
clear;
clc;
close all;

fprintf('=== Robot Visualization Examples ===\n\n');

%% Create robots for visualization
fprintf('Creating robots for visualization...\n\n');

% Simple 2-link planar robot
L2D(1) = Link([0, 0, 1, 0], 'standard');
L2D(2) = Link([0, 0, 0.8, 0], 'standard');
robot2D = SerialLink(L2D, 'name', '2-Link Planar');

% 3-link spatial robot
L3D(1) = Link([0, 0, 0.5, pi/2], 'standard');
L3D(2) = Link([0, 0, 0.5, 0], 'standard');
L3D(3) = Link([0, 0, 0.3, 0], 'standard');
robot3D = SerialLink(L3D, 'name', '3-Link Spatial');

%% Example 1: Basic Robot Visualization
fprintf('1. Basic Robot Visualization\n\n');

% Configuration for 2D robot
q_2d = [pi/6, pi/4];

% Plot the 2D robot
figure('Name', 'Basic 2D Robot Visualization');
robot2D.plot(q_2d);
title('2-Link Planar Robot');

% Configuration for 3D robot
q_3d = [pi/4, pi/6, pi/3];

% Plot the 3D robot
figure('Name', 'Basic 3D Robot Visualization');
robot3D.plot(q_3d);
title('3-Link Spatial Robot');

%% Example 2: Multiple Robot Configurations
fprintf('2. Visualizing Multiple Configurations\n\n');

% Create a grid of configurations
configs_2d = [
    0,     0;
    pi/6,  pi/6;
    pi/4,  pi/4;
    pi/3,  pi/3
];

figure('Name', 'Multiple Robot Configurations');
for i = 1:size(configs_2d, 1)
    subplot(2, 2, i);
    robot2D.plot(configs_2d(i,:));
    title(sprintf('Config %d: [%.0f°, %.0f°]', i, ...
        rad2deg(configs_2d(i,1)), rad2deg(configs_2d(i,2))));
end

%% Example 3: Animated Trajectory
fprintf('3. Animated Trajectory\n\n');

% Generate a simple trajectory
q_start = [0, 0, 0];
q_end = [pi/2, pi/3, pi/6];
t = 0:0.05:2;
q_traj = jtraj(q_start, q_end, t);

fprintf('Animating robot motion along trajectory...\n');
fprintf('Trajectory has %d steps\n\n', size(q_traj, 1));

% Animate with trail
figure('Name', 'Animated Trajectory with Trail');
robot3D.plot(q_traj, 'fps', 30, 'trail', 'r-');

%% Example 4: Workspace Visualization
fprintf('4. Workspace Visualization\n\n');

% Generate random configurations to map workspace
n_samples = 500;
workspace = zeros(n_samples, 3);

fprintf('Sampling workspace with %d configurations...\n', n_samples);

for i = 1:n_samples
    % Random joint configuration
    q_rand = [
        rand()*2*pi - pi;
        rand()*pi - pi/2;
        rand()*pi - pi/2
    ];
    
    % Compute forward kinematics
    T = robot3D.fkine(q_rand);
    workspace(i,:) = T.t';
end

% Visualize workspace
figure('Name', 'Robot Workspace');

% 3D scatter plot
subplot(2, 2, [1, 3]);
scatter3(workspace(:,1), workspace(:,2), workspace(:,3), 5, workspace(:,3), 'filled');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('3D Workspace');
colorbar; colormap('jet');
grid on; axis equal;
view(45, 30);

% XY projection
subplot(2, 2, 2);
scatter(workspace(:,1), workspace(:,2), 5, workspace(:,3), 'filled');
xlabel('X (m)'); ylabel('Y (m)');
title('XY Projection');
colorbar; colormap('jet');
grid on; axis equal;

% XZ projection
subplot(2, 2, 4);
scatter(workspace(:,1), workspace(:,3), 5, workspace(:,2), 'filled');
xlabel('X (m)'); ylabel('Z (m)');
title('XZ Projection');
colorbar; colormap('jet');
grid on; axis equal;

fprintf('Workspace visualization complete\n\n');

%% Example 5: End-Effector Trajectory Trace
fprintf('5. End-Effector Trajectory Trace\n\n');

% Create a circular trajectory in joint space
n_points = 100;
theta = linspace(0, 2*pi, n_points);

% Sinusoidal motion in joint space
q_circle = zeros(n_points, robot3D.n);
q_circle(:,1) = pi/4 * sin(theta);
q_circle(:,2) = pi/6 * cos(theta);
q_circle(:,3) = pi/8 * sin(2*theta);

% Compute end-effector positions
ee_positions = zeros(n_points, 3);
for i = 1:n_points
    T = robot3D.fkine(q_circle(i,:));
    ee_positions(i,:) = T.t';
end

% Visualize
figure('Name', 'End-Effector Trajectory');

% Plot trajectory in 3D
subplot(1, 2, 1);
plot3(ee_positions(:,1), ee_positions(:,2), ee_positions(:,3), ...
    'b-', 'LineWidth', 2);
hold on;
plot3(ee_positions(1,1), ee_positions(1,2), ee_positions(1,3), ...
    'go', 'MarkerSize', 10, 'LineWidth', 2);
plot3(ee_positions(end,1), ee_positions(end,2), ee_positions(end,3), ...
    'ro', 'MarkerSize', 10, 'LineWidth', 2);
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('End-Effector Trajectory');
legend('Trajectory', 'Start', 'End');
grid on; axis equal;
view(45, 30);

% Plot joint trajectories
subplot(1, 2, 2);
plot(theta, q_circle(:,1), 'r-', 'LineWidth', 2); hold on;
plot(theta, q_circle(:,2), 'g-', 'LineWidth', 2);
plot(theta, q_circle(:,3), 'b-', 'LineWidth', 2);
xlabel('Parameter θ (rad)');
ylabel('Joint angles (rad)');
title('Joint Space Trajectory');
legend('q_1', 'q_2', 'q_3');
grid on;

fprintf('End-effector trajectory computed and visualized\n\n');

%% Example 6: Interactive Visualization (requires user input)
fprintf('6. Interactive Robot Manipulation\n\n');

% Create a simple configuration
q_interactive = [pi/6, pi/4, pi/3];

fprintf('Displaying robot in interactive mode...\n');
fprintf('You can manually adjust the view using MATLAB''s rotation tool.\n\n');

figure('Name', 'Interactive Robot View');
robot3D.plot(q_interactive);
title('Interactive View - Use MATLAB rotation tool to adjust view');

% Enable rotation
rotate3d on;

%% Example 7: Custom Visualization with Configuration Space
fprintf('7. Configuration Space Visualization\n\n');

% For 2-link robot, visualize configuration space
n_grid = 30;
q1_range = linspace(-pi, pi, n_grid);
q2_range = linspace(-pi, pi, n_grid);

[Q1, Q2] = meshgrid(q1_range, q2_range);
EE_X = zeros(n_grid, n_grid);
EE_Y = zeros(n_grid, n_grid);

fprintf('Computing configuration space map...\n');

for i = 1:n_grid
    for j = 1:n_grid
        T = robot2D.fkine([Q1(i,j), Q2(i,j)]);
        EE_X(i,j) = T.t(1);
        EE_Y(i,j) = T.t(2);
    end
end

figure('Name', 'Configuration Space Mapping');

% Configuration space
subplot(1, 2, 1);
contourf(Q1, Q2, sqrt(EE_X.^2 + EE_Y.^2), 20);
xlabel('q_1 (rad)');
ylabel('q_2 (rad)');
title('Configuration Space - End-Effector Distance');
colorbar;
colormap('jet');

% Workspace
subplot(1, 2, 2);
scatter(EE_X(:), EE_Y(:), 10, sqrt(EE_X(:).^2 + EE_Y(:).^2), 'filled');
xlabel('X (m)');
ylabel('Y (m)');
title('Workspace - Reachable Positions');
colorbar;
colormap('jet');
axis equal;
grid on;

fprintf('Configuration space visualization complete\n\n');

%% Example 8: Comparison of Different Robots
fprintf('8. Comparing Different Robot Configurations\n\n');

% Create several robot configurations
configs_compare = [
    0,      0,     0;
    pi/6,   0,     0;
    pi/6,   pi/6,  0;
    pi/6,   pi/6,  pi/6
];

figure('Name', 'Robot Configuration Comparison');
for i = 1:size(configs_compare, 1)
    subplot(2, 2, i);
    robot3D.plot(configs_compare(i,:));
    title(sprintf('Config %d: [%.0f°, %.0f°, %.0f°]', i, ...
        rad2deg(configs_compare(i,1)), ...
        rad2deg(configs_compare(i,2)), ...
        rad2deg(configs_compare(i,3))));
end

fprintf('Configuration comparison complete\n\n');

fprintf('=== Examples Complete ===\n');
fprintf('\nVisualization tips:\n');
fprintf('  - Use rotate3d to interactively rotate 3D plots\n');
fprintf('  - Use zoom to zoom in/out\n');
fprintf('  - Use pan to move the view\n');
fprintf('  - Close figures when done to free memory\n');
