%% Template for Creating Custom Robot Models
% 
% This template helps you create your own robot model for use with
% Peter Corke's Robotics Toolbox.
%
% INSTRUCTIONS:
% 1. Copy this file and rename it (e.g., mdl_my_robot.m)
% 2. Fill in the DH parameters for your robot
% 3. Set physical properties (mass, inertia, etc.) if needed
% 4. Define useful joint configurations
% 5. Save and test your robot model
%
% Author: [Your Name]
% Date: [Date]

function robot = mdl_robot_template()
%MDL_ROBOT_TEMPLATE Template for custom robot model
%
% ROBOT = MDL_ROBOT_TEMPLATE() creates a SerialLink object representing
% [brief description of your robot]
%
% Robot specifications:
%   - Number of joints: [X]
%   - Type: [Manipulator/Mobile/Humanoid/etc.]
%   - Workspace: [approximate reach or dimensions]
%   - Application: [describe intended use]
%
% DH Convention: [Standard/Modified]
%
% Example:
%   robot = mdl_robot_template();
%   robot.plot(robot.qz);

%% Robot Name and Basic Info
robot_name = 'MyRobot';           % Give your robot a name
manufacturer = 'Custom';          % Your name or organization
comment = 'Custom robot model';   % Brief description

%% Define Number of Joints
n_joints = 3;  % Change this to your robot's number of joints

%% Define DH Parameters
% Standard DH Convention: [theta, d, a, alpha]
% Modified DH Convention: [alpha, a, theta, d]
%
% theta: joint angle (variable for revolute joints)
% d:     link offset along previous z-axis
% a:     link length along x-axis
% alpha: link twist (rotation about x-axis)

% Example for 3-DOF robot:
% Joint 1
L(1) = Link([0, 0, 0.5, pi/2], 'standard');  % [theta, d, a, alpha]

% Joint 2
L(2) = Link([0, 0, 0.5, 0], 'standard');

% Joint 3
L(3) = Link([0, 0, 0.3, 0], 'standard');

% Add more links as needed...
% L(4) = Link([0, 0, a4, alpha4], 'standard');
% L(5) = Link([0, 0, a5, alpha5], 'standard');
% L(6) = Link([0, 0, a6, alpha6], 'standard');

%% Set Joint Types (if needed)
% By default, all joints are revolute
% For prismatic joints, set joint type:
% L(i).isprismatic = true;  % Prismatic joint
% L(i).theta = 0;           % Fixed angle for prismatic

%% Set Joint Limits
% Define min and max joint angles/positions
L(1).qlim = [-pi, pi];           % Full rotation
L(2).qlim = [-pi/2, pi/2];       % Limited range
L(3).qlim = [-pi/2, pi/2];

% For prismatic joints, use position limits:
% L(i).qlim = [0, 0.5];  % 0 to 0.5 meters

%% Set Physical Properties (Optional but recommended for dynamics)

% Link 1 properties
L(1).m = 2.0;                    % Mass (kg)
L(1).r = [0.25, 0, 0];          % Center of mass (CoM) position [x, y, z]
L(1).I = [0.01, 0.05, 0.05, 0, 0, 0];  % Inertia tensor [Ixx Iyy Izz Ixy Iyz Ixz]
L(1).Jm = 0.001;                % Motor inertia (kg.m²)
L(1).G = 100;                   % Gear ratio
L(1).B = 0.001;                 % Viscous friction coefficient
L(1).Tc = [0.5, -0.5];          % Coulomb friction [positive, negative]

% Link 2 properties
L(2).m = 1.5;
L(2).r = [0.25, 0, 0];
L(2).I = [0.01, 0.04, 0.04, 0, 0, 0];
L(2).Jm = 0.001;
L(2).G = 100;
L(2).B = 0.001;
L(2).Tc = [0.4, -0.4];

% Link 3 properties
L(3).m = 1.0;
L(3).r = [0.15, 0, 0];
L(3).I = [0.005, 0.02, 0.02, 0, 0, 0];
L(3).Jm = 0.0005;
L(3).G = 50;
L(3).B = 0.0005;
L(3).Tc = [0.3, -0.3];

