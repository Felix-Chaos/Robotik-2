clear all;
close all;

%instantiate an object from the RobotClass passing the IP address of the 
%Cobotta. This establishes a connection to the Cobotta
myObject = RobotClass('172.16.6.103');

%this command moves to end-effector of the Cobotta to the initial Pose, in
%which the drone can be attached to the gripper. The method will 
%interactively give instructions for attaching the drone via the MATLAB 
%command window
myObject.move2measurepos();

%this command first moves the end-effector to the initial pose, than 
%rotates it about the x-axis in the following sequence:
%+45° | pause 3s | +45° | pause 3s | -45° | pause 3s | -45° | pause 3s
myObject.x_axis_rotation();

%this command first moves the end-effector to the initial pose, than 
%rotates it about the y-axis in the following sequence:
%+45° | pause 3s | +45° | pause 3s | -45° | pause 3s | -45° | pause 3s
myObject.y_axis_rotation();

%this command first moves the end-effector to the initial pose, than 
%rotates it about the z-axis in the following sequence:
%+45° | pause 3s | +45° | pause 3s | -45° | pause 3s | -45° | pause 3s
myObject.z_axis_rotation();

%this command disconnects the PC from the Cobotta
myObject.disconnect_from_robot();


