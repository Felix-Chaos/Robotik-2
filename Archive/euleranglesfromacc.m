% call function for calculating euler angles based on accelerometer data
load('sensor_data_1.mat'); 
eul_acc = EulerAnglesFromAcc(acc);

figure; 
subplot(2,1,1);
plot(time, acc,'.-');
legend('acc_x','acc_y','acc_z');
ylabel('m/{s^2}')
ylim([-10 10]);
title('accelerometer data')
subplot(2,1,2);
plot(time, eul_acc(:, 1:2));
ylim([-100 100]);
legend('roll','pitch');
title('accelerometer based euler angles');


function [euler_acc] = EulerAnglesFromAcc(acc)
    %Preallocation to improve loop performance
    euler_acc = zeros(size(acc, 1), 3);

    for i = 1:length(acc)
        % normalize acceleration vector at index i
        acc_norm = acci(1,:)/norm(acci((1,:)));

        ax = acc_norm(1,1);
        ay = acc_norm(1,2); 
        az = acc_norm(1,3);
       
        phi = -atan(ay,-az); 
        theta = -atan(-ax,sqrt(ay^2+az^2));
        psi = 0;

        euler_acc(i,:) = [phi, theta, psi].*180/pi;
    end
end
