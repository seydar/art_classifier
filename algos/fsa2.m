function [ary] = fsa(im)
  f = rgb2gray(im);
  F = fft2(f);

  ary = zeros(1, size(F, 1) * size(F, 2));
  for i = 1:size(F, 1)
    for j = 1:size(F, 2)
      ary(i + j) = ary(i + j) + F(i, j);
    end
  end
end

