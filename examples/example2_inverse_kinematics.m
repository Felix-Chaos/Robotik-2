%% Example 2: Inverse Kinematics for 2-Link Robot
% This example demonstrates inverse kinematics calculation
% for a 2-link planar robot arm

clear; clc; close all;

% Add src and utils to path
addpath('../src');
addpath('../utils');

% Define robot parameters
L1 = 1.0;  % Length of link 1 (meters)
L2 = 1.0;  % Length of link 2 (meters)

% Define target position
x_target = 1.5;
y_target = 0.5;

% Calculate inverse kinematics
try
    [theta1, theta2] = InverseKinematics2Link(x_target, y_target, L1, L2);
    
    % Display results
    fprintf('=== Inverse Kinematics Example ===\n');
    fprintf('Target Position: (%.3f, %.3f)\n', x_target, y_target);
    fprintf('Joint 1 Angle: %.2f deg\n', rad2deg(theta1));
    fprintf('Joint 2 Angle: %.2f deg\n', rad2deg(theta2));
    
    % Verify solution
    x_check = L1 * cos(theta1) + L2 * cos(theta1 + theta2);
    y_check = L1 * sin(theta1) + L2 * sin(theta1 + theta2);
    fprintf('Achieved Position: (%.3f, %.3f)\n', x_check, y_check);
    fprintf('Position Error: %.6f m\n', sqrt((x_check-x_target)^2 + (y_check-y_target)^2));
    
    % Visualize the robot
    plotRobot2Link(theta1, theta2, L1, L2);
    plot(x_target, y_target, 'mx', 'MarkerSize', 15, 'LineWidth', 3);
    legend('Link 1', 'Link 2', 'Base', 'Joint 1', 'End Effector', 'Target');
    
catch ME
    fprintf('Error: %s\n', ME.message);
end
