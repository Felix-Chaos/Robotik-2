load('sensor_data_2.mat');

acc_s.time = time;
acc_s.signals.values = acc;
acc_s.dimensions = 3;

gyro_s.time = time;
gyro_s.signals.values = gyro;
gyro_s.dimensions = 3;

gamma = 0.97;