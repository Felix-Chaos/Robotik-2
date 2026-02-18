function [theta1, theta2] = InverseKinematics2Link(x, y, L1, L2)
% InverseKinematics2Link - Compute inverse kinematics for 2-link planar robot
%
% Syntax: [theta1, theta2] = InverseKinematics2Link(x, y, L1, L2)
%
% Inputs:
%    x - Target x-coordinate
%    y - Target y-coordinate
%    L1 - Length of first link
%    L2 - Length of second link
%
% Outputs:
%    theta1 - Joint angle 1 (radians)
%    theta2 - Joint angle 2 (radians)
%
% Example:
%    [theta1, theta2] = InverseKinematics2Link(1.5, 0.5, 1, 1)
%
% Author: Robotik-2 Team

    % Check if target is reachable
    distance = sqrt(x^2 + y^2);
    if distance > (L1 + L2) || distance < abs(L1 - L2)
        error('Target position is out of reach');
    end
    
    % Calculate theta2 using law of cosines
    cos_theta2 = (x^2 + y^2 - L1^2 - L2^2) / (2 * L1 * L2);
    theta2 = atan2(sqrt(1 - cos_theta2^2), cos_theta2);
    
    % Calculate theta1
    k1 = L1 + L2 * cos(theta2);
    k2 = L2 * sin(theta2);
    theta1 = atan2(y, x) - atan2(k2, k1);
end
