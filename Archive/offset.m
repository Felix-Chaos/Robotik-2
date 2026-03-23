close all; 
clear all;
% load mat-file to have access to variables Ts, time, index, acc and gyro
load('no_motion.mat'); 
% calibration (acc, gyro) based on mean of first 100 samples (optional)
% ... 
gamma = 0.97;
% calculate euler angles from accelerometer data
eul_acc = EulerAnglesFromAccData(acc);
% calculate euler angles from gyroscope data
theta_gyr = IntegratedAnglesFromGyroData(gyro, Ts);
% calculate euler angles based on complementary filter
filtered_angles = ComplementaryFilter(gyro, acc, Ts, gamma);
% plot the three results as subplots (eul_acc, theta_gyr, filterd_angles)
%...
figure;
subplot(2,2,1);
plot(eul_acc);
title("Euler")
grid on;
subplot (2,2,2);
plot(theta_gyr);
title("Theta");
subplot (2,2,3);
plot(filtered_angles) % FIX: Changed subplot() to plot()
title("filtered angles")

% use your implemented funtion from exercise 5.1
function [theta] = IntegratedAnglesFromGyroData(gyro_data, Ts) % FIX: Output name matched to internal var
        %preallocation for performance
    theta = zeros(size(gyro_data,1), 3);
    %theta(k=0) (in MATLAB index is one-based, i.e. starts with 1)
    theta(1,:) = [0 0 0];
    mean_offset =mean(gyro_data(1:100,:),1);
    gyro_data = gyro_data -mean_offset;  % FIX: Added semicolon
    % loop through the vector (omega) and integrate the angular
    % rates
    for i = 2:size(gyro_data,1)   
        
        theta(i,:)=theta(i-1,:)+gyro_data(i-1,:)*Ts;
        
    end
    %conversion to degrees
    theta = theta.*180/pi;
end
% use your implemented funtion from exercise 4.2    
function [euler_acc] = EulerAnglesFromAccData(acc)
    %Preallocation to improve loop performance
    euler_acc = zeros(size(acc, 1), 3);
    for i = 1:size(acc, 1) % FIX: Changed length() to size() to handle single rows
        % normalize acceleration vector at index i
        acc_norm = acc(i,:)/norm(acc(i,:)); % FIX: Typos 'acci' fixed
        ax = acc_norm(1,1);
        ay = acc_norm(1,2); 
        az = acc_norm(1,3);
       
        phi = -atan2(ay,-az); % FIX: atan -> atan2 for stability
        theta = -atan2(-ax,sqrt(ay^2+az^2)); % FIX: atan -> atan2
        psi = 0;
        euler_acc(i,:) = [phi, theta, psi].*180/pi;
    end
end
% complete implementation based on slides and comments 
function [theta_hat] = ComplementaryFilter(omega, a, Ts, gamma)
    N = size(omega,1);
    % Preallocate
    theta_hat = zeros(N,3);   % fused output: theta_hat(k)
    theta_a   = zeros(N,3);   % accelerometer angle: theta_a(k)
    theta_g   = zeros(N,3);   % gyro-based angle update: theta_g(k)
    % initial angle based on accelerometer data (k = 1)
    theta_hat(1,:) = EulerAnglesFromAccData(a(1,:));
    theta_a(1,:)   = theta_hat(1,:);
    for k = 2:N
        % 1) accelerometer angle at time k
        theta_a(k,:) = EulerAnglesFromAccData(a(k,:));
        % 2)  gyro prediction at time k using previous fused output theta_hat(k-1,:)
        % FIX: Added Ts and unit conversion
        theta_g(k,:) = theta_hat(k-1,:) + omega(k-1,:)*Ts*180/pi;
        % 3) fuse roll & pitch (columns 1 and 2) using theta_g and theta_a
        % with factors gamma and (1-gamma)
        % FIX: Filled in logic and fixed 'gamm' typo
        theta_hat(k,1:2) = gamma * theta_g(k,1:2) + (1-gamma) * theta_a(k,1:2);
        % 4) yaw: gyro-only (accelerometer provides no yaw information)
        theta_hat(k,3) = theta_g(k,3);
    end
end