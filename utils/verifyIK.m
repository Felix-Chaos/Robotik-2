function success = verifyIK(robot, T_desired, q_solution, tolerance)
%VERIFYIK Verify an inverse kinematics solution
%
% SUCCESS = VERIFYIK(ROBOT, T_DESIRED, Q_SOLUTION) verifies that the joint
% configuration Q_SOLUTION reaches the desired transformation T_DESIRED
% within a default tolerance of 1mm position and 1 degree orientation.
%
% SUCCESS = VERIFYIK(ROBOT, T_DESIRED, Q_SOLUTION, TOLERANCE) uses custom
% tolerance: TOLERANCE = [position_tol (m), angle_tol (rad)]
%
% Returns:
%   SUCCESS - Boolean indicating if solution is valid
%
% Example:
%   robot = mdl_puma560();
%   T = transl(0.5, 0.2, 0.3);
%   q = robot.ikine(T);
%   success = verifyIK(robot, T, q);

% Default tolerance
if nargin < 4
    tolerance = [0.001, deg2rad(1)];  % 1mm, 1 degree
end

pos_tol = tolerance(1);
ang_tol = tolerance(2);

% Compute forward kinematics with solution
T_achieved = robot.fkine(q_solution);

% Extract positions
p_desired = T_desired.t;
p_achieved = T_achieved.t;

% Compute position error
pos_error = norm(p_achieved - p_desired);

% Extract rotations
R_desired = T_desired.R;
R_achieved = T_achieved.R;

% Compute rotation error (angle of rotation difference)
R_error = R_achieved * R_desired';
ang_error = acos((trace(R_error) - 1) / 2);

% Check if within tolerance
success = (pos_error <= pos_tol) && (ang_error <= ang_tol);

% Display results
fprintf('IK Verification Results:\n');
fprintf('  Position error: %.6f m (tolerance: %.6f m)\n', pos_error, pos_tol);
fprintf('  Orientation error: %.4f deg (tolerance: %.4f deg)\n', ...
    rad2deg(ang_error), rad2deg(ang_tol));

if success
    fprintf('  ✓ Solution is VALID\n');
else
    fprintf('  ✗ Solution is INVALID\n');
end

end
