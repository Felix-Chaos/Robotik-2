%% Basic Robot Demonstration
% This script demonstrates basic robot creation and manipulation using
% Peter Corke's Robotics Toolbox.
%
% Topics covered:
%   - Creating a simple 2-link planar robot
%   - Creating standard industrial robots (Puma 560, UR5)
%   - Basic joint configuration
%   - Forward kinematics
%   - Plotting the robot

%% Clear workspace
clear;
clc;
close all;

fprintf('=== Basic Robot Demonstration ===\n\n');

%% Example 1: Create a Simple 2-Link Planar Robot
fprintf('1. Creating a simple 2-link planar robot...\n');

% Define DH parameters for 2-link planar robot
% Link(theta, d, a, alpha)
L1 = Link([0, 0, 1, 0], 'standard');
L2 = Link([0, 0, 1, 0], 'standard');

% Set joint limits (optional)
L1.qlim = [-pi, pi];
L2.qlim = [-pi, pi];

% Create the robot
planar_robot = SerialLink([L1, L2], 'name', '2-Link Planar');

% Display robot information
fprintf('Robot created: %s\n', planar_robot.name);
fprintf('Number of joints: %d\n', planar_robot.n);
fprintf('\n');

% Define a joint configuration
q = [pi/4, pi/3];  % Joint angles in radians

% Compute forward kinematics
T = planar_robot.fkine(q);
fprintf('Joint configuration: q = [%.2f, %.2f] rad\n', q(1), q(2));
fprintf('End-effector position:\n');
fprintf('  x = %.3f\n', T.t(1));
fprintf('  y = %.3f\n', T.t(2));
fprintf('  z = %.3f\n\n', T.t(3));

% Plot the robot
figure('Name', '2-Link Planar Robot');
planar_robot.plot(q);
title('2-Link Planar Robot Configuration');

%% Example 2: Create a Puma 560 Robot (if available)
fprintf('2. Attempting to create a Puma 560 robot...\n');

try
    % Create Puma 560 robot model
    puma = mdl_puma560();
    
    fprintf('Puma 560 robot loaded successfully!\n');
    fprintf('Number of joints: %d\n\n', puma.n);
    
    % Define a joint configuration (home position)
    q_home = [0, 0, 0, 0, 0, 0];
    
    % Plot the robot
    figure('Name', 'Puma 560 Robot');
    puma.plot(q_home);
    title('Puma 560 Robot - Home Configuration');
    
catch ME
    fprintf('Could not load Puma 560 model.\n');
    fprintf('This requires the full Robotics Toolbox to be installed.\n');
    fprintf('Error: %s\n\n', ME.message);
end

%% Example 3: Create a UR5 Robot (if available)
fprintf('3. Attempting to create a UR5 robot...\n');

try
    % Create UR5 robot model
    ur5 = mdl_ur5();
    
    fprintf('UR5 robot loaded successfully!\n');
    fprintf('Number of joints: %d\n\n', ur5.n);
    
    % Define a joint configuration
    q_ur5 = [0, -pi/4, pi/2, -pi/4, -pi/2, 0];
    
    % Plot the robot
    figure('Name', 'UR5 Robot');
    ur5.plot(q_ur5);
    title('UR5 Robot Configuration');
    
catch ME
    fprintf('Could not load UR5 model.\n');
    fprintf('This requires the full Robotics Toolbox to be installed.\n');
    fprintf('Error: %s\n\n', ME.message);
end

fprintf('=== Demonstration Complete ===\n');
