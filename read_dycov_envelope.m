function [time, lower_limit, upper_limit] = read_dycov_envelope(csv_file_path)
% READ_DYCOV_ENVELOPE Read envelope data from dycov-generated CSV file
%
% USAGE:
%   [time, lower_limit, upper_limit] = read_dycov_envelope(csv_file_path)
%
% INPUT:
%   csv_file_path : Full path to the dycov envelope CSV file
%                   (e.g., '.../Overdamped/PCS_RTE-IGFM1/S_VolAngStep2/OC2/PCS_RTE-IGFM1.S_VolAngStep2.OC2.csv')
%
% OUTPUT:
%   time         : Time vector in seconds (column 1)
%   lower_limit  : Lower envelope limit in pu (column 3, 'lower')
%   upper_limit  : Upper envelope limit in pu (column 4, 'upper')
%
% NOTE:
%   dycov CSV files use semicolon (;) as delimiter and contain:
%   - Column 1: Time (s)
%   - Column 2: P/Q nominal value (pu)
%   - Column 3: P/Q lower limit (pu)
%   - Column 4: P/Q upper limit (pu)

    % Check if file exists
    if ~isfile(csv_file_path)
        error('File not found: %s', csv_file_path);
    end
    
    % Read the CSV file with semicolon delimiter
    % Use readtable for better handling of headers
    opts = detectImportOptions(csv_file_path);
    opts.Delimiter = ';';
    data_table = readtable(csv_file_path, opts);
    
    % Extract columns by index (first row is header)
    % Column 1: Time
    % Column 3: Lower limit
    % Column 4: Upper limit
    time = table2array(data_table(:, 1));
    lower_limit = table2array(data_table(:, 3));
    upper_limit = table2array(data_table(:, 4));
end
