function shift = FindShift(im1, im2)

% Pyramid for shifting
% scaling_factors = [0.03125 0.0625 0.125 0.25 0.5 1.0];
scaling_factors = [1.0];
y_offset = 0;
x_offset = 0;

for i=1:size(scaling_factors,2)
    % Resize both the images
    im1_resized = imresize(im1, scaling_factors(i));
    im2_resized = imresize(im2, scaling_factors(i));
    
    H = size(im1_resized, 1);
    W = size(im1_resized, 2);
    
%     ncc_score = NCC(im1_resized, im2_resized);
%     [ypeak, xpeak] = find(ncc_score==max(ncc_score(:)));
    [y_shift, x_shift] = SSD(im1_resized, im2_resized, -5, 10, -5, 10);
    
%     % Check the surface plots for the similarity metric
%     figure, surf(ncc_score), shading flat;
    y_offset = y_shift;
    x_offset = x_shift;
end

shift = [y_offset, x_offset];

end

% function ncc_score = NCC(im1, im2)
% % Calculates the similarity score between 2 images using Normalized Cross
% % Correlation
%     ncc_score = normxcorr2(im1, im2);
% end

function ncc_score = NCC(moving, fixed, startx, endx, starty, endy)
    M = 2*size(moving,1) + size(fixed,1);
    N = 2*size(moving,2) + size(fixed,2);
    ncc_mat = zeros(endy-starty+1, endx-startx+1);
    
    fixed_zero_padded = padarray(fixed, [size(moving,1), size(moving,2)], 0, 'both');
    
    % Zero pad the fixed image
    for i=1:endy-starty+1
        for j=1:endx-startx+1
            (moving - mean(moving))*(fixed - mean(fixed));
            ncc_mat(i,j) = sum(moving - mean(moving));
        end
    end

end


function [y_shift, x_shift] = SSD(moving, fixed, startx, endx, starty, endy)
    M = 2*size(moving,1) + size(fixed,1);
    N = 2*size(moving,2) + size(fixed,2);
    ssd_mat = zeros(endy-starty+1, endx-startx+1);
    
    fixed_zero_padded = padarray(fixed, [size(moving,1), size(moving,2)], 'circular', 'both');
    
    % Zero pad the fixed image
    for i=1:endy-starty+1
        for j=1:endx-startx+1
            ssd_mat(i,j) = sum(sum(moving - fixed_zero_padded(size(moving,1)+i:2*size(moving,1)-1+i, size(moving,2)+j:2*size(moving,2)-1+j)).^2);
        end
    end
    
    figure; 
    surf(ssd_mat);
    
    [ymin, xmin] = find(ssd_mat==min(ssd_mat(:)));
    
    
    y_shift = ymin(1) + starty;
    x_shift = xmin(1) + startx;
end



