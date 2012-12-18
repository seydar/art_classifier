function [c, avg] = fsa(im)
  %f = rgb2gray(im);
  F = fft2(im);
  size(F)
  c = cov(F);
  avg = mean(mean(F));
end

