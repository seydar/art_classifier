function db = db_setup(path)

  function image = get_image(name)
    full_path = [path '/images/' name];
    img = imread(full_path);

    listing = dir([path '/features/' name '.*']);
    listing = arrayfun(@(x) x.name, listing);

    features = struct();
    if size(listing, 1) ~= 0
      for i = 1:size(listing, 2)
        picture = regexp(listing(i), '\.([^.]+)$', 'match');
        load(listing, 'data');
        features.(picture) = data;
      end
    end

    function save_me
      fields = fieldnames(features);
      for i = 1:length(fields)
        save_path = [path '/features/' name '.' fields{i}];
        data = features.(fields{i});
        save(save_path, 'data');
      end
    end
    
    function add_feature(name, info)
      features.(name) = info;
    end

    image = struct();
    image.image = img;
    image.features = features;
    image.add_feature = @add_feature;
    image.save_me = @save_me;
  end

  db = struct();
  db.get_image = @get_image;
end

