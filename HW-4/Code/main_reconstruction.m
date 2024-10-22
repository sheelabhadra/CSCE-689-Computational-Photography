clear; clc;

%%% Assignment 4 - Starter code

% Setting up the input output paths and the parameters
inputDir = '../Images/';
outputDir = '../Results/';

sceneName = '1_Bicycles';

% Parsing the input images to get the file names and corresponding exposure
% values
[filePaths, exposures, numExposures] = ParseFiles([inputDir, '/', sceneName]);

% Reconstruct the irradiance of the scene using Eq. 6 in the Debevec paper
load('gFunc.mat')
[imgH, imgW, nChannels] = size(imread(filePaths{1,1}));

P = numel(filePaths);

lERed = zeros([imgH*imgW, 1]);
lEGreen = lERed;
lEBlue = lERed;

for i=1:numel(lERed)
    temp_red = 0;
    temp_green = 0;
    temp_blue = 0;
    for j=1:P
        img = imread(filePaths{1,j});
        redChannel = img(:,:,1);
        redChannel = reshape(redChannel, [imgH*imgW,1]);
        greenChannel = img(:,:,2);
        greenChannel = reshape(greenChannel, [imgH*imgW,1]);
        blueChannel = img(:,:,3);
        blueChannel = reshape(blueChannel, [imgH*imgW,1]);
        temp_red = temp_red + (triangle_function(redChannel(i))*(gRed(redChannel(i)+1) - log(exposures(j))))/triangle_function(redChannel(i));
        temp_green = temp_green + (triangle_function(greenChannel(i))*(gGreen(greenChannel(i)+1) - log(exposures(j))))/triangle_function(greenChannel(i));
        temp_blue = temp_blue + (triangle_function(blueChannel(i))*(gBlue(blueChannel(i)+1) - log(exposures(j))))/triangle_function(blueChannel(i));
    end
    if mod(i, 10) == 0
        disp(i)
    end
    lERed(i) = temp_red;
    lEGreen(i) = temp_green;
    lEBlue(i) = temp_blue;
end

lERed = reshape(lERed, [imgH, imgW]);
lEGreen = reshape(lEGreen, [imgH, imgW]);
lEBlue = reshape(lEBlue, [imgH, imgW]);

% Tonemap the image using the global operator
resultRed = zeros([imgH, imgW]);
resultGreen = resultRed;
resultBlue = resultRed;

for i=1:imgH
    for j=1:imgW
        resultRed(i,j) = lERed(i,j)/(1 + lERed(i,j));
        resultGreen(i,j) = lEGreen(i,j)/(1 + lEGreen(i,j));
        resultBlue(i,j) = lEBlue(i,j)/(1 + lEBlue(i,j));
    end
end

% Tonemap the image using MATLAB's local operator

% Create the triangle function
function [w] = triangle_function(Z)
    if (Z >= 0) && (Z < 127.5)
        w = Z/127.5;
    else
        w = (255 - Z)/127.5;
    end
end