clear; clc;

%%% Assignment 1 - Starter code


%%% 

% Setting the input output file path
imageDir = '../Images/';
imageName = 'cathedral.jpg';
outDir = '../Results/';

% Reading the glass plate image
glassPlate = im2double(imread([imageDir, imageName]));

% Separating the glass image into R, G, and B channels.
glassHeight = size(glassPlate, 1);
height = floor(glassHeight / 3);

b = glassPlate(1:height, :);
g = glassPlate(height+1:2*height, :);
r = glassPlate(2*height+1:3*height, :);

% The main part of the code. Implement the FindShift function
rShift = FindShift(r, b);
gShift = FindShift(g, b);

% Shifting the images using the obtained shift values
finalB = b;
finalG = circshift(g, gShift);
finalR = circshift(r, rShift);

% Putting together the aligned channels to form the color image
finalImage = cat(3, finalR, finalG, finalB);

% Writing the image to the Results folder
imwrite(finalImage, [outDir, imageName]);
