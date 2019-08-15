%% HARDWARE IN THE LOOP WITH MAVLINK MESSAGE

clear; clc; close all; instrreset;

%% Comunicação Serial
serial_port_name = 'COM6';
serial_baud_rate = 115200;

% DO NOT CHANGE BELOW THIS POINT
parse = parser();

% Open serial connection
s_port                 = serial(serial_port_name);
s_port.BaudRate        = serial_baud_rate;
s_port.InputBufferSize = 10000;

%% Definição de Variaveis
j     = 1 ;
FM    = [];
Theta = [];
yaw   = 0;
PNED  = 0;
CNT   = 0;
SYS   = 0;
GLP   = 0;
ATT   = 0;
t     = 0;
time  = 0;
%% Initialisation
Initialisation;

%% Boat Physical properties
PhysicalProperties

%% Variavel Global
global Sim;

try
    % Tenta abri a comunicação na porta serial
    fopen(s_port);
    fprintf('PORTA USB CONECTADA!\n')
catch exception
    % Caso não consiga, envia uma mensagem de erro
    fprintf('PORTA USB NAO CONECTADA!\n')
end

flushinput(s_port);
% t = tic;
while 1 %toc(t) < 30
    if s_port.BytesAvailable > 500
        b = fread(s_port,s_port.BytesAvailable);
        [parse, msg] = parse.byte_stream(b');
        for i = 1:length(msg)
            if msg{i}.get_msgid() == common.MAVLINK_MSG_ID_SYS_STATUS
                SYS = 1;
                mensagem = msg{i};
                FM      = [double(mensagem.get_errors_count1/10);
                           double(mensagem.get_errors_count2/10);
                           double(mensagem.get_errors_count3/10);
                           double(mensagem.get_errors_count4/10)];
            end
            
            if msg{i}.get_msgid() == common.MAVLINK_MSG_ID_NAV_CONTROLLER_OUTPUT
                CNT = 1;
                mensagem = msg{i};
                Theta      = [double(mensagem.get_prop_nav_roll/100)*(pi/180);
                              double(mensagem.get_prop_nav_pitch/100)*(pi/180);
                              double(mensagem.get_prop_nav_bearing/100)*(pi/180);
                              double(mensagem.get_prop_target_bearing/100)*(pi/180)];
            end
            %% Descomentar essa parte pra usar o tempo da PLACA
            if msg{i}.get_msgid() == common.MAVLINK_MSG_ID_ATTITUDE
                mensagem = msg{i};
                time = double(mensagem.get_prop_time_boot_ms)/1000;
                if ATT
                    Sim.Ts = time - t;
                    Sim.Ts
                    t = time;
                end
                ATT = 1;
            end
            %%
            if (CNT & SYS)
                CNT = 0;SYS = 0;
                
                Sim.PWM(:,j)   = FM;
                Sim.Theta(:,j) = Theta;
                
                %  Forças e torques dos controladores
                Torque = DirAllocationMatrix(FM,Theta);
                
                % Variavel para Plot
                Sim.F_out(:,j) = Torque;
                
                % Modelo do veículo
                modelo(Torque,j);
                
                %% plot da Figura
                Plot_general(Theta,FM,Sim.Current_X_Y_psi(3),[Sim.Current_X_Y_psi(1:2);0],1)
%                 Plot_general(Sim.Theta(:,j),Sim.PWM(:,j),Sim.Current_X_Y_psi(3),[Sim.Current_X_Y_psi(1:2,j);0],1)
                drawnow
                j = j+1;
            end
        end
        stats = parse.get_stats();
        %fprintf( 'Total Msg: %d\t Msg Errors: %d\t Unknown Msg:%d\n',stats.total, stats.errors, stats.unknown);%Debug
    end
end
fclose(s_port);