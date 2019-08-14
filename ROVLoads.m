%==========================================================================
% This function computes the net forces and moments acting on the ROV
%==========================================================================
function ROVLoads(stp)
% Numero de amostras para o filtro
N = 1;
% Global variable(s)
global Sim SimOutput_Plot Torque;

% Converts forces and moments which stem from the weight force from the NED frame to the BF frame, where g = 9.80665 [m/s^2] is the accel. of gravity
g_n = zeros(3,1);

% Hydrodynamic Resistance D(v)v
D_V = Hydro_Resist(); % Parte da Equação 7.06 -- Fossen

% Coriolis Effects C(v)v
Coriolis = Coriolis_Effect_Cat(); % Parte da Equação 7.06 -- Fossen 

% Totals the net forces and moments
% % alocação de forças pela tecnica do Leo 
% [Sim.F_out(:,stp+1),Sim.PWM(:,stp+1),Sim.Theta(:,stp+1)] = Leonardo(Sim.PWM(:,stp),Sim.Theta(:,stp),Sim.F(:,stp),10);
% 
%         if(stp>N)
%             Sim.PWM(:,stp+1)   = Moving_Average(Sim.PWM,N,stp+1);
%             Sim.Theta(:,stp+1) = Moving_Average(Sim.Theta,N,stp+1);
%             
%              Sim.F_out(:,stp+1) = DirAllocationMatrix(Sim.PWM(:,stp+1),Sim.Theta(:,stp+1));
%         end
%         
% 
% % Dinamica de atraso do servo
% % [Sim.F_out(:,stp+1),Sim.PWM(:,stp+1),Sim.Theta(:,stp+1)] = PWM_MotorsAndServos_Dynamics_TRUAV((stp+1),Sim.PWM,Sim.Theta);
% 
% Torque = Sim.F_out(:,stp);

% Sim.NetForcesAndMoments = Torque - D_V - Coriolis - g_n; % parte da equação 3.69 (segundo parentesis)
Sim.NetForces = D_V + Coriolis + g_n; % parte da equação 3.69 (segundo parentesis)

% Saves this(these) result(s) for later use
SimOutput_Plot.NetForcesAndMoments(:, stp) = Sim.NetForces;

SimOutput_Plot.Theta(:,stp)  = Sim.Theta(:,stp);
SimOutput_Plot.PWM(:,stp)    = Sim.PWM(:,stp);