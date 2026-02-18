function T = ForwardKinematics(theta, a, alpha, d)
% ForwardKinematics - Compute forward kinematics using DH parameters
%
% Syntax: T = ForwardKinematics(theta, a, alpha, d)
%
% Inputs:
%    theta - Joint angle (radians)
%    a - Link length
%    alpha - Link twist (radians)
%    d - Link offset
%
% Outputs:
%    T - 4x4 homogeneous transformation matrix
%
% Example:
%    T = ForwardKinematics(pi/4, 1, 0, 0)
%
% Author: Robotik-2 Team

    % Compute transformation matrix using DH convention
    ct = cos(theta);
    st = sin(theta);
    ca = cos(alpha);
    sa = sin(alpha);
    
    T = [ct    -st*ca   st*sa   a*ct;
         st    ct*ca    -ct*sa  a*st;
         0     sa       ca      d;
         0     0        0       1];
end
