function [db] = produce_features(base)

if matlabpool('size') == 0
	matlabpool open;
end

  
%  run 'vlfeat/toolbox/v1_setup'
  db = db_setup(base);

  path = [base '/images/*.jpg'];
  list = dir(path);

  new = {};
  for i = 1:size(list, 1)
    new{i} = list(i).name;
  end

  size(new,2)
  tic
  parfor i = 1:size(new, 2)
	disp(['Image #: ' num2str(i)]);
    image = db.get_image(new{i});
 %   image.hog = hog(image.image);
  %  image.add_feature('sift', sift_features(image.image));
 %   image.add_feature('edge_hist', edge_hist(image.image));
	 %image.lbp = lbp_features(image.image);
 %   image.corners = corners(image.image, );
 %   image.blobs = blobs(image.image, );
  %  image.color_palette = color_palette(image.image);
  image.add_feature('color_hist', color_hist(image.image, 10));
    image.save_me();
  end
  toc;
 
  matlabpool close;

  
  
  
end
