%% Inverse Kinematics Examples
% This script demonstrates inverse kinematics calculations using
% Peter Corke's Robotics Toolbox.
%
% Topics covered:
%   - Numerical inverse kinematics
%   - Solving for joint angles given end-effector pose
%   - Handling multiple solutions
%   - Dealing with singularities

%% Clear workspace
clear;
clc;
close all;

fprintf('=== Inverse Kinematics Examples ===\n\n');

%% Create a robot for IK demonstrations
fprintf('Creating a 3-link robot...\n');

% Define DH parameters
L(1) = Link([0, 0, 0.5, pi/2], 'standard');
L(2) = Link([0, 0, 0.5, 0], 'standard');
L(3) = Link([0, 0, 0.3, 0], 'standard');

% Create robot
robot = SerialLink(L, 'name', '3-Link Robot');

fprintf('Robot created with %d joints\n\n', robot.n);

%% Example 1: Basic Inverse Kinematics
fprintf('1. Basic Inverse Kinematics\n');

% Define a desired end-effector position
desired_position = [0.8, 0.2, 0.3];

% Create a transformation matrix for the desired pose
% Using identity rotation (no rotation, just position)
T_desired = transl(desired_position);

fprintf('Desired end-effector position: [%.2f, %.2f, %.2f]\n', ...
    desired_position(1), desired_position(2), desired_position(3));

