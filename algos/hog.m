function result = hog(pixels, params)
  pixels    = double(pixels);
  s         = size(pixels);
  grayscale = 1;

  if nargin < 2
    params = [9, 8. 2, 0, 0.2];
  end

  hist1 = 2 + ceil(-0.5 + s(1) / params(2));
  hist2 = 2 + ceil(-0.5 + s(2) / params(2));

  result = [];

  nb_bins    = params(1);
  cwidth     = params(2);
  orient     = params(4);
  block_size = params(3);
  clip_val   = params(5);

  bin_size   = (1 + (orient == 1)) * pi / nb_bins;
  dx, dy = [];

  // calculate gradients
  [dx, dy] = gradient(pixels);
  
end

