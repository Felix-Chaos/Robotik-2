function plotRobot2Link(theta1, theta2, L1, L2)
% plotRobot2Link - Visualize a 2-link planar robot arm
%
% Syntax: plotRobot2Link(theta1, theta2, L1, L2)
%
% Inputs:
%    theta1 - Joint angle 1 (radians)
%    theta2 - Joint angle 2 (radians)
%    L1 - Length of first link
%    L2 - Length of second link
%
% Example:
%    plotRobot2Link(pi/4, pi/4, 1, 1)
%
% Author: Robotik-2 Team

    % Calculate joint positions
    x0 = 0; y0 = 0;  % Base
    x1 = L1 * cos(theta1);
    y1 = L1 * sin(theta1);
    x2 = x1 + L2 * cos(theta1 + theta2);
    y2 = y1 + L2 * sin(theta1 + theta2);
    
    % Plot the robot
    figure;
    hold on;
    
    % Plot links
    plot([x0 x1], [y0 y1], 'b-', 'LineWidth', 3);
    plot([x1 x2], [y1 y2], 'r-', 'LineWidth', 3);
    
    % Plot joints
    plot(x0, y0, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
    plot(x1, y1, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
    plot(x2, y2, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    
    % Configure plot
    axis equal;
    grid on;
    xlabel('X Position');
    ylabel('Y Position');
    title('2-Link Planar Robot');
    legend('Link 1', 'Link 2', 'Base', 'Joint 1', 'End Effector');
    
    % Set axis limits
    maxReach = L1 + L2;
    xlim([-maxReach*1.1, maxReach*1.1]);
    ylim([-maxReach*1.1, maxReach*1.1]);
    
    hold off;
end
