%% Grid-following AC-AGI
% Developer: Nils Wiese, Weiwei Shan, E2N- Uni Kassel
% Last modification: Dec. 2025
% MATLAB Version: R2024b

% Simulation parameters
Ts_Control = 1e-4;
Ts_Power = 5e-5;
ControlSampleTime = 1/8000;
Ts = ControlSampleTime;
HWSampleTime = ControlSampleTime/4;


SC_AGI = 25*10^3;
PV_AGI = 70*10^3;
Hy_AGI = 50*10^3;
% Total Apparent Power of AGI
S_AGI = SC_AGI %+PV_AGI+Hy_AGI;


%% LCL Hardware
LCL.SI.R1 = 50e-3;
LCL.SI.R2 = 20e-3;
LCL.SI.Rc = 5e-3;
LCL.SI.L1 = 0.5e-3;
LCL.SI.L2 = 0.25e-3;
LCL.SI.C  = 47e-6;

VSMCTRL.PU = pu(25e3, 400, 50*2*pi);

% % Prarameters Kp Ki of PLL
% PLL_Kp = 60; % in strong grid
% PLL_Ki = 1400; % in strong grid

PLL_Kp = 30;  % in weak grid
PLL_Ki = 100; % in weak grid

% % % without transformer for strong grid
% x_trafo_pu = 0.0062; 
% x_grid1 = 0;
% x_grid2 = 0;
%%%%the grid at t_set = 1.5s from strong grid SCR 10 to weak grid SCR 2
%%%%%%% when x_grid1 = x_grid2, there is not switch.
% t_set   =1.5; 
% r_grid1 = 0.001;
% r_grid2 = 0.001;
% Hy_current_Kp=   0.3/10;
% Hy_current_Ki =  20/10;

% % % % with transformer for strong grid
% x_trafo_pu = 0.05; % 
% x_grid1 = 0;
% x_grid2 = 0;
%%%%the grid at 1.5s from strong grid SCR 10 to weak grid SCR 2
%%%%%%% when x_grid1 = x_grid2, there is not switch. 
% t_set   = 1.5;
% r_grid1 = 0.001;
% r_grid2 = 0.001 ;
% Hy_current_Kp=   0.3;
% Hy_current_Ki =  20;

% % % with transforer for weak grid; 
Hy_current_Kp=   0.3;
Hy_current_Ki =  20;

%%%% SC VSM requirements setting
Q_ref_pu_VSM = 1; 

%%%  PV Q-U requirements setting
Q_PV_ref = [-0.5 -0.5 0 0.5 0.5];
U_PV_ref = [0.8 0.9 1 1.1 1.2];
%%% PV P-f requirements setting
P_PV_ref = [1 1 1 1];
f_PV_ref = [46 50.1 52 53];

%%%  Battery Q-U requirements setting
Q_Batt_ref = [-0.5 -0.5 0 0.5 0.5];
U_Batt_ref = [0.8 0.9 1 1.1 1.2];
%%% Battery P-f requirements setting
P_Batt_ref = [0.5 0.5 0 0 -0.5 -0.5];
f_Batt_ref = [46 47 49.9 50.1 52 53];
