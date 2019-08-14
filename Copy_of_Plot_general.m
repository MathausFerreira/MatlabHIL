function Plot_general(Theta,FM,yaw,pose,i)
global ROV 
%% Função para plotar o barco com motores
% i      -> Indice da coluna da matriz com os valores Theta e F para todos os motores
% Theta  -> Matriz (ou Vetor) com os angulos de todos os motores
% FM     -> Matriz (ou Vetor) com as forças  de todos os motores
% yaw    -> Angulo de guinada do Barco
% pose   -> Posição xyz do veículo 
% Theta e PWM são organizados da seguinte maneira:
%                -------------------i--------------------
% Index          |1 | 2| 3| 4| 5| 6| 7| 8| 9|10|11|12|13|
% Theta_M1       |  |  |  |  |  |  |  |  |  |  |  |  |  |
% Theta_M2       |  |  |  |  |  |  |  |  |  |  |  |  |  |
% Theta_M3       |  |  |  |  |  |  |  |  |  |  |  |  |  |
% Theta_M4       |  |  |  |  |  |  |  |  |  |  |  |  |  |
yaw = -yaw;
Theta = -Theta;
%%

% Matriz de rotação para a posição dos motores
M_rotacao = [cos(yaw) -sin(yaw) 0; 
             sin(yaw)  cos(yaw) 0; 
                    0         0 1];
% plota o corpo do barco ( parte cinza)
PlotBarco(yaw,pose);

% motor 1 (superior DIREITO)
XYZ = M_rotacao * [(ROV.dcbby),ROV.Loa/4,0]';
PlotMotor(yaw + Theta(1,i),FM(1,i)*ROV.k1,pose,XYZ)

% motor 2 (inferior esquerdo)
XYZ = M_rotacao * [ROV.dceby,-ROV.Loa/4,0]';
PlotMotor(yaw + Theta(2,i),FM(2,i)*ROV.k1,pose,XYZ)

% motor 3 (superior esquerdo)
XYZ = M_rotacao * [(ROV.dceby),ROV.Loa/4,0]';
PlotMotor(yaw + Theta(3,i),FM(3,i)*ROV.k1,pose,XYZ)

% motor 4 (inferior direito)
XYZ = M_rotacao * [ROV.dcbby,-ROV.Loa/4,0]';
PlotMotor(yaw + Theta(4,i),FM(4,i)*ROV.k1,pose,XYZ);
% axis([-2 2 -4 4 0 1])
view(2)
end