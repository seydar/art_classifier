function db = db_setup(path)

  function image = get_image(name)
    full_path = [path '/images/' name '.jpg'];
    img = imread(full_path);

    listing = dir([path '/features/' name '.*']);
    listing = arrayfun(@(x) x.name, listing);

    features = struct();
    for i = 1:size(listing, 2)
      picture = regexp(listing(i), '\.([^.]+)$', 'match');
      load(listing, 'data');
      features.(picture) = data;
    end

    function save
      fields = fieldnames(features);
      for i = 1:length(fields)
        save_path = [path '/features/' name '.' fields{i}];
        data = features.(fields{i});
        save(save_path, 'data');
      end
    end

    image = struct();
    image.image = img;
    image.features = features;
    image.save = @save;
  end

  db = struct();
  db.get_image = @get_image;
end

