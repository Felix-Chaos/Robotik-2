function animateTrajectory(robot, q_trajectory, options)
%ANIMATETRAJECTORY Animate a robot following a trajectory
%
% ANIMATETRAJECTORY(ROBOT, Q_TRAJECTORY) animates the robot following
% the given joint space trajectory.
%
% ANIMATETRAJECTORY(ROBOT, Q_TRAJECTORY, OPTIONS) allows customization:
%   'fps'        - Frames per second (default: 30)
%   'trail'      - Show end-effector trail: 'on'/'off' (default: 'on')
%   'trailcolor' - Trail color (default: 'r')
%   'video'      - Save as video: 'on'/'off' (default: 'off')
%   'filename'   - Video filename (default: 'robot_animation.mp4')
%   'loop'       - Number of times to loop (default: 1)
%
% Example:
%   robot = SerialLink([Link([0,0,1,0]), Link([0,0,1,0])]);
%   q_traj = jtraj([0,0], [pi/2,pi/2], 0:0.05:2);
%   animateTrajectory(robot, q_traj, 'fps', 20, 'trail', 'on');

% Parse input options
if nargin < 3
    options = struct();
end

% Default options
if ~isfield(options, 'fps'), options.fps = 30; end
if ~isfield(options, 'trail'), options.trail = 'on'; end
if ~isfield(options, 'trailcolor'), options.trailcolor = 'r'; end
if ~isfield(options, 'video'), options.video = 'off'; end
if ~isfield(options, 'filename'), options.filename = 'robot_animation.mp4'; end
if ~isfield(options, 'loop'), options.loop = 1; end

n_steps = size(q_trajectory, 1);
fprintf('Animating trajectory with %d steps at %d fps...\n', n_steps, options.fps);

% Prepare figure
fig = figure('Name', 'Robot Animation');
robot.plot(q_trajectory(1,:));
hold on;

% Initialize trail
trail_points = [];
trail_handle = [];

% Setup video writer if requested
if strcmp(options.video, 'on')
    v = VideoWriter(options.filename, 'MPEG-4');
    v.FrameRate = options.fps;
    open(v);
    fprintf('Recording video to %s...\n', options.filename);
end

% Animation loop
for loop_idx = 1:options.loop
    for i = 1:n_steps
        % Update robot plot
        robot.plot(q_trajectory(i,:));
        
        % Update trail if enabled
        if strcmp(options.trail, 'on')
            T = robot.fkine(q_trajectory(i,:));
            ee_pos = T.t';
            trail_points = [trail_points; ee_pos];
            
            if ~isempty(trail_handle) && isvalid(trail_handle)
                delete(trail_handle);
            end
            
            if size(trail_points, 1) > 1
                trail_handle = plot3(trail_points(:,1), trail_points(:,2), ...
                    trail_points(:,3), options.trailcolor, 'LineWidth', 2);
            end
        end
        
        % Capture frame for video
        if strcmp(options.video, 'on')
            frame = getframe(fig);
            writeVideo(v, frame);
        end
        
        % Control frame rate
        pause(1/options.fps);
    end
    
    % Clear trail between loops if multiple loops
    if loop_idx < options.loop
        trail_points = [];
        if ~isempty(trail_handle) && isvalid(trail_handle)
            delete(trail_handle);
        end
    end
end

% Close video writer
if strcmp(options.video, 'on')
    close(v);
    fprintf('Video saved to %s\n', options.filename);
end

fprintf('Animation complete\n');

end
