function [F] = fsa(im)
  f = rgb2gray(im);
  F = ff2(f);
end

