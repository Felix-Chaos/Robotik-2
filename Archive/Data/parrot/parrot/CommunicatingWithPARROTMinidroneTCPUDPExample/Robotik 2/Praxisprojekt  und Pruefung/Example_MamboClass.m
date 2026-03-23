clear all; close all;

%instantiate an object from the MamboClass passing the name of the host
%model ('parrot_host'). The model needs to be available in the same folder
%as this script and the MamboClass file
my_mambo = MamboClass('parrot_host');

%connect to the mambo and start the controller model (the drone will start
%transmitting data via Bluetooth)
my_mambo.connect_to_mambo();

%start the host model which will receive the Bluetooth data received from
%the Drone. 
%The first argument defines the name of the matfile, to which
%the received sensor data shall be saved once the measurement is finished. 
%The second argument specifies the simulation duration (i.e. the stop time 
%of the model)
my_mambo.start_measurement('x_axis_rotation', 40);

% stop measurement using the corresponding MamboClass-method
my_mambo.stop_measurement();

%once all measurements are finished --> disconnect from mambo 
my_mambo.disconnect_from_mambo();

disp('All done.');
