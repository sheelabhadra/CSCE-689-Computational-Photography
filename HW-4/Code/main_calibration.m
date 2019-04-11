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
% s = RandStream('mlfg6331_64');
rng(7);
[imgH, imgW, nChannels] = size(imread(filePaths{1,1}));
N = 5*256/(numel(filePaths)-1);
N_per_image = ceil(N/numel(filePaths));
Zred = zeros(N_per_image, numel(filePaths));
Zgreen = Zred;
Zblue = Zred;

for j=1:numel(filePaths)
    img = imread(filePaths{1,j});
    redChannel = img(:,:,1); % R-channel
    redChannel = reshape(redChannel, [imgH*imgW,1]);
    greenChannel = img(:,:,2); % G-channel
    greenChannel = reshape(greenChannel, [imgH*imgW,1]);
    blueChannel = img(:,:,3); % R-channel
    blueChannel = reshape(blueChannel, [imgH*imgW,1]);
    
%     random_pixels = randi(s, 1:imgH*imgW, N_per_image, 'replacement', false);
    for i=1:N_per_image
        k = randi([1, imgH*imgW]);
        Zred(i,j) = redChannel(k);
        Zgreen(i,j) = greenChannel(k);
        Zblue(i,j) = blueChannel(k);
    end
end

% Recover the camera response function using Debevec's optimization code (gsolve.m)
[gRed, lERed] = gsolve(Zred, exposures, lambda, @triangle_function, Zmin, Zmax);
[gGreen, lEGreen] = gsolve(Zgreen, exposures, lambda, @triangle_function, Zmin, Zmax);
[gBlue, lEBlue] = gsolve(Zblue, exposures, lambda, @triangle_function, Zmin, Zmax);

save('gFunc.mat', 'gRed', 'gGreen', 'gBlue');

% Create the triangle function
function [w] = triangle_function(Z)
    if Z >= 0 && Z < 127.5
        w = Z/127.5;
    else
        w = (255 - Z)/127.5;
    end
end



