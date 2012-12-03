function h = lbp_features(im)
  im = rgb2gray(im);
  
  patterns = zeros((size(im, 1) - 2) * (size(im, 2) - 2), 1);
  for i = 2:(size(im, 1) - 1)
    for j = 2:(size(im, 2) - 1)
      patterns(i * j + j) = pattern(i, j, im);
    end
  end
  
  h = hist(patterns, 256);
end

  function num = pattern(i, j, im)
    p = im(i, j);
    num = [im(i-1, j-1) > p
           im(i,   j-1) > p
           im(i+1, j-1) > p
           im(i+1, j)   > p
           im(i+1, j+1) > p
           im(i,   j+1) > p
           im(i-1, j+1) > p
           im(i-1, j)   > p];
    num = num' * [1 2 4 8 16 32 64 128]';
  end