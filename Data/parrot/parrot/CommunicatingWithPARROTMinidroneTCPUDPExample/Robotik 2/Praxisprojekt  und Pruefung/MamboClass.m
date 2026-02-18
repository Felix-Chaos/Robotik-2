classdef MamboClass < handle
    properties
        model;      %name of the simulink model
        matfile;    %name of the output matfile
        sim_in;     %simulation-input objekt
        app_handle; %handle to flight interface app
        F;          %"Future object" returned by parfeval (parallel toolbox)
    end

    methods
        function obj = MamboClass(simulink_model_name)
            if ~ischar(simulink_model_name) && ~isstring(simulink_model_name)
                error('simulink_model_name must be a string.');
            end

            obj.model = simulink_model_name;
        end

        function [obj] = connect_to_mambo(obj)
            h = findall(0, 'Type', 'figure', 'Name', 'Parrot Flight Control Interface');
            if  ~isempty(h)
                close(h);  % Close the app if it is already opened (clean start)
            end
            
            obj.app_handle = Parrot_FlightInterface();
            obj.app_handle.Start.ValueChangedFcn(obj.app_handle.Start, []);
        
            % wait until start button changes to stop button 
            % (indicating that the drone has been started)
            wait_cycles = 0;
            timeout_lim = 10; % seconds
            while  ~strcmp(obj.app_handle.Stop.Enable, 'on')
                disp('Waiting for drone to start...');
                pause(1); 
                if wait_cycles < timeout_lim
                    wait_cycles = wait_cycles + 1;
                else
                    error(['timeout occurred while waiting for Bluetooth ' ...
                        'connnection to drone. Check if the PC is connected to ' ...
                        'the drone and retry.']);
                end
            end            
        end

        function [obj] = disconnect_from_mambo(obj)            
            % stop controller model
            obj.app_handle.Stop.ButtonPushedFcn(obj.app_handle.Stop, []) 
                        
            disp('disconnected');
        end

        function [obj] = start_measurement(obj, output_file, duration)
            % @param output_file:  name of mat-file, to which
            %                      outputdata shall be stored
            if ~ischar(output_file) && ~isstring(output_file)
                error('output_file must be a string.');
            end
            obj.matfile = output_file;
            
            % Load model
            disp(['Loading Simulink model "', obj.model, '"...']);
            load_system(obj.model);
            
            % Set simulation time parameters
            start_time = 0;
            % Maximum simulation time in seconds befor processing stops
            end_time = duration;  
            
            % Set model parameters programmatically
            obj.sim_in = Simulink.SimulationInput(obj.model);
            obj.sim_in = obj.sim_in.setModelParameter('StartTime', num2str(start_time), 'StopTime', num2str(end_time));
            
            % Run the simulation in the background
            disp("Starting simulation in background (Parallel Computing Toolbox required!)...");
            obj.F = parfeval(@sim, 1, obj.sim_in);

            pause(5);
            
            disp('Simulation is running!');
        end


        function [obj] = stop_measurement(obj)
            % Retrieve the results after completion
            sim_results = fetchOutputs(obj.F);

            rx_data = sim_results.rx_data;
            save(obj.matfile,'rx_data');

            disp(['Data saved into ' obj.matfile '.mat.']);
            
            %stop simulink model (run by parallel processing toolbox)
            cancel(obj.F);
        end

        function [ret_is_running] =  is_running(obj)
            ret_is_running = ~strcmp(obj.F.State, 'finished');
        end
    end
end