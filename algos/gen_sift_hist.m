function [  ] = gen_sift_hist( artist_1, artist_2, K )

	if matlabpool('size') == 0
	matlabpool open;
	end

	base = '.';
  db = db_setup(base);

  art_1_words =  load([base '/features/' artist_1 '.words.mat']);
  art_1_words = art_1_words.words;
  art_2_words = load([base '/features/' artist_2 '.words.mat']);
  art_2_words = art_2_words.words;
  code_book = [art_1_words art_2_words];

  size(code_book)
   
  artist_tree = vl_kdtreebuild(single(code_book));
  
  
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
	image.add_feature('sift_hist', sift_hist(artist_tree, code_book, K, image.image));
    image.save_me();
  end
  toc;
 
 % matlabpool close;




end

