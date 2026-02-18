function robot = mdl_2link_planar()
%MDL_2LINK_PLANAR Create a 2-link planar manipulator
%
% ROBOT = MDL_2LINK_PLANAR() creates a SerialLink object representing
% a simple 2-DOF planar manipulator (like a 2D robot arm).
%
% This is ideal for learning basic robotics concepts.
%
% Robot specifications:
%   - 2 revolute joints
%   - Link 1: 1.0m length
%   - Link 2: 0.8m length
%   - Total reach: 1.8m
%   - Operates in XY plane
%
% Useful configurations:
%   qz - Zero position [0, 0]
%   qr - Ready position [pi/4, pi/4]
%   qn - Nominal/elbow-up [pi/6, pi/3]
%   qd - Elbow-down [-pi/6, -pi/3]
%
% Example:
%   robot = mdl_2link_planar();
%   robot.plot(robot.qr);
%   
%   % Compute workspace
%   q1 = linspace(-pi, pi, 50);
%   q2 = linspace(-pi, pi, 50);
%   [Q1, Q2] = meshgrid(q1, q2);
%   for i = 1:length(q1)
%       for j = 1:length(q2)
%           T = robot.fkine([Q1(i,j), Q2(i,j)]);
%           X(i,j) = T.t(1);
%           Y(i,j) = T.t(2);
%       end
%   end
%   figure; plot(X(:), Y(:), '.');
%   axis equal; xlabel('X'); ylabel('Y'); title('Workspace');

% Define DH parameters [theta, d, a, alpha] in standard convention
% Link 1: First link (shoulder)
L(1) = Link([0, 0, 1.0, 0], 'standard');
L(1).m = 3.0;              % Mass (kg)
L(1).r = [0.5, 0, 0];      % Center of mass at link midpoint
L(1).I = [0, 0.25, 0.25, 0, 0, 0];  % Inertia tensor [Ixx Iyy Izz Ixy Iyz Ixz]
L(1).Jm = 0.002;           % Motor inertia
L(1).G = 100;              % Gear ratio
L(1).B = 0.001;            % Viscous friction coefficient
L(1).Tc = [0.5, -0.5];     % Coulomb friction [positive, negative]

% Link 2: Second link (elbow)
L(2) = Link([0, 0, 0.8, 0], 'standard');
L(2).m = 2.0;
L(2).r = [0.4, 0, 0];
L(2).I = [0, 0.15, 0.15, 0, 0, 0];
L(2).Jm = 0.001;
L(2).G = 80;
L(2).B = 0.0008;
L(2).Tc = [0.4, -0.4];

% Set joint limits (conservative)
L(1).qlim = [-pi, pi];
L(2).qlim = [-pi, pi];

% Create the robot
robot = SerialLink(L, 'name', '2-Link Planar', 'manufacturer', 'Custom');

% Define useful joint configurations
robot.qz = [0, 0];              % Zero/home position (straight out)
robot.qr = [pi/4, pi/4];        % Ready position
robot.qn = [pi/6, pi/3];        % Nominal position (elbow up)
robot.qd = [-pi/6, -pi/3];      % Elbow down position

% Add comment about the robot
robot.comment = 'Simple 2-DOF planar manipulator for education';

% Display basic information
fprintf('Created 2-Link Planar Manipulator\n');
fprintf('  Joints: %d\n', robot.n);
fprintf('  Link 1 length: %.2fm\n', L(1).a);
fprintf('  Link 2 length: %.2fm\n', L(2).a);
fprintf('  Max reach: %.2fm\n', L(1).a + L(2).a);
fprintf('  Min reach: %.2fm\n', abs(L(1).a - L(2).a));

end
