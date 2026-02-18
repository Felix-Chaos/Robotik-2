function J = JacobianMatrix(theta1, theta2, L1, L2)
% JacobianMatrix - Compute Jacobian matrix for 2-link planar robot
%
% Syntax: J = JacobianMatrix(theta1, theta2, L1, L2)
%
% Inputs:
%    theta1 - Joint angle 1 (radians)
%    theta2 - Joint angle 2 (radians)
%    L1 - Length of first link
%    L2 - Length of second link
%
% Outputs:
%    J - 2x2 Jacobian matrix
%
% Example:
%    J = JacobianMatrix(pi/4, pi/4, 1, 1)
%
% Author: Robotik-2 Team

    % Compute Jacobian components
    J11 = -L1*sin(theta1) - L2*sin(theta1 + theta2);
    J12 = -L2*sin(theta1 + theta2);
    J21 = L1*cos(theta1) + L2*cos(theta1 + theta2);
    J22 = L2*cos(theta1 + theta2);
    
    J = [J11 J12;
         J21 J22];
end
