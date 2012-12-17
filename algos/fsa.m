function [F] = fsa(im)
  f = rgb2gray(im);
  F = fft2(f);
end

