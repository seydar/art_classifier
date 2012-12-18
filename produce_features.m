function [db] = produce_features(base)

  if matlabpool('size') == 0
	  %matlabpool open;
  end

  
  %run 'vlfeat/toolbox/v1_setup'
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

    % image.add_feature('fsa', fsa(image.image));
    % image.add_feature('edge_hist', edge_hist(image.image));
	  % image.add_feature('lbp', lbp_features(image.image));
    % image.add_feature('corners', corners(image.image, 0.45));
    image.add_feature('blobs', blobs(image.image, 1600));
    % image.add_feature('color_palette', color_palette(image.image);
    % image.add_feature('color_hist', color_hist(image.image, 10));
    image.save_me();
  end
  toc;
 
  %matlabpool close;

  
  
  
end
