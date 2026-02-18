%% Trajectory Planning Examples
% This script demonstrates trajectory planning and generation using
% Peter Corke's Robotics Toolbox.
%
% Topics covered:
%   - Joint space trajectory planning
%   - Cartesian space trajectory planning
%   - Quintic polynomial trajectories
%   - Multi-segment trajectories
%   - Trajectory visualization

%% Clear workspace
clear;
clc;
close all;

fprintf('=== Trajectory Planning Examples ===\n\n');

%% Create a robot for trajectory demonstrations
fprintf('Creating a 3-link robot...\n');

% Define DH parameters
L(1) = Link([0, 0, 0.5, pi/2], 'standard');
L(2) = Link([0, 0, 0.5, 0], 'standard');
L(3) = Link([0, 0, 0.3, 0], 'standard');

% Create robot
robot = SerialLink(L, 'name', '3-Link Robot');

fprintf('Robot created with %d joints\n\n', robot.n);

%% Example 1: Simple Joint Space Trajectory
fprintf('1. Simple Joint Space Trajectory\n');

% Define start and end configurations
q_start = [0, 0, 0];
q_end = [pi/2, pi/3, pi/4];

% Time parameters
t_total = 2.0;  % Total time in seconds
dt = 0.05;      % Time step
t = 0:dt:t_total;
n_steps = length(t);

fprintf('Start configuration: q0 = [%.2f, %.2f, %.2f] rad\n', ...
    q_start(1), q_start(2), q_start(3));
fprintf('End configuration: qf = [%.2f, %.2f, %.2f] rad\n', ...
    q_end(1), q_end(2), q_end(3));
fprintf('Duration: %.2f seconds, Time step: %.3f seconds\n', t_total, dt);
fprintf('Number of steps: %d\n\n', n_steps);

% Generate trajectory using jtraj (quintic polynomial)
try
    q_traj = jtraj(q_start, q_end, t);
    
    fprintf('Trajectory generated successfully!\n');
    fprintf('Trajectory shape: %d x %d (steps x joints)\n\n', size(q_traj,1), size(q_traj,2));
    
    % Plot joint trajectories
    figure('Name', 'Joint Space Trajectory');
    for i = 1:robot.n
        subplot(robot.n, 1, i);
        plot(t, q_traj(:,i), 'LineWidth', 2);
        ylabel(sprintf('q_%d (rad)', i));
        grid on;
        if i == 1
            title('Joint Trajectories vs Time');
        end
        if i == robot.n
            xlabel('Time (s)');
        end
    end
    
    % Animate the trajectory
    fprintf('Animating trajectory...\n');
    figure('Name', 'Trajectory Animation');
    robot.plot(q_traj, 'fps', 30, 'trail', 'r-');
    
catch ME
    fprintf('Trajectory generation failed: %s\n\n', ME.message);
end

%% Example 2: Trajectory with Velocity and Acceleration
fprintf('2. Analyzing Trajectory Velocities and Accelerations\n');

try
    % Generate trajectory with velocity and acceleration
    [q_traj, qd_traj, qdd_traj] = jtraj(q_start, q_end, t);
    
    fprintf('Generated position, velocity, and acceleration profiles\n\n');
    
    % Plot comprehensive trajectory information
    figure('Name', 'Complete Trajectory Profile');
    
    for i = 1:robot.n
        % Position
        subplot(3, robot.n, i);
        plot(t, q_traj(:,i), 'b-', 'LineWidth', 2);
        ylabel(sprintf('q_%d', i));
        grid on;
        if i == 1
            title('Position');
        end
        
        % Velocity
        subplot(3, robot.n, i + robot.n);
        plot(t, qd_traj(:,i), 'r-', 'LineWidth', 2);
        ylabel(sprintf('q''_%d', i));
        grid on;
        if i == 1
            title('Velocity');
        end
        
        % Acceleration
        subplot(3, robot.n, i + 2*robot.n);
        plot(t, qdd_traj(:,i), 'g-', 'LineWidth', 2);
        ylabel(sprintf('q"_%d', i));
        xlabel('Time (s)');
        grid on;
        if i == 1
            title('Acceleration');
        end
    end
    
catch ME
    fprintf('Velocity/acceleration analysis failed: %s\n\n', ME.message);
end

%% Example 3: Multi-waypoint Trajectory
fprintf('3. Multi-waypoint Trajectory\n');

% Define multiple waypoints
waypoints = [
    0,     0,     0;
    pi/4,  pi/6,  pi/6;
    pi/2,  pi/3,  pi/4;
    pi/4,  pi/2,  0;
    0,     0,     0
];

fprintf('Number of waypoints: %d\n\n', size(waypoints, 1));

% Time for each segment
segment_time = 1.5;
dt_multi = 0.05;

