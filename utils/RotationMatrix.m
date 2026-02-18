function R = RotationMatrix(axis, angle)
% RotationMatrix - Generate rotation matrix around specified axis
%
% Syntax: R = RotationMatrix(axis, angle)
%
% Inputs:
%    axis - 'x', 'y', or 'z' for rotation axis
%    angle - Rotation angle in radians
%
% Outputs:
%    R - 3x3 rotation matrix
%
% Example:
%    R = RotationMatrix('z', pi/4)
%
% Author: Robotik-2 Team

    c = cos(angle);
    s = sin(angle);
    
    switch lower(axis)
        case 'x'
            R = [1  0  0;
                 0  c -s;
                 0  s  c];
        case 'y'
            R = [c  0  s;
                 0  1  0;
                -s  0  c];
        case 'z'
            R = [c -s  0;
                 s  c  0;
                 0  0  1];
        otherwise
            error('Axis must be x, y, or z');
    end
end
