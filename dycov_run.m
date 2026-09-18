cmd = ['wsl -d DycovApp dycov generateEnvelopes ' ...
    '-i /home/dycov_user/DyCov_projects/dyn-grid-compliance-verification/examples/GFM/Fusion/Producer.ini -o /home/dycov_user/DyCov_projects/dyn-grid-compliance-verification/examples/GFM/Fusion/Results'];
status = system(cmd);

if status ==0
    disp("DyCov finshed sucessfully")
else
    error("DyCov failed")
end 

csvFile = "\\wsl$\DycovApp\home\" + ...
    "dycov_user\DyCov_projects\dyn-grid-compliance-verification" + ...
    "\examples\GFM\Fusion\Results\PCS_RTE-IGFM1\S_VolAngStep1\OC1\" + ...
    "PCS_RTE-IGFM1.S_VolAngStep1.OC1.csv";

data = readtable(csvFile);

disp("Column names")
disp("data.Properties.VariableNames")

head(data)

plot(data{:,1},data{:,3},data{:,1},data{:,4});

