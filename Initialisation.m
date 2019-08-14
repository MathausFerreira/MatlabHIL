%==========================================================================
% This function closes all figures and clears all variables and functions
% from memory at first; then it initialises i) the data structure that
% stores the newest simulation data, ii) the data structure that stores the
% control data, and iii) the data structure that stores the simulation out-
% put
%==========================================================================
function Initialisation

%% Closes all figures and clears all variables and functions from memory
close all; clear all; clc;
% format short;
%% Global variable(s)
global Ctrl numFig Sim SimOutput_Plot Time;
%% Initialises figure counter
numFig = 1;

% Total simulation time [s]
tFinal = 400;
% Integration step / sampling period [s]
Ts = 0.01*10;

%% Creates the simulation time vector
Time = 0:Ts:tFinal;

%% Newest simulation data structure (Sim)
Current_X_Y_psi = zeros(3, 1);
Current_u_v_r   = zeros(3, 1);

%% Control data structure (Ctrl)

errIXPrev = 0;
errPXPrev = 0;

errIYPrev = 0;
errPYPrev = 0;

errIYawPrev = 0;
errPYawPrev = 0;

% Controle de Posição
kPX = 0.5;
kIX = 0.0;
kDX = 1;

kPY = 3.5;
kIY = 0.0;
kDY = 0;

kPYaw = 2;
kIYaw = 0.0;
kDYaw = 0.0;

%% Simulation output data structure (SimOutput_Plot)
NetForcesAndMoments = [];
X_Y_psi             = [];
u_v_w               = [];

% Angulo de cada Motor
Current_theta =[0;0;0;0];
Current_pwm = ones(4,1);

F = zeros(3,1);
PWM = ones(4,1);
Theta = zeros(4,1);

% PositionAndAttitude
SimOutput_Plot = struct('NetForcesAndMoments', NetForcesAndMoments, 'X_Y_psi', ...
    X_Y_psi, 'u_v_w', u_v_w);

Sim = struct('Name', 'Newest simulation data (Sim)','Current_X_Y_psi', ...
    Current_X_Y_psi,'F',F,'Current_u_v_r', Current_u_v_r,'tFinal', ...
    tFinal,'Ts', Ts,'Current_theta',Current_theta,'Current_pwm',Current_pwm,'PWM',PWM,...
    'Theta',Theta);

Ctrl = struct('kPX',kPX,'kIX',kIX,'kDX',kDX,'kPY',kPY,'kIY',kIY,'kDY',kDY,...
    'kPYaw',kPYaw,'kIYaw',kIYaw,'kDYaw',kDYaw,'errIXPrev',errIXPrev,'errIYPrev',errIYPrev,...
    'errPXPrev',errPXPrev,'errPYPrev',errPYPrev,'errIYawPrev',errIYawPrev,'errPYawPrev',errPYawPrev);