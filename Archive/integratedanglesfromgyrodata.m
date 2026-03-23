close all; 
clear all;

% load mat-file to have access to variables Ts, time, index, acc and gyro 
% (i.e. omega in rad/s)
load('no_motion.mat'); 
% calculate angles from gyroscope data
theta = IntegratedAnglesFromGyroData(gyro, Ts);

% plot data ...
figure;
plot(theta);

% add x-axis label ...
xlabel("Zeit in Sec");
% add y-axis label ...
ylabel = ("Ang Drift");
% add title ...
title("Angles from Gyro");
% add grid ...
grid on;
% this function expects omega in rad/s and Ts in seconds    
function [theta] = IntegratedAnglesFromGyroData(omega, Ts)
    %preallocation for performance
    theta = zeros(size(omega,1), 3);

    %theta(k=0) (in MATLAB index is one-based, i.e. starts with 1)
    theta(1,:) = [0 0 0];

    mean_offset =mean(omega(1:100,:),1);
    omega = omega -mean_offset  

    % loop through the vector (omega) and integrate the angular
    % rates
    for i = 2:size(omega,1)   
        
        theta(i,:)=theta(i-1,:)+omega(i-1,:)*Ts;
        
    end

    %conversion to degrees
    theta = theta.*180/pi;
end
    

