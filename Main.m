%% HARDWARE IN THE LOOP WITH MAVLINK MESSAGE

clear; clc; close all; instrreset;

%% Comunicação Serial
serial_port_name = 'COM6';
serial_baud_rate = 115200;

% DO NOT CHANGE BELOW THIS POINT
parse = parser();

% Open serial connection
s_port = serial(serial_port_name);
s_port.BaudRate = serial_baud_rate;
s_port.InputBufferSize = 10000;
%% Definição variaveis
% Variavel para controle de posição no vetor
j = 1 ;
FM = [];
yaw = 0;
Theta = [];
PNED= 0;
CNT = 0;
SYS = 0;
GLP = 0;
%% Boat Physical properties
PhysicalProperties

try
    fopen(s_port);
    flushinput(s_port);
    % t = tic;
    while 1 %toc(t) < 30
        if s_port.BytesAvailable > 500
            b = fread(s_port,s_port.BytesAvailable);
            [parse, msg] = parse.byte_stream(b');
            for i = 1:length(msg)
                %fprintf( 'Msg (%d) %s\n', msg{i}.get_msgid(), class(msg{i})); %Debug
                if msg{i}.get_msgid() == common.MAVLINK_MSG_ID_LOCAL_POSITION_NED
                    PNED = 1;
                    mensagem = msg{i};
                    pose(1,j) = (mensagem.get_prop_x);
                    pose(2,j) = (mensagem.get_prop_y);
                    pose(3,j) = 0*(mensagem.get_prop_z);
                end
                
                if msg{i}.get_msgid() == common.MAVLINK_MSG_ID_GLOBAL_POSITION_INT
                    GLP = 1;
                    mensagem = msg{i};
                    yaw(1,j) = double((mensagem.prop_hdg/100))*(pi/180);
                end
                
                if msg{i}.get_msgid() == common.MAVLINK_MSG_ID_SYS_STATUS
                    SYS = 1;
                    mensagem = msg{i};
                    FM(1,j) = mensagem.get_errors_count1/10;
                    FM(2,j) = mensagem.get_errors_count2/10;
                    FM(3,j) = mensagem.get_errors_count3/10;
                    FM(4,j) = mensagem.get_errors_count4/10;
                end
                
                if msg{i}.get_msgid() == common.MAVLINK_MSG_ID_NAV_CONTROLLER_OUTPUT
                    CNT = 1;
                    mensagem = msg{i};
                    Theta(1,j) = double(mensagem.get_prop_nav_roll/100)*(pi/180);
                    Theta(2,j) = double(mensagem.get_prop_nav_pitch/100)*(pi/180);
                    Theta(3,j) = double(mensagem.get_prop_nav_bearing/100)*(pi/180);
                    Theta(4,j) = double(mensagem.get_prop_target_bearing/100)*(pi/180);
                end
                
                if (CNT & SYS & GLP & PNED)
                    PNED= 0;
                    CNT = 0;
                    SYS = 0;
                    GLP = 0;
                    figure(1)
                    if( length(pose(1,:))>10)
                        plot(pose(1,end-10:end),pose(2,end-10:end),'+r');
                        hold on;
                    end
                    Plot_general(Theta(:,j),FM(:,j),yaw(1,j),pose(:,j),1)
                    j = j+1;
                end
            end
            stats = parse.get_stats();
            %fprintf( 'Total Msg: %d\t Msg Errors: %d\t Unknown Msg:%d\n',stats.total, stats.errors, stats.unknown);%Debug
        end
    end
    fclose(s_port);
    
catch exception
    fprintf('PORTA USB NÂO CONECTADA!\n')
end
