function [] = generate_codewords(db, K, n)
	
if matlabpool('size') == 0
	matlabpool open;
end

	artist_word(db, 'pollock',K,n);
	artist_word(db, 'Rembrandt',K,n);
	artist_word(db, 'monet',K,n);
%	matlabpool close;

end

function [] = artist_word(db, art_name, K, n)
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
		[~, d] = vl_sift(I);
		feat = [feat d];
	end

	[words, ~] = vl_ikmeans(feat, K);
	
	class(words)
	
	save_path = ['./features/' art_name '.words.mat']
	save(save_path, 'words');
	
	toc
end