function modelo(Torque,j)
global Sim SimOutput_Plot ROV

ROVLoads(j);
n_dot = BF2NED(Sim.Current_X_Y_psi(3),Sim.Current_u_v_r);
v_dot = ROV.InverseInertia * (Torque - Sim.NetForces);

%% Double integration: accelerations -> velocities -> position/attitude
X = [n_dot; v_dot]; % Vetor de Estados

if(j==1)
    Aux(:,j) =  Sim.Ts*X;
    AuxVector = Aux(:,j);
else
    Aux(:,j) = Sim.Ts*X;
    AuxVector = (Aux(:,j-1) + 2*(Aux(:,j-1)+Aux(:,j)) + Aux(:,j))/6;
end

AuxVector = [Sim.Current_X_Y_psi;Sim.Current_u_v_r] + AuxVector;
AuxVector(3) = rem(AuxVector(3),2*pi);

%% REAL
Sim.Current_X_Y_psi = AuxVector(1:3);
Sim.Current_u_v_r   = AuxVector(4:6);
%%
% Armazena para PLOT
SimOutput_Plot.u_v_w(:, j)   = Sim.Current_u_v_r;
SimOutput_Plot.X_Y_psi(:, j) = Sim.Current_X_Y_psi;
