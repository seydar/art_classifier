function [variance, avg, num] = blobs(im, thresh)
  I = rgb2gray(im);
  levels = 20;

  scale_space = zeros(size(I, 1), size(I, 2), levels);

  for sigma = 1:levels
    fsize =  2 * ceil(3 * sigma) + 1;
    laplace_of_gauss =  sigma ^ 2 * fspecial('log', fsize, sigma);
    IL = imfilter(double(I), laplace_of_gauss, 'same', 'replicate');
    scale_space(:, :, sigma) = IL .^ 2;
  end

  ss = nms(scale_space, 1);

  r = [];
  s = size(ss);
  for i = 1:s(1)
    for j = 1:s(2)
      for k = 1:s(3)
        if ss(i, j, k) > thresh
          r = [r; k * sqrt(2)];
        end
      end
    end
  end

  variance = var(r);
  avg      = mean(r);
  num      = size(r, 2);

end

