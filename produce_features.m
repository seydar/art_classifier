function produce_features(base)
  run 'vlfeat/toolbox/v1_setup'
  db = db_setup(base);

  path = [base '/images/*.jpg'];
  list = dir(path);

  new = {};
  for i = 1:size(list, 1)
    new{i} = list(i).name;
  end

  images = cellfun(@(x) db.get_image(x), new, 'uni', false);

  for i = 1:size(images, 2)
    image = images{i};
    image.hog = hog(image.image);
    image.sift = sift(image.image);
    image.corners = corners(image.image, );
    image.blobs = blobs(image.image, );
    image.color_palette = color_palette(image.image);
    image.save();
  end
end

