%% Test dycov CSV Reading Implementation

clear all
fprintf('=== DYCOV CSV Reading Test ===\n\n');

Test.Name = 'S-VolAngStep4-OC1';
Test.t_sim = 5;

% Construct the dycov envelope path
dycov_envelope_path = fullfile(pwd, '..', 'dyn-grid-compliance-verification', ...
    'docs', 'GFM_envelopes_curves', 'Envelopes', 'Underdamped', ...
    'PCS_RTE-IGFM1', 'S_VolAngStep4', 'OC2', ...
    'PCS_RTE-IGFM1.S_VolAngStep4.OC2.csv');

fprintf('Expected path:\n  %s\n\n', dycov_envelope_path);

% Check if file exists
if isfile(dycov_envelope_path)
    fprintf('✓ CSV FILE FOUND!\n\n');
    
    % Try to read the CSV
    try
        [t, lower, upper] = read_dycov_envelope(dycov_envelope_path);
        fprintf('✓ Successfully read dycov CSV!\n');
        fprintf('  - Data points: %d\n', length(t));
        fprintf('  - Time range: %.2f to %.2f seconds\n', min(t), max(t));
        fprintf('  - Power range: [%.4f, %.4f] pu\n', min(lower), max(upper));
        fprintf('\nImplementation Status: ✓ WORKING PROPERLY\n');
    catch ME
        fprintf('✗ Error reading CSV: %s\n', ME.message);
        fprintf('\nImplementation Status: ✗ FAILED (reading error)\n');
    end
else
    fprintf('✗ CSV FILE NOT FOUND!\n');
    fprintf('\nImplementation Status: ✗ FAILED (file not found)\n');
end
