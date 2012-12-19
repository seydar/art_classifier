function [svms, trees, codebooks] = create_sift_svm(db, art_1, art_2, f_train, s_train)

	%steps to do:
	%1)	extract sift data for the level needed
	%2)	generate codebook by clustering features from f_train and s_train
	%3)	build a kd-tree using that info
	%4)	generate histograms for each of the testing images as well as the
	%training images
	%5)	train svm with training images
	%6)	run svm with testing images
	
	%1)	extract sift data for the level needed
		
	svms = {};	
	trees = {};
	codebooks = {};
		
	firsts = dir(['./images/' art_1 '*']);
	seconds = dir(['./images/' art_2 '*']);
	
	for level = 3:8
		first_feats = [];
		second_feats = [];		
		for i = f_train(1:end)
			im1 = db.get_image(firsts(i).name);
			first_feats = [first_feats im1.features.(['rawsift' num2str(level)])];		
		end
		
		[f_words, ~] = vl_ikmeans(first_feats, 10);	%using 10-means clustering
		
		for i = s_train(1:end)
			im2 = db.get_image(seconds(i).name);
			second_feats = [second_feats im2.features.(['rawsift' num2str(level)])];		
		end
		
		[s_words, ~] = vl_ikmeans(second_feats, 10);

		%generate codebook	
		codebook = [f_words s_words];
		codebook = single(codebook);
		codebooks = [codebooks codebook];
		
		%build kd-tree
		artist_tree = vl_kdtreebuild(codebook);	
		%gen histograms for training data
		[t_f_hist, t_s_hist] = gen_sift_hist_(db, artist_tree, codebook, level, firsts, seconds, f_train, s_train);	
		%training svm
		key = [repmat(0,length(f_train),1); repmat(1,length(s_train),1)];
		trained_svm = svmtrain([t_f_hist; t_s_hist], key);
		svms = [svms trained_svm];
		trees = [trees artist_tree];
	end
	
end

function [first_hist, second_hist] = gen_sift_hist_(db, art_tree, code_book, level,  firsts, seconds, f, s)	%input is either training or testing

	image_clusters = [];
	all_hists = [];
	first_hist = [];
	second_hist = [];
	
	for j = f(1:end)
		im = db.get_image(firsts(j).name);
		d = im.features.(['rawsift' num2str(level)]);
		image_clusters = [];
		for k = 1:size(d,2)
			[i, ~] = vl_kdtreequery(art_tree, code_book, single(d(:,k)));
			image_clusters = [image_clusters; i];
		end
		hist_ = hist(double(image_clusters), 20);
		hist_ = hist_ ./ sum(hist_);
		first_hist = [first_hist; hist_];
	end
	
	
	for j = s(1:end)
		im = db.get_image(seconds(j).name);
		d = im.features.(['rawsift' num2str(level)]);
		image_clusters = [];
		for k = 1:size(d,2)
			[i, ~] = vl_kdtreequery(art_tree, code_book, single(d(:,k)));
			image_clusters = [image_clusters; i];
		end
		hist_ = hist(double(image_clusters), 20);
		hist_ = hist_ ./ sum(hist_);
		second_hist = [second_hist; hist_];
	end

	
	
	
end

