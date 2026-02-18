function trajectory = generateTrajectory(startPos, endPos, numPoints)
% generateTrajectory - Generate linear trajectory between two points
%
% Syntax: trajectory = generateTrajectory(startPos, endPos, numPoints)
%
% Inputs:
%    startPos - Starting position [x, y]
%    endPos - Ending position [x, y]
%    numPoints - Number of points in trajectory
%
% Outputs:
%    trajectory - Matrix of trajectory points (numPoints x 2)
%
% Example:
%    traj = generateTrajectory([0, 0], [1, 1], 50)
%
% Author: Robotik-2 Team

    if nargin < 3
        numPoints = 50;
    end
    
    % Generate linear interpolation
    t = linspace(0, 1, numPoints);
    trajectory = zeros(numPoints, 2);
    
    for i = 1:numPoints
        trajectory(i, :) = startPos + t(i) * (endPos - startPos);
    end
end
