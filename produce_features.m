function produce_features(base)
  matlabpool open;
  
  run 'vlfeat/toolbox/v1_setup'
  db = db_setup(base);

  path = [base '/images/*.jpg'];
  list = dir(path);

  new = {};
  for i = 1:size(list, 1)
    new{i} = list(i).name;
  end
  
  parfor i = 1:size(new, 2)
    image = db.get_image(x);
    image.hog = hog(image.image);
    image.sift = sift(image.image);
    image.corners = corners(image.image, );
    image.blobs = blobs(image.image, );
    image.color_palette = color_palette(image.image);
    image.save();
  end
end

