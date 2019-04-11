clear; clc;

%%% Assignment 4 - Starter code

% Setting up the input output paths and the parameters
inputDir = '../Images/';
outputDir = '../Results/';

sceneName = '1_Bicycle';

% Parsing the input images to get the file names and corresponding exposure
% values
[filePaths, exposures, numExposures] = ParseFiles([inputDir, '/', sceneName]);

% Reconstruct the irradiance of the scene using Eq. 6 in the Debevec paper
lE = zeros(size(imread(sceneName)));

% Tonemap the image using the global operator


% Tonemap the image using MATLAB's local operator

% Create the triangle function
function [w] = triangle_function(Z)
    if Z >= 0 && Z < 127.5
        w = Z/127.5;
    else
        w = (255 - Z)/127.5;
    end
end