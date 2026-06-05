clear all

Test.Name = 'S-AmpStep-OC1_VSM' 
Test.sim = 1; % if you have already save the data as S-AmpStep-OC1.mat, 
              % tunning the parameters of evenlope EXCELL Table with Test.sim = 0.
              % if Test.sim = 1, means the Simulink start to run. 
%==========================================================================
%% testcase configuration

Test.t_sim              = 5;    % simulation duration
Test.t_start            = 3;    % start time of test

% frequency step
Test.delta_f            = 0;    % frequency jump Hz;

% frequency ramp
Test.ramp_f_ROCOF       = 0;    % frequency ramp ROCOF HZ/s;
Test.ramp_f_duration    = 3;    % duration of ramp in s 

% voltage step
Test.delta_u            = -0.116;    % voltage jump in deg -> in current limit?

% voltage dip
Test.delta_u_fault      = 0;    % voltage dip in p.u. for three phase fault

%phase jump
Test.delta_phi          = 0;    % phase angle jump in deg

%% initial operating point
Q0         = 0;
P0         = 0;
 
%% grid properties

Test.x_trafo_pu = 0.05;
Test.x_grid1 = 0.1; %% SCR = 10, value of x_grid1 should be always larger than x_grid2 for initalization
Test.r_grid1 = 0.02;
Test.x_grid2 = 0.1; %% SCR = 2 or 10;
Test.r_grid2 = 0.05;
Test.t_xgrid = 1.5;    % step time for grid impedance

%% run simulation

if Test.sim
    init;
%    Test.simout=sim('AGI_hydrogen_test9.slx');
    Test.simout=sim('VSM_standalone_23a.slx');

 %%% if you want to save your new simulation results,when the grid
    %%% properties is changed please active the follow code.  
    save Test.Name Test 

else
    load([Test.Name,'.mat']);
end

%% Envelope for test specification - read from dycov CSV
% Path to dycov envelope CSV file
% Users can modify this path to select different test cases and operating conditions
% Available locations: 
%   - Overdamped or Underdamped conditions
%   - Different producers (PCS_RTE-IGFM1, PCS_RTE-IGFM2, etc.)
%   - Different test cases (S_VolAngStep, S_Rocof, etc.)
%   - Different operating conditions (OC1, OC2, OC3, etc.)

% Example for Voltage Angle Step test, Overdamped, OC1:
dycov_envelope_path = fullfile(pwd, '..', 'dyn-grid-compliance-verification', ...
    'docs', 'GFM_envelopes_curves', 'Envelopes', 'Overdamped', ...
    'PCS_RTE-IGFM1', 'S_VolAngStep2', 'OC1', ...
    'PCS_RTE-IGFM1.S_VolAngStep2.OC1.csv');

% Read envelope data from dycov CSV file
try
    [Test.Qlim.t, Test.Qlim.q_down, Test.Qlim.q_up] = read_dycov_envelope(dycov_envelope_path);
    fprintf('Successfully loaded envelope from: %s\n', dycov_envelope_path);
catch ME
    error('Failed to load envelope CSV file.\nPath: %s\nError: %s', dycov_envelope_path, ME.message);
end

%% Optional: Envelope properties (for reference)
% These were previously written to Excel for envelope tuning
% Q0         = 0;  % initial reactive Power in pu.
% SCR        = 1 /Test.x_grid2; % SCR = 2;   pu system!!!
% Xtr        = Test.x_trafo_pu  % transformer reactance
% If you need to adjust envelope limits, you can apply scaling factors here
%% plot results
figure;
plot_Results_Q(...
    Test.Name,...
    Test.simout.TestResult.Q_GRID_pu.Time,...
    Test.simout.TestResult.Q_GRID_pu.Data,...
    Test.t_start,...
    Test.Qlim.t,...
    Test.Qlim.q_up,...
    Test.Qlim.q_down...
    );

%% save results
if Test.sim
    save(Test.Name,'Test')
end;