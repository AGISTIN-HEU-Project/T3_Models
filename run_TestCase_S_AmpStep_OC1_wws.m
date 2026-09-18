clear all

Test.Name = 'S-AmpStep-OC1_VSM' 
Test.sim = 0; % if you have already save the data as S-AmpStep-OC1.mat, 
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
    Test.simout=sim('VSM_standalone.slx');

 %%% if you want to save your new simulation results,when the grid
    %%% properties is changed please active the follow code.  
    save Test.Name Test 

else
    mat_file = [Test.Name, '.mat'];
    if isfile(mat_file)
        load(mat_file);
    else
        fprintf('Note: %s not found. Creating new test structure.\n', mat_file);
        % Continue without loaded data - envelope will be loaded separately
    end
end

%% Envelope for test specification - read from dycov CSV
% NOTE: Using VolAmpStep1 from IGFM2 as equivalent to AmpStep
% AmpStep tests are not available for PCS_RTE-IGFM1, but VolAmpStep1 (IGFM2) is used instead

if isfield(Test, 'Qlim') && isstruct(Test.Qlim)
    % Qlim already loaded from saved .mat file
    fprintf('Using existing Qlim data from loaded file.\n');
else
    % Try to read from dycov CSV file - using VolAmpStep1 as AmpStep equivalent
    dycov_envelope_path = fullfile(pwd, '..', 'dyn-grid-compliance-verification', ...
        'docs', 'GFM_envelopes_curves', 'Envelopes', 'Overdamped', ...
        'PCS_RTE-IGFM2', 'S_VolAmpStep1', 'OC1', ...
        'PCS_RTE-IGFM2.S_VolAmpStep1.OC1.csv');
    
    if isfile(dycov_envelope_path)
        try
            [Test.Qlim.t, Test.Qlim.q_down, Test.Qlim.q_up] = read_dycov_envelope(dycov_envelope_path);
            fprintf('Successfully loaded envelope from dycov (IGFM2 VolAmpStep1): %s\n', dycov_envelope_path);
        catch ME
            fprintf('Warning: Could not load dycov envelope: %s\n', ME.message);
            Test.Qlim.t = linspace(0, Test.t_sim, 1000)';
            Test.Qlim.q_up = ones(size(Test.Qlim.t)) * 1.5;
            Test.Qlim.q_down = ones(size(Test.Qlim.t)) * (-1.5);
        end
    else
        fprintf('Note: VolAmpStep1 envelope not available. Using placeholder limits.\n');
        Test.Qlim.t = linspace(0, Test.t_sim, 1000)';
        Test.Qlim.q_up = ones(size(Test.Qlim.t)) * 1.5;
        Test.Qlim.q_down = ones(size(Test.Qlim.t)) * (-1.5);
    end
end

%% Optional: Envelope properties (for reference)
% These were previously written to Excel for envelope tuning
% Q0         = 0;  % initial reactive Power in pu.
% SCR        = 1 /Test.x_grid2; % SCR = 2;   pu system!!!
% Xtr        = Test.x_trafo_pu  % transformer reactance
% If you need to adjust envelope limits, you can apply scaling factors here
%% plot results
% Only plot if we have simulation output data
if isfield(Test, 'simout') && ~isempty(Test.simout) && isstruct(Test.simout)
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
else
    % Simout not available - just plot envelope limits
    fprintf('Simulation output (simout) not available. Plotting envelope limits only.\n');
    figure;
    plot(Test.Qlim.t, Test.Qlim.q_up, 'b-', 'LineWidth', 2); hold on;
    plot(Test.Qlim.t, Test.Qlim.q_down, 'r-', 'LineWidth', 2);
    xlabel('Time (s)');
    ylabel('Reactive Power (pu)');
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