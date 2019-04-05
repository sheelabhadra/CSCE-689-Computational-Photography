% Based on code by James Tompkin
%
% reads in a directory and parses out the exposure values
% files should be named like: "xxx_yyy.jpg" where
% xxx / yyy is the exposure in seconds. 

function [filePaths, exposures, numExposures] = ParseFiles(folderPath)   
    
list = dir(folderPath);
fileNames = setdiff({list.name}, {'.', '..'});
filePaths = strcat(strcat(folderPath, '/'), fileNames);
numExposures = length(fileNames);

exposures = zeros(numExposures, 1);

for i = 1 : numExposures
    fn = fileNames{i};
    [s, f] = regexp(fn, '(\d+)');
    nominator = fn(s(1):f(1));
    denominator = fn(s(2):f(2));
    exposure = str2double(nominator) / str2double(denominator);
    exposures(i) = exposure;
end

% sort by exposure
[exposures, indices] = sort(exposures, 'descend');
filePaths = filePaths(indices);
