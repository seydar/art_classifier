function [variance, avg, num] = corners(im, threshold)
  % Filter the image to denoise it
  im = imfilter(im, fspecial('gaussian'));

  % Compute the grayscale
  I = rgb2gray(im);

  % Compute the partial derivatives
  [Ix, Iy] = gradient(double(im));

  % Filter
  % Window size is for question a
  % The window is big enough to get proper values
  % without going crazy
  H = fspecial('gaussian', [20, 20]);
  Ix2 = double(imfilter(Ix .^ 2, H));
  Iy2 = double(imfilter(Iy .^ 2, H));
  Ixy = double(imfilter(Ix .* Iy, H));

  % Now we have 4 different images each with various filters on them.
  % Ix2 is the square of the change in the x direction
  % Iy2 is the square of the change in the y direction
  % Ixy is the change in each direction multiplied together
  M = [Ix2 Ixy
       Ixy Iy2];

  % question b
  rs = [];
  for i = 1:size(I, 1)
    for j = 1:size(I, 2)
      % the matrix of each pixel
      mat = [Ix2(i, j) Ixy(i, j); Ixy(i, j) Iy2(i, j)];
      % 0.04 was recommended online saying that the reason was a mystery
      rs(i, j) = det(mat) - 0.04 * trace(mat) .^ 2;
    end
  end

  % normalize it all
  rs = rs / max(max(rs));
  c = im2bw(rs, threshold);

  points = [];
  for i = 1:size(c, 1)
    for j = 1:size(c, 2)
      if c(i, j) == 1
        points = [points; [i j]];
      end
    end
  end

  centroid = mean(points)';
  points = points';
  ds = [];
  for i = 1:size(points, 2)
    ds = [ds; sum(mean(dist([points(:, i) centroid])))];
  end

  variance = var(ds);
  avg = mean(ds);
  num = size(ds, 1);
end

