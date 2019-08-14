function [] = PlotMotor(yaw,forca,pose,xyz_motor)  

%% Fator de escala força
sc = 100;

% tamanho helice
t = .5;
% tamanho motor
tm = .5;
% espessura
d = 0.02;

% ajuste para o plote
% yaw =-yaw;

%Decomposição de Forças
Fx = 0 ;%*cos(yaw);
Fy = forca;% *sin(yaw);
Fz = 0;
%Vetor de forças
FX = [0 sc*Fx];
FY = [0 sc*Fy];
FZ = [0 sc*Fz];

% Matriz de rotação em Z
M_Z = [cos(yaw) -sin(yaw) 0;
       sin(yaw)  cos(yaw) 0;
       0            0    1];
M_rotacao = [M_Z [xyz_motor(1);xyz_motor(2);xyz_motor(3)]; 0 0 0 1];

% Rotacao das forças
FF = M_rotacao * [FX;FY;FZ;ones(1,2)];

% Helice 
xd = [-t  t  t -t];
yd = [-d -d  d  d];
zd = [ 0  0  0  0];

% Motor
xd1 = [-tm/3 tm/3 tm/3 -tm/3];
yd1 = [-tm/2 -tm/2 tm/2 tm/2];
zd1 = [0 0 0 0];

% Rotação helice
XY = M_rotacao * ([xd ;(yd+tm/2); zd; ones(1,length(xd))]);

% Rotação motor
M  = M_rotacao * ([xd1;yd1;zd1; ones(1,length(xd1))]);
%%
 hold on
% Motor
fill3(pose(1)+ M(1,:),pose(2)+M(2,:),pose(3)+M(3,:),[1 1 0.5],'linewidth',1)
% Helice
fill3(pose(1)+XY(1,:), pose(2)+XY(2,:),pose(3)+XY(3,:),[0 1 1],'linewidth',1)
% Força
plot3(pose(1)+FF(1,:), pose(2)+FF(2,:), pose(3)+FF(3,:),'r','linewidth',2);

axis equal
hold off

end