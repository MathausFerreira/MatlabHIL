function AuxVector = Integra_modelo(X,j)

global Sim;

if(j==1)
    Aux(:,j) =  Sim.Ts*X;
    AuxVector = Aux(:,j);
else
    Aux(:,j) = Sim.Ts*X;
    AuxVector = (Aux(:,j-1) + 2*(Aux(:,j-1)+Aux(:,j)) + Aux(:,j))/6;
end