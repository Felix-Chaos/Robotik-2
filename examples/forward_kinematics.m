%% Forward Kinematics Examples
% This script demonstrates forward kinematics calculations using
% Peter Corke's Robotics Toolbox.
%
% Topics covered:
%   - Computing end-effector pose from joint angles
%   - Working with homogeneous transformations
%   - Extracting position and orientation
%   - Jacobian calculation

%% Clear workspace
clear;
clc;
close all;

fprintf('=== Forward Kinematics Examples ===\n\n');

%% Create a simple 3-link robot
fprintf('Creating a 3-link robot...\n');

% Define DH parameters
% Link([theta, d, a, alpha])
L(1) = Link([0, 0, 0.5, pi/2], 'standard');
L(2) = Link([0, 0, 0.5, 0], 'standard');
L(3) = Link([0, 0, 0.3, 0], 'standard');

% Create robot
robot = SerialLink(L, 'name', '3-Link Robot');

fprintf('Robot created with %d joints\n\n', robot.n);

%% Example 1: Basic Forward Kinematics
fprintf('1. Basic Forward Kinematics\n');

% Define joint configuration
q1 = [0, 0, 0];  % All joints at zero

% Compute forward kinematics
T1 = robot.fkine(q1);

fprintf('Joint angles: q = [%.2f, %.2f, %.2f] rad\n', q1(1), q1(2), q1(3));
fprintf('End-effector position:\n');
fprintf('  x = %.3f m\n', T1.t(1));
fprintf('  y = %.3f m\n', T1.t(2));
fprintf('  z = %.3f m\n\n', T1.t(3));

% Visualize
figure('Name', 'Forward Kinematics - Configuration 1');
robot.plot(q1);
title('Configuration 1: All joints at 0°');

%% Example 2: Different Joint Configuration
fprintf('2. Different Joint Configuration\n');

% Different joint configuration
q2 = [pi/4, pi/3, pi/6];  % 45°, 60°, 30°

% Compute forward kinematics
T2 = robot.fkine(q2);

fprintf('Joint angles: q = [%.2f, %.2f, %.2f] rad\n', q2(1), q2(2), q2(3));
fprintf('Joint angles: q = [%.1f°, %.1f°, %.1f°]\n', ...
    rad2deg(q2(1)), rad2deg(q2(2)), rad2deg(q2(3)));
fprintf('End-effector position:\n');
fprintf('  x = %.3f m\n', T2.t(1));
fprintf('  y = %.3f m\n', T2.t(2));
fprintf('  z = %.3f m\n\n', T2.t(3));

% Visualize
figure('Name', 'Forward Kinematics - Configuration 2');
robot.plot(q2);
title('Configuration 2: q = [45°, 60°, 30°]');

%% Example 3: Homogeneous Transformation Matrix
fprintf('3. Homogeneous Transformation Matrix\n');

% Get full transformation matrix
T3 = robot.fkine(q2);

fprintf('Complete 4x4 transformation matrix:\n');
disp(T3);

% Extract rotation matrix
R = T3.R;
fprintf('Rotation matrix (3x3):\n');
disp(R);

% Extract position vector
p = T3.t;
fprintf('Position vector:\n');
fprintf('  [%.3f, %.3f, %.3f]''\n\n', p(1), p(2), p(3));

%% Example 4: Multiple Configurations
fprintf('4. Computing FK for Multiple Configurations\n');

% Define multiple configurations
n_configs = 5;
q_multiple = zeros(n_configs, robot.n);
for i = 1:n_configs
    q_multiple(i,:) = [0, (i-1)*pi/8, 0];
end

fprintf('Computing FK for %d configurations...\n', n_configs);
for i = 1:n_configs
    T_temp = robot.fkine(q_multiple(i,:));
    fprintf('Config %d: q2=%.2f° -> x=%.3f, y=%.3f, z=%.3f\n', ...
        i, rad2deg(q_multiple(i,2)), T_temp.t(1), T_temp.t(2), T_temp.t(3));
end
fprintf('\n');

%% Example 5: Jacobian Matrix
fprintf('5. Jacobian Matrix\n');

% Compute Jacobian at current configuration
J = robot.jacob0(q2);

fprintf('Jacobian matrix at q = [%.2f, %.2f, %.2f]:\n', q2(1), q2(2), q2(3));
fprintf('Size: %dx%d\n', size(J,1), size(J,2));
fprintf('This relates joint velocities to end-effector velocity\n\n');

fprintf('Jacobian matrix:\n');
disp(J);

%% Example 6: Workspace Visualization
fprintf('6. Workspace Visualization\n');

% Generate random configurations to visualize workspace
n_samples = 100;
workspace_points = zeros(n_samples, 3);

for i = 1:n_samples
    % Random joint configuration
    q_rand = [rand()*2*pi - pi, rand()*pi - pi/2, rand()*pi - pi/2];
    T_rand = robot.fkine(q_rand);
    workspace_points(i,:) = T_rand.t';
end

figure('Name', 'Robot Workspace');
scatter3(workspace_points(:,1), workspace_points(:,2), workspace_points(:,3), 10, 'filled');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('Robot Workspace (Random Sampling)');
grid on; axis equal;

fprintf('Generated %d random poses to visualize workspace\n\n', n_samples);

fprintf('=== Examples Complete ===\n');
