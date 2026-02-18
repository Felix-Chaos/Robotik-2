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

% use your implemented funtion from exercise 5.1
function [euler_gyro] = IntegratedAnglesFromGyroData(gyro_data, Ts)
    % ...
end
% use your implemented funtion from exercise 4.2    
function [euler_acc] = EulerAnglesFromAccData(acc)
    % ...
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
        % theta_g(k,:) = ... ;

        % 3) fuse roll & pitch (columns 1 and 2) using theta_g and theta_a
        % with factors gamma and (1-gamma)
        % theta_hat(k,1:2) = ... ;

        % 4) yaw: gyro-only (accelerometer provides no yaw information)
        % theta_hat(k,3) = ... ;
    end
end