% Generate multi-segment trajectory
q_multi = [];
for i = 1:size(waypoints, 1)-1
    t_seg = 0:dt_multi:segment_time;
    q_seg = jtraj(waypoints(i,:), waypoints(i+1,:), t_seg);
    q_multi = [q_multi; q_seg];
end

fprintf('Total trajectory points: %d\n', size(q_multi, 1));
fprintf('Total duration: %.2f seconds\n\n', size(q_multi,1) * dt_multi);

% Plot multi-waypoint trajectory
t_multi = (0:size(q_multi,1)-1) * dt_multi;

figure('Name', 'Multi-waypoint Trajectory');
for i = 1:robot.n
    subplot(robot.n, 1, i);
    plot(t_multi, q_multi(:,i), 'LineWidth', 2);
    hold on;
    % Mark waypoints
    waypoint_times = (0:size(waypoints,1)-1) * segment_time / dt_multi * dt_multi;
    plot(waypoint_times, waypoints(:,i), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
    ylabel(sprintf('q_%d (rad)', i));
    grid on;
    legend('Trajectory', 'Waypoints');
    if i == 1
        title('Multi-waypoint Joint Trajectories');
    end
    if i == robot.n
        xlabel('Time (s)');
    end
end

%% Example 4: Cartesian Space Trajectory
fprintf('4. Cartesian Space Trajectory\n');

% Define start and end positions in Cartesian space
p_start = [0.8, 0.0, 0.2];
p_end = [0.6, 0.3, 0.4];

fprintf('Start position: [%.2f, %.2f, %.2f] m\n', p_start(1), p_start(2), p_start(3));
fprintf('End position: [%.2f, %.2f, %.2f] m\n\n', p_end(1), p_end(2), p_end(3));

% Generate Cartesian trajectory
t_cart = 0:0.05:2.0;
n_cart = length(t_cart);

% Linear interpolation in Cartesian space
p_traj = zeros(n_cart, 3);
for i = 1:n_cart
    s = (i-1) / (n_cart-1);  % Interpolation parameter [0, 1]
    p_traj(i,:) = (1-s) * p_start + s * p_end;
end

fprintf('Generated %d Cartesian waypoints\n', n_cart);

% Convert to joint space using IK
q_cart_traj = zeros(n_cart, robot.n);
q_prev = [0, 0, 0];  % Initial guess

fprintf('Converting Cartesian trajectory to joint space...\n');
for i = 1:n_cart
    T_target = transl(p_traj(i,:));
    try
        q_cart_traj(i,:) = robot.ikine(T_target, q_prev, 'mask', [1 1 1 0 0 0]);
        q_prev = q_cart_traj(i,:);  % Use previous solution as next guess
    catch
        fprintf('  IK failed at step %d\n', i);
        q_cart_traj(i,:) = q_prev;
    end
end

fprintf('Cartesian trajectory conversion complete\n\n');

% Plot Cartesian trajectory
figure('Name', 'Cartesian Trajectory');
subplot(2,1,1);
plot3(p_traj(:,1), p_traj(:,2), p_traj(:,3), 'b-', 'LineWidth', 2);
hold on;
plot3(p_start(1), p_start(2), p_start(3), 'go', 'MarkerSize', 10, 'LineWidth', 2);
plot3(p_end(1), p_end(2), p_end(3), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('Cartesian Space Trajectory');
legend('Trajectory', 'Start', 'End');
grid on; axis equal;

subplot(2,1,2);
for i = 1:robot.n
    plot(t_cart, q_cart_traj(:,i), 'LineWidth', 2);
    hold on;
end
xlabel('Time (s)');
ylabel('Joint angles (rad)');
title('Joint Space Trajectory (from Cartesian)');
legend('q_1', 'q_2', 'q_3');
grid on;

%% Example 5: Trajectory Timing Analysis
fprintf('5. Trajectory Timing and Performance\n');

% Compare different trajectory durations
durations = [0.5, 1.0, 2.0, 4.0];

fprintf('Comparing trajectories with different durations:\n');

figure('Name', 'Trajectory Duration Comparison');

for idx = 1:length(durations)
    t_dur = 0:0.02:durations(idx);
    q_dur = jtraj(q_start, q_end, t_dur);
    
    % Compute approximate velocities
    qd_approx = diff(q_dur) / 0.02;
    
    % Max velocity for each joint
    max_vel = max(abs(qd_approx), [], 1);
    
    fprintf('  Duration %.1f s: Max velocities = [%.2f, %.2f, %.2f] rad/s\n', ...
        durations(idx), max_vel(1), max_vel(2), max_vel(3));
    
    subplot(2, 2, idx);
    plot(t_dur, q_dur, 'LineWidth', 2);
    xlabel('Time (s)');
    ylabel('Joint angles (rad)');
    title(sprintf('Duration: %.1f s', durations(idx)));
    legend('q_1', 'q_2', 'q_3');
    grid on;
end

fprintf('\n=== Examples Complete ===\n');
