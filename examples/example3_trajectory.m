%% Example 3: Trajectory Following
% This example demonstrates trajectory generation and following
% for a 2-link planar robot arm

clear; clc; close all;

% Add src and utils to path
addpath('../src');
addpath('../utils');

% Define robot parameters
L1 = 1.0;  % Length of link 1 (meters)
L2 = 1.0;  % Length of link 2 (meters)

% Define start and end positions
startPos = [1.0, 1.0];
endPos = [1.5, 0.5];

% Generate trajectory
numPoints = 50;
trajectory = generateTrajectory(startPos, endPos, numPoints);

% Calculate joint angles for each point
theta1_trajectory = zeros(numPoints, 1);
theta2_trajectory = zeros(numPoints, 1);

fprintf('=== Trajectory Following Example ===\n');
fprintf('Computing trajectory with %d points...\n', numPoints);

for i = 1:numPoints
    try
        [theta1_trajectory(i), theta2_trajectory(i)] = ...
            InverseKinematics2Link(trajectory(i,1), trajectory(i,2), L1, L2);
    catch
        fprintf('Warning: Point %d is unreachable\n', i);
        theta1_trajectory(i) = NaN;
        theta2_trajectory(i) = NaN;
    end
end

% Plot trajectory
figure;
subplot(2, 2, 1);
plot(trajectory(:,1), trajectory(:,2), 'b-', 'LineWidth', 2);
hold on;
plot(startPos(1), startPos(2), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
plot(endPos(1), endPos(2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
grid on;
xlabel('X Position (m)');
ylabel('Y Position (m)');
title('Cartesian Trajectory');
legend('Trajectory', 'Start', 'End');
axis equal;

% Plot joint angles
subplot(2, 2, 2);
plot(1:numPoints, rad2deg(theta1_trajectory), 'b-', 'LineWidth', 2);
hold on;
plot(1:numPoints, rad2deg(theta2_trajectory), 'r-', 'LineWidth', 2);
grid on;
xlabel('Time Step');
ylabel('Joint Angle (degrees)');
title('Joint Angles vs Time');
legend('Joint 1', 'Joint 2');

% Plot joint velocities (numerical derivative)
subplot(2, 2, 3);
dt = 0.1;  % Time step
omega1 = [0; diff(theta1_trajectory)/dt];
omega2 = [0; diff(theta2_trajectory)/dt];
plot(1:numPoints, rad2deg(omega1), 'b-', 'LineWidth', 2);
hold on;
plot(1:numPoints, rad2deg(omega2), 'r-', 'LineWidth', 2);
grid on;
xlabel('Time Step');
ylabel('Joint Velocity (deg/s)');
title('Joint Velocities vs Time');
legend('Joint 1', 'Joint 2');

% Animate robot motion
subplot(2, 2, 4);
hold on;
grid on;
xlabel('X Position (m)');
ylabel('Y Position (m)');
title('Robot Animation');
axis equal;
maxReach = L1 + L2;
xlim([-maxReach*0.2, maxReach*1.2]);
ylim([-maxReach*0.2, maxReach*1.2]);

% Plot trajectory path
plot(trajectory(:,1), trajectory(:,2), 'b--', 'LineWidth', 1);

fprintf('Animating robot motion...\n');
for i = 1:5:numPoints
    if ~isnan(theta1_trajectory(i))
        % Calculate positions
        x0 = 0; y0 = 0;
        x1 = L1 * cos(theta1_trajectory(i));
        y1 = L1 * sin(theta1_trajectory(i));
        x2 = x1 + L2 * cos(theta1_trajectory(i) + theta2_trajectory(i));
        y2 = y1 + L2 * sin(theta1_trajectory(i) + theta2_trajectory(i));
        
        % Clear previous robot
        cla;
        plot(trajectory(:,1), trajectory(:,2), 'b--', 'LineWidth', 1);
        
        % Plot robot
        plot([x0 x1], [y0 y1], 'b-', 'LineWidth', 3);
        plot([x1 x2], [y1 y2], 'r-', 'LineWidth', 3);
        plot(x0, y0, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
        plot(x1, y1, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
        plot(x2, y2, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
        
        axis equal;
        xlim([-maxReach*0.2, maxReach*1.2]);
        ylim([-maxReach*0.2, maxReach*1.2]);
        
        drawnow;
        pause(0.05);
    end
end

fprintf('Animation complete!\n');
