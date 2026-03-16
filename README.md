# Quaternion from Gyroscope to Euler Angles (MATLAB)

This mini-guide shows how to:
1. Integrate gyroscope angular rates to quaternions
2. Convert quaternions to Euler angles
3. Plot roll, pitch, yaw over time

## Requirements
- Gyroscope data `gyro` as `N x 3` in rad/s (`[wx wy wz]`)
- Sampling frequency `fs` in Hz

## Core idea
At each sample, update orientation quaternion with angular velocity:

- Angular increment: `dtheta = omega * dt`
- Quaternion update (small-angle form):
  - `dq = [1, 0.5*dtheta_x, 0.5*dtheta_y, 0.5*dtheta_z]`
- New orientation: `q_k = normalize(q_{k-1} * dq)`

## MATLAB example
```matlab
% Inputs:
% gyro: N x 3 (rad/s)
% fs:   sample rate (Hz)

dt = 1 / fs;
N = size(gyro, 1);

% Store orientation quaternions
q = quaternion.zeros(N, 1);
q(1) = quaternion(1, 0, 0, 0); % identity orientation

for k = 2:N
    w = gyro(k-1, :);           % rad/s
    dtheta = w * dt;            % rad

    % Small-angle delta quaternion [w x y z]
    dq = quaternion([1, 0.5*dtheta(1), 0.5*dtheta(2), 0.5*dtheta(3)]);

    % Right-multiply for body rates; normalize to avoid drift from numerics
    q(k) = normalize(q(k-1) * dq);
end

% Convert to Euler angles in degrees (roll, pitch, yaw)
eul_deg = eulerd(q, 'XYZ', 'frame');

% Time vector
t = (0:N-1)' / fs;

% Plot
figure('Name', 'Gyro -> Quaternion -> Euler');
plot(t, eul_deg, 'LineWidth', 1.2);
grid on;
xlabel('Time (s)');
ylabel('Angle (deg)');
legend('Roll', 'Pitch', 'Yaw', 'Location', 'best');
title('Euler Angles from Gyroscope Quaternion Integration');
```

## Notes
- Pure gyro integration drifts over time.
- For long recordings, fuse with accelerometer/magnetometer (e.g., complementary filter or AHRS).
