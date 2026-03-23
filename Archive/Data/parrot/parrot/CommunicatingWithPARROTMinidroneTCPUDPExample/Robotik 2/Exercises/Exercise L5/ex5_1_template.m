close all; 
clear all;

% load mat-file to have access to variables Ts, time, index, acc and gyro 
% (i.e. omega in rad/s)
load('no_motion.mat'); 
% calculate angles from gyroscope data
theta = IntegratedAnglesFromGyroData(gyro, Ts);

% plot data ...

% add x-axis label ...

% add y-axis label ...

% add title ...

% add grid ...

% this function expects omega in rad/s and Ts in seconds    
function [theta] = IntegratedAnglesFromGyroData(omega, Ts)
    %preallocation for performance
    theta = zeros(size(omega,1), 3);

    %theta(k=0) (in MATLAB index is one-based, i.e. starts with 1)
    theta(1,:) = [0 0 0];

    

    % loop through the vector (omega) and integrate the angular
    % rates
    for i = 2:size(omega,1)   
        
        %...

    end

    %conversion to degrees
    theta = theta.*180/pi;
end
    

