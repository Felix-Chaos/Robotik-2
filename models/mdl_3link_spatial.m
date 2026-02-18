function robot = mdl_3link_spatial()
%MDL_3LINK_SPATIAL Create a 3-link spatial manipulator
%
% ROBOT = MDL_3LINK_SPATIAL() creates a SerialLink object representing
% a 3-DOF spatial manipulator with revolute joints.
%
% This is a custom robot model for educational purposes.
%
% Robot specifications:
%   - 3 revolute joints
%   - Link 1: 0.5m length, 90° twist
%   - Link 2: 0.5m length, 0° twist  
%   - Link 3: 0.3m length, 0° twist
%   - Total reach: ~1.3m
%
% Example:
%   robot = mdl_3link_spatial();
%   robot.plot([0, pi/4, pi/6]);

% Define DH parameters [theta, d, a, alpha] in standard convention
% Joint 1: Base rotation
L(1) = Link([0, 0, 0.5, pi/2], 'standard');
L(1).m = 2.0;              % Mass (kg)
L(1).r = [0.25, 0, 0];     % Center of mass
L(1).I = [0.01, 0.05, 0.05, 0, 0, 0];  % Inertia tensor
L(1).Jm = 0.001;           % Motor inertia
L(1).G = 100;              % Gear ratio
L(1).B = 0.001;            % Viscous friction
L(1).Tc = [0.5, -0.5];     % Coulomb friction

% Joint 2: Shoulder
L(2) = Link([0, 0, 0.5, 0], 'standard');
L(2).m = 1.5;
L(2).r = [0.25, 0, 0];
L(2).I = [0.01, 0.04, 0.04, 0, 0, 0];
L(2).Jm = 0.001;
L(2).G = 100;
L(2).B = 0.001;
L(2).Tc = [0.4, -0.4];

% Joint 3: Elbow
L(3) = Link([0, 0, 0.3, 0], 'standard');
L(3).m = 1.0;
L(3).r = [0.15, 0, 0];
L(3).I = [0.005, 0.02, 0.02, 0, 0, 0];
L(3).Jm = 0.0005;
L(3).G = 50;
L(3).B = 0.0005;
L(3).Tc = [0.3, -0.3];

% Set joint limits
L(1).qlim = [-pi, pi];
L(2).qlim = [-pi/2, pi/2];
L(3).qlim = [-pi/2, pi/2];

% Create the robot
robot = SerialLink(L, 'name', '3-Link Spatial', 'manufacturer', 'Custom');

% Define useful configurations
robot.qz = [0, 0, 0];           % Zero position
robot.qr = [0, pi/4, pi/4];     % Ready position
robot.qn = [0, 0, pi/2];        % Nominal position

% Add tool transform (if needed)
% robot.tool = transl(0, 0, 0.1);  % 10cm tool

% Display information
fprintf('Created 3-Link Spatial Manipulator\n');
fprintf('  Joints: %d\n', robot.n);
fprintf('  Max reach: ~%.2fm\n', sum([L.a]));

end
