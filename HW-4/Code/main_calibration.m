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
N = 5*256/(numel(filePaths)-1);
[imgH, imgW] = size(imread(filePaths{1,1}));
Z = zeros(imgH*imgW, numel(filePaths));

for j=1:numel(filePaths)
    img = imread(filePaths{1,j});
    img = reshape(img, [imgH*imgW,1]);
    for i=1:N/numel(filePaths) + 1
        k = randi([1, imgH*imgW]);
        Z(i,j) = img(k);
    end
end

% Recover the camera response function using Debevec's optimization code (gsolve.m)
[g, lE] = gsolve(Z, exposures, lambda, @triangle_function, Zmin, Zmax);

% Create the triangle function
function [w] = triangle_function(Z)
    if Z >= 0 && Z < 127.5
        w = Z/127.5;
    else
        w = (255 - Z)/127.5;
    end
end


