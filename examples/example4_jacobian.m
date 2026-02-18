%% Example 4: Jacobian Matrix and Velocity Analysis
% This example demonstrates Jacobian matrix calculation
% and velocity analysis for a 2-link planar robot arm

clear; clc; close all;

% Add src and utils to path
addpath('../src');
addpath('../utils');

% Define robot parameters
L1 = 1.0;  % Length of link 1 (meters)
L2 = 1.0;  % Length of link 2 (meters)

% Define joint angles
theta1 = pi/6;  % 30 degrees
theta2 = pi/4;  % 45 degrees

% Define joint velocities (rad/s)
omega1 = 0.5;
omega2 = 0.3;

% Calculate Jacobian matrix
J = JacobianMatrix(theta1, theta2, L1, L2);

% Display Jacobian
fprintf('=== Jacobian Matrix Example ===\n');
fprintf('Joint Configuration:\n');
fprintf('  theta1 = %.2f deg\n', rad2deg(theta1));
fprintf('  theta2 = %.2f deg\n', rad2deg(theta2));
fprintf('\nJacobian Matrix:\n');
disp(J);

% Calculate end effector velocity
omega = [omega1; omega2];
v = J * omega;

fprintf('Joint Velocities:\n');
fprintf('  omega1 = %.3f rad/s\n', omega1);
fprintf('  omega2 = %.3f rad/s\n', omega2);
fprintf('\nEnd Effector Velocity:\n');
fprintf('  vx = %.3f m/s\n', v(1));
fprintf('  vy = %.3f m/s\n', v(2));
fprintf('  Speed = %.3f m/s\n', norm(v));

% Check manipulability
manipulability = sqrt(det(J * J'));
fprintf('\nManipulability Index: %.4f\n', manipulability);

if manipulability < 0.01
    fprintf('Warning: Robot is near a singularity!\n');
else
    fprintf('Robot configuration is well-conditioned.\n');
end

% Visualize robot and velocity
figure;
plotRobot2Link(theta1, theta2, L1, L2);

% Calculate end effector position
x = L1 * cos(theta1) + L2 * cos(theta1 + theta2);
y = L1 * sin(theta1) + L2 * sin(theta1 + theta2);

% Draw velocity vector
quiver(x, y, v(1), v(2), 0.5, 'g', 'LineWidth', 2, 'MaxHeadSize', 0.5);
legend('Link 1', 'Link 2', 'Base', 'Joint 1', 'End Effector', 'Velocity');
title('Robot Configuration with Velocity Vector');
