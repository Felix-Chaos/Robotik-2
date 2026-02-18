function robot = createCustomRobot(dh_params, robot_name)
%CREATECUSTOMROBOT Create a custom robot from DH parameters
%
% ROBOT = CREATECUSTOMROBOT(DH_PARAMS, ROBOT_NAME) creates a SerialLink
% robot from Denavit-Hartenberg parameters.
%
% Inputs:
%   DH_PARAMS  - Nx4 matrix where each row is [theta, d, a, alpha]
%                in standard DH convention
%   ROBOT_NAME - String name for the robot (optional)
%
% Output:
%   ROBOT - SerialLink object
%
% DH Parameters:
%   theta - Joint angle (for revolute joints, this is the variable)
%   d     - Link offset (distance along previous z to common normal)
%   a     - Link length (length of common normal)
%   alpha - Link twist (angle about common normal from old z to new z)
%
% Example 1: 2-link planar robot
%   dh = [0, 0, 1.0, 0;
%         0, 0, 0.8, 0];
%   robot = createCustomRobot(dh, '2-Link Planar');
%
% Example 2: 3-link spatial robot
%   dh = [0, 0,   0.5, pi/2;
%         0, 0,   0.5, 0;
%         0, 0.2, 0.3, 0];
%   robot = createCustomRobot(dh, '3-Link Spatial');

% Check inputs
if nargin < 1
    error('DH parameters are required');
end

if nargin < 2
    robot_name = 'Custom Robot';
end

% Validate DH parameters
if size(dh_params, 2) ~= 4
    error('DH parameters must be Nx4 matrix [theta, d, a, alpha]');
end

n_joints = size(dh_params, 1);

fprintf('Creating %d-DOF robot: %s\n', n_joints, robot_name);

% Create links
L = Link.empty(n_joints, 0);

for i = 1:n_joints
    % Extract parameters
    theta = dh_params(i, 1);
    d = dh_params(i, 2);
    a = dh_params(i, 3);
    alpha = dh_params(i, 4);
    
    % Create link (assuming revolute joint - theta is variable)
    L(i) = Link([theta, d, a, alpha], 'standard');
    
    % Set default joint limits
    L(i).qlim = [-pi, pi];
    
    fprintf('  Link %d: θ=%.3f, d=%.3f, a=%.3f, α=%.3f (%.1f°)\n', ...
        i, theta, d, a, alpha, rad2deg(alpha));
end

% Create robot
robot = SerialLink(L, 'name', robot_name);

fprintf('Robot created successfully!\n');
fprintf('  Name: %s\n', robot.name);
fprintf('  DOF: %d\n', robot.n);

% Display summary
fprintf('\nRobot summary:\n');
display(robot);

end
