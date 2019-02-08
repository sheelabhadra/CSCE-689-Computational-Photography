function shift = FindShift(im1, im2, similarity_metric)

% Pyramid for multi-scale matching
% For JPEGs : scaling level = 0 (no resizing is required)
% For TIFs: scaling level
if size(im1, 1) > 1000
    scaling_levels = 5;
    disp("High dimensional image; performing search using multi-scale approach...")
else
    scaling_levels = 0;
    disp("Low dimensional image; performing search at original resolution...")
end

y_shift = 0;
x_shift = 0;

startx = -5;
endx = 5;
starty = -5;
endy = 5;

for sc=scaling_levels:-1:0
    s = ['Image size reduced by a factor of ',num2str(2^sc)];
    disp(s)
    % Resize both the images
    im1_resized = imresize(im1, 2^-sc);
    im2_resized = imresize(im2, 2^-sc);
    
    if similarity_metric == 'NCC'
        [y_shift, x_shift] = NCC(im1_resized, im2_resized, startx, endx, starty, endy);
    else
        [y_shift, x_shift] = SSD(im1_resized, im2_resized, startx, endx, starty, endy);
    end
    
%     % Check the surface plots for the similarity metric
    
    startx = 2*x_shift - 5;
    endx = 2*x_shift + 5;
    starty = 2*y_shift - 5;
    endy = 2*y_shift + 5;
end

shift = [y_shift, x_shift];

end


function [y_shift, x_shift] = NCC(moving, fixed, startx, endx, starty, endy)
    % fixed - reference image
    % moving - image that is slided over the reference image
    
    % Matrix to store the NCC values for all shifts
    ncc_mat = zeros(endy-starty+1, endx-startx+1);
    
    H = size(moving, 1);
    W = size(moving, 2);
    
    mean_adjusted_moving = moving - mean(moving);
    mean_fixed = mean(fixed);
    
    % Add circular padding to the fixed image
    fixed_padded = padarray(fixed, [H, W], 'circular', 'both');
    
    for i=1:endy-starty+1
        for j=1:endx-startx+1
            num = sum(sum(mean_adjusted_moving.*(fixed_padded(H+i:2*H-1+i, W+j:2*W-1+j) - mean_fixed)));
            den =  sum(sum(mean_adjusted_moving.^2))*sum(sum((fixed_padded(H+i:2*H-1+i, W+j:2*W-1+j) - mean_fixed).^2))^0.5;
            ncc_mat(i,j) = num/den;
        end
    end
    
    % Surface plot for the SSD matrix
%     figure; 
%     surf(ssd_mat);
    
    % Find the shift/offset where the minimum value occurs
    [ymin, xmin] = find(ncc_mat==max(ncc_mat(:)));
    
    % Grab the first shift value since there can be multiple minima
    y_shift = ymin(1) + starty;
    x_shift = xmin(1) + startx;

end


function [y_shift, x_shift] = SSD(moving, fixed, startx, endx, starty, endy)
    % fixed - reference image
    % moving - image that is slided over the reference image
    
    % Matrix to store the SSD values for all shifts
    ssd_mat = zeros(endy-starty+1, endx-startx+1);
    
    H = size(moving, 1);
    W = size(moving, 2);
    
    % Add circular padding to the fixed image
    fixed_padded = padarray(fixed, [H, W], 'circular', 'both');
    
    for i=1:endy-starty+1
        for j=1:endx-startx+1
            ssd_mat(i,j) = sum(sum((moving - fixed_padded(H+i:2*H-1+i, W+j:2*W-1+j)).^2));
        end
    end
    
    % Surface plot for the SSD matrix
%     figure; 
%     surf(ssd_mat);
    
    % Find the shift/offset where the minimum value occurs
    [ymin, xmin] = find(ssd_mat==min(ssd_mat(:)));
    
    % Grab the first shift value since there can be multiple minima
    y_shift = ymin(1) + starty;
    x_shift = xmin(1) + startx;
end



