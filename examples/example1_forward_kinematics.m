%% Example 1: Forward Kinematics for 2-Link Robot
% This example demonstrates forward kinematics calculation
% for a 2-link planar robot arm

clear; clc; close all;

% Add src and utils to path
addpath('../src');
addpath('../utils');

% Define robot parameters
L1 = 1.0;  % Length of link 1 (meters)
L2 = 1.0;  % Length of link 2 (meters)

% Define joint angles
theta1 = pi/4;  % 45 degrees
theta2 = pi/3;  % 60 degrees

% Calculate end effector position
x = L1 * cos(theta1) + L2 * cos(theta1 + theta2);
y = L1 * sin(theta1) + L2 * sin(theta1 + theta2);

% Display results
fprintf('=== Forward Kinematics Example ===\n');
fprintf('Link 1 Length: %.2f m\n', L1);
fprintf('Link 2 Length: %.2f m\n', L2);
fprintf('Joint 1 Angle: %.2f deg\n', rad2deg(theta1));
fprintf('Joint 2 Angle: %.2f deg\n', rad2deg(theta2));
fprintf('End Effector Position: (%.3f, %.3f)\n', x, y);

% Visualize the robot
plotRobot2Link(theta1, theta2, L1, L2);
