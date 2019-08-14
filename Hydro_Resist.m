%===========================================================================
% This function computes the Hydrodynamic Resistance D(v)v acting on the ROV
%===========================================================================

function [Results] = Hydro_Resist()

global ROV Sim;

% Alterações:
% Data: 01 de agosto de 2018
% Por quem: Marina
% O que: Inseri parâmetros que são utilizados  pelo modelo oficial do
% Fossen para 3 DOF e alterei a matriz de damping linear. 
% Inicialmente parâmetros foram chutados.

% Parametros de amortecimento linear
Xu = ROV.Xu;
Yv = ROV.Yv;
Yr = ROV.Yr;
Nv = ROV.Nv;
Nr = ROV.Nr;

% Alterações:
% Data: 08 de agosto de 2018
% Por quem: Marina
% O que: Inclusão matriz de damping não linear. 

% Parametros de amortecimento não linear
Xuu = ROV.Xuu;
Yvv = ROV.Yvv;
Yrv = ROV.Yrv;
Yvr = ROV.Yvr;
Yrr = ROV.Yrr;
Nvv = ROV.Nvv;
Nrv = ROV.Nrv;
Nvr = ROV.Nvr;
Nrr = ROV.Nrr;

% Velocidades
ur = Sim.Current_u_v_r(1);
vr = Sim.Current_u_v_r(2);
r  = Sim.Current_u_v_r(3);

%%  Matriz de amortecimento

% Equação 7.19 -- Fossen

D_lin =  [ -Xu       0        0; 
             0     -Yv      -Yr; 
             0     -Nv      -Nr];

% Equação 7.24 -- Fossen
D_non_lin = - [ Xuu*abs(ur)      0            0;
                    0       Yvv*abs(vr)    Yvr*abs(vr);
                    0       Nvv*abs(vr)    Nvr*abs(vr)];

% Equação 6.57 -- Fossen
DV = D_lin + D_non_lin;                      

%%
% Parte da Equação 8.1 -- Fossen
Results = DV*Sim.Current_u_v_r;

end