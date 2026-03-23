classdef RobotClass < handle
    properties
        ip_address % Property to store the IP address
        robot % Robot Controls
        cao % CaoEngine Object
        ws % CaoWorkspace Object
        ctrl_robot %CaoController Object
        initial_meas_pose = [220, -50, 300, 180, 0, 180]; % fixed defined measurement pose
    end

    methods
        % Method to initialize with IP address and connect robot
        function obj = RobotClass(ip_address)
            if ischar(ip_address) || isstring(ip_address)
                obj.ip_address = char(ip_address); % save IPAdress as String
                fprintf('IP-Adresse %s erfolgreich initialisiert.\n', obj.ip_address);

                %% Create a CaoEngine object
                obj.cao = actxserver('CAO.CaoEngine');
                % Create a CaoWorkspace object
                obj.ws = obj.cao.Workspaces.Item(int32(0));
                % Create a CaoController object
                obj.ctrl_robot = obj.ws.AddController('RC8', 'CaoProv.DENSO.RC8','',join(['server=',ip_address]));
                % Create Robot Controls
                obj.robot = obj.ctrl_robot.AddRobot('arm');
                obj.robot.Execute('TakeArm');
                obj.robot.Execute('motor', true);
                obj.robot.Speed(-1,100);
                fprintf('Roboter erfolgreich eingerichtet.\n');
            else
                error('Die IP-Adresse muss ein String sein.');
            end
        end

        % Method to disconnect robot
        function obj = disconnect_from_robot(obj)
            if isempty(obj.robot)
                error('Roboter nicht verbunden.');
            else
                % Motor off
                obj.robot.Execute('Motor', '0');
                % Release semaphore
                obj.robot.Execute('GiveArm');
                fprintf('Verbindung zum Roboter erfolgreich getrennt.\n');
            end
        end


        function obj =move2measurepos(obj)
            measurepos_str=obj.pose2Str(obj.initial_meas_pose);
            obj.robot.Move(1,measurepos_str)

            % Schleife, bis die Drohne gegriffen wurde
            while true
                % Eingabe des Benutzers abfragen
                user_input = input('Wurde die Drohne bereits vom Endeffektor gegriffen? (y für yes / n für no): ', 's');

                % Überprüfen der Benutzereingabe
                if strcmpi(user_input, 'y')
                    disp('Drohne wurde gegriffen. Fortfahren mit beliebiger Taste.');
                    break; % Schleife verlassen
                elseif strcmpi(user_input, 'n')
                    disp('Drohne wurde noch nicht gegriffen. Gripper wird geöffnet.');
                    obj.ctrl_robot.Execute('HandChuck',1);
                    fprintf('Positionieren sie die Drohne im Gripper. Bestätigen mit einer beliebigen Taste\n');
                    pause;
                    fprintf('Gripper schließt. Bitte warten ... \n');
                    obj.ctrl_robot.Execute('HandChuck',0);
                    fprintf('Drohne wurde gegriffen. Fortfahren mit beliebiger Taste \n');
                    pause;
                    break; % Schleife verlassen
                else
                    disp('Ungültige Eingabe. Bitte "y" für yes oder "n" für no eingeben.');
                end
            end


        end

        function obj =x_axis_rotation(obj)
            %Rotate the end effector by 45° with respect to the x-axis
            target_pose=obj.initial_meas_pose ;
            delta_joint=45;
            for i=1:4
                if(i<3)
                    target_pose(4)=target_pose(4)+delta_joint;
                else
                    target_pose(4)=target_pose(4)-delta_joint;
                end
                pose1_str=obj.pose2Str(target_pose);
                obj.robot.Move(2,pose1_str);
                pause(3);
            end
        end

        function obj =y_axis_rotation(obj)
            %Rotate the end effector by 45° with respect to the y-axis
            target_pose=obj.initial_meas_pose ;

            delta_joint=45;
            for i=1:4
                if(i<3)
                    target_pose(5)=target_pose(5)+delta_joint;
                else
                    target_pose(5)=target_pose(5)-delta_joint;
                end
                pose1_str=obj.pose2Str(target_pose);
                obj.robot.Move(2,pose1_str);
                pause(3);
            end
        end

        function obj =z_axis_rotation(obj)
            %Rotate the end effector by 45° with respect to the z-axis
            target_pose=obj.initial_meas_pose ;
            delta_joint=45;
            for i=1:4
                if(i<3)
                    target_pose(6)=target_pose(6)+delta_joint;
                else
                    target_pose(6)=target_pose(6)-delta_joint;
                end
                pose1_str=obj.pose2Str(target_pose);
                obj.robot.Move(2,pose1_str);
                pause(3);
            end
        end

        function obj =z_axis_translation(obj)
            %Translate the end effector by DeltaP with respect to the z-axis
            target_pose=obj.initial_meas_pose ;
            delta_trans=15;
            for i=1:4
                if(i<3)
                    target_pose(3)=target_pose(3)+delta_trans;
                else
                    target_pose(3)=target_pose(3)-delta_trans;
                end
                pose1_str=obj.pose2Str(target_pose);
                obj.robot.Move(2,pose1_str);
                pause(3);
            end
        end


        function pose=pose2Str(obj,X)
            pose=['P(',num2str(X(1)),',',num2str(X(2)),',',num2str(X(3)),','...
                ,num2str(X(4)),',',num2str(X(5)),',',num2str(X(6)),',',num2str(261),')'];

        end
    end
end