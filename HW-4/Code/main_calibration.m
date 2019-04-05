clear; clc; 

%%% Assignment 4 - Starter code

% Setting up the input output paths and the parameters
inputDir = '../Images/';
outputDir = '../Results/';

lambda = 50;
Zmin = 0;
Zmax = 255;

calibSetName = '0_Calib_Chapel';

% Parsing the input images to get the file names and corresponding exposure
% values
[filePaths, exposures, numExposures] = ParseFiles([inputDir, '/', calibSetName]);


% Sample the images


% Create the triangle function


% Recover the camera response function using Debevec's optimization code (gsolve.m)

    