% Solve inverse kinematics (numerical solution)
try
    q_ik = robot.ikine(T_desired, 'mask', [1 1 1 0 0 0]);
    
    fprintf('IK solution found: q = [%.3f, %.3f, %.3f] rad\n', q_ik(1), q_ik(2), q_ik(3));
    fprintf('IK solution found: q = [%.1f°, %.1f°, %.1f°]\n\n', ...
        rad2deg(q_ik(1)), rad2deg(q_ik(2)), rad2deg(q_ik(3)));
    
    % Verify the solution with forward kinematics
    T_verify = robot.fkine(q_ik);
    achieved_position = T_verify.t;
    
    fprintf('Verification (FK on IK solution):\n');
    fprintf('  Achieved position: [%.3f, %.3f, %.3f]\n', ...
        achieved_position(1), achieved_position(2), achieved_position(3));
    fprintf('  Position error: %.6f m\n\n', ...
        norm(achieved_position - desired_position'));
    
    % Visualize the solution
    figure('Name', 'Inverse Kinematics - Solution');
    robot.plot(q_ik);
    title(sprintf('IK Solution for target [%.2f, %.2f, %.2f]', ...
        desired_position(1), desired_position(2), desired_position(3)));
    
catch ME
    fprintf('IK failed: %s\n', ME.message);
    fprintf('This might require the full Robotics Toolbox.\n\n');
end

%% Example 2: IK with Initial Guess
fprintf('2. IK with Initial Guess\n');

% Sometimes providing an initial guess helps find a better solution
q_initial = [0, pi/4, 0];
fprintf('Using initial guess: q0 = [%.3f, %.3f, %.3f] rad\n', ...
    q_initial(1), q_initial(2), q_initial(3));

try
    q_ik2 = robot.ikine(T_desired, q_initial, 'mask', [1 1 1 0 0 0]);
    
    fprintf('IK solution: q = [%.3f, %.3f, %.3f] rad\n\n', ...
        q_ik2(1), q_ik2(2), q_ik2(3));
    
catch ME
    fprintf('IK with initial guess failed: %s\n\n', ME.message);
end

%% Example 3: Multiple Target Positions
fprintf('3. Computing IK for Multiple Target Positions\n');

% Define multiple target positions
n_targets = 5;
targets = [
    0.6, 0.2, 0.2;
    0.7, 0.1, 0.3;
    0.5, 0.3, 0.1;
    0.8, 0.0, 0.2;
    0.6, 0.3, 0.3
];

fprintf('Computing IK for %d target positions...\n', n_targets);

solutions = zeros(n_targets, robot.n);
errors = zeros(n_targets, 1);

for i = 1:n_targets
    try
        T_target = transl(targets(i,:));
        q_sol = robot.ikine(T_target, 'mask', [1 1 1 0 0 0]);
        solutions(i,:) = q_sol;
        
        % Verify
        T_check = robot.fkine(q_sol);
        errors(i) = norm(T_check.t - targets(i,:)');
        
        fprintf('  Target %d: [%.2f, %.2f, %.2f] -> Error: %.6f m\n', ...
            i, targets(i,1), targets(i,2), targets(i,3), errors(i));
    catch
        fprintf('  Target %d: Failed to find solution\n', i);
    end
end
fprintf('\n');

%% Example 4: IK with Full Pose (Position + Orientation)
fprintf('4. IK with Full Pose Specification\n');

% Define a target pose with both position and orientation
target_pos = [0.7, 0.2, 0.3];
target_rot = rpy2r(30, 0, 45, 'deg');  % Roll-Pitch-Yaw to rotation matrix
T_full = rt2tr(target_rot, target_pos);

fprintf('Target position: [%.2f, %.2f, %.2f]\n', target_pos(1), target_pos(2), target_pos(3));
fprintf('Target orientation: RPY = [30°, 0°, 45°]\n');

try
    % Use full 6-DOF mask (position + orientation)
    q_full = robot.ikine(T_full, 'mask', [1 1 1 1 1 1]);
    
    fprintf('IK solution: q = [%.3f, %.3f, %.3f] rad\n\n', ...
        q_full(1), q_full(2), q_full(3));
    
    % Note: For a 3-DOF robot, full 6-DOF pose may not be achievable
    fprintf('Note: 3-DOF robot cannot achieve arbitrary 6-DOF poses.\n');
    fprintf('Solution may be approximate.\n\n');
    
catch ME
    fprintf('Full-pose IK not possible with 3-DOF robot.\n');
    fprintf('Error: %s\n\n', ME.message);
end

%% Example 5: Reachability Check
fprintf('5. Checking Workspace Reachability\n');

% Test if various points are reachable
test_points = [
    0.5, 0.0, 0.0;   % Likely reachable
    1.5, 0.0, 0.0;   % Likely too far
    0.3, 0.3, 0.0;   % Likely reachable
    2.0, 2.0, 2.0;   % Definitely too far
];

fprintf('Testing reachability of %d points...\n', size(test_points, 1));

for i = 1:size(test_points, 1)
    T_test = transl(test_points(i,:));
    try
        q_test = robot.ikine(T_test, 'mask', [1 1 1 0 0 0]);
        
        % Check if solution is valid
        if ~isempty(q_test) && ~any(isnan(q_test))
            T_achieved = robot.fkine(q_test);
            error_dist = norm(T_achieved.t - test_points(i,:)');
            
            if error_dist < 0.01  % 1cm threshold
                fprintf('  Point %d [%.2f, %.2f, %.2f]: ✓ REACHABLE (error: %.4f m)\n', ...
                    i, test_points(i,1), test_points(i,2), test_points(i,3), error_dist);
            else
                fprintf('  Point %d [%.2f, %.2f, %.2f]: ✗ NOT REACHABLE (error: %.4f m)\n', ...
                    i, test_points(i,1), test_points(i,2), test_points(i,3), error_dist);
            end
        else
            fprintf('  Point %d [%.2f, %.2f, %.2f]: ✗ NO SOLUTION FOUND\n', ...
                i, test_points(i,1), test_points(i,2), test_points(i,3));
        end
    catch
        fprintf('  Point %d [%.2f, %.2f, %.2f]: ✗ IK FAILED\n', ...
            i, test_points(i,1), test_points(i,2), test_points(i,3));
    end
end

fprintf('\n=== Examples Complete ===\n');
