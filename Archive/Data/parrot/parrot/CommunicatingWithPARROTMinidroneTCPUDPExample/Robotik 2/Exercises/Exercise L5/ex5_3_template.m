% load mat-file to have access to variables Ts, time, index, acc and gyro
% (i.e. omega in rad/s)
load('no_motion.mat'); 

% call function QuaternionFromGyroData ...

% plot euler angles ...

% add x-axis label ...

% add y-axis label
% ...
% add title
% ...
% add grid
%...
    
function [q, euler] = QuaternionFromGyroData(omega, Ts)

    % set initial quaternion q(k=0) as identity quaternion
    q = UnitQuaternion; 
    
    for k = 2:size(omega,1)        
        % convert angular velocity to vector quaternion
        % note: this is not a unit quaternion, that's why class Quaternion
        %       is used!
        Omega_q = Quaternion([0, omega(k-1,:)]); 
    
        % compute quaternion derivative
        % q_dot = ...;
    
        % Integrate quaternion
        % q(k,:) = ...;

        % convert Quaternion into UnitQuaternion (implicit normalization)
        q(k,:) = UnitQuaternion(q(k)); 
        
        % convert UnitQuaternion into euler angles
        euler(k,:) = q(k,:).torpy().*180/pi;
    end
end