% Repeat for additional links...

%% Create the Robot
robot = SerialLink(L, 'name', robot_name, 'manufacturer', manufacturer);
robot.comment = comment;

%% Define Useful Joint Configurations
% These are standard poses that are useful for testing and demonstration

robot.qz = zeros(1, n_joints);              % Zero position (all joints at 0)
robot.qr = [0, pi/4, pi/4];                % Ready position
robot.qn = [0, pi/6, pi/3];                % Nominal position
% robot.qd = [value1, value2, ...];         % Custom configuration

% Add more configurations as needed for your robot

%% Set Tool Transform (Optional)
% If your robot has an end-effector or tool, define its transform
% robot.tool = transl(0, 0, 0.1);           % 10cm tool extension in z
% robot.tool = transl(0, 0, 0.1) * trotz(pi/4);  % Tool with rotation

%% Set Base Transform (Optional)
% If your robot is mounted on a platform or has a non-standard base
% robot.base = transl(0, 0, 0.5);           % Base elevated by 0.5m
% robot.base = transl(1, 0, 0) * trotz(pi/2);  % Base offset and rotated

%% Display Robot Information
fprintf('Created robot: %s\n', robot.name);
fprintf('  Manufacturer: %s\n', manufacturer);
fprintf('  Number of joints: %d\n', robot.n);
fprintf('  Comment: %s\n', comment);

% Calculate and display reach
total_reach = sum([L.a]);
fprintf('  Approximate reach: %.3f m\n', total_reach);

% Display joint types
fprintf('  Joint types: ');
for i = 1:robot.n
    if L(i).isprismatic
        fprintf('P');
    else
        fprintf('R');
    end
end
fprintf('\n');

%% Additional Notes
% Add any special notes about your robot here
fprintf('\nNotes:\n');
fprintf('  - [Add any important information about your robot]\n');
fprintf('  - [Known limitations or special features]\n');
fprintf('  - [Recommended configurations for testing]\n');

end

%% CHECKLIST BEFORE FINALIZING
% [ ] DH parameters are correct and verified
% [ ] Joint limits are appropriate
% [ ] Physical properties are set (if needed for dynamics)
% [ ] Useful configurations are defined
% [ ] Tool transform is set (if applicable)
% [ ] Base transform is set (if applicable)
% [ ] Documentation is complete
% [ ] Model has been tested

%% TESTING YOUR ROBOT MODEL
% After creating your model, test it with these commands:
%
% % Load the model
% robot = mdl_robot_template();  % Replace with your function name
%
% % Display information
% robot
%
% % Test forward kinematics
% T = robot.fkine(robot.qz);
% disp(T);
%
% % Visualize the robot
% figure;
% robot.plot(robot.qz);
%
% % Test with different configurations
% robot.plot(robot.qr);
% robot.plot(robot.qn);
%
% % Visualize workspace
% plotWorkspace3D(robot, 'nsamples', 1000);
%
% % Test trajectory
% q_traj = jtraj(robot.qz, robot.qr, 0:0.05:2);
% robot.plot(q_traj);

%% COMMON DH PARAMETER EXAMPLES
%
% Revolute joint (like shoulder or elbow):
%   L = Link([0, 0, length, twist], 'standard');
%
% Prismatic joint (linear actuator):
%   L = Link([0, 0, 0, 0], 'standard');
%   L.isprismatic = true;
%
% Joint with 90° twist (common in many robots):
%   L = Link([0, 0, length, pi/2], 'standard');
%
% Joint with no twist (planar motion):
%   L = Link([0, 0, length, 0], 'standard');

%% REFERENCE ROBOTS
% For inspiration, look at these existing robot models:
% - mdl_puma560()      : 6-DOF industrial robot
% - mdl_ur5()          : Universal Robots UR5
% - mdl_2link_planar() : Simple 2-DOF planar robot (in this workspace)
% - mdl_3link_spatial(): 3-DOF spatial robot (in this workspace)
