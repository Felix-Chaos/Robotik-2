% load mat-file to have access to variables Ts, time, index, acc and gyro
% (i.e. omega in rad/s)
load('no_motion.mat'); 

% call function QuaternionFromGyroData ...
[theta,euler]=QuaternionFromGyroData(gyro,Ts);
% plot euler angles ...
figure;
plot(time,euler);
% add x-axis label ...
xlabel('X');
% add y-axis label
ylabel('Y');
% add title
title("EulerStuff")
% add grid
grid on;
    
function [q, euler] = QuaternionFromGyroData(omega, Ts)

    % set initial quaternion q(k=0) as identity quaternion
    q = UnitQuaternion; 
    
    for k = 2:size(omega,1)        
        % convert angular velocity to vector quaternion
        % note: this is not a unit quaternion, that's why class Quaternion
        %       is used!
        Omega_q = Quaternion([0, omega(k-1,:)]); 
    
        % compute quaternion derivative
        %k=0;%????
         q_dot = 0.5 * q(k-1,:) * Omega_q;
    
        % Integrate quaternion
         q(k,:) = q(k-1,:)+q_dot*Ts;


        % convert Quaternion into UnitQuaternion (implicit normalization)
        q(k,:) = UnitQuaternion(q(k)); 
        
        % convert UnitQuaternion into euler angles
        euler(k,:) = q(k,:).torpy().*180/pi;
    end
end

