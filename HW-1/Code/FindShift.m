function shift = FindShift(im1, im2)

shift = [0, 0];

% Cost function to find similarity metric
J = 0.0;

% Pyramid for shifting
% scaling_factors = [0.125 0.25 0.5 1.0];
scaling_factors = [1.0];

for i=1:size(scaling_factors,1)
    % Resize both the images
    im1_resized = imresize(im1, scaling_factors(i));
    im2_resized = imresize(im2, scaling_factors(i));
    
    H = size(im1_resized, 1);
    W = size(im1_resized, 2);
    
    ncc_score = NCC(im1_resized, im2_resized);
    [ypeak, xpeak] = find(ncc_score==max(ncc_score(:)));
    
%     % Check the surface plots for the similarity metric
%     figure, surf(ncc_score), shading flat;
    
    y_offset = ypeak - H;
    x_offset = xpeak - W;
end

shift = [y_offset, x_offset];

end

function ncc_score = NCC(im1, im2)
% Calculates the similarity score between 2 images using Normalized Cross
% Correlation
    ncc_score = normxcorr2(im1, im2);
end
