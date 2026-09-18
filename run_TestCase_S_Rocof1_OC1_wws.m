clear all

Test.Name = 'S-Rocof1-OC1' 
Test.sim = 0; % if you have already save the data as S-Rocof1-OC1.mat, 
              % tunning the parameters of evenlope EXCELL Table with Test.sim = 0.
              % if Test.sim = 1, means the Simulink start to run. 
%==========================================================================
%% testcase configuration

Test.t_sim              = 8;    % simulation duration
Test.t_start            = 3;    % start time of test

% frequency step
Test.delta_f            = 0;    % frequency jump Hz;

% frequency ramp
Test.ramp_f_ROCOF       = -0.5;    % frequency ramp ROCOF HZ/s;
Test.ramp_f_duration    = 3;    % duration of ramp in s 

% voltage step
Test.delta_u            = 0;    % voltage jump in deg

% voltage dip
Test.delta_u_fault      = 0;    % voltage dip in p.u. for three phase fault

%phase jump
Test.delta_phi          = 0;    % phase angle jump in deg


%% grid properties

Test.x_trafo_pu = 0.05;
Test.x_grid1 = 0.1; % SCR = 10 value of x_grid1 should be always larger than x_grid2 for initalization
Test.r_grid1 = 0.02;
Test.x_grid2 = 0.1; % SCR = 2 or 10
Test.r_grid2 = 0.05;
Test.t_xgrid = 1.5;    % step time for grid impedance

%% run simulation

if Test.sim
    init;
    Test.simout=sim('AGI_hydrogen_test9.slx');

    %%% if you want to save your new simulation results,when the grid
    %%% properties is changed please active the follow code.

    save Test.Name Test 
  
else
    load([Test.Name,'.mat'])
end

%% Envelope for test specification - read from dycov CSV
% NOTE: Rocof tests are not available in dycov database for PCS_RTE-IGFM1
% Using saved envelope limits from .mat file or placeholders

if isfield(Test, 'Plim') && isstruct(Test.Plim)
    % Plim already loaded from saved .mat file
    fprintf('Using existing Plim data from loaded file.\n');
else
    % Try to load from dycov for IGFM4 if available
    % IGFM4 has Rocof tests available
    dycov_envelope_path = fullfile(pwd, '..', 'dyn-grid-compliance-verification', ...
        'docs', 'GFM_envelopes_curves', 'Envelopes', 'Underdamped', ...
        'PCS_RTE-IGFM4', 'S_Rocof1', 'OC1', ...
        'PCS_RTE-IGFM4.S_Rocof1.OC1.csv');
    
    if isfile(dycov_envelope_path)
        try
            [Test.Plim.t, Test.Plim.p_down, Test.Plim.p_up] = read_dycov_envelope(dycov_envelope_path);
            fprintf('Successfully loaded envelope from dycov (IGFM4): %s\n', dycov_envelope_path);
        catch ME
            fprintf('Warning: Could not load dycov envelope: %s\n', ME.message);
            Test.Plim.t = linspace(0, Test.t_sim, 1000)';
            Test.Plim.p_up = ones(size(Test.Plim.t)) * 1.5;
            Test.Plim.p_down = ones(size(Test.Plim.t)) * (-1.5);
        end
    else
        fprintf('Note: Rocof envelope not available in dycov for IGFM1. Using placeholder limits.\n');
        Test.Plim.t = linspace(0, Test.t_sim, 1000)';
        Test.Plim.p_up = ones(size(Test.Plim.t)) * 1.5;
        Test.Plim.p_down = ones(size(Test.Plim.t)) * (-1.5);
    end
end

%% Optional: Envelope properties (for reference)
% These were previously written to Excel for envelope tuning
% P0         = 0.09;  % initial Power in pu. 
% SCR        = 1/Test.x_grid2;  % SCR 2 or 10
% D          = 100;   % damping of PT2
% H          = 5;     % inertia (Ta = 2H)
% Xtr        = 0.06;  % transformer reactance
% Rocof_pu   = -0.01; % frequency ramp slope in pu
% If you need to adjust envelope limits, you can apply scaling factors here

%% plot results

% Only plot if we have simulation output data
if isfield(Test, 'simout') && ~isempty(Test.simout) && isstruct(Test.simout)
    figure;
    plot_Results_P(...
        Test.Name,...
        Test.simout.TestResult.P_GRID_pu.Time,...
        Test.simout.TestResult.P_GRID_pu.Data,...
        Test.t_start,...
        Test.Plim.t,...
        Test.Plim.p_up,...
        Test.Plim.p_down...
        );
else
    % Simout not available - just plot envelope limits
    fprintf('Simulation output (simout) not available. Plotting envelope limits only.\n');
    figure;
    plot(Test.Plim.t, Test.Plim.p_up, 'b-', 'LineWidth', 2); hold on;
    plot(Test.Plim.t, Test.Plim.p_down, 'r-', 'LineWidth', 2);
    xlabel('Time (s)');
    ylabel('Power (pu)');
    title(sprintf('Test: %s - Envelope Limits Only', Test.Name));
    legend('Upper limit', 'Lower limit');
    grid on;
end

% Save figure as PNG
figure_filename = sprintf('%s_envelope.png', Test.Name);
saveas(gcf, figure_filename);
fprintf('Plot saved to: %s\n', figure_filename);

%% save results
if Test.sim
    save(Test.Name,'Test')
end;