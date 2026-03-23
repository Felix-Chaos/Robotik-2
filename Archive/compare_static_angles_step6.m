%% Step 6 (simple): compare calculated static angles to desired angles
% Minimal version: keep only the core workflow and basic comments.

clear; clc; close all;

files = {'x_axis_rotation_3.mat', 'y_axis_rotation_3.mat', 'z_axis_rotation_3.mat'};
labels = {'X rotation', 'Y rotation', 'Z rotation'};
axisCol = [1, 2, 3];                    % X->roll, Y->pitch, Z->yaw
desired = [0, 45, 90, 45, 0]';          % required static sequence [deg]

fs = 50;
maxDurationSec = 60;
gyroThreshDeg = 3;                      % below this -> static
minStaticSec = 1.0;

for i = 1:numel(files)
    fprintf('\n===== %s =====\n', labels{i});

    % 1) Load data
    S = load(files{i});
    data = squeeze(S.rx_data.signals.values)';      % N x 6
    t = (0:size(data,1)-1)' / fs;
    idx = t <= maxDurationSec;
    t = t(idx);
    accel = data(idx, 1:3);
    gyro = data(idx, 4:6);                          % rad/s

    % 2) Complementary filter -> Euler angles [deg]
    fuse = complementaryFilter('SampleRate', fs, 'HasMagnetometer', false);
    q = fuse(accel, gyro);
    if isa(q, 'quaternion')
        eulDeg = eulerd(q, 'XYZ', 'frame');
    else
        eulDeg = q;
    end
    if size(eulDeg,2) == 2
        eulDeg(:,3) = 0;
    end

    % Use only the tested axis and set start angle to 0 deg
    angleSig = eulDeg(:, axisCol(i));
    angleSig = angleSig - angleSig(1);
    angleSigInv = -angleSig;

    % 3) Detect static phases from gyro norm
    gyroNormDeg = vecnorm(gyro * 180/pi, 2, 2);
    isStatic = gyroNormDeg < gyroThreshDeg;

    % Find start/end indices of static runs
    d = diff([false; isStatic; false]);
    starts = find(d == 1);
    ends = find(d == -1) - 1;

    % Keep only runs with minimum length
    minLen = round(minStaticSec * fs);
    keep = (ends - starts + 1) >= minLen;
    starts = starts(keep);
    ends = ends(keep);

    if isempty(starts)
        warning('No static phases found in %s', files{i});
        continue;
    end

    % Use first 5 static phases only (simple chronological mapping)
    n = min(5, numel(starts));
    starts = starts(1:n);
    ends = ends(1:n);
    desiredNow = desired(1:n);

    % Simple sign check: compute which sign is closer to desired sequence.
    meanNormal = zeros(n,1);
    meanInverted = zeros(n,1);
    for p = 1:n
        valsNormal = angleSig(starts(p):ends(p));
        valsInverted = angleSigInv(starts(p):ends(p));
        meanNormal(p) = mean(valsNormal);
        meanInverted(p) = mean(valsInverted);
    end

    scoreNormal = mean(abs(meanNormal - desiredNow));
    scoreInverted = mean(abs(meanInverted - desiredNow));

    if scoreInverted < scoreNormal
        signLabel = 'inverted sign is closer to desired sequence';
    else
        signLabel = 'normal sign is closer to desired sequence';
    end
    fprintf('Sign check: %s\n', signLabel);

    % 4) Per-phase mean, std, mean error (for both signs)
    meanDeg = zeros(n,1);
    stdDeg = zeros(n,1);
    meanErrDeg = zeros(n,1);
    meanDegInv = zeros(n,1);
    stdDegInv = zeros(n,1);
    meanErrDegInv = zeros(n,1);
    for p = 1:n
        vals = angleSig(starts(p):ends(p));
        valsInv = angleSigInv(starts(p):ends(p));
        meanDeg(p) = mean(vals);
        stdDeg(p) = std(vals);
        meanErrDeg(p) = meanDeg(p) - desiredNow(p);
        meanDegInv(p) = mean(valsInv);
        stdDegInv(p) = std(valsInv);
        meanErrDegInv(p) = meanDegInv(p) - desiredNow(p);
    end

    Tphase = table((1:n)', desiredNow, ...
        meanDeg, stdDeg, meanErrDeg, ...
        meanDegInv, stdDegInv, meanErrDegInv, ...
        'VariableNames', {'Phase', 'DesiredDeg', ...
        'MeanDegNormal', 'StdDegNormal', 'MeanErrorDegNormal', ...
        'MeanDegInverted', 'StdDegInverted', 'MeanErrorDegInverted'});
    disp('Per-phase results:');
    disp(Tphase);

    % 5) For each target angle (0,45,90): error mean and error std (both)
    targets = unique(desiredNow);
    targetDeg = zeros(numel(targets),1);
    errMean = zeros(numel(targets),1);
    errStd = zeros(numel(targets),1);
    errMeanInv = zeros(numel(targets),1);
    errStdInv = zeros(numel(targets),1);

    for k = 1:numel(targets)
        tgt = targets(k);
        allErr = [];
        allErrInv = [];
        for p = 1:n
            if desiredNow(p) == tgt
                vals = angleSig(starts(p):ends(p));
                valsInv = angleSigInv(starts(p):ends(p));
                allErr = [allErr; vals - tgt]; 
                allErrInv = [allErrInv; valsInv - tgt]; 
            end
        end
        targetDeg(k) = tgt;
        errMean(k) = mean(allErr);
        errStd(k) = std(allErr);
        errMeanInv(k) = mean(allErrInv);
        errStdInv(k) = std(allErrInv);
    end

    Ttarget = table(targetDeg, errMean, errStd, errMeanInv, errStdInv, ...
        'VariableNames', {'TargetDeg', ...
        'MeanErrorDegNormal', 'StdErrorDegNormal', ...
        'MeanErrorDegInverted', 'StdErrorDegInverted'});
    disp('Per-target-angle error results:');
    disp(Ttarget);

    % 6) Simple plot: normal + inverted + desired in static phases
    desiredTrace = nan(size(angleSig));
    for p = 1:n
        desiredTrace(starts(p):ends(p)) = desiredNow(p);
    end

    figure('Name', ['Step 6 - ' labels{i}], 'NumberTitle', 'off');
    plot(t, angleSig, 'b', 'LineWidth', 1.2); hold on;
    plot(t, angleSigInv, 'm', 'LineWidth', 1.2);
    plot(t, desiredTrace, 'r--', 'LineWidth', 1.5);
    grid on;
    xlabel('Time [s]');
    ylabel('Angle [deg]');
    title(['Static comparison - ' labels{i}]);
    legend('Calculated angle (normal)', 'Calculated angle (inverted)', ...
        'Desired angle in static phases', 'Location', 'best');
end
