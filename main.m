%% Robotik-2 Main Script
% Main entry point for the Robotik-2 MATLAB project
% 
% This script provides an interactive menu to run various examples
% and demonstrations of robot kinematics and control

clear; clc; close all;

fprintf('===========================================\n');
fprintf('    Welcome to Robotik-2 Project\n');
fprintf('===========================================\n');
fprintf('\n');

% Add paths
addpath('src');
addpath('utils');
addpath('examples');

fprintf('Available Examples:\n');
fprintf('  1. Forward Kinematics\n');
fprintf('  2. Inverse Kinematics\n');
fprintf('  3. Trajectory Following\n');
fprintf('  4. Jacobian Matrix Analysis\n');
fprintf('  5. Run All Examples\n');
fprintf('  0. Exit\n');
fprintf('\n');

% Get user selection
choice = input('Enter your choice (0-5): ');

fprintf('\n');

switch choice
    case 1
        fprintf('Running Forward Kinematics Example...\n');
        run('examples/example1_forward_kinematics');
        
    case 2
        fprintf('Running Inverse Kinematics Example...\n');
        run('examples/example2_inverse_kinematics');
        
    case 3
        fprintf('Running Trajectory Following Example...\n');
        run('examples/example3_trajectory');
        
    case 4
        fprintf('Running Jacobian Matrix Example...\n');
        run('examples/example4_jacobian');
        
    case 5
        fprintf('Running All Examples...\n\n');
        
        fprintf('1/4: Forward Kinematics...\n');
        run('examples/example1_forward_kinematics');
        fprintf('\nPress any key to continue...\n');
        pause;
        close all;
        
        fprintf('\n2/4: Inverse Kinematics...\n');
        run('examples/example2_inverse_kinematics');
        fprintf('\nPress any key to continue...\n');
        pause;
        close all;
        
        fprintf('\n3/4: Trajectory Following...\n');
        run('examples/example3_trajectory');
        fprintf('\nPress any key to continue...\n');
        pause;
        close all;
        
        fprintf('\n4/4: Jacobian Matrix...\n');
        run('examples/example4_jacobian');
        
        fprintf('\n===========================================\n');
        fprintf('All examples completed!\n');
        fprintf('===========================================\n');
        
    case 0
        fprintf('Exiting Robotik-2 Project. Goodbye!\n');
        
    otherwise
        fprintf('Invalid choice. Please run the script again.\n');
end

fprintf('\n');
