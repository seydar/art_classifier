function [] = generate_codewords(db, K, n, level)
	
if matlabpool('size') == 0
	matlabpool open;
end

	artist_word(db, 'pollock',K,n, level);
	artist_word(db, 'Rembrandt',K,n, level);
	artist_word(db, 'monet',K,n, level);
    artist_word(db, 'picasso',K,n, level);

end

function [] = artist_word(db, art_name, K, n, level)
 path = ['./images/' art_name '*.jpg'];
list = dir(path);

  new = {};
  for i = 1:n
    new{i} = list(i).name;
  end

  size(new,2);
  
  tic

  feat = [];
  
	parfor i = 1:size(new, 2)
		disp(['Sift features from #: ' num2str(i)]);
	    image = db.get_image(new{i});
		I = single(rgb2gray(image.image));
		[~, d] = vl_sift(I, 'levels',level);
		feat = [feat d];
	end

	[words, ~] = vl_ikmeans(feat, K);
	
	class(words)
	
	save_path = ['./features/' art_name '.words.level.' level '.mat'];
	save(save_path, 'words');
	
	toc
end