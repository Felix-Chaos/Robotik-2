% move RTB paths to top
%setRTBpaths;

% clean up
clear all; close all;

%% define desired angles 
%  --> these are the rotation angles that need to be determined based on 
% the accelerometer measurement
roll = pi*3/4; pitch = pi/4; yaw = 0;

%% apply the given rotation angles to gain rotated acceleration vector in B 
% 1. use the corresponding RTB function to generate a unit quaternion
% A_q_B corresponding to roll, pitch, yaw
A_q_B = UnitQuaternion.rpy(roll, pitch, yaw);

% 2. calculate B_q_A and plot it
B_q_A = A_q_B.inv;
B_q_A.plot('color','b', 'frame','real');
view(3);
hold on;

% 3. Generate vector A_g = [0 0 1] and apply a quaternion rotation using B_q_A
A_g = [0 0 1];
A_q_g = UnitQuaternion(0, A_g);
B_q_g = B_q_A * A_q_g * B_q_A.conj;

% 4. define "measured" acceleration vector a_m as vector part of quaternion B_q_A
a_m = B_q_g.v;


%% TODO play around with different start values and check the result
% define a start value for the gradient descent algorithm
euler_start = [0 0 pi/2];
q_start_obj = UnitQuaternion.rpy(euler_start);
q_start = [q_start_obj.s q_start_obj.v];

%% applying the gradient descent algorithm
[q_out,exitflag] = gradient_descent(a_m,  q_start);

if exitflag == 1
    q_found = UnitQuaternion(q_out(1), q_out(2:4));
    q_found.plot('color','g');
    disp(['Found q: ', num2str(q_out)]);
else
    disp('no solution found');
end

function [q_out, success] = gradient_descent(a_in, q0)
    % define the tolerance and maximum number of iterations
    tol = 1e-2;
    max_iter = 1000;

    % Step size
    mu = 0.01;

    % Work internally with column vectors (4x1)
    q = q0(:);
    q = q / norm(q);      % ensure unit quaternion

    success = 0;

    for iter = 1:max_iter
        % Residual vector G(q) (3x1)
        G = G_q(q, a_in);

        % Jacobian J = dG/dq (3x4)
        J = jacobian_g(q);

        % Gradient of F (4x1): grad F = J^T * G
        gradF = J.' * G;

        % Stopping criteria
        if norm(G) < tol 
            success = 1;
            break;
        end

        % Gradient descent update
        q = q - mu * gradF;

        % Re-normalize quaternion to keep it on S^3
        q = q / norm(q);
    end

    % Return as row vector to match your outer code usage
    q_out = q.';
end

function G = G_q(q, a_in)
    % q is 4x1: [q0 q1 q2 q3]^T
    q0 = q(1);
    q1 = q(2); q2 = q(3); q3 = q(4);

    % Return residual as column vector (3x1)
    G = [
        2 * (q1 * q3 + q0 * q2) - a_in(1);
        2 * (q2 * q3 - q0 * q1) - a_in(2);
        (q0^2 - q1^2 - q2^2 + q3^2) - a_in(3)
    ];
end

function J = jacobian_g(q)
    % q is 4x1
    q0 = q(1);
    q1 = q(2); q2 = q(3); q3 = q(4);

    % J is 3x4: each row is grad of one residual component
    J = [
        2*q2,   2*q3,   2*q0,   2*q1;
       -2*q1,  -2*q0,   2*q3,   2*q2;
        2*q0,  -2*q1,  -2*q2,   2*q3
    ];
end

