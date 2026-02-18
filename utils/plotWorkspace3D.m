function plotWorkspace3D(robot, options)
%PLOTWORKSPACE3D Plot the 3D workspace of a robot manipulator
%
% PLOTWORKSPACE3D(ROBOT) generates a 3D visualization of the robot's
% reachable workspace using random sampling.
%
% PLOTWORKSPACE3D(ROBOT, OPTIONS) allows customization with options:
%   'nsamples'   - Number of samples (default: 1000)
%   'plot'       - Plot type: 'scatter', 'cloud', 'boundary' (default: 'scatter')
%   'colormap'   - Colormap to use (default: 'jet')
%   'alpha'      - Transparency value (default: 0.6)
%
% Example:
%   robot = SerialLink([Link([0,0,1,0]), Link([0,0,1,0])]);
%   plotWorkspace3D(robot, 'nsamples', 2000, 'plot', 'cloud');

% Parse input options
if nargin < 2
    options = struct();
end

% Default options
if ~isfield(options, 'nsamples'), options.nsamples = 1000; end
if ~isfield(options, 'plot'), options.plot = 'scatter'; end
if ~isfield(options, 'colormap'), options.colormap = 'jet'; end
if ~isfield(options, 'alpha'), options.alpha = 0.6; end

fprintf('Generating workspace with %d samples...\n', options.nsamples);

% Generate random joint configurations
n = robot.n;
workspace_points = zeros(options.nsamples, 3);

% Get joint limits if available
if ~isempty(robot.qlim)
    q_min = robot.qlim(:, 1);
    q_max = robot.qlim(:, 2);
else
    % Use default limits
    q_min = -pi * ones(n, 1);
    q_max = pi * ones(n, 1);
end

% Sample workspace
for i = 1:options.nsamples
    % Random configuration within joint limits
    q = q_min + rand(n, 1) .* (q_max - q_min);
    
    % Compute forward kinematics
    T = robot.fkine(q');
    workspace_points(i, :) = T.t';
end

% Create figure
figure('Name', sprintf('%s Workspace', robot.name));

% Plot based on type
switch options.plot
    case 'scatter'
        % Scatter plot colored by z-coordinate
        scatter3(workspace_points(:,1), workspace_points(:,2), ...
            workspace_points(:,3), 10, workspace_points(:,3), 'filled', ...
            'MarkerFaceAlpha', options.alpha);
        
    case 'cloud'
        % Point cloud
        plot3(workspace_points(:,1), workspace_points(:,2), ...
            workspace_points(:,3), '.', 'MarkerSize', 2);
        
    case 'boundary'
        % Convex hull (boundary)
        try
            K = convhull(workspace_points);
            trisurf(K, workspace_points(:,1), workspace_points(:,2), ...
                workspace_points(:,3), 'FaceAlpha', options.alpha, ...
                'EdgeColor', 'none');
        catch
            warning('Could not compute convex hull, using scatter instead');
            scatter3(workspace_points(:,1), workspace_points(:,2), ...
                workspace_points(:,3), 10, workspace_points(:,3), 'filled');
        end
end

% Formatting
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
title(sprintf('%s - Workspace (%d samples)', robot.name, options.nsamples));
colormap(options.colormap);
colorbar;
grid on;
axis equal;
view(45, 30);
rotate3d on;

fprintf('Workspace visualization complete\n');

end
