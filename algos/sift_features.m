function [d] = sift_features(image)
I = single(rgb2gray(image));
[~,d] = vl_sift(I);
end
