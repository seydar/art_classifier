function [] = generate_codewords(K, n, level)
	
db = db_setup('.');
if matlabpool('size') == 0
	matlabpool open;
end

tic
	artist_word(db, 'pollock',K,n, level);
	artist_word(db, 'Rembrandt',K,n, level);
	artist_word(db, 'monet',K,n, level); 
    artist_word(db, 'picasso',K,n, level);
toc


end

function [] = artist_word(db, art_name, K, n, level)
disp(['generating ' art_name ' codewords']);
 path = ['./images/' art_name '*.jpg'];
list = dir(path);

  new = {};
  for i = 1:n
    new{i} = list(i).name;
  end

  size(new,2);


  feat = [];
  
	parfor i = 1:size(new, 2)
	    image = db.get_image(new{i});
		I = single(rgb2gray(image.image));
		[~, d] = vl_sift(I, 'levels',level);
		feat = [feat d];
	end

	[words, ~] = vl_ikmeans(feat, K);
	save_path = ['./features/' art_name '.words.level.' num2str(level) '.mat'];
    save(save_path, 'words');
end