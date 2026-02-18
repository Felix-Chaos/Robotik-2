%% MATLAB Startup Script for Robotics Workspace
% This script initializes the MATLAB workspace with the Robotics Toolbox
% from Peter Corke and sets up the necessary paths.
%
% Usage: Run this script at the start of each MATLAB session, or add it
%        to your MATLAB startup file.

fprintf('\n');
fprintf('========================================\n');
fprintf('  Robotics Workspace Initialization\n');
fprintf('========================================\n\n');

% Get the current directory
currentDir = fileparts(mfilename('fullpath'));

% Add project directories to path
fprintf('Adding project directories to path...\n');

% Add examples directory
if exist(fullfile(currentDir, 'examples'), 'dir')
    addpath(genpath(fullfile(currentDir, 'examples')));
    fprintf('  - Added examples directory\n');
end

% Add utils directory
if exist(fullfile(currentDir, 'utils'), 'dir')
    addpath(genpath(fullfile(currentDir, 'utils')));
    fprintf('  - Added utils directory\n');
end

% Add models directory
if exist(fullfile(currentDir, 'models'), 'dir')
    addpath(genpath(fullfile(currentDir, 'models')));
    fprintf('  - Added models directory\n');
end

fprintf('\n');

% Check for Robotics Toolbox
fprintf('Checking for Robotics Toolbox...\n');
try
    % Try to create a simple robot to verify toolbox is installed
    rtbVersion = ver('RTB');
    if ~isempty(rtbVersion)
        fprintf('  ✓ Robotics Toolbox found: Version %s\n', rtbVersion.Version);
    else
        % Alternative check
        if exist('SerialLink', 'class') == 8
            fprintf('  ✓ Robotics Toolbox detected\n');
        else
            warning('Robotics Toolbox may not be installed properly');
            fprintf('  ✗ Robotics Toolbox not found\n');
            fprintf('\n');
            fprintf('To install Peter Corke''s Robotics Toolbox:\n');
            fprintf('  1. Download from: https://github.com/petercorke/robotics-toolbox-matlab\n');
            fprintf('  2. Or install via: https://petercorke.com/toolboxes/robotics-toolbox/\n');
            fprintf('  3. Run the toolbox installation script\n');
        end
    end
catch
    warning('Could not verify Robotics Toolbox installation');
    fprintf('  ⚠ Unable to verify Robotics Toolbox\n');
    fprintf('\n');
    fprintf('To install Peter Corke''s Robotics Toolbox:\n');
    fprintf('  1. Download from: https://github.com/petercorke/robotics-toolbox-matlab\n');
    fprintf('  2. Or install via: https://petercorke.com/toolboxes/robotics-toolbox/\n');
    fprintf('  3. Run the toolbox installation script\n');
end

fprintf('\n');
fprintf('========================================\n');
fprintf('  Workspace Ready!\n');
fprintf('========================================\n');
fprintf('\n');
fprintf('Available example scripts:\n');
fprintf('  - basic_robot_demo.m       : Basic robot creation and manipulation\n');
fprintf('  - forward_kinematics.m     : Forward kinematics examples\n');
fprintf('  - inverse_kinematics.m     : Inverse kinematics examples\n');
fprintf('  - trajectory_planning.m    : Trajectory generation examples\n');
fprintf('  - robot_visualization.m    : Robot visualization examples\n');
fprintf('\n');
fprintf('Type ''help <script_name>'' for more information on each script.\n');
fprintf('\n');
