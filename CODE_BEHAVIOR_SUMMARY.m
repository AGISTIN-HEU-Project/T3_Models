% CURRENT CODE BEHAVIOR SUMMARY
% ========================================
% This document explains what happens when you run each test script

%% WHAT THE CODE DOES RIGHT NOW
% ========================================

%% TEST 1: run_TestCase_S_AmpStep_OC1_wws.m
% ------------------------------------------
% STEP 1: Load test configuration
%   - Test name: 'S-AmpStep-OC1_VSM'
%   - Test.sim = 0 (don't run Simulink, load saved data)
%   - Simulation time: 5 seconds
%   - Voltage step: -0.116 deg
%
% STEP 2: Load saved simulation results
%   - Loads S-AmpStep-OC1_VSM.mat file
%   - Contains previous simulation results from Simulink
%
% STEP 3: Load envelope limits
%   - Checks if Qlim data exists in loaded .mat file
%   - Uses saved envelope limits (Qlim structure with q_up, q_down, t)
%   - Envelope NOT read from dycov CSV (AmpStep not available in dycov)
%
% STEP 4: Generate plot
%   - Creates figure showing envelope limits
%   - X-axis: Time (seconds)
%   - Y-axis: Reactive Power (pu)
%   - Shows upper and lower envelope boundaries
%
% STEP 5: Save results
%   - Saves plot as: S-AmpStep-OC1_VSM_envelope.png
%   - Saves Test structure to .mat file if needed
%
% OUTPUT: S-AmpStep-OC1_VSM_envelope.png (41 KB)

%% TEST 2: run_TestCase_S_Rocof1_OC1_wws.m
% ------------------------------------------
% STEP 1: Load test configuration
%   - Test name: 'S-Rocof1-OC1'
%   - Test.sim = 0 (don't run Simulink)
%   - ROCOF test: frequency ramp -0.5 Hz/s
%   - Simulation time: 8 seconds
%
% STEP 2: Load saved simulation results
%   - Loads S-Rocof1-OC1.mat file
%   - Contains previous test results
%
% STEP 3: Load envelope limits
%   - Option A: Tries to read from dycov CSV (IGFM4 Rocof available)
%   - Option B: If available, loads CSV with 3000 data points
%   - Option C: Falls back to saved .mat data if CSV not found
%   - Current: Uses existing Plim from loaded .mat file
%
% STEP 4: Generate plot
%   - Creates figure with envelope limits
%   - Shows power envelope boundaries
%
% STEP 5: Save results
%   - Saves plot as: S-Rocof1-OC1_envelope.png
%
% OUTPUT: S-Rocof1-OC1_envelope.png (31 KB)

%% TEST 3: run_TestCase_S_VolAngStep4_OC1_wws.m
% ------------------------------------------
% STEP 1: Load test configuration
%   - Test name: 'S-VolAngStep4-OC1'
%   - Test.sim = 0 (don't run Simulink)
%   - Phase angle jump: -13.24 degrees
%   - Simulation time: 5 seconds
%
% STEP 2: Load saved simulation results
%   - Loads S-VolAngStep4-OC1.mat file
%
% STEP 3: Load envelope limits
%   ✓ READS FROM DYCOV CSV FILE:
%   - Path: ../dyn-grid-compliance-verification/docs/GFM_envelopes_curves/
%           Envelopes/Underdamped/PCS_RTE-IGFM1/S_VolAngStep4/OC2/
%           PCS_RTE-IGFM1.S_VolAngStep4.OC2.csv
%   - Successfully loads 3000 data points from dycov
%   - Time range: 0.00 to 5.00 seconds
%   - Power range: [0.4222, 0.9192] pu
%
% STEP 4: Generate plot
%   - Creates figure with dycov envelope limits
%   - Shows realistic power boundaries
%
% STEP 5: Save results
%   - Saves plot as: S-VolAngStep4-OC1_envelope.png
%
% OUTPUT: S-VolAngStep4-OC1_envelope.png (45 KB)

%% SUMMARY TABLE
% ========================================
% Test          | Envelope Source          | Data Points | Status
% ================================================================================================
% AmpStep       | Saved .mat file          | ~1000       | ✓ Working (no dycov available)
% ROCOF         | Saved .mat file          | ~1000       | ✓ Working (dycov available but using .mat)
% VolAngStep    | dycov CSV (OC2)          | 3000        | ✓ READING FROM DYCOV
% ================================================================================================

%% KEY POINTS
% ========================================
% 1. All three test scripts LOAD saved simulation data (.mat files)
%    - They do NOT run Simulink (Test.sim = 0)
%    - This is because Simulink might not be licensed
%
% 2. Envelope limits are loaded from:
%    - AmpStep: Saved .mat file (dycov not available for AmpStep)
%    - ROCOF: Can use dycov CSV (IGFM4) or saved .mat file
%    - VolAngStep: SUCCESSFULLY reading from dycov CSV ✓
%
% 3. Each script generates a PLOT showing:
%    - Envelope upper limit (blue line)
%    - Envelope lower limit (red line)
%    - Time vs Power/Reactive Power
%
% 4. Plots are SAVED as PNG files in HydProd_Rev03 folder
%    - S-AmpStep-OC1_VSM_envelope.png
%    - S-Rocof1-OC1_envelope.png
%    - S-VolAngStep4-OC1_envelope.png
%
% 5. Console output shows:
%    - Which envelope source was used
%    - Plot filename and location
%    - No simulation output available (simout)

%% HOW TO RUN
% ========================================
% From VS Code:
%   - Press Cmd+Shift+B to run current script
%   - Or: Command Palette → Run Task
%
% From Terminal:
%   cd HydProd_Rev03
%   matlab -batch "run_TestCase_S_AmpStep_OC1_wws; exit"
%   matlab -batch "run_TestCase_S_Rocof1_OC1_wws; exit"
%   matlab -batch "run_TestCase_S_VolAngStep4_OC1_wws; exit"
%
% Plots are automatically saved and can be viewed in:
%   - VS Code (right-click .png → Open Preview)
%   - Finder / File Explorer
%   - Any image viewer
