clear; clc; close all;

%%% Assignment 2 - Starter code
% Code from James Hays

% Setting up the input output paths
data_dir = '../Images/';
out_dir = '../Results/';

% false for source gradient, true for mixing gradients
isMix = false;

N = 7;
offset = cell(N,1);
offset{1} = [210, 10];
offset{2} = [10, 28];
offset{3} = [140, 80];
offset{4} = [-40, 90];
offset{5} = [60, 100];
offset{6} = [20, 20];
offset{7} = [-28, 88];

for i = 1 : N
    
    source = im2double(imread(sprintf('%s/source_%02d.jpg',data_dir,i)));
    mask = im2double(imread(sprintf('%s/mask_%02d.jpg',data_dir,i)));
    target = im2double(imread(sprintf('%s/target_%02d.jpg',data_dir,i)));
    
    % cleaning up the mask
    mask(mask < 0.5) = 0;
    mask(mask >= 0.5) = 1;
    
    % Align the source and mask using the provided offest
    [source, mask, target] = fiximages(source, mask, target, offset{i});
    
	
    % The main part of the code. Implement the PoissonBlend function
    output = PoissonBlend(source, mask, target, isMix);
    
    % Writing the result
    output = im2uint8(output);
    imwrite(output,sprintf('%s/res_img%02d.jpg',out_dir,i));
    
end

